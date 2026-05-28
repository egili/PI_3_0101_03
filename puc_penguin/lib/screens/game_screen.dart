import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import '../providers/game_provider.dart';
import '../providers/mission_provider.dart';
import 'environments_screen.dart';
import 'missions_screen.dart';
import 'dart:async';
import '../widgets/animated_sprite.dart';
import '../providers/dialogue_provider.dart';
import '../widgets/dialog_box.dart';
import '../utils/app_router.dart';
import '../utils/transitions.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final LocationService _locationService = LocationService();
  StreamSubscription<Position>? _positionStreamSubscription;

  String _locationMessage = 'Obtendo localização...';
  String _coords = 'Lat: -, Lon: -';
  String _currentEnvironment = 'Nenhum ambiente próximo';

  final List<double> _latBuffer = [];
  final List<double> _lonBuffer = [];
  static const int _bufferSize = 5;

  String? _lastEnvironmentId;
  bool _salvando = false;
  bool _mostrarPromptDialogo = false;
  Environment? _ambienteAtual;

  //Integrar Background
  String _getBackgroundImage() {
    switch (_lastEnvironmentId) {
      case 'h15':
        return 'assets/backgrounds/h15.png';

      case 'biblioteca':
        return 'assets/backgrounds/biblioteca.png';

      case 'hospital':
        return 'assets/backgrounds/hospital.png';

      case 'oficina':
        return 'assets/backgrounds/oficina.png';

      case 'mercadao':
        return 'assets/backgrounds/mercadao.png';

      default:
        return 'assets/backgrounds/default.png';
    }
  }
  //

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _startTrackingLocation();
  }

  void _startTrackingLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      _updateLocationUI(position);

      _positionStreamSubscription = _locationService.getPositionStream().listen(
        (Position position) => _updateLocationUI(position),
        onError: (error) {
          setState(() {
            _locationMessage = 'Erro ao atualizar localização: $error';
          });
        },
      );
    } catch (e) {
      setState(() => _locationMessage = 'Permissão de localização negada.');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Permissão Necessária"),
            content: const Text(
              "Você precisa aceitar a permissão de localização para o RPG funcionar.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Entendi"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _updateLocationUI(Position position) async {
    _latBuffer.add(position.latitude);
    _lonBuffer.add(position.longitude);
    if (_latBuffer.length > _bufferSize) _latBuffer.removeAt(0);
    if (_lonBuffer.length > _bufferSize) _lonBuffer.removeAt(0);

    final avgLat = _latBuffer.reduce((a, b) => a + b) / _latBuffer.length;
    final avgLon = _lonBuffer.reduce((a, b) => a + b) / _lonBuffer.length;

    final environment = _checkActiveEnvironment(avgLat, avgLon);

    if (environment != null && environment.id != _lastEnvironmentId) {
      _lastEnvironmentId = environment.id;
      _vibrate();
      // Salva no Firebase em background — não bloqueia o fluxo do jogo
      _salvarAmbienteNoFirebase(environment);
      ref.read(missionProvider.notifier).atualizarMissaoAtiva(environment.id);
      setState(() {
        _ambienteAtual = environment;
        _mostrarPromptDialogo = true;
      });
    } else if (environment == null) {
      _lastEnvironmentId = null;
      ref.read(dialogueProvider.notifier).closeDialogue();
      setState(() {
        _ambienteAtual = null;
        _mostrarPromptDialogo = false;
      });
    }

    setState(() {
      _locationMessage = 'Localização atualizada em tempo real';
      _coords =
          'Lat: ${avgLat.toStringAsFixed(6)}, Lon: ${avgLon.toStringAsFixed(6)}';
      _currentEnvironment = environment != null
          ? 'Você está em: ${environment.name}'
          : 'Nenhum ambiente próximo';
    });
  }

  Future<void> _salvarAmbienteNoFirebase(Environment environment) async {
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final firebaseService = ref.read(firebaseProgressServiceProvider);

      await firebaseService.salvarAmbienteAtual(
        deviceId: deviceId,
        environmentId: environment.id,
      );
      await firebaseService.desbloquearAmbiente(
        deviceId: deviceId,
        environmentId: environment.id,
      );

      ref.read(currentEnvironmentIdProvider.notifier).state = environment.id;
      final unlocked = [...ref.read(unlockedEnvironmentsProvider)];
      if (!unlocked.contains(environment.id)) {
        unlocked.add(environment.id);
        ref.read(unlockedEnvironmentsProvider.notifier).state = unlocked;

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.lock_open, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Novo Ambiente!'),
                ],
              ),
              content: Text(
                'Parabéns! Você acabou de desbloquear o acesso ao ambiente: ${environment.name}!',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Incrível!'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Firebase não configurado: $e');
    }
  }

  Future<void> _salvarManualmente() async {
    setState(() => _salvando = true);

    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final firebaseService = ref.read(firebaseProgressServiceProvider);
      final player = ref.read(playerProvider);
      final currentEnvId = ref.read(currentEnvironmentIdProvider);
      final unlocked = ref.read(unlockedEnvironmentsProvider);

      // CORREÇÃO: lê as missões antes de salvar para não sobrescrever
      final progressAtual = await firebaseService.carregarProgresso(deviceId);
      final missoesConcluidas = progressAtual?.missoesConcluidas ?? [];

      await firebaseService.salvarProgresso(
        deviceId: deviceId,
        playerName: player?.name ?? 'Jogador',
        gender: player?.gender.name ?? 'male',
        currentEnvironmentId: currentEnvId,
        unlockedEnvironments: unlocked,
        missoesConcluidas: missoesConcluidas, // antes era const []
        escolhas: const {},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Jogo salvo com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar. Verifique sua conexão.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() => _salvando = false);
    }
  }

  void _abrirMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blueGrey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Opções',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Salvar Jogo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvando
                      ? null
                      : () {
                          Navigator.pop(context);
                          _salvarManualmente();
                        },
                  icon: _salvando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_salvando ? 'Salvando...' : 'Salvar Jogo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // NOVO: botão Missões
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MissionsScreen()),
                    );
                  },
                  icon: const Icon(Icons.assignment),
                  label: const Text('Missões'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Ver Ambientes
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EnvironmentsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.explore),
                  label: const Text('Ver Ambientes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Environment? _checkActiveEnvironment(double lat, double lon) {
    for (var env in staticEnvironments) {
      double distance = Geolocator.distanceBetween(
        lat,
        lon,
        env.latitude,
        env.longitude,
      );
      if (distance <= env.radius) return env;
    }
    return null;
  }

  Future<void> _vibrate() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.heavyImpact();
  }

  // ─── Métodos auxiliares de NPC / Sprite ────────────────────────────────────

  /// Sprite do NPC correspondente ao ambiente atual.
  String _getNpcSpriteForEnvironment(String? environmentId) {
    switch (environmentId) {
      case 'h15':
        return 'assets/npcs/Pingulino/Pingulino.png';
      case 'biblioteca':
        return 'assets/npcs/Niyagi/Niyagi.png';
      case 'hospital':
        return 'assets/npcs/Joycelina/Joycelina.png';
      case 'oficina':
        return 'assets/npcs/Truffles/Truffles.png';
      case 'mercadao':
        return 'assets/npcs/Frigelino/Frigelino.png';
      default:
        return 'assets/npcs/Pingulino/Pingulino.png';
    }
  }

  /// Nome de exibição do NPC correspondente ao ambiente atual.
  String _getNpcNameForEnvironment(String? environmentId) {
    switch (environmentId) {
      case 'h15':
        return 'Pingulino';
      case 'biblioteca':
        return 'Niyagi';
      case 'hospital':
        return 'Joycelina';
      case 'oficina':
        return 'Truffles';
      case 'mercadao':
        return 'Frigelino';
      default:
        return 'NPC';
    }
  }

  /// ID do diálogo a ser iniciado para o ambiente atual.
  String _getDialogueIdForEnvironment(String? environmentId) {
    switch (environmentId) {
      case 'h15':
        return 'h15_intro_1';
      case 'biblioteca':
        return 'biblio_intro_1';
      case 'hospital':
        return 'hospital_intro_1';
      case 'oficina':
        return 'oficina_intro_1';
      case 'mercadao':
        return 'mercadao_intro_1';
      default:
        return 'h15_intro_1';
    }
  }

  /// Sprite do jogador conforme o gênero selecionado no onboarding.
  String _getPlayerSprite() {
    final player = ref.read(playerProvider);
    final isFemale = player?.gender.name == 'female';
    return isFemale
        ? 'assets/player/idle/Player_female.png'
        : 'assets/player/idle/Player.png';
  }

  // ─── Pop-ups ───────────────────────────────────────────────────────────────

  void _mostrarPopupNovoAmbiente(String nomeAmbiente) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1526),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF4A90E2), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90E2).withOpacity(0.3),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A3A5C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_open_rounded,
                    color: Color(0xFF4A90E2), size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'NOVO AMBIENTE DESBLOQUEADO',
                style: TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                nomeAmbiente,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Você chegou a um novo local da ilha!',
                style: TextStyle(color: Colors.white60, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A6FDB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Incrível!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarPopupItemRecebido(String nomeItem) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1526),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD700), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.25),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2000),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.card_giftcard_rounded,
                    color: Color(0xFFFFD700), size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'ITEM RECEBIDO',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nomeItem,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Este item foi confiado a você.',
                style: TextStyle(color: Colors.white60, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8860B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Ótimo!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Item entregue ao jogador ao concluir o diálogo correto de cada ambiente.
  String? _getItemDoAmbiente(String? environmentId) {
    switch (environmentId) {
      case 'h15':
        return 'Comunicador';
      case 'biblioteca':
        return 'Mapa da Ilha';
      case 'hospital':
        return 'Kit Médico';
      case 'oficina':
        return 'Chave Multiuso';
      case 'mercadao':
        return 'Ração de Emergência';
      default:
        return null;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final missaoAtiva = ref.watch(missaoAtivaProvider);
    final currentDialogue = ref.watch(dialogueProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Localização de ${ref.watch(playerProvider)?.name ?? "Jogador"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Opções',
            onPressed: _abrirMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // ÁREA DO JOGO
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final npcSize = w * 0.40;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // FUNDO
                    Positioned.fill(
                      child: Image.asset(
                        _getBackgroundImage(),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // NPCs — só aparecem dentro de um ambiente ativo
                    if (_lastEnvironmentId != null) ...[
                      if (_lastEnvironmentId == 'h15')
                        Positioned(
                          left: w * 0.06, bottom: h * 0.04,
                          child: AnimatedSprite(
                            frames: const ['assets/npcs/Pingulino/Pingulino.png'],
                            size: npcSize,
                          ),
                        ),
                      if (_lastEnvironmentId == 'biblioteca')
                        Positioned(
                          left: w * 0.06, bottom: h * 0.04,
                          child: AnimatedSprite(
                            frames: const ['assets/npcs/Niyagi/Niyagi.png'],
                            size: npcSize,
                          ),
                        ),
                      if (_lastEnvironmentId == 'hospital')
                        Positioned(
                          right: w * 0.06, bottom: h * 0.04,
                          child: AnimatedSprite(
                            frames: const ['assets/npcs/Joycelina/Joycelina.png'],
                            size: npcSize,
                          ),
                        ),
                      if (_lastEnvironmentId == 'oficina')
                        Positioned(
                          left: w * 0.06, bottom: h * 0.04,
                          child: AnimatedSprite(
                            frames: const ['assets/npcs/Truffles/Truffles.png'],
                            size: npcSize,
                          ),
                        ),
                      if (_lastEnvironmentId == 'mercadao') ...[
                        Positioned(
                          left: w * 0.04, bottom: h * 0.04,
                          child: AnimatedSprite(
                            frames: const ['assets/npcs/Frigelino/Frigelino.png'],
                            size: npcSize,
                          ),
                        ),
                        Positioned(
                          right: w * 0.04, bottom: h * 0.04,
                          child: AnimatedSprite(
                            frames: const ['assets/npcs/Buffles/Buffles.png'],
                            size: npcSize * 0.85,
                          ),
                        ),
                      ],
                    ],

                    // HUD
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            _locationMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _coords,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Text(
                              _currentEnvironment,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (missaoAtiva != null) ...[
                            const SizedBox(height: 12),
                            _MissaoAtivaHUD(titulo: missaoAtiva.titulo),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // DIÁLOGO
          if (currentDialogue != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.60,
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: DialogBox(
                    node: currentDialogue,
                    npcSprite: _getNpcSpriteForEnvironment(_lastEnvironmentId),
                    playerSprite: _getPlayerSprite(),
                    onNext: () => ref.read(dialogueProvider.notifier).next(),
                    onChoiceSelected: (choice) =>
                        ref.read(dialogueProvider.notifier).makeChoice(choice),
                  ),
                ),
              ),
            ),

          // PROMPT
          if (_mostrarPromptDialogo && currentDialogue == null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _NpcPromptOverlay(
                npcName: _getNpcNameForEnvironment(_lastEnvironmentId),
                onFalar: () {
                  setState(() => _mostrarPromptDialogo = false);
                  final dialogueId = _getDialogueIdForEnvironment(_lastEnvironmentId);
                  final envId = _lastEnvironmentId;
                  ref.read(dialogueProvider.notifier).startDialogue(
                    dialogueId,
                    onComplete: () {
                      final item = _getItemDoAmbiente(envId);
                      if (item != null && mounted) _mostrarPopupItemRecebido(item);
                    },
                  );
                },
                onIgnorar: () => setState(() => _mostrarPromptDialogo = false),
              ),
            ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────
// PROMPT DE INTERAÇÃO COM NPC
// ─────────────────────────────────────────────

class _NpcPromptOverlay extends StatelessWidget {
  final String npcName;
  final VoidCallback onFalar;
  final VoidCallback onIgnorar;

  const _NpcPromptOverlay({
    required this.npcName,
    required this.onFalar,
    required this.onIgnorar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xDD0A1628),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3A5C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.chat_bubble_outline,
                    color: Color(0xFF4A90E2), size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      npcName,
                      style: const TextStyle(
                        color: Color(0xFF4A90E2),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Deseja conversar com este personagem?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onFalar,
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('RESPONDER',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A6FDB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onIgnorar,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('IGNORAR /\nNAO FALAR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5),
                      textAlign: TextAlign.center),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2C3E),
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HUD DE MISSÃO ATIVA
// ─────────────────────────────────────────────

class _MissaoAtivaHUD extends StatelessWidget {
  final String titulo;

  const _MissaoAtivaHUD({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A90E2), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_turned_in,
            color: Color(0xFF4A90E2),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MISSÃO ATIVA',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}