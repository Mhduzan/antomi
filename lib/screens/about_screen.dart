// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import '../utils/responsive.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late R _r;
  late AnimationController _pulseCtrl, _slideCtrl, _rotateCtrl, _waveCtrl;
  late Animation<double> _pulseAnim, _waveAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this)..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _rotateCtrl = AnimationController(duration: const Duration(seconds: 20), vsync: this)..repeat();
    _waveCtrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveCtrl);
    _slideCtrl = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)..forward();
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose(); _slideCtrl.dispose();
    _rotateCtrl.dispose(); _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    _r = r;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Blue header
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _waveAnim,
                    builder: (_, __) => CustomPaint(
                      size: const Size(double.infinity, 180),
                      painter: _AboutWavePainter(_waveAnim.value),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.pad, r.padXs, r.pad, r.pad + 8),
                    child: Column(
                      children: [
                        // AppBar
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: r.w(36), height: r.w(36),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(r.padSm),
                                ),
                                child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: r.iconSm),
                              ),
                            ),
                            Expanded(child: Center(child: Text('Tentang Aplikasi',
                              style: GoogleFonts.poppins(fontSize: r.sp(17), fontWeight: FontWeight.w700, color: Colors.white)))),
                            SizedBox(width: r.w(36)),
                          ],
                        ),

                        SizedBox(height: r.h(16)),

                        // Logo UNRI
                        AnimatedBuilder(
                          animation: Listenable.merge([_rotateCtrl, _pulseCtrl]),
                          builder: (_, __) => Transform.scale(
                            scale: _pulseAnim.value,
                            child: Container(
                              width: r.w(86), height: r.w(86),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.25), blurRadius: 20, spreadRadius: 4)],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/LOGO-UNRI.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(Icons.school_rounded, size: r.w(44), color: AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: r.h(10)),
                        Text('UNIVERSITAS RIAU',
                          style: GoogleFonts.poppins(fontSize: r.sp(16), fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
                        Text('Fakultas Keguruan dan Ilmu Pendidikan',
                          style: GoogleFonts.inter(fontSize: r.sp(12), color: Colors.white.withOpacity(0.8))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(r.pad, r.pad, r.pad, r.pad + 8),
                child: Column(
                  children: [
                    // App info card
                    _buildCard(child: Column(
                      children: [
                        Container(
                          width: r.w(72), height: r.w(72),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(r.radiusLg),
                            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 6))],
                          ),
                          child: Icon(Icons.medical_services_rounded, size: r.iconLg, color: Colors.white),
                        ),
                        SizedBox(height: r.h(10)),
                        Text('Anatomi Quiz Game',
                          style: GoogleFonts.poppins(fontSize: r.sp(20), fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        SizedBox(height: r.h(4)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: r.padSm + 4, vertical: r.padXs),
                          decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(r.padSm)),
                          child: Text('Versi 2.0.0',
                            style: GoogleFonts.inter(fontSize: r.sp(12), fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ),
                      ],
                    )),

                    SizedBox(height: r.h(10)),

                    _buildInfoCard(
                      title: 'Tentang Aplikasi',
                      icon: Icons.info_rounded,
                      content: 'Aplikasi ini merupakan media pembelajaran interaktif berbasis game quiz yang dirancang untuk membantu mahasiswa dan pelajar dalam memahami materi anatomi tubuh manusia. Dengan pendekatan yang menyenangkan, pengguna dapat menguji dan meningkatkan pengetahuan mereka tentang sistem otot, tulang, dan sendi.',
                    ),

                    SizedBox(height: r.h(10)),

                    // Fitur grid
                    _buildCard(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(Icons.star_rounded, 'Fitur Unggulan', AppColors.warning),
                        SizedBox(height: r.h(14)),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                          children: [
                            _featureTile(Icons.quiz_rounded, '3 Level', AppColors.primary),
                            _featureTile(Icons.accessibility_new_rounded, 'Anatomi\nLengkap', AppColors.success),
                            _featureTile(Icons.image_rounded, 'Visual\nGambar', const Color(0xFFEC4899)),
                            _featureTile(Icons.emoji_events_rounded, 'Sistem\nPoin', AppColors.warning),
                            _featureTile(Icons.trending_up_rounded, 'Track\nProgress', const Color(0xFF06B6D4)),
                            _featureTile(Icons.psychology_rounded, 'Edukatif', AppColors.danger),
                          ],
                        ),
                      ],
                    )),

                    SizedBox(height: r.h(10)),

                    _buildInfoCard(
                      title: 'Tujuan Penelitian',
                      icon: Icons.school_rounded,
                      content: 'Aplikasi ini dikembangkan sebagai bagian dari skripsi untuk memenuhi persyaratan gelar Sarjana Pendidikan di Universitas Riau. Tujuannya adalah mengembangkan media pembelajaran interaktif yang efektif untuk meningkatkan pemahaman mahasiswa pada materi anatomi tubuh manusia.',
                    ),

                    SizedBox(height: r.h(10)),

                    // Developer card — foto MariaUlva
                    _buildCard(child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (_, __) => Transform.scale(
                            scale: _pulseAnim.value,
                            child: Container(
                              width: r.w(64), height: r.w(64),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/ulpa.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                                    child: Icon(Icons.person_rounded, color: Colors.white, size: r.w(30)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: r.w(14)),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MariaUlva',
                              style: GoogleFonts.poppins(fontSize: r.sp(18), fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            Text('Pengembang · Skripsi Biologi',
                              style: GoogleFonts.inter(fontSize: r.sp(12), color: AppColors.textSecondary)),
                            SizedBox(height: r.h(4)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: r.padXs + 4, vertical: r.padXs - 1),
                              decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(r.padXs + 2)),
                              child: Text('Tahun Akademik 2024/2025',
                                style: GoogleFonts.inter(fontSize: r.sp(11), fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ),
                          ],
                        )),
                      ],
                    )),

                    SizedBox(height: r.h(14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(_r.pad - 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
    ),
    child: child,
  );

  Widget _buildInfoCard({required String title, required IconData icon, required String content}) =>
    _buildCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(icon, title, AppColors.primary),
        SizedBox(height: _r.h(10)),
        Text(content, style: GoogleFonts.inter(fontSize: _r.sp(13), color: AppColors.textSecondary, height: 1.6), textAlign: TextAlign.justify),
      ],
    ));

  Widget _sectionTitle(IconData icon, String title, Color color) => Row(
    children: [
      Container(
        width: _r.w(34), height: _r.w(34),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(_r.padSm)),
        child: Icon(icon, color: color, size: _r.iconSm),
      ),
      SizedBox(width: _r.w(10)),
      Text(title, style: GoogleFonts.poppins(fontSize: _r.sp(14), fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ],
  );

  Widget _featureTile(IconData icon, String label, Color color) => Container(
    padding: EdgeInsets.all(_r.padXs + 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(_r.radius),
      border: Border.all(color: color.withOpacity(0.15)),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: color, size: _r.iconSm + 4),
      SizedBox(height: _r.h(6)),
      Text(label, textAlign: TextAlign.center,
        style: GoogleFonts.inter(fontSize: _r.sp(10), fontWeight: FontWeight.w600, color: color, height: 1.3)),
    ]),
  );
}

class _AboutWavePainter extends CustomPainter {
  final double wave;
  _AboutWavePainter(this.wave);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06)..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    for (double x = 0; x <= size.width; x += 8) {
      path.lineTo(x, size.height * 0.7 + math.sin((x * 0.02) + wave) * 18);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_AboutWavePainter old) => old.wave != wave;
}
