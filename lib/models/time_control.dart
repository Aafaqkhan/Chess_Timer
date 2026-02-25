class TimeControl {
  final String id;
  final String name;
  final int durationMinutes; // Game time in minutes
  final int incrementSeconds; // Time added per move
  final String category; // Bullet, Blitz, Rapid, Classical, Custom
  final bool isCustom;

  TimeControl({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.incrementSeconds,
    required this.category,
    this.isCustom = false,
  });

  // Calculate total duration in seconds for the timer
  int get durationSeconds => durationMinutes * 60;

  // Formatting for display like "10+5"
  String get displayFormat => '$durationMinutes+$incrementSeconds';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'incrementSeconds': incrementSeconds,
      'category': category,
      'isCustom': isCustom,
    };
  }

  factory TimeControl.fromJson(Map<String, dynamic> json) {
    return TimeControl(
      id: json['id'],
      name: json['name'],
      durationMinutes: json['durationMinutes'],
      incrementSeconds: json['incrementSeconds'],
      category: json['category'],
      isCustom: json['isCustom'] ?? false,
    );
  }
}
