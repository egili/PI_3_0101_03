import 'dart:async';
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

  Future<StreamSubscription?> startTracking({
    required void Function(Environment) onEnvironmentEnter,
    required void Function() onEnvironmentExit,
  }) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(locationMessage: 'GPS desativado. Ative a localização.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = state.copyWith(locationMessage: 'Permissão de localização negada.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(
          locationMessage: 'Permissão negada permanentemente. Ative nas configurações.');
      return null;
    }

    final subscription = _locationService.getPositionStream().listen(
      (position) => _updateLocation(
        position,
        onEnvironmentEnter: onEnvironmentEnter,
        onEnvironmentExit: onEnvironmentExit,
      ),
      onError: (error) {
        state = state.copyWith(locationMessage: 'Erro ao atualizar localização: $error');
      },
    );

    return subscription;
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

    // Usa a média suavizada para ENTRAR (evita falsos positivos de GPS instável)
    // Usa a posição bruta para SAIR (reage imediatamente ao cruzar o raio)
    final environmentByAvg = _checkActiveEnvironment(avgLat, avgLon);
    final environmentByRaw = _checkActiveEnvironment(position.latitude, position.longitude);

    final environment = (environmentByAvg != null &&
            environmentByRaw != null &&
            environmentByAvg.id == environmentByRaw.id)
        ? environmentByAvg
        : null;

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
      onEnvironmentEnter(environment!);
    } else if (wasInEnvironment && !isNowInEnvironment) {
      onEnvironmentExit();
    }
  }

  Environment? _checkActiveEnvironment(double lat, double lon) {
    for (var env in staticEnvironments) {
      double distance =
          Geolocator.distanceBetween(lat, lon, env.latitude, env.longitude);
      if (distance <= env.radius) return env;
    }
    return null;
  }

  void clear() {
    _latBuffer.clear();
    _lonBuffer.clear();
    state = LocationSessionState();
  }
}

final locationSessionProvider =
    StateNotifierProvider<LocationSessionNotifier, LocationSessionState>((ref) {
  return LocationSessionNotifier();
});