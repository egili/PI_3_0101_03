import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import '../providers/game_provider.dart';
import 'environments_screen.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
    _startTrackingLocation();
  }

  void _startTrackingLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      _updateLocationUI(position);

      _positionStreamSubscription =
          _locationService.getPositionStream().listen(
        (Position position) => _updateLocationUI(position),
        onError: (error) {
          setState(() {
            _locationMessage = 'Erro ao atualizar localização: $error';
          });
        },
      );
    } catch (e) {

      setState(() => _locationMessage = e.toString());

      // 3. Tratar a recusa (atualiza o texto da tela para não ficar carregando infinitamente)
      setState(() {
        _locationMessage = 'Permissão de localização negada.';
      });

      // 4. Exibir a mensagem caso seja negado (mostra um pop-up pro usuário)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Permissão Necessária"),
            content: const Text("Você precisa aceitar a permissão de localização para o RPG funcionar."),
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
              content: Text('Parabéns! Você acabou de desbloquear o acesso ao ambiente: ${environment.name}!'),
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

      await firebaseService.salvarProgresso(
        deviceId: deviceId,
        playerName: player?.name ?? 'Jogador',
        gender: player?.gender.name ?? 'male',
        currentEnvironmentId: currentEnvId,
        unlockedEnvironments: unlocked,
        missoesConcluidas: const [],
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

              // ── Salvar Jogo ───────────────────────────────
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
                              strokeWidth: 2, color: Colors.white),
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

              // ── Ver Ambientes ─────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EnvironmentsScreen()),
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
          lat, lon, env.latitude, env.longitude);
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
      body: Center(
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
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
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
                    fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}