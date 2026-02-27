import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/theme.dart';
import '../services/storage_service.dart';

class ThemeController extends GetxController {
  final Rx<Color> primaryColor = AppTheme.primaryGreen.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    try {
      final storage = Get.find<StorageService>();
      final settings = storage.loadSettings();
      primaryColor.value = _getColorFromString(settings.themeColor);
    } catch (_) {
      // StorageService might not be initialized yet in tests or certain flows
    }
  }

  ThemeData get currentTheme => AppTheme.darkTheme(primaryColor.value);

  void changeColor(Color color) {
    primaryColor.value = color;
    _saveTheme(color);
  }

  void _saveTheme(Color color) {
    try {
      final storage = Get.find<StorageService>();
      final settings = storage.loadSettings();
      settings.themeColor = _getStringFromColor(color);
      storage.saveSettings(settings);
    } catch (_) {
      // StorageService not initialized
    }
  }

  String _getStringFromColor(Color color) {
    if (color == AppTheme.primaryRed) return 'red';
    if (color == AppTheme.primaryBlue) return 'blue';
    if (color == AppTheme.primaryGreen) return 'green';
    if (color == AppTheme.primaryBlack) return 'black';
    if (color == AppTheme.primaryWhite) return 'white';
    return 'green';
  }

  Color _getColorFromString(String name) {
    switch (name) {
      case 'red':
        return AppTheme.primaryRed;
      case 'blue':
        return AppTheme.primaryBlue;
      case 'black':
        return AppTheme.primaryBlack;
      case 'white':
        return AppTheme.primaryWhite;
      case 'green':
      default:
        return AppTheme.primaryGreen;
    }
  }
}
