import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryGreen = Color(0xFF388E3C);
  static const Color primaryBlack = Color(0xFF212121);
  static const Color primaryWhite = Color(0xFFBDBDBD);

  static const Color myBackgroundDark = Color(0xFF1E1E1E);

  static ThemeData darkTheme(Color primaryColor) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: myBackgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor.withOpacity(0.8),
      ),
      useMaterial3: true,
    );
  }
}
