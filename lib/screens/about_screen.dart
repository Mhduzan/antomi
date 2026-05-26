import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _slideController;
  
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Rotasi logo
    _rotateController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateController);
    
    // Pulse untuk logo dan avatar
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Gelombang background
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveController);
    
    // Float untuk kartu
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // Bounce untuk fitur
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    
    // Slide untuk konten
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _floatController.dispose();
    _bounceController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang Aplikasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb), Color(0xFFf5576c)],
          ),
        ),
        child: Stack(
          children: [
            // Background gelombang
            _buildWaveBackground(),
            
            // Partikel mengambang
            _buildFloatingParticles(),
            
            // Konten utama
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Logo UNRI dengan animasi
                    _buildAnimatedLogo(),
                    
                    const SizedBox(height: 30),
                    
                    // Nama Universitas
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildUniversityInfo(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Card Aplikasi
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildAppCard(),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Deskripsi Aplikasi
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildDescriptionCard(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Fitur Aplikasi
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildFeaturesGrid(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tujuan Penelitian
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildResearchCard(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Informasi Pengembang
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildDeveloperCard(),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Tombol Kembali
                    _buildBackButton(context),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveBackground() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: AboutWavePainter(waveValue: _waveAnimation.value),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(25, (index) {
        final size = MediaQuery.of(context).size;
        return Positioned(
          left: (index * 59) % size.width,
          top: (index * 41) % size.height,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 2 * math.pi),
            duration: Duration(seconds: 4 + (index % 5)),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(math.sin(value) * 25, math.cos(value * 1.5) * 25),
                child: Container(
                  width: 5 + (index % 10),
                  height: 5 + (index % 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotateController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    'assets/LOGO-UNRI.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.school,
                        size: 80,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUniversityInfo() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [Colors.white, Colors.yellow.shade300],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            'UNIVERSITAS RIAU',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.yellow.shade300],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Fakultas Keguruan dan Ilmu Pendidikan',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Pendidikan Biologi',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAppCard() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF0F0F0)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _rotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.health_and_safety,
                          size: 56,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Anatomi Quiz Game',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF667eea),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Versi 2.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildGradientIcon(Icons.info_outline),
              const SizedBox(width: 12),
              Text(
                'Tentang Aplikasi',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF667eea),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Aplikasi ini merupakan media pembelajaran interaktif berbasis game quiz yang dirancang untuk membantu mahasiswa dan pelajar dalam memahami materi anatomi tubuh manusia. Dengan pendekatan yang menyenangkan, pengguna dapat menguji dan meningkatkan pengetahuan mereka tentang sistem otot, tulang, dan sendi.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildGradientIcon(Icons.star),
              const SizedBox(width: 12),
              Text(
                'Fitur Unggulan',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF667eea),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildAnimatedFeatureItem(
                icon: Icons.quiz,
                title: '3 Level',
                description: 'Dasar s.d Mahir',
                color: const Color(0xFF4158D0),
                delay: 0,
              ),
              _buildAnimatedFeatureItem(
                icon: Icons.accessibility_new,
                title: 'Anatomi Lengkap',
                description: 'Otot, Tulang, Sendi',
                color: const Color(0xFF43E97B),
                delay: 200,
              ),
              _buildAnimatedFeatureItem(
                icon: Icons.image,
                title: 'Visual Gambar',
                description: 'Ilustrasi edukatif',
                color: const Color(0xFFFA709A),
                delay: 400,
              ),
              _buildAnimatedFeatureItem(
                icon: Icons.emoji_events,
                title: 'Sistem Poin',
                description: 'Reward pencapaian',
                color: const Color(0xFFFEE140),
                delay: 600,
              ),
              _buildAnimatedFeatureItem(
                icon: Icons.trending_up,
                title: 'Tracking',
                description: 'Pantau progress',
                color: const Color(0xFF30CFD0),
                delay: 800,
              ),
              _buildAnimatedFeatureItem(
                icon: Icons.psychology,
                title: 'Edukatif',
                description: 'Belajar interaktif',
                color: const Color(0xFFF5576C),
                delay: 1000,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: opacity,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, title == '3 Level' ? _bounceAnimation.value : 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color.withOpacity(0.1), Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, size: 24, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildResearchCard() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_floatAnimation.value * 0.5, 0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.purple.shade50],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blue.shade200, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildWaveIcon(Icons.school),
                    const SizedBox(width: 12),
                    Text(
                      'Tujuan Penelitian',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aplikasi ini dikembangkan sebagai bagian dari skripsi untuk memenuhi persyaratan gelar Sarjana Pendidikan di Universitas Riau. Tujuannya adalah mengembangkan media pembelajaran interaktif yang efektif untuk meningkatkan pemahaman mahasiswa pada materi anatomi tubuh manusia.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveIcon(IconData icon) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 2 * math.pi),
      duration: const Duration(seconds: 2),
      builder: (context, double angle, child) {
        final double offsetY = math.sin(angle) * 5;
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildDeveloperCard() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.5),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPulsingAvatar(),
                const SizedBox(height: 16),
                Text(
                  'Ulva',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF667eea),
                  ),
                ),
                Text(
                  'Pengembang',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF667eea).withOpacity(0.1), const Color(0xFF764ba2).withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Skripsi - Pendidikan Biologi',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF667eea),
                        ),
                      ),
                      Text(
                        'Universitas Riau',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      'Tahun Akademik 2024/2025',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingAvatar() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: 0.98 + (scale * 0.02),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                shadowColor: Colors.white.withOpacity(0.5),
              ),
              child: Text(
                'Kembali ke Menu',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter untuk efek gelombang
class AboutWavePainter extends CustomPainter {
  final double waveValue;
  
  AboutWavePainter({required this.waveValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    for (double i = 0; i <= size.width; i += 10) {
      double y = size.height * 0.7 + math.sin((i * 0.02) + waveValue) * 20;
      path.lineTo(i, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Gelombang kedua
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    
    for (double i = 0; i <= size.width; i += 10) {
      double y = size.height * 0.75 + math.cos((i * 0.025) + waveValue * 1.5) * 25;
      path2.lineTo(i, y);
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint2);
  }
  
  @override
  bool shouldRepaint(AboutWavePainter oldDelegate) {
    return oldDelegate.waveValue != waveValue;
  }
}