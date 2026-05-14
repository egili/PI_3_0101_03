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
    state = state.whenData(
      (missions) => missions.map((m) {
        if (m.isConcluida) return m;
        if (m.environmentId == environmentId) {
          return m.copyWith(status: MissionStatus.ativa);
        }
        if (m.isAtiva) return m.copyWith(status: MissionStatus.pendente);
        return m;
      }).toList(),
    );
  }

  /// Recarrega do Firebase — usar ao retomar o jogo.
  Future<void> recarregar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_carregarMissoes);
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
