// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);      // Biru utama
  static const Color primaryDark = Color(0xFF1E40AF);   // Biru gelap
  static const Color success = Color(0xFF22C55E);       // Hijau
  static const Color warning = Color(0xFFF59E0B);       // Orange
  static const Color danger = Color(0xFFF34F6F);        // Merah muda
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}