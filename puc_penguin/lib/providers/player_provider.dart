import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../services/storage_service.dart';

class PlayerProvider extends StateNotifier<Player?> {
  PlayerProvider() : super(null);

  final StorageService _storageService = StorageService();

  /// Carrega os dados do jogador do armazenamento local.
  Future<void> loadPlayer() async {
    final name = await _storageService.loadPlayerName();
    final genderStr = await _storageService.loadPlayerGender();

    if (name != null && genderStr != null) {
      final gender = genderStr == 'male' ? Gender.male : Gender.female;
      state = Player(
        name: name,
        gender: gender,
      );
    }
  }

  /// Define o jogador atual e salva no armazenamento.
  Future<void> setPlayer(Player player) async {
    state = player;
    await _storageService.savePlayerName(player.name);
    await _storageService.savePlayerGender(player.gender == Gender.male ? 'male' : 'female');
  }

  void clearProfile() {
    state = null;
  }
}

final playerProvider = StateNotifierProvider<PlayerProvider, Player?>((ref) {
  return PlayerProvider();
});
