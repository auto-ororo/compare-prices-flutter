import 'package:flutter/material.dart';

import 'assets/color/app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              headline6: TextStyle(fontSize: 18, color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1,
          color: Colors.white),
      primaryColor: AppColors.primary,
      accentColor: AppColors.primary,
      colorScheme: ColorScheme.light().copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onPrimary,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              headline6: TextStyle(fontSize: 18, color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 1,
          color: AppColors.darkAppBarBackground),
      primaryColor: AppColors.primary,
      accentColor: AppColors.primary,
      errorColor: Colors.redAccent,
      colorScheme: ColorScheme.dark().copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onPrimary,
      ),
    );
  }
}
