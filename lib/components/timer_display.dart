import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerDisplay extends StatelessWidget {
  final int timeInSeconds;
  final bool isActive;
  final bool isGameOver;

  const TimerDisplay({
    super.key,
    required this.timeInSeconds,
    this.isActive = false,
    this.isGameOver = false,
  });

  String _formatTime(int totalSeconds) {
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

  @override
  Widget build(BuildContext context) {
    final bool isDanger = timeInSeconds <= 30 && timeInSeconds > 0;
    final bool isZero = timeInSeconds <= 0;

    Color textColor;
    if (isZero) {
      textColor = Colors.red.shade700;
    } else if (isDanger && isActive) {
      textColor = Colors.red.shade400;
    } else if (isActive) {
      textColor = Theme.of(context).colorScheme.onPrimary;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: GoogleFonts.robotoMono(
        fontSize: isActive ? 72 : 60,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 2,
      ),
      child: Text(_formatTime(timeInSeconds)),
    );
  }
}
