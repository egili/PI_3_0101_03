import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../constants/environments.dart';
import '../models/environment.dart';

class LocationSessionState {
  final String locationMessage;
  final String coords;
  final String currentEnvironment;
  final Environment? environment;
  final bool promptDialogue;

  LocationSessionState({
    this.locationMessage = 'Obtendo localização...',
    this.coords = 'Lat: -, Lon: -',
    this.currentEnvironment = 'Nenhum ambiente próximo',
    this.environment,
    this.promptDialogue = false,
  });

  LocationSessionState copyWith({
    String? locationMessage,
    String? coords,
    String? currentEnvironment,
    Environment? environment,
    bool? promptDialogue,
    bool clearEnvironment = false,
  }) {
    return LocationSessionState(
      locationMessage: locationMessage ?? this.locationMessage,
      coords: coords ?? this.coords,
      currentEnvironment: currentEnvironment ?? this.currentEnvironment,
      environment: clearEnvironment ? null : (environment ?? this.environment),
      promptDialogue: promptDialogue ?? this.promptDialogue,
    );
  }
}

class LocationSessionNotifier extends StateNotifier<LocationSessionState> {
  LocationSessionNotifier() : super(LocationSessionState());

  final LocationService _locationService = LocationService();
  final List<double> _latBuffer = [];
  final List<double> _lonBuffer = [];
  static const int _bufferSize = 5;

  // BUG #3: aceita callback separado para saída de ambiente
  Future<void> startTracking({
    required void Function(Environment) onEnvironmentEnter,
    required void Function() onEnvironmentExit,
  }) async {
    // Verifica se o GPS está ativado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(locationMessage: 'GPS desativado. Ative a localização.');
      return;
    }

    // Verifica e solicita permissão de localização
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = state.copyWith(locationMessage: 'Permissão de localização negada.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(locationMessage: 'Permissão negada permanentemente. Ative nas configurações.');
      return;
    }

    _locationService.getPositionStream().listen(
      (Position position) => _updateLocation(
        position,
        onEnvironmentEnter: onEnvironmentEnter,
        onEnvironmentExit: onEnvironmentExit,
      ),
      onError: (error) {
        state = state.copyWith(locationMessage: 'Erro ao atualizar localização: $error');
      },
    );
  }

  void _updateLocation(
    Position position, {
    required void Function(Environment) onEnvironmentEnter,
    required void Function() onEnvironmentExit,
  }) {
    _latBuffer.add(position.latitude);
    _lonBuffer.add(position.longitude);
    if (_latBuffer.length > _bufferSize) _latBuffer.removeAt(0);
    if (_lonBuffer.length > _bufferSize) _lonBuffer.removeAt(0);

    final avgLat = _latBuffer.reduce((a, b) => a + b) / _latBuffer.length;
    final avgLon = _lonBuffer.reduce((a, b) => a + b) / _lonBuffer.length;

    final environment = _checkActiveEnvironment(avgLat, avgLon);
    final wasInEnvironment = state.environment != null;
    final isNowInEnvironment = environment != null;

    state = state.copyWith(
      locationMessage: 'Localização atualizada em tempo real',
      coords: 'Lat: ${avgLat.toStringAsFixed(6)}, Lon: ${avgLon.toStringAsFixed(6)}',
      currentEnvironment: environment != null
          ? 'Você está em: ${environment.name}'
          : 'Nenhum ambiente próximo',
      environment: environment,
      clearEnvironment: environment == null,
    );

    if (isNowInEnvironment) {
      // Entrou ou permanece em um ambiente
      onEnvironmentEnter(environment!);
    } else if (wasInEnvironment && !isNowInEnvironment) {
      // BUG #3: saiu de todos os ambientes
      onEnvironmentExit();
    }
  }

  Environment? _checkActiveEnvironment(double lat, double lon) {
    for (var env in staticEnvironments) {
      double distance = Geolocator.distanceBetween(lat, lon, env.latitude, env.longitude);
      if (distance <= env.radius) return env;
    }
    return null;
  }

  void clear() {
    state = LocationSessionState();
  }
}

final locationSessionProvider = StateNotifierProvider<LocationSessionNotifier, LocationSessionState>((ref) {
  return LocationSessionNotifier();
});