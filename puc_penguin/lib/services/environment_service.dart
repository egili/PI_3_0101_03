import 'package:geolocator/geolocator.dart';
import '../models/environment.dart';
import '../constants/environments.dart';

/// Resultado da detecção de ambiente.
/// Usamos uma classe em vez de retornar apenas o Environment para poder
/// incluir a distância calculada, que é útil para mostrar ao jogador.
class EnvironmentDetectionResult {
  final Environment environment;
  final double distanceInMeters;

  const EnvironmentDetectionResult({
    required this.environment,
    required this.distanceInMeters,
  });
}

/// Serviço responsável por identificar em qual ambiente o jogador está.
/// Toda a lógica de geolocalização + comparação fica aqui, separada da UI.
class EnvironmentService {
  // Lista de ambientes do jogo — vem do repositório central
  final List<Environment> _environments =
      staticEnvironments;

  /// Recebe a [position] atual do GPS e retorna o ambiente ativo,
  /// ou null se o jogador estiver fora de qualquer área.
  EnvironmentDetectionResult? detectEnvironment(Position position) {
    // Guarda o melhor resultado encontrado (menor distância dentro do raio)
    EnvironmentDetectionResult? closest;

    for (final env in _environments) {
      // Calcula a distância em metros entre o jogador e o centro do ambiente
      final double distance = Geolocator.distanceBetween(
        position.latitude,   // latitude atual do jogador
        position.longitude,  // longitude atual do jogador
        env.latitude,        // latitude do centro do ambiente
        env.longitude,       // longitude do centro do ambiente
      );

      // Verifica se está dentro do raio de ativação
      final bool dentroDoRaio = distance <= env.radius;

      // Só considera ambientes desbloqueados e dentro do raio
      if (dentroDoRaio && env.isUnlocked) {
        // Se ainda não temos nenhum resultado, ou este é mais próximo, atualiza
        if (closest == null || distance < closest.distanceInMeters) {
          closest = EnvironmentDetectionResult(
            environment: env,
            distanceInMeters: distance,
          );
        }
      }
    }

    // Retorna o ambiente mais próximo encontrado, ou null se fora de área
    return closest;
  }

  /// Retorna a distância até o ambiente mais próximo (mesmo que fora do raio).
  /// Útil para mostrar "Você está a Xm do próximo ponto".
  EnvironmentDetectionResult? findNearest(Position position) {
    EnvironmentDetectionResult? nearest;

    for (final env in _environments) {
      final double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        env.latitude,
        env.longitude,
      );

      if (nearest == null || distance < nearest.distanceInMeters) {
        nearest = EnvironmentDetectionResult(
          environment: env,
          distanceInMeters: distance,
        );
      }
    }

    return nearest;
  }
}
