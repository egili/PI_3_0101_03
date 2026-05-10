import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import '../providers/game_provider.dart';

class EnvironmentsScreen extends ConsumerWidget {
  const EnvironmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedEnvironmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambientes'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contador de progresso
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              '${unlockedIds.length} de ${staticEnvironments.length} desbloqueados',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),

          // Carrossel de ambientes
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

/// Card individual do carrossel
class _EnvironmentCard extends StatelessWidget {
  final Environment environment;
  final bool isUnlocked;

  const _EnvironmentCard({
    required this.environment,
    required this.isUnlocked,
  });

  // Cor placeholder de cada ambiente — trocar por imagem depois
  Color get _placeholderColor {
    switch (environment.id) {
      case 'h15':        return Colors.indigo.shade700;
      case 'biblioteca': return Colors.teal.shade700;
      case 'hospital':   return Colors.red.shade700;
      case 'oficina':    return Colors.orange.shade700;
      case 'mercadao':   return Colors.green.shade700;
      default:           return Colors.blueGrey.shade700;
    }
  }

  // Ícone placeholder de cada ambiente
  IconData get _placeholderIcon {
    switch (environment.id) {
      case 'h15':        return Icons.science;
      case 'biblioteca': return Icons.menu_book;
      case 'hospital':   return Icons.local_hospital;
      case 'oficina':    return Icons.build;
      case 'mercadao':   return Icons.restaurant;
      default:           return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EnvironmentDetailScreen(
                environment: environment,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Este ambiente está bloqueado. Visite o local para desbloqueá-lo!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black87,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Imagem / Placeholder ──────────────────────
              // Quando tiver imagem, substitua este Container por:
              // Image.asset('assets/images/${environment.id}.png', fit: BoxFit.cover)
              Container(
                color: _placeholderColor,
                child: Icon(
                  _placeholderIcon,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),

              // ── Overlay escuro para bloqueados ────────────
              if (!isUnlocked)
                Container(
                  color: Colors.black.withOpacity(0.65),
                ),

              // ── Gradiente inferior (desbloqueados) ────────
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
                          Colors.black.withOpacity(0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Conteúdo do card ──────────────────────────
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

  /// Conteúdo para ambiente desbloqueado
  Widget _buildUnlockedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          environment.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          environment.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Text(
                    'Ver detalhes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Conteúdo para ambiente bloqueado — só preview mínima
  Widget _buildLockedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.lock, color: Colors.white54, size: 36),
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
          'Visite este local para desbloquear',
          style: TextStyle(color: Colors.white38, fontSize: 12),
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
      case 'h15':        return Colors.indigo.shade700;
      case 'biblioteca': return Colors.teal.shade700;
      case 'hospital':   return Colors.red.shade700;
      case 'oficina':    return Colors.orange.shade700;
      case 'mercadao':   return Colors.green.shade700;
      default:           return Colors.blueGrey.shade700;
    }
  }

  IconData get _placeholderIcon {
    switch (environment.id) {
      case 'h15':        return Icons.science;
      case 'biblioteca': return Icons.menu_book;
      case 'hospital':   return Icons.local_hospital;
      case 'oficina':    return Icons.build;
      case 'mercadao':   return Icons.restaurant;
      default:           return Icons.place;
    }
  }

  // O que tem em cada ambiente
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
            content: Text('Este ambiente ainda está bloqueado!'),
            backgroundColor: Colors.red.shade800,
          ),
        );
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Imagem grande no topo ─────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                environment.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder — substitua por Image.asset quando tiver imagem
                  Container(
                    color: _placeholderColor,
                    child: Icon(
                      _placeholderIcon,
                      size: 100,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  // Gradiente para o título ficar legível
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
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
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_open, color: Colors.green, size: 14),
                        SizedBox(width: 4),
                        Text('Desbloqueado',
                            style: TextStyle(
                                color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Descrição
                  const Text(
                    'Descrição',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    environment.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // O que tem no local
                  const Text(
                    'O que você encontrará',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _whatToFind,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
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