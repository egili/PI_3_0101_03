import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // necessário para HapticFeedback
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final LocationService _locationService = LocationService();
  StreamSubscription<Position>? _positionStreamSubscription;

  // ── Textos exibidos na tela (mesmo estilo original) ───────
  String _locationMessage = 'Obtendo localização...';
  String _coords = 'Lat: -, Lon: -';
  String _currentEnvironment = 'Nenhum ambiente próximo';

  // ── Média móvel (invisível ao usuário, só suaviza os números) ──
  // Guarda as últimas 5 leituras e exibe a média delas
  final List<double> _latBuffer = [];
  final List<double> _lonBuffer = [];
  static const int _bufferSize = 5;

  // ── Controle de vibração ──────────────────────────────────
  // Guarda o ID do último ambiente detectado para vibrar
  // apenas UMA vez ao entrar, não a cada atualização GPS
  String? _lastEnvironmentId;

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

  void _updateLocationUI(Position position) {
    // ── 1. Média móvel ──────────────────────────────────────
    // Adiciona leitura e mantém só as últimas _bufferSize
    _latBuffer.add(position.latitude);
    _lonBuffer.add(position.longitude);
    if (_latBuffer.length > _bufferSize) {
      _latBuffer.removeAt(0);
      _lonBuffer.removeAt(0);
    }

    // Calcula a média — isso elimina os "pulos" do GPS
    final avgLat = _latBuffer.reduce((a, b) => a + b) / _latBuffer.length;
    final avgLon = _lonBuffer.reduce((a, b) => a + b) / _lonBuffer.length;

    // ── 2. Detecta ambiente ─────────────────────────────────
    final environment = _checkActiveEnvironment(avgLat, avgLon);

    // ── 3. Vibração ao entrar em nova área ──────────────────
    // Só vibra se for um ambiente DIFERENTE do último detectado
    if (environment != null && environment.id != _lastEnvironmentId) {
      _lastEnvironmentId = environment.id;
      _vibrate(); // toca a vibração
    } else if (environment == null) {
      // Saiu de todos os ambientes — reseta para vibrar na próxima entrada
      _lastEnvironmentId = null;
    }

    // ── 4. Atualiza a UI no estilo original ─────────────────
    setState(() {
      _locationMessage = 'Localização atualizada em tempo real';

      // toStringAsFixed(6) = 6 casas decimais (~11cm de precisão)
      // É mais estável que mostrar todos os decimais do double
      _coords =
          'Lat: ${avgLat.toStringAsFixed(6)}, Lon: ${avgLon.toStringAsFixed(6)}';

      _currentEnvironment = environment != null
          ? 'Você está em: ${environment.name}'
          : 'Nenhum ambiente próximo';
    });
  }

  /// Detecta em qual ambiente o jogador está com base na posição suavizada.
  Environment? _checkActiveEnvironment(double lat, double lon) {
    for (var env in staticEnvironments) {
      double distance = Geolocator.distanceBetween(
        lat, lon, env.latitude, env.longitude,
      );
      if (distance <= env.radius) {
        return env;
      }
    }
    return null;
  }

  /// Vibra o celular em padrão duplo (bum-bum) ao entrar em uma área.
  /// HapticFeedback é nativo do Flutter — não precisa de pacote extra.
  Future<void> _vibrate() async {
    // Vibração pesada — sentida mesmo no bolso
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
    // Visual 100% igual ao original
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