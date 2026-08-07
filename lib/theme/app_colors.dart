import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ==========================
  // BRAND COLORS
  // ==========================

  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF8E86FF);
  static const Color accent = Color(0xFF00C2FF);

  // ==========================
  // BACKGROUND
  // ==========================

  static const Color background = Color(0xFFF8F9FD);
  static const Color surface = Colors.white;

  // Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // ==========================
  // TEXT COLORS
  // ==========================

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Colors.white;

  // ==========================
  // STATUS COLORS
  // ==========================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ==========================
  // BORDER & DIVIDER
  // ==========================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE0E0E0);

  // ==========================
  // SHADOW
  // ==========================

  static const Color shadow = Color(0x14000000);

  // ==========================
  // PREMIUM
  // ==========================

  static const Color premiumGold = Color(0xFFFFC107);

  // ==========================
  // GRADIENT
  // ==========================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF8E86FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF00C2FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      Color(0xFFFFD54F),
      Color(0xFFFFA000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}