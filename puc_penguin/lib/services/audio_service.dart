import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Serviço de áudio para músicas e efeitos sonoros.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _musicEnabled = true;
  String? _currentAssetPath;

  Future<void> playMenuMusic() async {
    if (!_musicEnabled) return;
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource('audio/menu_music.mp3'));
    } catch (e) {
      debugPrint('AudioService: erro ao tocar música do menu: $e');
    }
  }

  Future<void> playEnvironmentMusic(String assetPath) async {
    if (!_musicEnabled) return;
    try {
      // Remove 'assets/' prefix for AssetSource if present
      final relativePath = assetPath.startsWith('assets/')
          ? assetPath.substring(7)
          : assetPath;

      // Only play if the path is different from what's currently playing (if possible)
      // Note: AudioPlayer doesn't easily expose current asset path, but we can track it.
      if (_currentAssetPath == relativePath) return;
      _currentAssetPath = relativePath;

      await _musicPlayer.stop();
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource(relativePath));
    } catch (e) {
      debugPrint('AudioService: erro ao tocar música de ambiente ($assetPath): $e');
    }
  }

  Future<void> stopMusic() async {
    _currentAssetPath = null;
    try {
      await _musicPlayer.stop();
    } catch (e) {
      debugPrint('AudioService: erro ao parar música: $e');
    }
  }


  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) stopMusic();
  }
}
