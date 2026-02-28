import '../models/time_control.dart';

class AppConstants {
  static const String appName = 'BlitzClock – Chess Timer';

  // Categories
  static const String categoryBullet = 'Bullet';
  static const String categoryBlitz = 'Blitz';
  static const String categoryRapid = 'Rapid';
  static const String categoryClassical = 'Classical';
  static const String categoryCustom = 'Custom';

  // Default Time Controls
  static final List<TimeControl> defaultTimeControls = [
    // Bullet
    TimeControl(
      id: 'b1_0',
      name: '1+0',
      durationMinutes: 1,
      incrementSeconds: 0,
      category: categoryBullet,
    ),
    TimeControl(
      id: 'b1_1',
      name: '1+1',
      durationMinutes: 1,
      incrementSeconds: 1,
      category: categoryBullet,
    ),
    TimeControl(
      id: 'b2_1',
      name: '2+1',
      durationMinutes: 2,
      incrementSeconds: 1,
      category: categoryBullet,
    ),
    // Blitz
    TimeControl(
      id: 'bl3_0',
      name: '3+0',
      durationMinutes: 3,
      incrementSeconds: 0,
      category: categoryBlitz,
    ),
    TimeControl(
      id: 'bl3_2',
      name: '3+2',
      durationMinutes: 3,
      incrementSeconds: 2,
      category: categoryBlitz,
    ),
    TimeControl(
      id: 'bl5_0',
      name: '5+0',
      durationMinutes: 5,
      incrementSeconds: 0,
      category: categoryBlitz,
    ),
    TimeControl(
      id: 'bl5_3',
      name: '5+3',
      durationMinutes: 5,
      incrementSeconds: 3,
      category: categoryBlitz,
    ),
    // Rapid
    TimeControl(
      id: 'r10_0',
      name: '10+0',
      durationMinutes: 10,
      incrementSeconds: 0,
      category: categoryRapid,
    ),
    TimeControl(
      id: 'r10_5',
      name: '10+5',
      durationMinutes: 10,
      incrementSeconds: 5,
      category: categoryRapid,
    ),
    TimeControl(
      id: 'r15_10',
      name: '15+10',
      durationMinutes: 15,
      incrementSeconds: 10,
      category: categoryRapid,
    ),
    TimeControl(
      id: 'r25_10',
      name: '25+10',
      durationMinutes: 25,
      incrementSeconds: 10,
      category: categoryRapid,
    ),
    TimeControl(
      id: 'r30_0',
      name: '30+0',
      durationMinutes: 30,
      incrementSeconds: 0,
      category: categoryRapid,
    ),
    // Classical
    TimeControl(
      id: 'c45_15',
      name: '45+15',
      durationMinutes: 45,
      incrementSeconds: 15,
      category: categoryClassical,
    ),
    TimeControl(
      id: 'c60_0',
      name: '60+0',
      durationMinutes: 60,
      incrementSeconds: 0,
      category: categoryClassical,
    ),
    TimeControl(
      id: 'c90_30',
      name: '90+30',
      durationMinutes: 90,
      incrementSeconds: 30,
      category: categoryClassical,
    ),
  ];
}
