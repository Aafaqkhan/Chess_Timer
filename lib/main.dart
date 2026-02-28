import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'controllers/timer_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AudioService().init());

  // Register controllers
  Get.put(ThemeController());
  Get.put(TimerController());

  runApp(const ChessTimerApp());
}

class ChessTimerApp extends StatelessWidget {
  const ChessTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: 'BlitzClock – Chess Timer',
        debugShowCheckedModeBanner: false,
        theme: themeCtrl.currentTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
