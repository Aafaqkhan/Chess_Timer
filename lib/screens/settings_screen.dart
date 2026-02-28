import 'package:chess_timer/screens/time_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/settings_tile.dart';
import '../utils/theme.dart';
import '../controllers/theme_controller.dart';
import '../controllers/timer_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static final Map<String, Color> _themeColors = {
    'blue': AppTheme.primaryBlue,
    'red': AppTheme.primaryRed,
    'green': AppTheme.primaryGreen,
    'black': AppTheme.primaryBlack,
    'white': AppTheme.primaryWhite,
  };

  static String _getSelectedColorName(Color current) {
    for (var entry in _themeColors.entries) {
      if (entry.value == current) return entry.key;
    }
    return 'blue';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeCtrl = Get.find<ThemeController>();
    final tc = Get.find<TimerController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Section: Time Controls
          _sectionTitle('Time Controls', theme),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.clock,
            title: "Time Controls",
            subtitle: "Set the time controls for the game",
            trailing: const Icon(LucideIcons.chevronRight, size: 18),
            onTap: () => Get.to(
              () => const TimeSelectionScreen(),
              transition: Transition.downToUp,
            ),
          ),

          const SizedBox(height: 24),

          // Section: Game
          _sectionTitle('Game', theme),
          const SizedBox(height: 8),

          Obx(
            () => SettingsTile(
              icon: LucideIcons.volume2,
              title: 'Sound',
              subtitle: 'Play sounds on move and timeout',
              trailing: Switch.adaptive(
                value: tc.isSoundOn.value,
                activeColor: theme.colorScheme.primary,
                onChanged: (v) {
                  tc.updateSound(v);
                  if (v) {
                    SystemSound.play(SystemSoundType.click);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          Obx(
            () => SettingsTile(
              icon: LucideIcons.smartphone,
              title: 'Vibration',
              subtitle: 'Haptic feedback on move',
              trailing: Switch.adaptive(
                value: tc.isVibrationOn.value,
                activeColor: theme.colorScheme.primary,
                onChanged: (v) {
                  tc.updateVibration(v);
                  if (v) {
                    HapticFeedback.mediumImpact();
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section: Appearance
          _sectionTitle('Appearance', theme),
          const SizedBox(height: 8),

          Obx(() {
            final selectedName = _getSelectedColorName(
              themeCtrl.primaryColor.value,
            );
            return SettingsTile(
              icon: LucideIcons.palette,
              title: 'Theme Color',
              subtitle:
                  selectedName[0].toUpperCase() + selectedName.substring(1),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: _themeColors.entries.map((entry) {
                  final isSelected =
                      themeCtrl.primaryColor.value == entry.value;
                  return GestureDetector(
                    onTap: () {
                      themeCtrl.changeColor(entry.value);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: entry.value.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            );
          }),

          const SizedBox(height: 24),

          // Section: Players
          _sectionTitle('Players', theme),
          const SizedBox(height: 8),

          Obx(
            () => SettingsTile(
              icon: LucideIcons.user,
              title: 'Player 1 Name',
              subtitle: tc.player1Name.value,
              trailing: const Icon(LucideIcons.chevronRight, size: 18),
              onTap: () => _editPlayerName(1),
            ),
          ),
          const SizedBox(height: 8),

          Obx(
            () => SettingsTile(
              icon: LucideIcons.user,
              title: 'Player 2 Name',
              subtitle: tc.player2Name.value,
              trailing: const Icon(LucideIcons.chevronRight, size: 18),
              onTap: () => _editPlayerName(2),
            ),
          ),

          const SizedBox(height: 32),

          // App info
          Center(
            child: Text(
              'BlitzClock – Chess Timer v1.0.0',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
        letterSpacing: 1.5,
      ),
    );
  }

  void _editPlayerName(int playerNumber) {
    final tc = Get.find<TimerController>();
    final currentName = playerNumber == 1
        ? tc.player1Name.value
        : tc.player2Name.value;
    final controller = TextEditingController(text: currentName);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Player $playerNumber Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                tc.updatePlayerName(playerNumber, name);
              }
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
