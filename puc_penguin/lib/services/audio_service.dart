import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Serviço de áudio para músicas e efeitos sonoros.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _musicEnabled = true;

  Future<void> playMenuMusic() async {
    if (!_musicEnabled) return;
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource('audio/menu_music.mp3'));
    } catch (e) {
      debugPrint('AudioService: erro ao tocar música: $e');
    }
  }

  Future<void> stopMusic() async {
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
