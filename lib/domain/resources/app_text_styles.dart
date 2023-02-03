import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static const TextStyle menuPageTitle = TextStyle(
      color: AppColors.title, fontWeight: FontWeight.w700, fontSize: 20);
  static const TextStyle appRed =
      TextStyle(color: AppColors.appRed, fontSize: 14);
  static const TextStyle appGreen =
      TextStyle(color: AppColors.appGreen, fontSize: 14);
  static const TextStyle body2 =
      TextStyle(color: AppColors.mainText, fontSize: 14);
  static const TextStyle caption =
      TextStyle(color: AppColors.subTitle, fontSize: 12);
  static const TextStyle overline = TextStyle(
      letterSpacing: 1.5,
      color: AppColors.title,
      fontWeight: FontWeight.w500,
      fontSize: 10);
  static const TextStyle buttonBlack = TextStyle(
      color: AppColors.mainText, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle button = TextStyle(
      color: AppColors.activeBlue, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle buttonInactive = TextStyle(
      color: AppColors.borderGrey, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle buttonWhite =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle subtitle1 =
      TextStyle(color: AppColors.title, fontSize: 16);

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    disabledBackgroundColor: AppColors.borderGrey,
    disabledForegroundColor: AppColors.subTitle,
    padding: const EdgeInsets.symmetric(vertical: 12),
    backgroundColor: AppColors.activeBlue,
    textStyle: AppStyles.buttonWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  );
}
