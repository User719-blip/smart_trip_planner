import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF046735); // Dark green
  static const background = Color(0xFFF8F8F8);
  static const subtitle = Color(0xFF888888);
  static const button = Color(0xFF046735); // Matches primary
}

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: AppColors.background,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primary,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
);
