import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import '../utils/storage_helper.dart';
import 'quiz_level_screen.dart';
import 'game_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _totalPoin = 0;
  int _levelTerbuka = 1;
  
  // Multiple Animation Controllers untuk efek yang lebih kaya
  late AnimationController _waveController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _shakeController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // 1. Gelombang untuk background
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveController);
    
    // 2. Rotasi untuk icon settings
    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateController);
    
    // 3. Bounce untuk kartu
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    
    // 4. Pulse untuk avatar
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // 5. Float untuk kartu kedua
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // 6. Shake untuk tombol
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _shakeAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _rotateController.dispose();
    _bounceController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final poin = await StorageHelper().getTotalPoin();
    final level = await StorageHelper().getLevelTerbuka();
    setState(() {
      _totalPoin = poin;
      _levelTerbuka = level;
    });
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
        child: SafeArea(
          child: Stack(
            children: [
              // Animasi gelombang background
              _buildWaveBackground(),
              
              // Bola-bola beranimasi
              _buildFloatingBubbles(),
              
              // Konten utama
              Column(
                children: [
                  // Header dengan animasi
                  _buildAnimatedHeader(),
                  
                  const SizedBox(height: 16),
                  
                  // Quote dengan efek neon
                  _buildNeonQuote(),
                  
                  const SizedBox(height: 32),
                  
                  // Grid Menu dengan animasi yang kelihatan
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.85,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _build3DMenuCard(
                            icon: Icons.quiz,
                            title: 'QUIZ',
                            subtitle: 'Uji Pengetahuan',
                            color1: const Color(0xFF4158D0),
                            color2: const Color(0xFFC850C0),
                            delay: 0,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const QuizLevelScreen()),
                              );
                              if (result == true) _loadData();
                            },
                          ),
                          _build3DMenuCard(
                            icon: Icons.gamepad,
                            title: 'GAME',
                            subtitle: 'Tebak Gambar',
                            color1: const Color(0xFFF9D423),
                            color2: const Color(0xFFFF4E50),
                            delay: 150,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              );
                              if (result == true) _loadData();
                            },
                          ),
                          _build3DMenuCard(
                            icon: Icons.person,
                            title: 'PROFIL',
                            subtitle: 'Lihat Progres',
                            color1: const Color(0xFF00B4DB),
                            color2: const Color(0xFF0083B0),
                            delay: 300,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ProfileScreen()),
                              ).then((_) => _loadData());
                            },
                          ),
                          _build3DMenuCard(
                            icon: Icons.info,
                            title: 'TENTANG',
                            subtitle: 'Info Aplikasi',
                            color1: const Color(0xFFF53844),
                            color2: const Color(0xFF42378F),
                            delay: 450,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AboutScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Background gelombang
  Widget _buildWaveBackground() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: WavePainter(waveValue: _waveAnimation.value),
        );
      },
    );
  }

  // Bola-bola mengambang
  Widget _buildFloatingBubbles() {
    return Stack(
      children: List.generate(15, (index) {
        return Positioned(
          left: (index * 73) % MediaQuery.of(context).size.width,
          top: (index * 47) % MediaQuery.of(context).size.height,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 2 * math.pi),
            duration: Duration(seconds: 3 + index),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(math.sin(value) * 20, math.cos(value * 1.3) * 20),
                child: Container(
                  width: 30 + (index % 20),
                  height: 30 + (index % 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
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

  // Header dengan animasi
  Widget _buildAnimatedHeader() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - opacity)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Avatar berdenyut
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Color(0xFF667eea),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, User! 👋',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Andomi Learner',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildGlassChip(
                              icon: Icons.star,
                              label: '$_totalPoin Poin',
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 10),
                            _buildGlassChip(
                              icon: Icons.verified,
                              label: 'Level $_levelTerbuka',
                              color: Colors.lightGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Settings berputar
                  AnimatedBuilder(
                    animation: _rotateAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Quote dengan efek neon
  Widget _buildNeonQuote() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Colors.white, Colors.yellow.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: Text(
              '✨ Pelajari Anatomi dengan\nCara yang Menyenangkan! ✨',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Glassmorphism Chip
  Widget _buildGlassChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
                          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 3D Menu Card dengan animasi bouncing dan floating
  Widget _build3DMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: opacity,
            child: GestureDetector(
              onTap: onTap,
              child: AnimatedBuilder(
                animation: Listenable.merge([_bounceAnimation, _floatAnimation]),
                builder: (context, child) {
                  final double bounce = title == 'QUIZ' ? _bounceAnimation.value : 
                                       (title == 'GAME' ? _floatAnimation.value : 0);
                  
                  return Transform.translate(
                    offset: Offset(0, bounce),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color1, color2],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: color1.withOpacity(0.6),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Efek glasir
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Konten
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon dengan animasi rotate
                                AnimatedBuilder(
                                  animation: _shakeController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: title == 'QUIZ' ? _shakeAnimation.value * 0.05 : 0,
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.25),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.5),
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          icon,
                                          size: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    subtitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter untuk efek gelombang
class WavePainter extends CustomPainter {
  final double waveValue;
  
  WavePainter({required this.waveValue});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    for (double i = 0; i <= size.width; i += 10) {
      double y = size.height * 0.7 + math.sin((i * 0.02) + waveValue) * 15;
      path.lineTo(i, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Gelombang kedua
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    
    for (double i = 0; i <= size.width; i += 10) {
      double y = size.height * 0.75 + math.cos((i * 0.025) + waveValue * 1.5) * 20;
      path2.lineTo(i, y);
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint2);
  }
  
  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.waveValue != waveValue;
}