import 'dart:async';
import 'package:get/get.dart';
import '../models/time_control.dart';
import '../utils/constants.dart';

enum PlayerTurn { none, player1, player2 }

class TimerController extends GetxController {
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

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    resetGame();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void setTimeControl(TimeControl tc) {
    currentTimeControl.value = tc;
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
    // TODO: integrate audio & vibration here
  }

  void timeOut(PlayerTurn losingPlayer) {
    _timer?.cancel();
    isPlaying.value = false;
    isGameOver.value = true;
    // TODO: integrate timeout sound
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
