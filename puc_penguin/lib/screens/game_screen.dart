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
      await _salvarAmbienteNoFirebase(environment);

      // NOVO: atualiza a missão ativa ao entrar em um ambiente
      ref.read(missionProvider.notifier).atualizarMissaoAtiva(environment.id);
    } else if (environment == null) {
      _lastEnvironmentId = null;
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

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  // NOVO: observa a missão ativa para o HUD
  final missaoAtiva = ref.watch(missaoAtivaProvider);

  return Scaffold(
    appBar: AppBar(
      title: const Text('Localização do Jogador'),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Opções',
          onPressed: _abrirMenu,
        ),
      ],
    ),

    body: Stack(
      children: [
        // FUNDO
        Positioned.fill(
          child: Image.asset(
            _getBackgroundImage(),
            fit: BoxFit.cover,
          ),
        ),

        // NPC H15
        if (_lastEnvironmentId == 'h15')
          Positioned(
            left: 120,
            top: 240,
            child: AnimatedSprite(
              frames: const [
                'assets/npcs/Pingulino/Pingulino.png',
             ],
              size: 90,
            ),
          ),

        // NPC BIBLIOTECA
        if (_lastEnvironmentId == 'biblioteca')
          Positioned(
            left: 80,
            top: 250,
            child: AnimatedSprite(
              frames: const [
                'assets/npcs/Niyagi/Niyagi.png',
              ],
              size: 90,
            ),
          ),

        // NPC HOSPITAL
        if (_lastEnvironmentId == 'hospital')
          Positioned(
            left: 220,
            top: 220,
            child: AnimatedSprite(
              frames: const [
                'assets/npcs/Joycelina/Joycelina.png',
              ],
              size: 90,
            ),
          ),

        // NPC OFICINA
        if (_lastEnvironmentId == 'oficina')
          Positioned(
            left: 100,
            top: 260,
            child: AnimatedSprite(
              frames: const [
                'assets/npcs/Truffles/Truffles.png',
              ],
              size: 90,
            ),
          ),

        // NPC MERCADÃO - FRANGELINO
        if (_lastEnvironmentId == 'mercadao')
          Positioned(
            left: 70,
            top: 240,
            child: AnimatedSprite(
              frames: const [
                'assets/npcs/Frangelino/Frangelino.png',
              ],
              size: 90,
            ),
          ),

        // NPC MERCADÃO - BUFFLES
        if (_lastEnvironmentId == 'mercadao')
          Positioned(
            right: 70,
            top: 260,
            child: AnimatedSprite(
              frames: const [
                'assets/npcs/Buffles/Buffles.png',
              ],
              size: 90,
            ),
          ),

        // PLAYER
        Center(
          child: AnimatedSprite(
            frames: const [
              'assets/player/idle/Player.png',
            ],
            size: 120,
          ),
        ),
  Widget build(BuildContext context) {
    // Observa a missão ativa para o HUD
    final missaoAtiva = ref.watch(missaoAtivaProvider);
    // NOVO: Observa o estado do diálogo
    final currentDialogue = ref.watch(dialogueProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Localização de ${ref.watch(playerProvider)?.name ?? 'Jogador'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Opções',
            onPressed: _abrirMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          // CONTEÚDO ORIGINAL DO MAPA E HUD
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 50, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  _locationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  _coords,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(
                    _currentEnvironment,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // HUD com a missão ativa
                if (missaoAtiva != null) ...[
                  const SizedBox(height: 20),
                  _MissaoAtivaHUD(titulo: missaoAtiva.titulo),
                ],

                // NOVO: BOTÃO DE TESTE DE DIÁLOGO
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // Inicia o diálogo do Dr. Garibaldo conforme mapeado no gameScript
                    ref.read(dialogueProvider.notifier).startDialogue('h15_intro_1');
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Testar Diálogo Dr. Garibaldo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // NOVO: OVERLAY DO DIÁLOGO
          if (currentDialogue != null)
            Positioned(
              bottom: 20, // Posiciona a caixa na parte inferior da tela
              left: 0,
              right: 0,
              child: DialogBox(
                node: currentDialogue,
                onNext: () {
                  ref.read(dialogueProvider.notifier).next();
                },
                onChoiceSelected: (choice) {
                  ref.read(dialogueProvider.notifier).makeChoice(choice);
                },
              ),
            ),
        ],
      ),
    );
  }
}

        // HUD
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 220),

                Text(
                  _locationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _coords,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Text(
                    _currentEnvironment,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // HUD DE MISSÃO
                if (missaoAtiva != null) ...[
                  const SizedBox(height: 20),
                  _MissaoAtivaHUD(titulo: missaoAtiva.titulo),
                ],
              ],
            ),
          ),
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