import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_screen.dart';
import 'environments_screen.dart';
import 'missions_screen.dart';
import '../utils/constants.dart';
import '../providers/game_provider.dart';
import '../providers/mission_provider.dart';
import '../services/firebase_progress_service.dart';
import '../models/player.dart';

// ── Paleta temática PUC Penguin ───────────────────────────────────────────
class _PenguinColors {
  static const Color iceBlue = Color(0xFF3BBFFF);
  static const Color deepBlue = Color(0xFF054C94);
  static const Color yellowMain = Color(0xFFFFC107);
  static const Color yellowDark = Color(0xFFE59000);
  static const Color snowWhite = Color(0xFFECF6FF);
  static const Color iceStroke = Color(0xFF7DD8FF);
  static const Color disabledBg = Color(0xFF8ABCD4);
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _verificandoSave = true;
  bool _temSaveExistente = false;

  @override
  void initState() {
    super.initState();
    _verificarSaveExistente();
  }

  Future<void> _verificarSaveExistente() async {
    try {
      final firebaseService = ref.read(firebaseProgressServiceProvider);
      await firebaseService.garantirAutenticacao();

      final deviceId = await ref.read(deviceIdProvider.future);
      final temSave = await firebaseService.temProgressoSalvo(deviceId);

      setState(() {
        _temSaveExistente = temSave;
        _verificandoSave = false;
      });
    } catch (e) {
      debugPrint('Erro ao verificar save: $e');
      setState(() => _verificandoSave = false);
    }
  }

  Future<void> _iniciarNovoJogo() async {
    try {
      final firebaseService = ref.read(firebaseProgressServiceProvider);
      await firebaseService.garantirAutenticacao();

      final deviceId = await ref.read(deviceIdProvider.future);

      await firebaseService.salvarProgresso(
        deviceId: deviceId,
        playerName: 'Jogador',
        gender: 'male',
        currentEnvironmentId: null,
        unlockedEnvironments: ['h15'],
        missoesConcluidas: [],
        escolhas: {},
      );

      ref.read(playerProvider.notifier).state = Player(
        name: 'Jogador',
        gender: Gender.male,
      );

      await ref.read(missionProvider.notifier).recarregar();
    } catch (e) {
      debugPrint('Firebase não configurado ainda: $e');
    }

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
      if (mounted) _verificarSaveExistente();
    }
  }

  Future<void> _continuarJogo() async {
    try {
      final firebaseService = ref.read(firebaseProgressServiceProvider);
      await firebaseService.garantirAutenticacao();

      final deviceId = await ref.read(deviceIdProvider.future);
      final progress = await firebaseService.carregarProgresso(deviceId);

      if (progress != null) {
        ref.read(unlockedEnvironmentsProvider.notifier).state =
            progress.unlockedEnvironments;
        ref.read(currentEnvironmentIdProvider.notifier).state =
            progress.currentEnvironmentId;
        ref.read(playerProvider.notifier).state = Player(
          name: progress.playerName,
          gender: GenderHelper.fromString(progress.gender),
        );

        await ref.read(missionProvider.notifier).recarregar();

        if (progress.currentEnvironmentId != null) {
          ref
              .read(missionProvider.notifier)
              .atualizarMissaoAtiva(progress.currentEnvironmentId!);
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar progresso: $e');
    }

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
      if (mounted) _verificarSaveExistente();
    }
  }

  void _verAmbientes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EnvironmentsScreen()),
    );
  }

  void _verMissoes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MissionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ── Tamanhos ajustáveis ──────────────────────────────────────────────────
    final double logoWidthFactor = size.width > 600
        ? 0.4
        : 0.80; // era 0.4  → logo maior
    const double btnHeight =
        40.0; // era AppSizes.buttonHeight (≈56) → botões menores
    const double btnFontSize = 15.0; // texto menor proporcional
    const double btnIconSize = 18.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),

              // ── Logo ──────────────────────────────────────────────────────
              SizedBox(
                width: size.width * logoWidthFactor,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.sports_esports,
                    size: size.width * 0.3,
                    color: Colors.blue,
                  ),
                ),
              ),

              // ── Botões ────────────────────────────────────────────────────
              Column(
                children: [
                  _buildPrimaryButton(
                    text: AppText.startGame,
                    icon: Icons.play_arrow_rounded,
                    onPressed: _iniciarNovoJogo,
                    height: btnHeight,
                    fontSize: btnFontSize,
                    iconSize: btnIconSize,
                  ),
                  SizedBox(height: size.height * 0.015),

                  _verificandoSave
                      ? const CircularProgressIndicator()
                      : _buildIceButton(
                          text: AppText.continueGame,
                          icon: Icons.save_rounded,
                          onPressed: _temSaveExistente ? _continuarJogo : null,
                          disabled: !_temSaveExistente,
                          tooltip: !_temSaveExistente ? AppText.noSave : null,
                          height: btnHeight,
                          fontSize: btnFontSize,
                          iconSize: btnIconSize,
                        ),
                  SizedBox(height: size.height * 0.015),

                  _buildIceButton(
                    text: 'Ver Ambientes',
                    icon: Icons.explore_rounded,
                    onPressed: _verAmbientes,
                    height: btnHeight,
                    fontSize: btnFontSize,
                    iconSize: btnIconSize,
                  ),
                  SizedBox(height: size.height * 0.015),

                  _buildIceButton(
                    text: 'Ver Missões',
                    icon: Icons.assignment_rounded,
                    onPressed: _verMissoes,
                    height: btnHeight,
                    fontSize: btnFontSize,
                    iconSize: btnIconSize,
                  ),
                ],
              ),

              // ── Rodapé ────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Text(
                  "© 2026 PUC Penguin - Grupo 03",
                  style: TextStyle(
                    fontSize: AppSizes.textLarge,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Botão amarelo principal ────────────────────────────────────────────────
  Widget _buildPrimaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required double height,
    required double fontSize,
    required double iconSize,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height + 6,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height + 2,
              decoration: BoxDecoration(
                color: _PenguinColors.yellowDark,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius + 4),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: height + 2,
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  size: iconSize,
                  color: _PenguinColors.deepBlue,
                ),
                label: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: _PenguinColors.deepBlue,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _PenguinColors.yellowMain,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadius + 4,
                    ),
                    side: const BorderSide(
                      color: _PenguinColors.yellowDark,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Botão de gelo (secundários) ───────────────────────────────────────────
  Widget _buildIceButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    required double height,
    required double fontSize,
    required double iconSize,
    bool disabled = false,
    String? tooltip,
  }) {
    final button = SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton.icon(
        onPressed: disabled ? null : onPressed,
        icon: Icon(
          icon,
          size: iconSize,
          color: disabled ? _PenguinColors.disabledBg : _PenguinColors.deepBlue,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: disabled
                ? _PenguinColors.disabledBg
                : _PenguinColors.deepBlue,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? Colors.grey.shade300
              : _PenguinColors.snowWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius + 2),
            side: BorderSide(
              color: disabled ? Colors.grey.shade400 : _PenguinColors.iceBlue,
              width: 2,
            ),
          ),
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }
}
