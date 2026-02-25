import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controllers/timer_controller.dart';
import '../components/player_panel.dart';
import '../components/control_button.dart';
import 'time_selection_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TimerController tc = Get.find<TimerController>();

    // Lock to portrait and hide system UI for immersive feel
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // ── Player 2 (Top – rotated 180°) ──
            Expanded(
              child: Obx(
                () => PlayerPanel(
                  playerName: 'Player 2',
                  timeInSeconds: tc.player2TimeLeft.value,
                  moveCount: tc.player2Moves.value,
                  isActive:
                      tc.turn.value == PlayerTurn.player2 && tc.isPlaying.value,
                  isGameOver: tc.isGameOver.value,
                  isWinner: tc.isGameOver.value && tc.player2TimeLeft.value > 0,
                  isRotated: true,
                  onTap: () => tc.switchTurn(PlayerTurn.player2),
                ),
              ),
            ),

            // ── Center Control Bar ──
            _buildControlBar(context, tc),

            // ── Player 1 (Bottom) ──
            Expanded(
              child: Obx(
                () => PlayerPanel(
                  playerName: 'Player 1',
                  timeInSeconds: tc.player1TimeLeft.value,
                  moveCount: tc.player1Moves.value,
                  isActive:
                      tc.turn.value == PlayerTurn.player1 && tc.isPlaying.value,
                  isGameOver: tc.isGameOver.value,
                  isWinner: tc.isGameOver.value && tc.player1TimeLeft.value > 0,
                  isRotated: false,
                  onTap: () => tc.switchTurn(PlayerTurn.player1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar(BuildContext context, TimerController tc) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Settings
          ControlButton(
            icon: LucideIcons.settings,
            size: 44,
            tooltip: 'Settings',
            onTap: () => Get.to(
              () => const SettingsScreen(),
              transition: Transition.cupertino,
            ),
          ),

          // Reset
          ControlButton(
            icon: LucideIcons.rotateCcw,
            size: 44,
            tooltip: 'Reset',
            onTap: () => _showResetDialog(context, tc),
          ),

          // Time selection (shows current time control)
          Obx(
            () => GestureDetector(
              onTap: () => Get.to(
                () => const TimeSelectionScreen(),
                transition: Transition.downToUp,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  tc.currentTimeControl.value.displayFormat,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),

          // Play / Pause
          Obx(
            () => ControlButton(
              icon: tc.isPlaying.value ? LucideIcons.pause : LucideIcons.play,
              size: 52,
              backgroundColor: theme.colorScheme.primary,
              iconColor: Colors.white,
              tooltip: tc.isPlaying.value ? 'Pause' : 'Play',
              onTap: () => tc.togglePlayPause(),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, TimerController tc) {
    // If game hasn't started, just reset silently
    if (!tc.isPlaying.value && tc.turn.value == PlayerTurn.none) {
      tc.resetGame();
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Game?'),
        content: const Text(
          'This will reset both timers to the starting time.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              tc.resetGame();
              Get.back();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
