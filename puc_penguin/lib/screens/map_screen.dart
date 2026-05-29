import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../models/environment.dart';

/// Tela de mapa — mostra todos os ambientes do jogo
/// e indica quais estão desbloqueados/bloqueados/ativos.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lê o ambiente atual e a lista de ambientes (assíncrona)
    final currentEnvId = ref.watch(currentEnvironmentIdProvider);
    final environmentsAsync = ref.watch(environmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa do Campus'),
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blueGrey.shade900,
      body: environmentsAsync.when(
        // Estado de carregamento
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),

        // Estado de erro
        error: (error, _) => Center(
          child: Text(
            'Erro ao carregar ambientes:\n$error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),

        // Estado com dados — mostra a lista de ambientes
        data: (environments) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: environments.length,
          itemBuilder: (context, index) {
            final env = environments[index];
            final isActive = env.id == currentEnvId;

            return _EnvironmentCard(
              environment: env,
              isActive: isActive,
            );
          },
        ),
      ),
    );
  }
}

/// Card individual de cada ambiente no mapa.
/// Widget separado para deixar o código mais organizado.
class _EnvironmentCard extends StatelessWidget {
  final Environment environment;
  final bool isActive; // true = jogador está aqui agora

  const _EnvironmentCard({
    required this.environment,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    // Define cores e ícone com base no estado do ambiente
    final Color borderColor = isActive
        ? Colors.greenAccent        // você está aqui
        : environment.isUnlocked
            ? Colors.blueAccent     // desbloqueado mas não está lá
            : Colors.grey.shade700; // bloqueado

    final Color bgColor = isActive
        ? Colors.green.withOpacity(0.15)
        : environment.isUnlocked
            ? Colors.blue.withOpacity(0.08)
            : Colors.black26;

    final IconData icon = isActive
        ? Icons.my_location
        : environment.isUnlocked
            ? Icons.place
            : Icons.lock;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isActive ? 2 : 1),
      ),
      child: Row(
        children: [
          // Ícone de status
          Icon(icon, color: borderColor, size: 28),
          const SizedBox(width: 16),

          // Informações do ambiente
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome do ambiente
                Text(
                  environment.name,
                  style: TextStyle(
                    color: environment.isUnlocked ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Descrição (só aparece se desbloqueado)
                if (environment.isUnlocked)
                  Text(
                    environment.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  const Text(
                    'Avance na história para desbloquear',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                // Badge "VOCÊ ESTÁ AQUI" quando ativo
                if (isActive) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '📍 VOCÊ ESTÁ AQUI',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
