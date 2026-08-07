import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF8E44AD);

  // Background
  static const Color background = Color(0xFFF5F7FA);
  static const Color card = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF757575);

  // Status
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF8E44AD),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}