import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/game_provider.dart';
import '../services/location_service.dart';
import '../services/environment_service.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final LocationService _locationService = LocationService();
  final EnvironmentService _environmentService = EnvironmentService();

  StreamSubscription<Position>? _subscription;

  String _locationMessage = 'Obtendo localização...';
  String _coords = 'Lat: -, Lon: -';

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    try {
      Position position =
          await _locationService.getCurrentLocation();

      _processPosition(position);

      _subscription =
          _locationService.getPositionStream().listen(
        (position) {
          _processPosition(position);
        },
      );
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
      });
    }
  }

  void _processPosition(Position position) {
    final result =
        _environmentService.detectEnvironment(position);

    ref.read(currentEnvironmentIdProvider.notifier).state =
        result?.environment.id;

    setState(() {
      _locationMessage = 'Localização atualizada';
      _coords =
          'Lat: ${position.latitude.toStringAsFixed(5)} | '
          'Lon: ${position.longitude.toStringAsFixed(5)}';
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEnv =
        ref.watch(currentEnvironmentIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(_locationMessage),
            const SizedBox(height: 10),
            Text(_coords),
            const SizedBox(height: 30),
            Text(
              currentEnv == null
                  ? 'Nenhum ambiente próximo'
                  : 'Você está em: $currentEnv',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}