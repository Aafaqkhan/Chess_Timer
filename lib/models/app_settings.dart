class AppSettings {
  bool isSoundOn;
  bool isVibrationOn;
  String themeColor; // red, blue, green
  bool isDarkMode;
  String player1Name;
  String player2Name;
  String selectedTimeId;

  AppSettings({
    this.isSoundOn = true,
    this.isVibrationOn = true,
    this.themeColor = 'green',
    this.isDarkMode = true,
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.selectedTimeId = 'bl5_0',
  });

  Map<String, dynamic> toJson() {
    return {
      'isSoundOn': isSoundOn,
      'isVibrationOn': isVibrationOn,
      'themeColor': themeColor,
      'isDarkMode': isDarkMode,
      'player1Name': player1Name,
      'player2Name': player2Name,
      'selectedTimeId': selectedTimeId,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isSoundOn: json['isSoundOn'] ?? true,
      isVibrationOn: json['isVibrationOn'] ?? true,
      themeColor: json['themeColor'] ?? 'green',
      isDarkMode: json['isDarkMode'] ?? true,
      player1Name: json['player1Name'] ?? 'Player 1',
      player2Name: json['player2Name'] ?? 'Player 2',
      selectedTimeId: json['selectedTimeId'] ?? 'bl5_0',
    );
  }
}
