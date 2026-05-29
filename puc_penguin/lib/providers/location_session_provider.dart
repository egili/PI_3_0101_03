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
  }) {
    return LocationSessionState(
      locationMessage: locationMessage ?? this.locationMessage,
      coords: coords ?? this.coords,
      currentEnvironment: currentEnvironment ?? this.currentEnvironment,
      environment: environment ?? this.environment,
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

  void startTracking(void Function(Environment) onEnvironmentChange) {
    _locationService.getPositionStream().listen(
      (Position position) => _updateLocation(position, onEnvironmentChange),
      onError: (error) {
        state = state.copyWith(locationMessage: 'Erro ao atualizar localização: $error');
      },
    );
  }

  void _updateLocation(Position position, void Function(Environment) onEnvironmentChange) {
    _latBuffer.add(position.latitude);
    _lonBuffer.add(position.longitude);
    if (_latBuffer.length > _bufferSize) _latBuffer.removeAt(0);
    if (_lonBuffer.length > _bufferSize) _lonBuffer.removeAt(0);

    final avgLat = _latBuffer.reduce((a, b) => a + b) / _latBuffer.length;
    final avgLon = _lonBuffer.reduce((a, b) => a + b) / _lonBuffer.length;

    final environment = _checkActiveEnvironment(avgLat, avgLon);

    state = state.copyWith(
      locationMessage: 'Localização atualizada em tempo real',
      coords: 'Lat: ${avgLat.toStringAsFixed(6)}, Lon: ${avgLon.toStringAsFixed(6)}',
      currentEnvironment: environment != null ? 'Você está em: ${environment.name}' : 'Nenhum ambiente próximo',
      environment: environment,
    );

    if (environment != null) {
      onEnvironmentChange(environment);
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
