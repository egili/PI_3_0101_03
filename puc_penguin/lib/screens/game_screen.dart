import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/environment_service.dart';
import '../providers/game_provider.dart';
import 'dart:async';

// Mudamos de StatefulWidget para ConsumerStatefulWidget
// porque precisamos acessar os providers do Riverpod (ref)
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final LocationService _locationService = LocationService();

  // Instancia o novo serviço de detecção de ambientes
  final EnvironmentService _environmentService = EnvironmentService();

  StreamSubscription<Position>? _positionStreamSubscription;
  String _locationMessage = 'Obtendo localização...';
  String _coords = 'Lat: -, Lon: -';
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
      // Pega a posição inicial uma vez
      Position position = await _locationService.getCurrentLocation();
      _processPosition(position);

      // Depois disso, fica ouvindo atualizações em tempo real
      _positionStreamSubscription =
          _locationService.getPositionStream().listen(
        (Position position) {
          _processPosition(position);
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

  /// Centraliza todo o processamento de uma nova posição GPS.
  /// Separa bem as responsabilidades: UI, provider e lógica de negócio.
  void _processPosition(Position position) {
    // 1. Delega a lógica de detecção para o serviço especializado
    final result = _environmentService.detectEnvironment(position);

    // 2. Busca o ambiente mais próximo (mesmo fora do raio) para informar o jogador
    final nearest = _environmentService.findNearest(position);

    // 3. Atualiza o provider global com o ID do ambiente atual (ou null)
    //    Isso permite que qualquer widget na árvore reaja a essa mudança
    ref.read(currentEnvironmentIdProvider.notifier).state =
        result?.environment.id;

    // 4. Atualiza o estado local da tela para refletir na UI
    setState(() {
      _locationMessage = 'Localização atualizada em tempo real';
      _coords =
          'Lat: ${position.latitude.toStringAsFixed(5)}, '
          'Lon: ${position.longitude.toStringAsFixed(5)}';
    });
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
    // Lê o ID do ambiente atual do provider — se mudar, o widget reconstrói
    final currentEnvId = ref.watch(currentEnvironmentIdProvider);

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
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Widget que reage ao ambiente detectado
            _buildEnvironmentCard(currentEnvId),
          ],
        ),
      ),
    );
  }

  /// Separa a construção do card em método próprio para deixar o build limpo.
  Widget _buildEnvironmentCard(String? currentEnvId) {
    // Caso fora de área (null): mostra mensagem de nenhum ambiente próximo
    if (currentEnvId == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: const Text(
          'Nenhum ambiente próximo.\nCaminha até um ponto do mapa!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Caso dentro de um ambiente: mostra o nome com destaque
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        children: [
          const Icon(Icons.place, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            '📍 Você está em:',
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
          Text(
            currentEnvId, // Aqui você pode trocar pelo nome, buscando na lista
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
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
