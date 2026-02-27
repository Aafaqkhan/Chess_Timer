import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

class AudioService extends GetxService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Note: Place placeholder sound files or handle gracefully if not present
  // For production, we'd add 'assets/sounds/tick.mp3' etc. in pubspec.yaml

  bool _canVibrate = false;

  Future<AudioService> init() async {
    _canVibrate = await Vibration.hasVibrator() ?? false;
    return this;
  }

  Future<void> playTickSound(bool isEnabled) async {
    if (!isEnabled) return;
    try {
      // In a real app we need corresponding asset files.
      await _audioPlayer.play(AssetSource('sounds/tick_short_4.mp3'));
    } catch (e) {
      print("Error playing sound: $e 11");
    }
  }

  Future<void> playTimeoutSound(bool isEnabled) async {
    if (!isEnabled) return;
    try {
      await _audioPlayer.play(AssetSource('sounds/timeout.mp3'));
    } catch (e) {
      print("Error playing sound: $e 22");
    }
  }

  Future<void> triggerVibration(bool isEnabled) async {
    if (!isEnabled) return;
    if (_canVibrate) {
      // Short haptic feedback
      Vibration.vibrate(duration: 50);
    }
  }
}
