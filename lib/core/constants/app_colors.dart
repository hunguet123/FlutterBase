import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF673AB7); // Deep Purple
  static const Color primaryVariant = Color(0xFF311B92);
  
  // Secondary colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);

  // Surface colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Error colors
  static const Color error = Color(0xFFB00020);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0x99000000);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xB3FFFFFF);
}
