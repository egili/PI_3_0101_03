import '../constants/environments.dart';
import '../models/environment.dart';
import 'storage_service.dart';

/// Serviço com as regras de negócio do jogo.
/// Ele não sabe nada de UI — só decide O QUE acontece no jogo.
class GameService {
  final StorageService _storageService = StorageService();

  /// Retorna todos os ambientes, marcando quais estão desbloqueados
  /// com base na lista salva no dispositivo.
  Future<List<Environment>> getEnvironmentsWithProgress() async {
    final unlockedIds = await _storageService.loadUnlockedEnvironments();
    final all = MockEnvironmentRepository.allEnvironments;

    // Recria cada ambiente com o isUnlocked correto
    return all.map((env) {
      final isUnlocked = unlockedIds.contains(env.id);
      return env.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  /// Desbloqueia um novo ambiente quando o jogador chega até ele.
  /// Retorna true se foi desbloqueado agora, false se já estava desbloqueado.
  Future<bool> unlockEnvironment(String environmentId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();

    // Já estava desbloqueado — não faz nada
    if (unlocked.contains(environmentId)) return false;

    // Adiciona o novo ID e salva
    unlocked.add(environmentId);
    await _storageService.saveUnlockedEnvironments(unlocked);
    return true; // desbloqueou agora!
  }

  /// Verifica se um ambiente específico está desbloqueado.
  Future<bool> isEnvironmentUnlocked(String environmentId) async {
    final unlocked = await _storageService.loadUnlockedEnvironments();
    return unlocked.contains(environmentId);
  }

  /// Carrega o progresso completo do jogador ao iniciar o app.
  /// Retorna um Map com os dados, ou null se não há jogo salvo.
  Future<Map<String, dynamic>?> loadGameProgress() async {
    final hasGame = await _storageService.hasSavedGame();
    if (!hasGame) return null;

    return {
      'playerName': await _storageService.loadPlayerName(),
      'playerGender': await _storageService.loadPlayerGender(),
      'unlockedEnvironments': await _storageService.loadUnlockedEnvironments(),
    };
  }

  /// Salva o progresso quando o jogador visita um ambiente.
  Future<void> saveVisit({
    required String playerName,
    required String gender,
    required String environmentId,
  }) async {
    await _storageService.savePlayerName(playerName);
    await _storageService.savePlayerGender(gender);
    await unlockEnvironment(environmentId);
  }
}
