import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mission.dart';
import '../providers/mission_provider.dart';

// ── Paleta temática PUC Penguin ───────────────────────────────────────────
class _PenguinColors {
  static const Color iceBlue = Color(0xFF3BBFFF);
  static const Color deepBlue = Color(0xFF054C94);
  static const Color yellowMain = Color(0xFFFFC107);
  static const Color yellowDark = Color(0xFFE59000);
  static const Color snowWhite = Color(0xFFECF6FF);
  static const Color bgDark = Color(0xFF0A2A5E);
  static const Color bgMid = Color(0xFF1A4E7A);
}

class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(missionProvider);
    final concluidas = ref.watch(missoesConcluidasCountProvider);
    final total = missionsAsync.value?.length ?? 0;

    return Scaffold(
      backgroundColor: _PenguinColors.bgDark,
      appBar: AppBar(
        backgroundColor: _PenguinColors.deepBlue,
        title: const Text(
          'Missões',
          style: TextStyle(
            color: _PenguinColors.snowWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: _PenguinColors.snowWhite),
        elevation: 0,
      ),
      body: missionsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: _PenguinColors.iceBlue),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: _PenguinColors.yellowMain,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Erro ao carregar missões',
                style: TextStyle(color: _PenguinColors.snowWhite, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(missionProvider.notifier).recarregar(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _PenguinColors.yellowMain,
                  foregroundColor: _PenguinColors.deepBlue,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
        data: (missions) => Column(
          children: [
            _ProgressHeader(concluidas: concluidas, total: total),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: missions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _MissionCard(mission: missions[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BARRA DE PROGRESSO
// ─────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  final int concluidas;
  final int total;

  const _ProgressHeader({required this.concluidas, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : concluidas / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: _PenguinColors.deepBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(color: _PenguinColors.iceBlue, fontSize: 13),
              ),
              Text(
                '$concluidas / $total missões',
                style: const TextStyle(
                  color: _PenguinColors.snowWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                _PenguinColors.yellowMain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CARD DE MISSÃO
// ─────────────────────────────────────────────

class _MissionCard extends ConsumerWidget {
  final Mission mission;

  const _MissionCard({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color cardColor;
    final Color borderColor;
    final Widget leadingIcon;

    switch (mission.status) {
      case MissionStatus.concluida:
        // Verde gelo — concluída
        cardColor = const Color(0xFF0D3320);
        borderColor = Colors.greenAccent;
        leadingIcon = const Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: 28,
        );
        break;
      case MissionStatus.ativa:
        // Azul gelo — ativa
        cardColor = const Color(0xFF0D2A4E);
        borderColor = _PenguinColors.iceBlue;
        leadingIcon = const Icon(
          Icons.radio_button_checked,
          color: _PenguinColors.iceBlue,
          size: 28,
        );
        break;
      case MissionStatus.pendente:
        // Azul escuro apagado — pendente
        cardColor = _PenguinColors.bgMid;
        borderColor = Colors.white12;
        leadingIcon = const Icon(
          Icons.radio_button_unchecked,
          color: Colors.white38,
          size: 28,
        );
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leadingIcon,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mission.titulo,
                          style: TextStyle(
                            color: mission.isPendente
                                ? Colors.white38
                                : _PenguinColors.snowWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: mission.isConcluida
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Colors.greenAccent,
                          ),
                        ),
                      ),
                      // Badge ATIVA — amarelo temático
                      if (mission.isAtiva)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _PenguinColors.yellowMain,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ATIVA',
                            style: TextStyle(
                              color: _PenguinColors.deepBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission.descricao,
                    style: TextStyle(
                      color: mission.isPendente
                          ? Colors.white24
                          : Colors.white60,
                      fontSize: 13,
                    ),
                  ),

                  // Missão ATIVA: botão amarelo primário
                  if (mission.isAtiva) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmarConclusao(context, ref),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Marcar como concluída'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _PenguinColors.yellowMain,
                          foregroundColor: _PenguinColors.deepBlue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: _PenguinColors.yellowDark,
                              width: 1.5,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Missão PENDENTE: botão de gelo outline
                  if (mission.isPendente) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _ativarMissao(ref),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('Iniciar missão'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _PenguinColors.iceBlue,
                          side: const BorderSide(
                            color: _PenguinColors.iceBlue,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ativarMissao(WidgetRef ref) {
    ref
        .read(missionProvider.notifier)
        .atualizarMissaoAtiva(mission.environmentId);
  }

  void _confirmarConclusao(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _PenguinColors.bgMid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Concluir missão?',
          style: TextStyle(
            color: _PenguinColors.snowWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tem certeza que deseja marcar "${mission.titulo}" como concluída?'
          '${mission.proximoEnvironmentId != null ? '\n\nIsso desbloqueará um novo ambiente!' : ''}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: _PenguinColors.iceBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(missionProvider.notifier)
                  .concluirMissao(mission.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: _PenguinColors.deepBlue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            mission.proximoEnvironmentId != null
                                ? 'Missão concluída! Novo ambiente desbloqueado 🗺️'
                                : '"${mission.titulo}" concluída!',
                            style: const TextStyle(
                              color: _PenguinColors.deepBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: _PenguinColors.yellowMain,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _PenguinColors.yellowMain,
              foregroundColor: _PenguinColors.deepBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
