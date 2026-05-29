import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mission_provider.dart';
import '../utils/app_router.dart';

/// Tela final exibida após o jogador concluir todas as missões (h15_final_fim).
class EndingScreen extends ConsumerWidget {
  const EndingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF04080F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Título
              const Text(
                'FIM',
                style: TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'PUC PENGUIN',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Ícone de conclusão
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4A90E2), width: 2),
                  color: const Color(0xFF0D1526),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF4A90E2),
                  size: 64,
                ),
              ),
              const SizedBox(height: 40),
              // Texto narrativo de encerramento
              const Text(
                'A ilha e seus blocos agora pertencem\naos seus habitantes restaurados.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.7,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'O verdadeiro inimigo era a lógica analítica\nsem coração. E, de algum jeito imprevisível,\na esperança humana venceu os algoritmos.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.7,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 56),
              // Créditos
              _creditSection('Desenvolvido por', 'Grupo 03 — PUC-Campinas'),
              const SizedBox(height: 12),
              _creditSection('Disciplina', 'Projetos Interdisciplinares'),
              const SizedBox(height: 48),
              // Botão novo jogo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(missionProvider.notifier).resetar();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    'Novo Jogo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A6FDB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white54,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Voltar ao Menu'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _creditSection(String label, String value) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
