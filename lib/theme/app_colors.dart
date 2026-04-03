// config/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFE59866);
  static const Color mediumOrange = Color(0xFFFF8C42);
  static const Color darkOrange = Color(0xFFD35400);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textHint = Color(0xFF999999);

  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  // UI Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFD0D0D0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);

  // Special Colors
  static const Color ratingStar = Color(0xFFFFC107);
  static const Color shadowLight = Color(0x14000000);

  // Category Colors Method
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'historical':
        return const Color(0xFF8B4513);
      case 'cultural':
        return const Color(0xFF9C27B0);
      case 'nature':
        return const Color(0xFF4CAF50);
      case 'shopping':
        return const Color(0xFFFF9800);
      case 'food':
        return const Color(0xFFE91E63);
      case 'relaxation':
        return const Color(0xFF00BCD4);
      case 'adventure':
        return const Color(0xFFFF5722);
      case 'entertainment':
        return const Color(0xFF3F51B5);
      default:
        return primaryOrange;
    }
  }
}