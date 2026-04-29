import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/environments.dart';
import '../models/environment.dart';

class EnvironmentNotifier extends StateNotifier<Environment?> {
  EnvironmentNotifier() : super(null);

  void updateLocation(Position position) {
    for (var env in staticEnvironments) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        env.latitude,
        env.longitude,
      );

      if (distance <= env.radius) {
        state = env;
        return;
      }
    }
    state = null; // Fora de qualquer área
  }
}

final environmentProvider = StateNotifierProvider<EnvironmentNotifier, Environment?>((ref) {
  return EnvironmentNotifier();
});
