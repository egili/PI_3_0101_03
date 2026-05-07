import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/environment.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';
import '../services/firebase_progress_service.dart';
import '../services/device_id_service.dart';

// ─────────────────────────────────────────────
// PROVIDERS SIMPLES
// ─────────────────────────────────────────────

final playerProvider = StateProvider<Player?>((ref) => null);
final currentEnvironmentIdProvider = StateProvider<String?>((ref) => null);
final unlockedEnvironmentsProvider =
    StateProvider<List<String>>((ref) => ['h15']);

// ─────────────────────────────────────────────
// PROVIDERS DE SERVIÇO
// ─────────────────────────────────────────────

final gameServiceProvider = Provider<GameService>((ref) => GameService());
final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());
final firebaseProgressServiceProvider =
    Provider<FirebaseProgressService>((ref) => FirebaseProgressService());

// ─────────────────────────────────────────────
// PROVIDER DO DEVICE ID
// ─────────────────────────────────────────────

/// Carrega o ID único do dispositivo de forma assíncrona.
/// Usado como chave no Firestore.
final deviceIdProvider = FutureProvider<String>((ref) async {
  return DeviceIdService.getDeviceId();
});

/// Carrega o progresso do jogador do Firebase ao iniciar o app.
/// Retorna null se for a primeira vez (jogador novo).
final gameProgressProvider = FutureProvider<GameProgress?>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  final firebaseService = ref.read(firebaseProgressServiceProvider);

  final progress = await firebaseService.carregarProgresso(deviceId);

  if (progress != null) {
    // Restaura o estado global com os dados carregados do banco
    ref.read(unlockedEnvironmentsProvider.notifier).state =
        progress.unlockedEnvironments;
    ref.read(currentEnvironmentIdProvider.notifier).state =
        progress.currentEnvironmentId;
  }

  return progress;
});

final environmentsProvider = FutureProvider<List<Environment>>((ref) async {
  final gameService = ref.read(gameServiceProvider);
  return gameService.getEnvironmentsWithProgress();
});

final currentEnvironmentProvider = Provider<Environment?>((ref) {
  final currentId = ref.watch(currentEnvironmentIdProvider);
  final environmentsAsync = ref.watch(environmentsProvider);

  return environmentsAsync.whenOrNull(
    data: (environments) {
      if (currentId == null) return null;
      try {
        return environments.firstWhere((e) => e.id == currentId);
      } catch (_) {
        return null;
      }
    },
  );
});


class ProgressSaverNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Salva todo o progresso atual do jogador.
  Future<void> salvarTudo() async {
    final deviceId = await ref.read(deviceIdProvider.future);
    final firebaseService = ref.read(firebaseProgressServiceProvider);
    final player = ref.read(playerProvider);
    final currentEnvId = ref.read(currentEnvironmentIdProvider);
    final unlocked = ref.read(unlockedEnvironmentsProvider);

    if (player == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await firebaseService.salvarProgresso(
        deviceId: deviceId,
        playerName: player.name,
        gender: player.gender.name,
        currentEnvironmentId: currentEnvId,
        unlockedEnvironments: unlocked,
        missoesConcluidas: const [],
        escolhas: const {},
      );
    });
  }

  /// Salva o desbloqueio de um ambiente e atualiza o estado local.
  Future<void> salvarDesbloqueio(String environmentId) async {
    final deviceId = await ref.read(deviceIdProvider.future);
    final firebaseService = ref.read(firebaseProgressServiceProvider);

    await firebaseService.desbloquearAmbiente(
      deviceId: deviceId,
      environmentId: environmentId,
    );

    final unlocked = [...ref.read(unlockedEnvironmentsProvider)];
    if (!unlocked.contains(environmentId)) {
      unlocked.add(environmentId);
      ref.read(unlockedEnvironmentsProvider.notifier).state = unlocked;
    }
  }
}

final progressSaverProvider =
    AsyncNotifierProvider<ProgressSaverNotifier, void>(
  ProgressSaverNotifier.new,
);