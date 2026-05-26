import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentAsset;

  Future<void> playMusic(String assetPath) async {
    if (_currentAsset == assetPath) return;

    await stopMusic();

    try {
      _currentAsset = assetPath;
      await _player.setReleaseMode(ReleaseMode.loop);

      // Remove 'assets/' prefix if present as AssetSource expects path relative to assets root
      final relativePath = assetPath.startsWith('assets/')
          ? assetPath.substring(7)
          : assetPath;

      await _player.play(AssetSource(relativePath));
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  Future<void> playMenuMusic() async {
    await playMusic('assets/audio/main_theme.wav');
  }

  Future<void> stopMusic() async {
    await _player.stop();
    _currentAsset = null;
  }

  void dispose() {
    _player.dispose();
  }
}
