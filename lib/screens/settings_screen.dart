import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/settings_tile.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundOn = true;
  bool _vibrationOn = true;
  bool _darkMode = true;
  String _selectedColor = 'blue';

  final Map<String, Color> _themeColors = {
    'blue': AppTheme.primaryBlue,
    'red': AppTheme.primaryRed,
    'green': AppTheme.primaryGreen,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          // Section: Game
          _sectionTitle('Game'),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.volume2,
            title: 'Sound',
            subtitle: 'Play sounds on move and timeout',
            trailing: Switch.adaptive(
              value: _soundOn,
              activeColor: theme.colorScheme.primary,
              onChanged: (v) => setState(() => _soundOn = v),
            ),
          ),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.smartphone,
            title: 'Vibration',
            subtitle: 'Haptic feedback on move',
            trailing: Switch.adaptive(
              value: _vibrationOn,
              activeColor: theme.colorScheme.primary,
              onChanged: (v) => setState(() => _vibrationOn = v),
            ),
          ),

          const SizedBox(height: 24),

          // Section: Appearance
          _sectionTitle('Appearance'),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.moon,
            title: 'Dark Mode',
            subtitle: 'Use dark theme',
            trailing: Switch.adaptive(
              value: _darkMode,
              activeColor: theme.colorScheme.primary,
              onChanged: (v) {
                setState(() => _darkMode = v);
                Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.palette,
            title: 'Theme Color',
            subtitle:
                _selectedColor[0].toUpperCase() + _selectedColor.substring(1),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: _themeColors.entries.map((entry) {
                final isSelected = _selectedColor == entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = entry.key);
                    Get.changeTheme(
                      _darkMode
                          ? AppTheme.darkTheme(entry.value)
                          : AppTheme.lightTheme(entry.value),
                    );
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
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Section: Players
          _sectionTitle('Players'),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.user,
            title: 'Player 1 Name',
            subtitle: 'Player 1',
            trailing: const Icon(LucideIcons.chevronRight, size: 18),
            onTap: () => _editPlayerName(1),
          ),
          const SizedBox(height: 8),

          SettingsTile(
            icon: LucideIcons.user,
            title: 'Player 2 Name',
            subtitle: 'Player 2',
            trailing: const Icon(LucideIcons.chevronRight, size: 18),
            onTap: () => _editPlayerName(2),
          ),

          const SizedBox(height: 32),

          // App info
          Center(
            child: Text(
              'Chess Timer v1.0.0',
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

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.5,
      ),
    );
  }

  void _editPlayerName(int playerNumber) {
    final controller = TextEditingController(text: 'Player $playerNumber');
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
              // TODO: Persist via StorageService
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
