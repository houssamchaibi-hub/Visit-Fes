// lib/presentation/home/config/app_theme.dart

import 'package:flutter/material.dart';

/// App theme configuration and color palette
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ============================================================================
  // COLORS
  // ============================================================================

  // Primary Colors
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color primaryOrangeLight = Color(0xFFFB923C);
  static const Color primaryOrangeDark = Color(0xFFEA580C);

  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundGrey = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFFBDBDBD); // NEW: For search hint

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFE8F5E9); // NEW: Light success
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFE3F2FD); // NEW: Light info

  // Border Colors
  static const Color border = Color(0xFFE0E0E0); // NEW: For borders

  // Special Colors
  static const Color ratingStar = Color(0xFFFBBF24);
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);

  // ============================================================================
  // SPACING
  // ============================================================================

  static const double spaceSM = 4.0;   // NEW: Extra small spacing
  static const double spaceMD = 8.0;   // NEW: Small spacing
  static const double spaceLG = 16.0;  // NEW: Medium spacing
  static const double spaceXL = 24.0;  // NEW: Large spacing
  static const double space2XL = 32.0; // NEW: Extra large spacing

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusXL = 16.0; // NEW: Alias for consistency

  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(radiusXLarge);

  // ============================================================================
  // CATEGORY COLORS
  // ============================================================================

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'museum':
        return const Color(0xFF8E44AD);
      case 'historical':
        return const Color(0xFFD4773C);
      case 'nature':
        return const Color(0xFF4CAF50);
      case 'cultural':
        return const Color(0xFF9C27B0);
      case 'spa':
        return const Color(0xFF9C27B0);
      case 'hammam':
        return const Color(0xFF00BCD4);
      case 'wellness':
        return const Color(0xFF4CAF50);
      case 'restaurant':
        return const Color(0xFFFF5722);
      case 'cafe':
        return const Color(0xFF795548);
      case 'shopping':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF2196F3);
    }
  }

  // ============================================================================
  // THEME DATA
  // ============================================================================

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: backgroundWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        secondary: primaryOrangeLight,
        surface: backgroundWhite,
        error: error,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryOrangeLight,
        surface: Color(0xFF2C3E50),
        error: error,
      ),
    );
  }

  // ============================================================================
  // GRADIENTS
  // ============================================================================

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [primaryOrange, primaryOrangeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFF06292)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // SHADOWS
  // ============================================================================

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: shadowLight,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> cardShadowPressed = [
    BoxShadow(
      color: shadowMedium,
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: shadowLight,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}