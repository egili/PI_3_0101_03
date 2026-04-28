import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/environment.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';

// ─────────────────────────────────────────────
// PROVIDERS SIMPLES (StateProvider)
// Usados para valores que mudam diretamente, sem lógica complexa
// ─────────────────────────────────────────────

/// Perfil do jogador atual. Null = nenhum jogador criado ainda.
final playerProvider = StateProvider<Player?>((ref) => null);

/// ID do ambiente onde o jogador está agora. Null = fora de qualquer área.
final currentEnvironmentIdProvider = StateProvider<String?>((ref) => null);

/// Lista de IDs de ambientes desbloqueados.
final unlockedEnvironmentsProvider =
    StateProvider<List<String>>((ref) => ['h15']);

// ─────────────────────────────────────────────
// PROVIDERS DE SERVIÇO
// Instâncias únicas dos serviços, compartilhadas em todo o app
// ─────────────────────────────────────────────

/// Provedor do GameService — regras de negócio do jogo.
final gameServiceProvider = Provider<GameService>((ref) => GameService());

/// Provedor do StorageService — persistência local.
final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

// ─────────────────────────────────────────────
// PROVIDER ASSÍNCRONO
// Carrega a lista de ambientes com progresso do jogador
// ─────────────────────────────────────────────

/// Retorna todos os ambientes do jogo com o status de desbloqueio
/// carregado do armazenamento local. É um FutureProvider porque
/// precisa esperar o SharedPreferences responder.
final environmentsProvider = FutureProvider<List<Environment>>((ref) async {
  final gameService = ref.read(gameServiceProvider);
  return gameService.getEnvironmentsWithProgress();
});

// ─────────────────────────────────────────────
// PROVIDER DERIVADO
// Calcula dados a partir de outros providers
// ─────────────────────────────────────────────

/// Retorna o objeto Environment completo do ambiente atual,
/// derivado do ID salvo em currentEnvironmentIdProvider.
/// Null se o jogador estiver fora de área.
final currentEnvironmentProvider = Provider<Environment?>((ref) {
  final currentId = ref.watch(currentEnvironmentIdProvider);
  final environmentsAsync = ref.watch(environmentsProvider);

  // environmentsAsync pode ser loading/error/data — só age se tiver data
  return environmentsAsync.whenOrNull(
    data: (environments) {
      if (currentId == null) return null;
      try {
        return environments.firstWhere((e) => e.id == currentId);
      } catch (_) {
        return null; // ID não encontrado na lista
      }
    },
  );
});
