import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';



class AppTheme {
  AppTheme._();



  static ThemeData get lightTheme {

    return ThemeData(

      useMaterial3: true,


      scaffoldBackgroundColor:
      AppColors.background,


      primaryColor:
      AppColors.primary,


      colorScheme:
      ColorScheme.fromSeed(
        seedColor:
        AppColors.primary,
      ),


      textTheme:
      TextTheme(

        headlineLarge:
        AppTextStyles.headlineLarge,


        headlineMedium:
        AppTextStyles.headlineMedium,


        titleLarge:
        AppTextStyles.titleLarge,


        titleMedium:
        AppTextStyles.titleMedium,


        bodyLarge:
        AppTextStyles.bodyLarge,


        bodyMedium:
        AppTextStyles.bodyMedium,


        labelMedium:
        AppTextStyles.labelMedium,

      ),
    );
  }
}
