import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final LocationService _locationService = LocationService();
  StreamSubscription<Position>? _positionStreamSubscription;
  String _locationMessage = 'Obtendo localização...';
  String _coords = 'Lat: -, Lon: -';
  String _currentEnvironment = 'Nenhum ambiente próximo';

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
        (Position position) {
          _updateLocationUI(position);
        },
        onError: (error) {
          setState(() {
            _locationMessage = 'Erro ao atualizar localização: $error';
          });
        },
      );
    } catch (e) {
      setState(() {
        _locationMessage = e.toString();
      });
    }
  }

  void _updateLocationUI(Position position) {
    final environment = _checkActiveEnvironment(position);
    setState(() {
      _locationMessage = 'Localização atualizada em tempo real';
      _coords = 'Lat: ${position.latitude}, Lon: ${position.longitude}';
      _currentEnvironment = environment != null
          ? 'Você está em: ${environment.name}'
          : 'Nenhum ambiente próximo';
    });
  }

  dynamic _checkActiveEnvironment(Position position) {
    for (var env in AppEnvironments.environments) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        env.latitude,
        env.longitude,
      );

      if (distance <= env.radius) {
        return env;
      }
    }
    return null;
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
