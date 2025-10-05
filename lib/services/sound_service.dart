import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Reproduce el sonido cuando se selecciona una casilla
  Future<void> playCellSelectionSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/4.mp3'));
    } catch (e) {
      // Silenciar errores de audio para no interrumpir el juego
      print('Error reproduciendo sonido: $e');
    }
  }

  /// Libera los recursos del reproductor de audio
  void dispose() {
    _audioPlayer.dispose();
  }
}
