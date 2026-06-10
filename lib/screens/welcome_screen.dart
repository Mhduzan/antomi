// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import '../utils/responsive.dart';
import 'menu_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _waveCtrl, _pulseCtrl, _slideCtrl, _floatCtrl;
  late Animation<double> _waveAnim, _pulseAnim, _floatAnim, _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveCtrl);

    _pulseCtrl = AnimationController(duration: const Duration(milliseconds: 1600), vsync: this)..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.07).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _floatCtrl = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _slideCtrl = AnimationController(duration: const Duration(milliseconds: 900), vsync: this)..forward();
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _waveCtrl.dispose(); _pulseCtrl.dispose(); _slideCtrl.dispose(); _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blue header
          Container(
            height: size.height * 0.54,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
          ),
          // Wave clip
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            child: SizedBox(
              height: size.height * 0.54,
              child: AnimatedBuilder(
                animation: _waveAnim,
                builder: (_, __) => CustomPaint(size: Size.infinite, painter: _WavePainter(_waveAnim.value)),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: r.h(24)),

                // Logo floating
                AnimatedBuilder(
                  animation: Listenable.merge([_pulseCtrl, _floatCtrl]),
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _floatAnim.value),
                    child: Transform.scale(
                      scale: _pulseAnim.value,
                      child: Container(
                        width: r.logoSz,
                        height: r.logoSz,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 30, offset: const Offset(0, 10))],
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
                ),

                SizedBox(height: r.h(16)),

                // Title
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        Text('ANATOMI',
                          style: GoogleFonts.poppins(fontSize: r.sp(26), fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3)),
                        Text('QUIZ GAME',
                          style: GoogleFonts.poppins(fontSize: r.sp(15), fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.85), letterSpacing: 4)),
                        SizedBox(height: r.h(6)),
                        Text('Belajar Anatomi Jadi Lebih Seru!',
                          style: GoogleFonts.inter(fontSize: r.sp(12), color: Colors.white.withOpacity(0.75))),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: r.h(28)),

                // White card
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: r.pad),
                      padding: EdgeInsets.all(r.pad + 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.radiusXl),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, -4))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Feature pills
                          Wrap(
                            spacing: 8, runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _pill(r, Icons.quiz_outlined, '3 Level Quiz'),
                              _pill(r, Icons.gamepad_outlined, 'Tebak Gambar'),
                              _pill(r, Icons.emoji_events_outlined, 'Sistem Poin'),
                              _pill(r, Icons.trending_up_rounded, 'Track Progress'),
                            ],
                          ),

                          SizedBox(height: r.h(24)),

                          // Mulai
                          SizedBox(
                            width: double.infinity,
                            height: r.btnH,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushReplacement(context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const MenuScreen(),
                                  transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                                  transitionDuration: const Duration(milliseconds: 400),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radius)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('MULAI', style: GoogleFonts.poppins(fontSize: r.sp(15), fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                                  SizedBox(width: r.w(8)),
                                  Icon(Icons.arrow_forward_rounded, size: r.iconSm),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: r.h(10)),

                          // Login
                          SizedBox(
                            width: double.infinity,
                            height: r.btnHSm,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radius)),
                              ),
                              child: Text('LOGIN (opsional)',
                                style: GoogleFonts.poppins(fontSize: r.sp(13), fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: r.h(12)),
                Text('© 2024 Anatomi Quiz Game',
                  style: GoogleFonts.inter(fontSize: r.sp(10), color: AppColors.textLight)),
                SizedBox(height: r.h(12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(R r, IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.padSm + 2, vertical: r.padXs + 2),
      decoration: BoxDecoration(
        color: AppColors.primaryPale,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.iconSm - 2, color: AppColors.primary),
          SizedBox(width: r.w(5)),
          Text(label, style: GoogleFonts.inter(fontSize: r.sp(11), fontWeight: FontWeight.w600, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double wave;
  _WavePainter(this.wave);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06)..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    for (double x = 0; x <= size.width; x += 8) {
      path.lineTo(x, size.height * 0.8 + math.sin((x * 0.02) + wave) * 18);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_WavePainter old) => old.wave != wave;
}
