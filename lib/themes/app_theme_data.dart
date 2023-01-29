import 'package:flutter/material.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/utils/helper.dart';

class AppThemeData {
  static ThemeData mainTheme = ThemeData(
      dividerColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xff9E9E9E), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.activeBlue, width: 2)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.slidingPanel,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20))
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.title,
          unselectedItemColor: AppColors.title,
          selectedLabelStyle: AppStyles.caption,
          unselectedLabelStyle: AppStyles.caption,
          selectedIconTheme: IconThemeData(size: 24),
          backgroundColor: Colors.white,
          unselectedIconTheme: IconThemeData(size: 24)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.activeBlue,
        extendedTextStyle: AppStyles.buttonWhite,
      ),
    expansionTileTheme: ExpansionTileThemeData(
      iconColor: AppColors.activeBlue,

    )
  );
}
