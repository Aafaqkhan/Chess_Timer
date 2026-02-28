import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'timer_display.dart';

class PlayerPanel extends StatelessWidget {
  final String playerName;
  final int timeInSeconds;
  final int moveCount;
  final bool isActive;
  final bool isGameOver;
  final bool isWinner;
  final bool isRotated; // true for top player (phone laid flat)
  final VoidCallback onTap;

  const PlayerPanel({
    super.key,
    required this.playerName,
    required this.timeInSeconds,
    required this.moveCount,
    required this.isActive,
    required this.isGameOver,
    required this.isWinner,
    this.isRotated = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine background color
    Color bgColor;
    if (isGameOver && isWinner) {
      bgColor = Colors.green.shade600;
    } else if (isGameOver && !isWinner) {
      bgColor = Colors.red.shade800.withOpacity(0.6);
    } else if (isActive) {
      bgColor = theme.colorScheme.primary.withOpacity(0.9);
    } else {
      bgColor = theme.brightness == Brightness.dark
          ? const Color(0xFF2A2A2A)
          : const Color(0xFFE0E0E0);
    }

    // Text color based on active state
    Color textColor = isActive || (isGameOver && isWinner)
        ? Colors.white
        : theme.colorScheme.onSurface.withOpacity(0.6);

    Widget panelContent = Container(
      width: double.infinity,
      decoration: BoxDecoration(color: bgColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Player name
                Text(
                  playerName,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Timer display
                TimerDisplay(
                  timeInSeconds: timeInSeconds,
                  isActive: isActive,
                  isGameOver: isGameOver,
                ),
                const SizedBox(height: 12),

                // Move count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Moves: $moveCount',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Rotate 180° for top player
    if (isRotated) {
      panelContent = RotatedBox(quarterTurns: 2, child: panelContent);
    }

    return panelContent;
  }
}
