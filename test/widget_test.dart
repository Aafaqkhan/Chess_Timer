import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:chess_timer/services/storage_service.dart';
import 'package:chess_timer/services/audio_service.dart';
import 'package:chess_timer/controllers/theme_controller.dart';
import 'package:chess_timer/controllers/timer_controller.dart';
import 'package:chess_timer/main.dart';
import 'package:chess_timer/screens/home_screen.dart';

void main() {
  testWidgets('Chess Timer App starts and loads home screen', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Reset GetX instances to prevent dependency leakage
    Get.reset();

    // Initialize services
    await Get.putAsync(() => StorageService().init());
    await Get.putAsync(() => AudioService().init());

    // Register controllers
    Get.put(ThemeController());
    Get.put(TimerController());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChessTimerApp());
    await tester.pumpAndSettle();

    // Verify that the HomeScreen is rendered.
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
