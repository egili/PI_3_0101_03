import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/environment.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';

final playerProvider = StateProvider<Player?>((ref) => null);

final currentEnvironmentIdProvider =
    StateProvider<String?>((ref) => null);

final unlockedEnvironmentsProvider =
    StateProvider<List<String>>((ref) => ['h15']);

final gameServiceProvider =
    Provider<GameService>((ref) => GameService());

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

final environmentsProvider =
    FutureProvider<List<Environment>>((ref) async {
  final gameService = ref.read(gameServiceProvider);
  return gameService.getEnvironmentsWithProgress();
});

final currentEnvironmentProvider =
    Provider<Environment?>((ref) {
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