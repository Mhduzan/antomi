// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Blues - sesuai referensi #2563EB, #1E40AF
  static const Color primary       = Color(0xFF2563EB);
  static const Color primaryDark   = Color(0xFF1E40AF);
  static const Color primaryLight  = Color(0xFF3B82F6);
  static const Color primaryPale   = Color(0xFFEFF6FF);

  // Accent
  static const Color success       = Color(0xFF22C55E);
  static const Color successLight  = Color(0xFFDCFCE7);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color warningLight  = Color(0xFFFEF3C7);
  static const Color danger        = Color(0xFFEF4444);
  static const Color dangerLight   = Color(0xFFFEE2E2);

  // Neutral
  static const Color white         = Color(0xFFFFFFFF);
  static const Color background    = Color(0xFFF8FAFF);
  static const Color cardBg        = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight     = Color(0xFF94A3B8);
  static const Color divider       = Color(0xFFE2E8F0);
  static const Color inputBg       = Color(0xFFF1F5F9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );
}
