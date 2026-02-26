import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/theme.dart';

class ThemeController extends GetxController {
  final Rx<Color> primaryColor = AppTheme.primaryBlue.obs;

  ThemeData get currentTheme => AppTheme.darkTheme(primaryColor.value);

  void changeColor(Color color) {
    primaryColor.value = color;
  }
}
