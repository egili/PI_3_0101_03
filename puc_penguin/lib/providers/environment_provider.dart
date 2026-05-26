import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/environments.dart';
import '../models/environment.dart';
import '../services/audio_service.dart';

class EnvironmentNotifier extends StateNotifier<Environment?> {
  EnvironmentNotifier() : super(null);

  void updateLocation(Position position, WidgetRef ref) {
    for (var env in staticEnvironments) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        env.latitude,
        env.longitude,
      );

      if (distance <= env.radius) {
        if (state?.id != env.id) {
          state = env;
          AudioService().playMusic(env.audioAsset);

          // Auto-unlock logic
          final progressSaver = ref.read(progressSaverProvider.notifier);
          progressSaver.salvarDesbloqueio(env.id);
        }
        return;
      }
    }
    if (state != null) {
      state = null; // Fora de qualquer área
      AudioService().stopMusic();
    }
  }
}

final environmentProvider = StateNotifierProvider<EnvironmentNotifier, Environment?>((ref) {
  return EnvironmentNotifier();
});
