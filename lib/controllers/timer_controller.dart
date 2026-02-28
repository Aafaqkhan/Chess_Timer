import 'dart:async';
import 'package:chess_timer/services/audio_service.dart';
import 'package:get/get.dart';
import '../models/time_control.dart';
import '../utils/constants.dart';
import '../services/storage_service.dart';

enum PlayerTurn { none, player1, player2 }

class TimerController extends GetxController {
  final AudioService _audioService = Get.find<AudioService>();

  final bool isCustom;

  TimerController({this.isCustom = false});

  // Current Time Control (default to Blitz 5+0 initially)
  var currentTimeControl = AppConstants.defaultTimeControls
      .firstWhere((tc) => tc.name == '5+0')
      .obs;

  // Times in seconds
  var player1TimeLeft = 0.obs;
  var player2TimeLeft = 0.obs;

  // Move counters
  var player1Moves = 0.obs;
  var player2Moves = 0.obs;

  // Game state
  var isPlaying = false.obs;
  var isGameOver = false.obs;
  var turn = PlayerTurn.none.obs;

  // Player names
  var player1Name = 'Player 1'.obs;
  var player2Name = 'Player 2'.obs;

  // Settings
  var isSoundOn = true.obs;
  var isVibrationOn = true.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadPlayerNames();
    resetGame();
  }

  void _loadPlayerNames() {
    final storage = Get.find<StorageService>();
    final settings = storage.loadSettings();
    player1Name.value = settings.player1Name;
    player2Name.value = settings.player2Name;
    isSoundOn.value = settings.isSoundOn;
    isVibrationOn.value = settings.isVibrationOn;

    // Load persisted selected time control
    final savedTimeId = settings.selectedTimeId;

    final defaultMatches = AppConstants.defaultTimeControls.where(
      (tc) => tc.id == savedTimeId,
    );
    if (defaultMatches.isNotEmpty) {
      currentTimeControl.value = defaultMatches.first;
    } else {
      final customTimes = storage.loadCustomTimeControls();
      final customMatches = customTimes.where((tc) => tc.id == savedTimeId);
      if (customMatches.isNotEmpty) {
        currentTimeControl.value = customMatches.first;
      } else {
        currentTimeControl.value = AppConstants.defaultTimeControls.firstWhere(
          (tc) => tc.name == '5+0',
        );
      }
    }
  }

  void updateSound(bool value) {
    isSoundOn.value = value;
    final storage = Get.find<StorageService>();
    final settings = storage.loadSettings();
    settings.isSoundOn = value;
    storage.saveSettings(settings);
  }

  void updateVibration(bool value) {
    isVibrationOn.value = value;
    final storage = Get.find<StorageService>();
    final settings = storage.loadSettings();
    settings.isVibrationOn = value;
    storage.saveSettings(settings);
  }

  void updatePlayerName(int playerNumber, String name) {
    if (playerNumber == 1) {
      player1Name.value = name;
    } else {
      player2Name.value = name;
    }
    // Persist
    final storage = Get.find<StorageService>();
    final settings = storage.loadSettings();
    if (playerNumber == 1) {
      settings.player1Name = name;
    } else {
      settings.player2Name = name;
    }
    storage.saveSettings(settings);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void setTimeControl(TimeControl tc) {
    currentTimeControl.value = tc;

    // Save to settings
    final storage = Get.find<StorageService>();
    final settings = storage.loadSettings();
    settings.selectedTimeId = tc.id;
    storage.saveSettings(settings);

    resetGame();
  }

  void resetGame() {
    _timer?.cancel();
    isPlaying.value = false;
    isGameOver.value = false;
    turn.value = PlayerTurn.none;
    player1Moves.value = 0;
    player2Moves.value = 0;

    int initialTime = currentTimeControl.value.durationSeconds;
    player1TimeLeft.value = initialTime;
    player2TimeLeft.value = initialTime;
  }

  void togglePlayPause() {
    if (isGameOver.value) return;

    if (isPlaying.value) {
      pauseTimer();
    } else {
      // If game hasn't started, default to first move from Player 1
      if (turn.value == PlayerTurn.none) {
        turn.value = PlayerTurn.player1;
      }
      startTimer();
    }
  }

  void startTimer() {
    isPlaying.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (turn.value == PlayerTurn.player1) {
        if (player1TimeLeft.value > 0) {
          player1TimeLeft.value--;
        } else {
          timeOut(PlayerTurn.player1);
        }
      } else if (turn.value == PlayerTurn.player2) {
        if (player2TimeLeft.value > 0) {
          player2TimeLeft.value--;
        } else {
          timeOut(PlayerTurn.player2);
        }
      }
    });
  }

  void pauseTimer() {
    isPlaying.value = false;
    _timer?.cancel();
  }

  void switchTurn(PlayerTurn tapFrom) {
    // If game is over, do nothing
    if (isGameOver.value) return;

    // If game not started, tapping starts it and gives turn to the OTHER player
    if (!isPlaying.value && turn.value == PlayerTurn.none) {
      turn.value = tapFrom == PlayerTurn.player1
          ? PlayerTurn.player2
          : PlayerTurn.player1;
      startTimer();
      // Optional: Add a move? Typically the first tap doesn't count as a move, just starts the clock.

      _audioService.playTickSound(isSoundOn.value);
      _audioService.triggerVibration(isVibrationOn.value);

      return;
    }

    // If game is paused, but has started, do we allow tap to resume and switch?
    // Let's assume you must use the Play/Pause button to resume.
    if (!isPlaying.value) return;

    // Only active player can switch turn
    if (turn.value != tapFrom) return;

    // Add increment to the player who just moved
    int increment = currentTimeControl.value.incrementSeconds;
    if (tapFrom == PlayerTurn.player1) {
      player1TimeLeft.value += increment;
      player1Moves.value++;
      turn.value = PlayerTurn.player2;
    } else {
      player2TimeLeft.value += increment;
      player2Moves.value++;
      turn.value = PlayerTurn.player1;
    }

    // Play sound / vibrate

    // 🔊 Play move sound
    _audioService.playTickSound(isSoundOn.value);

    // 📳 Trigger vibration
    _audioService.triggerVibration(isVibrationOn.value);
  }

  void timeOut(PlayerTurn losingPlayer) {
    _timer?.cancel();
    isPlaying.value = false;
    isGameOver.value = true;

    // Play timeout sound and vibrate
    _audioService.playTimeoutSound(isSoundOn.value);
    _audioService.triggerVibration(isVibrationOn.value);
  }

  String formatTime(int totalSeconds) {
    if (totalSeconds < 0) return "0:00";
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
