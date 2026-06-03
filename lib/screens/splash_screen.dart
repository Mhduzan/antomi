// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'welcome_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _waveController;
  late AnimationController _fadeController;
  late AnimationController _dotsController;

  late Animation<double> _pulseAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _waveAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _dotsAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    _rotateAnim = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_rotateController);

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(_waveController);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _dotsAnim = Tween<double>(begin: 0, end: 1).animate(_dotsController);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _waveController.dispose();
    _fadeController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Stack(
          children: [
            // Background wave
            AnimatedBuilder(
              animation: _waveAnim,
              builder: (_, __) => CustomPaint(
                size: Size.infinite,
                painter: _WavePainter(_waveAnim.value),
              ),
            ),

            // Floating circles decoration
            ..._buildFloatingCircles(),

            // Main content
            FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo animated
                    AnimatedBuilder(
                      animation: Listenable.merge(
                          [_pulseController, _rotateController]),
                      builder: (_, __) {
                        return Transform.scale(
                          scale: _pulseAnim.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/Gemini_Generated_Image_3tqpec3tqpec3tqp.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.medical_services_rounded,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'ANDOMI',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Belajar Anatomi Jadi Seru',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Animated dots loader
                    AnimatedBuilder(
                      animation: _dotsAnim,
                      builder: (_, __) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          final offset =
                              math.sin((_dotsAnim.value * 2 * math.pi) -
                                  (i * 0.6));
                          return Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 5),
                            width: 10,
                            height: 10,
                            transform: Matrix4.translationValues(
                                0, offset * 8, 0),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.5 + (offset + 1) * 0.25),
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

            // Bottom text
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  'Anatomi Quiz Game v2.0',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingCircles() {
    final positions = [
      [0.05, 0.1, 80.0],
      [0.8, 0.05, 60.0],
      [0.9, 0.4, 100.0],
      [0.1, 0.7, 70.0],
      [0.7, 0.85, 90.0],
    ];
    return positions.asMap().entries.map((e) {
      final idx = e.key;
      final pos = e.value;
      return Positioned(
        left: MediaQuery.of(context).size.width * pos[0],
        top: MediaQuery.of(context).size.height * pos[1],
        child: AnimatedBuilder(
          animation: _waveAnim,
          builder: (_, __) {
            final offset = math.sin(_waveAnim.value + idx) * 12;
            return Transform.translate(
              offset: Offset(0, offset),
              child: Container(
                width: pos[2],
                height: pos[2],
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            );
          },
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
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (int w = 0; w < 2; w++) {
      final path = Path();
      final yBase = size.height * (0.75 + w * 0.1);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 8) {
        final y =
            yBase + math.sin((x * 0.015) + wave + w) * (18 + w * 8);
        path.lineTo(x, y);
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
