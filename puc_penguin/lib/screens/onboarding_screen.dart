import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../providers/player_provider.dart';
import '../utils/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  Gender? _selectedGender;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _completeOnboarding(WidgetRef ref) async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showSnack('Por favor, insira o nome do seu pinguim');
      return;
    }
    if (_selectedGender == null) {
      _showSnack('Por favor, selecione um gênero');
      return;
    }

    final player = Player(name: name, gender: _selectedGender!);
    await ref.read(playerProvider.notifier).setPlayer(player);

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.tutorial);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF1A3A5C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF060E1A),
          body: Stack(
            children: [
              // ── Fundo estrelado ──────────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(painter: _StarfieldPainter()),
              ),

              // ── Gradiente de profundidade ────────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.2,
                      colors: [
                        const Color(0xFF0A2040).withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Conteúdo ─────────────────────────────────────────────────
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          // Título
                          const Text(
                            'QUEM É VOCÊ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 60,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // ── Seleção de gênero ──────────────────────────
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ESCOLHA SEU PINGUIM',
                              style: TextStyle(
                                color: Color(0xFF4A90E2),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _GenderCard(
                                  label: 'MASCULINO',
                                  spritePath:
                                      'assets/player/idle/Player.png',
                                  isSelected:
                                      _selectedGender == Gender.male,
                                  accentColor: const Color(0xFF4A90E2),
                                  onTap: () => setState(
                                      () => _selectedGender = Gender.male),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _GenderCard(
                                  label: 'FEMININO',
                                  spritePath:
                                      'assets/player/idle/Player_female.png',
                                  isSelected:
                                      _selectedGender == Gender.female,
                                  accentColor: const Color(0xFFE24A90),
                                  onTap: () => setState(
                                      () => _selectedGender = Gender.female),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // ── Nome ───────────────────────────────────────
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'NOME DO PINGUIM',
                              style: TextStyle(
                                color: Color(0xFF4A90E2),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _nameController,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: const Color(0xFF4A90E2),
                            decoration: InputDecoration(
                              hintText: 'Ex: Pinguim Gelado',
                              hintStyle: const TextStyle(
                                  color: Colors.white24, fontSize: 15),
                              filled: true,
                              fillColor: const Color(0xFF0D1F35),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Color(0xFF1E3A5F)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Color(0xFF1E3A5F)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Color(0xFF4A90E2), width: 2),
                              ),
                              prefixIcon: const Icon(Icons.sports_esports,
                                  color: Color(0xFF4A90E2)),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // ── Botão ──────────────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  _nameController.text.isNotEmpty &&
                                          _selectedGender != null
                                      ? () => _completeOnboarding(ref)
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A6FDB),
                                disabledBackgroundColor:
                                    const Color(0xFF1A2A3A),
                                foregroundColor: Colors.white,
                                disabledForegroundColor: Colors.white24,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.rocket_launch, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    'COMEÇAR JORNADA',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Card de seleção de gênero ─────────────────────────────────────────────────

class _GenderCard extends StatelessWidget {
  final String label;
  final String spritePath;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.spritePath,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.15)
              : const Color(0xFF0D1F35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFF1E3A5F),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            // Preview do sprite
            SizedBox(
              height: 130,
              child: Image.asset(
                spritePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 80,
                  color: accentColor.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Label
            Text(
              label,
              style: TextStyle(
                color: isSelected ? accentColor : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // Indicador selecionado
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 28 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fundo estrelado ───────────────────────────────────────────────────────────

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.35);
    final stars = [
      [0.1, 0.05], [0.3, 0.12], [0.7, 0.08], [0.9, 0.15],
      [0.2, 0.25], [0.5, 0.18], [0.8, 0.3],  [0.15, 0.4],
      [0.65, 0.35],[0.45, 0.5], [0.85, 0.45],[0.05, 0.6],
      [0.35, 0.65],[0.75, 0.6], [0.55, 0.75],[0.25, 0.8],
      [0.9, 0.72], [0.12, 0.88],[0.6, 0.9],  [0.4, 0.95],
    ];
    for (final s in stars) {
      canvas.drawCircle(
        Offset(size.width * s[0], size.height * s[1]),
        1.5,
        paint,
      );
    }
    // Estrelas maiores
    paint.color = Colors.white.withOpacity(0.6);
    final big = [[0.22, 0.1], [0.78, 0.22], [0.5, 0.4], [0.88, 0.65]];
    for (final s in big) {
      canvas.drawCircle(
        Offset(size.width * s[0], size.height * s[1]),
        2.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
