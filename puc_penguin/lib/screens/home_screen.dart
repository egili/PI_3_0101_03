import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_screen.dart';
import 'onboarding_screen.dart';
import 'environments_screen.dart';
import 'missions_screen.dart';
import '../utils/constants.dart';
import '../providers/game_provider.dart';
import '../utils/app_router.dart';
import '../utils/transitions.dart';
import '../providers/mission_provider.dart';
import '../services/firebase_progress_service.dart';
import '../services/audio_service.dart';
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
    AudioService().playMenuMusic();
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
    // Limpa perfil do jogador e reseta missões para o estado inicial
    ref.read(playerProvider.notifier).clearProfile();
    await ref.read(missionProvider.notifier).resetar();

    if (mounted) {
      await Navigator.push(
        context,
        AppTransitions.route(const OnboardingScreen(), type: TransitionType.fade),
      );
      if (mounted) _verificarSaveExistente();
    }
  }

  Future<void> _continuarJogo() async {
    try {
      AudioService().stopMusic();
      final firebaseService = ref.read(firebaseProgressServiceProvider);
      await firebaseService.garantirAutenticacao();

      final deviceId = await ref.read(deviceIdProvider.future);
      final progress = await firebaseService.carregarProgresso(deviceId);

      if (progress != null) {
        ref.read(unlockedEnvironmentsProvider.notifier).state =
            progress.unlockedEnvironments;
        ref.read(currentEnvironmentIdProvider.notifier).state =
            progress.currentEnvironmentId;

        ref.read(playerProvider.notifier).setPlayer(Player(
          name: progress.playerName,
          gender: GenderHelper.fromString(progress.gender),
        ));

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
        AppTransitions.route(const GameScreen(), type: TransitionType.slideFromRight),
      );
      if (mounted) _verificarSaveExistente();
    }
  }

  void _verAmbientes() {
    Navigator.pushNamed(context, AppRoutes.environments);
  }

  void _verMissoes() {
    Navigator.pushNamed(context, AppRoutes.missions);
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
      backgroundColor: const Color(0xFF0A2A5E),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFF0A2A5E)),
          Opacity(
            opacity: 0.18,
            child: Image.asset(
              'assets/backgrounds/background.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),

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

              SizedBox(height: size.height * 0.06),

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
            ],
          ),
        ),
      ),
        ],
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