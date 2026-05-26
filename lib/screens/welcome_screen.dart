import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import 'menu_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. Rotasi logo
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateController);
    
    // 2. Pulse untuk logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // 3. Gelombang background
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveController);
    
    // 4. Slide untuk konten
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    // 5. Fade untuk tombol
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
              const Color(0xFFf5576c),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animasi gelombang
            _buildWaveBackground(),
            
            // Bola-bola mengambang
            _buildFloatingParticles(),
            
            // Bintang berkilau
            _buildTwinklingStars(),
            
            // Konten utama
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    
                    // Logo dengan animasi
                    _buildAnimatedLogo(),
                    
                    const SizedBox(height: 40),
                    
                    // Teks dengan animasi slide
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
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
                              'Quiz Game Anatomi',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          Text(
                            'Tingkatkan pengetahuanmu tentang\nanatomi tubuh manusia',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Tombol Mulai dengan animasi
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            _buildAnimatedButton(),
                            const SizedBox(height: 20),
                            _buildGlassButton(),
                          ],
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Footer dengan animasi
                    _buildAnimatedFooter(),
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
          painter: WelcomeWavePainter(waveValue: _waveAnimation.value),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(20, (index) {
        final size = MediaQuery.of(context).size;
        return Positioned(
          left: (index * 73) % size.width,
          top: (index * 47) % size.height,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 2 * math.pi),
            duration: Duration(seconds: 3 + (index % 5)),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(math.sin(value) * 30, math.cos(value * 1.5) * 30),
                child: Container(
                  width: 4 + (index % 8),
                  height: 4 + (index % 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15 + (index % 5) * 0.02),
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

  Widget _buildTwinklingStars() {
    return Stack(
      children: List.generate(30, (index) {
        final size = MediaQuery.of(context).size;
        return Positioned(
          left: (index * 37) % size.width,
          top: (index * 53) % size.height,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(seconds: 2 + (index % 3)),
            builder: (context, double value, child) {
              final opacity = (math.sin(value * math.pi) * 0.5 + 0.5);
              return Opacity(
                opacity: opacity,
                child: Icon(
                  Icons.star,
                  size: 8 + (index % 6),
                  color: Colors.white.withOpacity(0.6),
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
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    'assets/Gemini_Generated_Image_3tqpec3tqpec3tqp.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.health_and_safety,
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

  Widget _buildAnimatedButton() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: 0.95 + (scale * 0.05),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                shadowColor: Colors.white.withOpacity(0.5),
              ),
              child: Text(
                'Mulai Sekarang',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Fitur login akan segera hadir!'),
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'OK',
                textColor: const Color(0xFF667eea),
                onPressed: () {},
              ),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          'Login / Daftar',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFooter() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Column(
            children: [
              const Divider(
                color: Colors.white24,
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 10),
              Text(
                '© 2024 Anatomi Quiz Game',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white38,
                ),
              ),
              Text(
                'Untuk Pembelajaran Biologi',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom Painter untuk efek gelombang
class WelcomeWavePainter extends CustomPainter {
  final double waveValue;
  
  WelcomeWavePainter({required this.waveValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    
    for (double i = 0; i <= size.width; i += 10) {
      double y = size.height * 0.8 + math.sin((i * 0.02) + waveValue) * 20;
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
    path2.moveTo(0, size.height * 0.85);
    
    for (double i = 0; i <= size.width; i += 10) {
      double y = size.height * 0.85 + math.cos((i * 0.025) + waveValue * 1.5) * 25;
      path2.lineTo(i, y);
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint2);
  }
  
  @override
  bool shouldRepaint(WelcomeWavePainter oldDelegate) {
    return oldDelegate.waveValue != waveValue;
  }
}