import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_screen.dart';
import 'environments_screen.dart';
import '../utils/constants.dart';
import '../providers/game_provider.dart';
import '../services/firebase_progress_service.dart';
import '../models/player.dart';

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

      // ✅ Garante login anônimo antes de qualquer operação no Firebase
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
    } catch (e) {
      debugPrint('Firebase não configurado ainda: $e');
    }

    if (mounted) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => const GameScreen()));
      // Atualiza o botão Continuar ao voltar para a HomeScreen
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
      }
    } catch (e) {
      debugPrint('Erro ao carregar progresso: $e');
    }

    if (mounted) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => const GameScreen()));
      if (mounted) _verificarSaveExistente();
    }
  }

  void _verAmbientes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EnvironmentsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),

              Column(
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: Image.asset(
                      'assets/logo.png',
                      width: size.width * 0.4,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.sports_esports,
                        size: size.width * 0.3,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    AppText.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.textExtraLarge,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  // Botão Novo Jogo
                  _buildButton(
                    text: AppText.startGame,
                    onPressed: _iniciarNovoJogo,
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Botão Continuar
                  _verificandoSave
                      ? const CircularProgressIndicator()
                      : _buildButton(
                          text: AppText.continueGame,
                          isSecondary: true,
                          onPressed: _temSaveExistente
                              ? _continuarJogo
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(AppText.noSave)),
                                  );
                                },
                          disabled: !_temSaveExistente,
                        ),
                  SizedBox(height: size.height * 0.02),

                  // Botão Ver Ambientes
                  _buildButton(
                    text: 'Ver Ambientes',
                    isSecondary: true,
                    onPressed: _verAmbientes,
                    icon: Icons.explore,
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.02),
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

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    bool isSecondary = false,
    bool disabled = false,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? Colors.grey.shade300
              : isSecondary
                  ? AppColors.buttonSecondary
                  : AppColors.buttonPrimary,
          foregroundColor: isSecondary ? AppColors.textPrimary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}