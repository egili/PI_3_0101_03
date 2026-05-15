import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerProfile {
  final String name;
  final String gender;

  PlayerProfile({required this.name, required this.gender});
}

class PlayerProvider extends StateNotifier<PlayerProfile?> {
  PlayerProvider() : super(null);

  void setProfile(String name, String gender) {
    state = PlayerProfile(name: name, gender: gender);
  }

  void clearProfile() {
    state = null;
  }
}

final playerProvider = StateNotifierProvider<PlayerProvider, PlayerProfile?>((ref) {
  return PlayerProvider();
});
