// lib/screens/menu_screen.dart
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

class _MenuScreenState extends State<MenuScreen>
    with TickerProviderStateMixin {
  int _totalPoin = 0;
  int _levelTerbuka = 1;

  late AnimationController _waveCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _shimmerCtrl;

  late Animation<double> _waveAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _loadData();

    _waveCtrl = AnimationController(
        duration: const Duration(seconds: 4), vsync: this)
      ..repeat();
    _waveAnim =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveCtrl);

    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this)
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _floatCtrl = AnimationController(
        duration: const Duration(milliseconds: 2200), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _shimmerCtrl = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat();
    _shimmerAnim =
        Tween<double>(begin: -1, end: 2).animate(_shimmerCtrl);
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final poin = await StorageHelper().getTotalPoin();
    final level = await StorageHelper().getLevelTerbuka();
    if (mounted) {
      setState(() {
        _totalPoin = poin;
        _levelTerbuka = level;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Blue header background
          Container(
            height: size.height * 0.32,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),

          // Wave on header
          ClipRect(
            child: SizedBox(
              height: size.height * 0.32,
              child: AnimatedBuilder(
                animation: _waveAnim,
                builder: (_, __) => CustomPaint(
                  size: Size.infinite,
                  painter: _MenuWavePainter(_waveAnim.value),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                const SizedBox(height: 20),

                // Poin card - floating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildPoinCard(),
                ),

                const SizedBox(height: 24),

                // Section title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Menu Utama',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2x2 Menu Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMenuCard(
                          index: 0,
                          icon: Icons.quiz_rounded,
                          title: 'QUIZ',
                          subtitle: 'Uji Pengetahuan',
                          color: AppColors.primary,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const QuizLevelScreen()),
                            );
                            if (result == true) _loadData();
                          },
                        ),
                        _buildMenuCard(
                          index: 1,
                          icon: Icons.extension_rounded,
                          title: 'TEBAK\nGAMBAR',
                          subtitle: 'Word Puzzle',
                          color: const Color(0xFF0EA5E9),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GameScreen()),
                            );
                            if (result == true) _loadData();
                          },
                        ),
                        _buildMenuCard(
                          index: 2,
                          icon: Icons.person_rounded,
                          title: 'PROFIL',
                          subtitle: 'Lihat Progres',
                          color: const Color(0xFF6366F1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfileScreen()),
                            ).then((_) => _loadData());
                          },
                        ),
                        _buildMenuCard(
                          index: 3,
                          icon: Icons.info_rounded,
                          title: 'TENTANG',
                          subtitle: 'Info Aplikasi',
                          color: const Color(0xFF8B5CF6),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AboutScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.person_rounded,
                    color: AppColors.primary, size: 28),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, User! 👋',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  'Andomi Learner',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Level badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded,
                    color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Lv $_levelTerbuka',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoinCard() {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatAnim.value * 0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Poin
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.stars_rounded,
                          color: AppColors.warning, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Poin',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '$_totalPoin',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider),
              const SizedBox(width: 16),

              // Level
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.lock_open_rounded,
                          color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level Terbuka',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '$_levelTerbuka / 3',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 120),
      curve: Curves.easeOutBack,
      builder: (_, val, __) {
        return Transform.scale(
          scale: val,
          child: AnimatedBuilder(
            animation: _floatCtrl,
            builder: (_, __) {
              final yOff = index % 2 == 0
                  ? _floatAnim.value
                  : -_floatAnim.value;
              return Transform.translate(
                offset: Offset(0, yOff * 0.6),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                          color: color.withOpacity(0.12), width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        // Background accent
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.06),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(icon,
                                    color: color, size: 26),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow
                        Positioned(
                          top: 14,
                          right: 14,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MenuWavePainter extends CustomPainter {
  final double wave;
  _MenuWavePainter(this.wave);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 2; i++) {
      final path = Path();
      final yBase = size.height * (0.65 + i * 0.15);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 8) {
        path.lineTo(x,
            yBase + math.sin((x * 0.018) + wave + i) * (16 + i * 8));
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_MenuWavePainter old) => old.wave != wave;
}
