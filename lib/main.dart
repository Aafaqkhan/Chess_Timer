import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/theme.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'controllers/timer_controller.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AudioService().init());

  // Register controller
  Get.put(TimerController());

  runApp(const ChessTimerApp());
}

class ChessTimerApp extends StatelessWidget {
  const ChessTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chess Timer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(AppTheme.primaryBlue),
      darkTheme: AppTheme.darkTheme(AppTheme.primaryBlue),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
