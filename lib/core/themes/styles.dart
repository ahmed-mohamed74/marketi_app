import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    //fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBlueColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBlueColor,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlueColor,
  );
  static const TextStyle appBarTitle1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlueColor,
  );
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlueColor,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlueColor,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.darkBlueColor,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.navyColor,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static const TextStyle hintText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.greyScaleColor,
  );
}
