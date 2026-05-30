import 'package:flutter/material.dart';
import '../utils/app_router.dart';
import '../utils/transitions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import '../providers/game_provider.dart';

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

class EnvironmentsScreen extends ConsumerWidget {
  const EnvironmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedEnvironmentsProvider);

    return Scaffold(
      backgroundColor: _PenguinColors.bgDark,
      appBar: AppBar(
        backgroundColor: _PenguinColors.deepBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Ambientes',
          style: TextStyle(
            color: _PenguinColors.snowWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: _PenguinColors.snowWhite),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Contador de progresso ──────────────────────────────────────
          Container(
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
                      style: TextStyle(
                        color: _PenguinColors.iceBlue,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${unlockedIds.length} / ${staticEnvironments.length} desbloqueados',
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
                    value: staticEnvironments.isEmpty
                        ? 0
                        : unlockedIds.length / staticEnvironments.length,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      _PenguinColors.yellowMain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Carrossel de ambientes ─────────────────────────────────────
          Expanded(
            child: PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.85),
              itemCount: staticEnvironments.length,
              itemBuilder: (context, index) {
                final env = staticEnvironments[index];
                final isUnlocked = unlockedIds.contains(env.id);
                return _EnvironmentCard(
                  environment: env,
                  isUnlocked: isUnlocked,
                );
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// CARD DO CARROSSEL
// ─────────────────────────────────────────────────────────

class _EnvironmentCard extends StatelessWidget {
  final Environment environment;
  final bool isUnlocked;

  const _EnvironmentCard({required this.environment, required this.isUnlocked});

  String get _imagePath => 'assets/images/environments/${environment.id}.png';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          Navigator.push(
            context,
            AppTransitions.route(
              EnvironmentDetailScreen(environment: environment),
              type: TransitionType.slideFromBottom,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Este ambiente está bloqueado. Avance na história para desbloqueá-lo!',
                style: TextStyle(
                  color: _PenguinColors.deepBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: _PenguinColors.yellowMain,
              duration: const Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? _PenguinColors.iceBlue.withOpacity(0.6)
                : Colors.white12,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked
                  ? _PenguinColors.iceBlue.withOpacity(0.15)
                  : Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Imagem ────────────────────────────────────
              Image.asset(
                _imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _PenguinColors.bgMid,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.white30,
                  ),
                ),
              ),

              // ── Overlay bloqueado ─────────────────────────
              if (!isUnlocked) Container(color: Colors.black.withOpacity(0.70)),

              // ── Gradiente inferior (desbloqueado) ─────────
              if (isUnlocked)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          _PenguinColors.bgDark.withOpacity(0.92),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Conteúdo ──────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: isUnlocked
                      ? _buildUnlockedContent()
                      : _buildLockedContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnlockedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          environment.name,
          style: const TextStyle(
            color: _PenguinColors.snowWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          environment.description,
          style: TextStyle(
            color: _PenguinColors.snowWhite.withOpacity(0.75),
            fontSize: 13,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        // Botão "Ver detalhes" — estilo amarelo temático
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _PenguinColors.yellowMain,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _PenguinColors.yellowDark, width: 1.5),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ver detalhes',
                style: TextStyle(
                  color: _PenguinColors.deepBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                size: 14,
                color: _PenguinColors.deepBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLockedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.lock, color: _PenguinColors.iceBlue, size: 36),
        const SizedBox(height: 8),
        Text(
          environment.name,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          'Avance na história para desbloquear',
          style: TextStyle(color: _PenguinColors.iceBlue, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// TELA DE DETALHE DO AMBIENTE
// ─────────────────────────────────────────────────────────

class EnvironmentDetailScreen extends ConsumerWidget {
  final Environment environment;

  const EnvironmentDetailScreen({super.key, required this.environment});

  Color get _placeholderColor {
    switch (environment.id) {
      case 'h15':
        return _PenguinColors.bgMid;
      case 'biblioteca':
        return const Color(0xFF0D3A3A);
      case 'hospital':
        return const Color(0xFF3A0D0D);
      case 'oficina':
        return const Color(0xFF3A2A0D);
      case 'mercadao':
        return const Color(0xFF0D3A1A);
      default:
        return _PenguinColors.bgDark;
    }
  }

  IconData get _placeholderIcon {
    switch (environment.id) {
      case 'h15':
        return Icons.science;
      case 'biblioteca':
        return Icons.menu_book;
      case 'hospital':
        return Icons.local_hospital;
      case 'oficina':
        return Icons.build;
      case 'mercadao':
        return Icons.restaurant;
      default:
        return Icons.place;
    }
  }

  String get _whatToFind {
    switch (environment.id) {
      case 'h15':
        return '• Laboratório de pesquisas avançadas\n'
            '• Terminais com dados confidenciais\n'
            '• Equipamentos experimentais\n'
            '• Pistas sobre o incidente';
      case 'biblioteca':
        return '• Arquivos históricos da instituição\n'
            '• Documentos sigilosos\n'
            '• Tatames e área de treinamento\n'
            '• Registros do passado';
      case 'hospital':
        return '• Equipamentos médicos experimentais\n'
            '• Prontuários confidenciais\n'
            '• Sala de emergência abandonada\n'
            '• Máquina de diagnóstico especial';
      case 'oficina':
        return '• Ferramentas e componentes\n'
            '• Projetos inacabados\n'
            '• Peças de reposição raras\n'
            '• Área de montagem secreta';
      case 'mercadao':
        return '• Freezer com cabos de energia\n'
            '• Suprimentos escondidos\n'
            '• Ponto de encontro dos sobreviventes\n'
            '• Gerador de emergência';
      default:
        return '• Explore o local para descobrir';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedEnvironmentsProvider);
    final isUnlocked = unlockedIds.contains(environment.id);

    if (!isUnlocked) {
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Este ambiente ainda está bloqueado!',
              style: TextStyle(
                color: _PenguinColors.deepBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: _PenguinColors.yellowMain,
          ),
        );
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: _PenguinColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar com imagem ────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _PenguinColors.deepBlue,
            iconTheme: const IconThemeData(color: _PenguinColors.snowWhite),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                environment.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _PenguinColors.snowWhite,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/environments/${environment.id}.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _placeholderColor,
                      child: Icon(
                        _placeholderIcon,
                        size: 100,
                        color: _PenguinColors.iceBlue.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _PenguinColors.bgDark.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Conteúdo detalhado ────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge desbloqueado
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.greenAccent, width: 1.2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_open,
                          color: Colors.greenAccent,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Desbloqueado',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Descrição
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _PenguinColors.snowWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    environment.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // O que tem no local
                  const Text(
                    'O que você encontrará',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _PenguinColors.snowWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _whatToFind,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
