// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import 'welcome_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl, _waveCtrl, _fadeCtrl, _dotsCtrl;
  late Animation<double> _pulseAnim, _waveAnim, _fadeAnim, _dotsAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this)..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _waveCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveCtrl);

    _fadeCtrl = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _dotsCtrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat();
    _dotsAnim = Tween<double>(begin: 0, end: 1).animate(_dotsCtrl);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose(); _waveCtrl.dispose();
    _fadeCtrl.dispose(); _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Stack(
          children: [
            // Wave background
            AnimatedBuilder(
              animation: _waveAnim,
              builder: (_, __) => CustomPaint(size: Size.infinite, painter: _WavePainter(_waveAnim.value)),
            ),

            // Floating circles
            ..._buildCircles(size, r),

            // Content
            FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) => Transform.scale(
                        scale: _pulseAnim.value,
                        child: Container(
                          width: r.logoSz,
                          height: r.logoSz,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 30, spreadRadius: 10)],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/Gemini_Generated_Image_3tqpec3tqpec3tqp.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.medical_services_rounded, size: r.iconLg * 1.5, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: r.h(24)),

                    Text('ANDOMI',
                      style: GoogleFonts.poppins(
                        fontSize: r.sp(28),
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(height: r.h(6)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: r.pad, vertical: r.padXs),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Belajar Anatomi Jadi Seru',
                        style: GoogleFonts.inter(fontSize: r.sp(12), color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500),
                      ),
                    ),

                    SizedBox(height: r.h(50)),

                    // Bouncing dots
                    AnimatedBuilder(
                      animation: _dotsAnim,
                      builder: (_, __) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          final offset = math.sin((_dotsAnim.value * 2 * math.pi) - (i * 0.6));
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: r.w(10),
                            height: r.w(10),
                            transform: Matrix4.translationValues(0, offset * 8, 0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5 + (offset + 1) * 0.25),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom version text
            Positioned(
              bottom: r.h(28),
              left: 0, right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Text('Anatomi Quiz Game v2.0',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: r.sp(11), color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCircles(Size size, R r) {
    final positions = [[0.05, 0.1, 0.18], [0.8, 0.05, 0.14], [0.85, 0.4, 0.22], [0.05, 0.7, 0.16], [0.7, 0.85, 0.2]];
    return positions.asMap().entries.map((e) {
      final idx = e.key;
      final pos = e.value;
      final sz = size.width * pos[2];
      return Positioned(
        left: size.width * pos[0],
        top: size.height * pos[1],
        child: AnimatedBuilder(
          animation: _waveAnim,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, math.sin(_waveAnim.value + idx) * 12),
            child: Container(
              width: sz, height: sz,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _WavePainter extends CustomPainter {
  final double wave;
  _WavePainter(this.wave);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05)..style = PaintingStyle.fill;
    for (int w = 0; w < 2; w++) {
      final path = Path();
      final yBase = size.height * (0.75 + w * 0.1);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 8) {
        path.lineTo(x, yBase + math.sin((x * 0.015) + wave + w) * (18 + w * 8));
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(_WavePainter old) => old.wave != wave;
}
