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
      errorColor: AppColors.error,
      colorScheme: ColorScheme.light().copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        error: AppColors.error,
        onError: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onPrimary,
      ),
      // primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
    );
  }
}
