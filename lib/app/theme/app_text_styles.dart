import 'package:flutter/material.dart';


class AppTextStyles {
  AppTextStyles._();



  static TextStyle get headlineLarge =>
      const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );


  static TextStyle get headlineMedium =>
      const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );


  static TextStyle get titleLarge =>
      const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );


  static TextStyle get titleMedium =>
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );


  static TextStyle get titleSmall =>
      const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );



  // usato in tutta l'app
  static TextStyle get body =>
      const TextStyle(
        fontSize: 14,
        height: 1.4,
      );



  static TextStyle get bodyLarge =>
      const TextStyle(
        fontSize: 16,
      );



  static TextStyle get bodyMedium =>
      const TextStyle(
        fontSize: 14,
      );



  static TextStyle get bodySmall =>
      const TextStyle(
        fontSize: 12,
      );



  static TextStyle get labelMedium =>
      const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );



  static TextStyle get button =>
      const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
}