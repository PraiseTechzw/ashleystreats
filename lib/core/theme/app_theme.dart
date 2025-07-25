import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.secondary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
      error: AppColors.accent,
    ),
    cardColor: AppColors.card,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.button,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.secondary,
    secondaryHeaderColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.secondary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.secondary,
      secondary: AppColors.primary,
      surface: AppColors.card.withOpacity(0.8),
      error: AppColors.accent,
    ),
    cardColor: AppColors.card.withOpacity(0.8),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.button,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
    ),
  );
}
