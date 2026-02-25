import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../models/app_settings.dart';
import '../models/time_control.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  static const String keySettings = 'app_settings';
  static const String keyCustomTimes = 'custom_time_controls';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // --- Settings ---
  AppSettings loadSettings() {
    String? settingsJson = _prefs.getString(keySettings);
    if (settingsJson != null) {
      return AppSettings.fromJson(jsonDecode(settingsJson));
    }
    return AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(keySettings, jsonEncode(settings.toJson()));
  }

  // --- Custom Time Controls ---
  List<TimeControl> loadCustomTimeControls() {
    List<String>? timesJson = _prefs.getStringList(keyCustomTimes);
    if (timesJson != null) {
      return timesJson.map((t) => TimeControl.fromJson(jsonDecode(t))).toList();
    }
    return [];
  }

  Future<void> saveCustomTimeControls(List<TimeControl> customTimes) async {
    List<String> timesJson = customTimes
        .map((t) => jsonEncode(t.toJson()))
        .toList();
    await _prefs.setStringList(keyCustomTimes, timesJson);
  }

  // Clear Custom Times (Restore Defaults)
  Future<void> clearCustomTimeControls() async {
    await _prefs.remove(keyCustomTimes);
  }
}
