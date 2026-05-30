import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/environment.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';
import '../services/firebase_progress_service.dart';
import '../services/device_id_service.dart';

// ─────────────────────────────────────────────
// NOTIFIERS
// ─────────────────────────────────────────────

class PlayerNotifier extends Notifier<Player?> {
  final _storageService = StorageService();

  @override
  Player? build() => null;

  Future<void> setPlayer(Player player) async {
    state = player;
    await _storageService.savePlayerName(player.name);
    await _storageService.savePlayerGender(
        player.gender == Gender.male ? 'male' : 'female');
  }

  void setConsumedSabotagedFood(bool value) {
    if (state == null) return;
    state = state!.copyWith(consumedSabotagedFood: value);
  }

  Future<void> loadPlayer() async {
    final name = await _storageService.loadPlayerName();
    final genderStr = await _storageService.loadPlayerGender();
    if (name != null && genderStr != null) {
      state = Player(
        name: name,
        gender: genderStr == 'male' ? Gender.male : Gender.female,
      );
    }
  }

  void clearProfile() {
    state = null;
  }
}

class CurrentEnvironmentIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

class UnlockedEnvironmentsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ['h15'];
}

// ─────────────────────────────────────────────
// PROVIDERS SIMPLES
// ─────────────────────────────────────────────

final playerProvider = NotifierProvider<PlayerNotifier, Player?>(
  PlayerNotifier.new,
);

final currentEnvironmentIdProvider =
    NotifierProvider<CurrentEnvironmentIdNotifier, String?>(
      CurrentEnvironmentIdNotifier.new,
    );

final unlockedEnvironmentsProvider =
    NotifierProvider<UnlockedEnvironmentsNotifier, List<String>>(
      UnlockedEnvironmentsNotifier.new,
    );

// ─────────────────────────────────────────────
// PROVIDERS DE SERVIÇO
// ─────────────────────────────────────────────

final gameServiceProvider = Provider<GameService>((ref) {
  final firebaseService = ref.read(firebaseProgressServiceProvider);
  return GameService(firebaseService, null);
});

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

final firebaseProgressServiceProvider = Provider<FirebaseProgressService>(
  (ref) => FirebaseProgressService(),
);

// ─────────────────────────────────────────────
// DEVICE ID
// ─────────────────────────────────────────────

final deviceIdProvider = FutureProvider<String>((ref) async {
  return DeviceIdService.getDeviceId();
});

final gameProgressProvider = FutureProvider<GameProgress?>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  final firebaseService = ref.read(firebaseProgressServiceProvider);

  final progress = await firebaseService.carregarProgresso(deviceId);

  if (progress != null) {
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

// ─────────────────────────────────────────────
// PROGRESS SAVER
// ─────────────────────────────────────────────

class ProgressSaverNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> salvarTudo() async {
    final deviceId = await ref.read(deviceIdProvider.future);
    final firebaseService = ref.read(firebaseProgressServiceProvider);
    final player = ref.read(playerProvider);
    final currentEnvId = ref.read(currentEnvironmentIdProvider);
    final unlocked = ref.read(unlockedEnvironmentsProvider);

    if (player == null) return;

    // CORREÇÃO: lê as missões salvas antes de sobrescrever o documento
    final progressAtual = await firebaseService.carregarProgresso(deviceId);
    final missoesConcluidas = progressAtual?.missoesConcluidas ?? [];

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await firebaseService.salvarProgresso(
        deviceId: deviceId,
        playerName: player.name,
        gender: player.gender.name,
        currentEnvironmentId: currentEnvId,
        unlockedEnvironments: unlocked,
        missoesConcluidas: missoesConcluidas, // antes era const [] — bug
        escolhas: const {},
      );
    });
  }

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
