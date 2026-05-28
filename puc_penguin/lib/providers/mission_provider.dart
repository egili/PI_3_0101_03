import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mission.dart';
import '../constants/missions.dart';
import '../providers/game_provider.dart';

// ─────────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────────

class MissionNotifier extends AsyncNotifier<List<Mission>> {
  @override
  Future<List<Mission>> build() => _carregarMissoes();

  Future<List<Mission>> _carregarMissoes() async {
    final deviceId = await ref.read(deviceIdProvider.future);
    final firebaseService = ref.read(firebaseProgressServiceProvider);

    // Lê do Firestore o array missoesConcluidas do documento do jogador
    final progress = await firebaseService.carregarProgresso(deviceId);
    final concluidasIds = progress?.missoesConcluidas ?? [];
    final currentEnvId = ref.read(currentEnvironmentIdProvider);

    return staticMissions.map((m) {
      if (concluidasIds.contains(m.id)) {
        return m.copyWith(status: MissionStatus.concluida);
      }
      if (currentEnvId != null && m.environmentId == currentEnvId) {
        return m.copyWith(status: MissionStatus.ativa);
      }
      return m;
    }).toList();
  }

  /// Marca missão como concluída, persiste no Firebase e desbloqueia
  /// o próximo ambiente se houver.
  Future<void> concluirMissao(String missionId) async {
    final deviceId = await ref.read(deviceIdProvider.future);
    final firebaseService = ref.read(firebaseProgressServiceProvider);

    // Optimistic update — reflete na UI imediatamente
    state = state.whenData(
      (missions) => missions
          .map(
            (m) => m.id == missionId
                ? m.copyWith(status: MissionStatus.concluida)
                : m,
          )
          .toList(),
    );

    // Persiste usando arrayUnion (não sobrescreve outras missões)
    await firebaseService.concluirMissao(
      deviceId: deviceId,
      missaoId: missionId,
    );

    // Desbloqueia próximo ambiente se a missão tiver um
    final missions = state.asData?.value ?? [];
    final concluida = missions.cast<Mission?>().firstWhere(
      (m) => m?.id == missionId,
      orElse: () => null,
    );

    if (concluida?.proximoEnvironmentId != null) {
      await ref
          .read(progressSaverProvider.notifier)
          .salvarDesbloqueio(concluida!.proximoEnvironmentId!);
    }

    // Recarrega para garantir consistência com o Firestore
    state = await AsyncValue.guard(_carregarMissoes);
  }

  /// Atualiza qual missão está ativa com base no ambiente atual.
  /// Chamado pelo GPS quando o jogador entra em um novo ambiente.
  void atualizarMissaoAtiva(String environmentId) {
    state = state.whenData((missions) {
      // Só ativa a PRIMEIRA missão não concluída do ambiente — evita
      // que múltiplas missões do mesmo ambiente fiquem ativas ao mesmo tempo.
      bool jaAtivou = false;
      return missions.map((m) {
        if (m.isConcluida) return m;
        if (!jaAtivou && m.environmentId == environmentId) {
          jaAtivou = true;
          return m.copyWith(status: MissionStatus.ativa);
        }
        if (m.isAtiva) return m.copyWith(status: MissionStatus.pendente);
        return m;
      }).toList();
    });
  }

  /// Recarrega do Firebase — usar ao retomar o jogo.
  Future<void> recarregar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_carregarMissoes);
  }

  /// Reseta todas as missões para pendente (usado em "Novo Jogo").
  /// Limpa também o Firebase e restaura o estado inicial dos ambientes.
  Future<void> resetar() async {
    // Reset imediato das missões na UI
    state = AsyncData(staticMissions.toList());

    // Reseta ambientes: só o h15 começa desbloqueado
    ref.read(unlockedEnvironmentsProvider.notifier).state = ['h15'];
    ref.read(currentEnvironmentIdProvider.notifier).state = null;

    // Persiste o reset no Firebase
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final firebaseService = ref.read(firebaseProgressServiceProvider);
      final player = ref.read(playerProvider);
      await firebaseService.salvarProgresso(
        deviceId: deviceId,
        playerName: player?.name ?? 'Jogador',
        gender: player?.gender.name ?? 'male',
        currentEnvironmentId: null,
        unlockedEnvironments: const ['h15'],
        missoesConcluidas: const [],
        escolhas: const {},
      );
    } catch (e) {
      debugPrint('Erro ao resetar no Firebase: $e');
    }
  }
}

final missionProvider = AsyncNotifierProvider<MissionNotifier, List<Mission>>(
  MissionNotifier.new,
);

// ─────────────────────────────────────────────
// PROVIDERS DERIVADOS
// ─────────────────────────────────────────────

/// Missão ativa no momento. Fallback para a primeira pendente.
final missaoAtivaProvider = Provider<Mission?>((ref) {
  final missions = ref.watch(missionProvider).asData?.value;
  if (missions == null || missions.isEmpty) return null;
  try {
    return missions.firstWhere((m) => m.isAtiva);
  } catch (_) {}
  try {
    return missions.firstWhere((m) => m.isPendente);
  } catch (_) {}
  return null;
});

/// Total de missões concluídas (barra de progresso).
final missoesConcluidasCountProvider = Provider<int>((ref) {
  return ref.watch(missionProvider).value?.where((m) => m.isConcluida).length ??
      0;
});