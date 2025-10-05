import 'package:audioplayers/audioplayers.dart';
import '../utils/app_logger.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Reproduce el sonido cuando se selecciona una casilla
  Future<void> playCellSelectionSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/4.mp3'));
    } catch (e, stackTrace) {
      // Registrar error pero no interrumpir el juego
      logger.error('Error reproduciendo sonido', e, stackTrace);
    }
  }

  /// Libera los recursos del reproductor de audio
  void dispose() {
    _audioPlayer.dispose();
  }
}
