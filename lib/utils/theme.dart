import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E88E5), Color(0xFF6A1B9A), Color(0xFF0D47A1)],
  );

  static const LinearGradient quizGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E88E5), Color(0xFF2196F3)],
  );

  static const LinearGradient gameGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF009688)],
  );

  static const LinearGradient aboutGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
  );

  static List<BoxShadow> softShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
  ];

  static TextStyle heading1 = GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold);
  static TextStyle heading2 = GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle bodyText = GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600);
}