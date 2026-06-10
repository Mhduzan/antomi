// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../utils/storage_helper.dart';
import 'quiz_level_screen.dart';
import 'game_session_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _totalPoin = 0, _levelTerbuka = 1;
  late AnimationController _waveCtrl, _floatCtrl;
  late Animation<double> _waveAnim, _floatAnim;

  @override
  void initState() {
    super.initState();
    _loadData();
    _waveCtrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveCtrl);
    _floatCtrl = AnimationController(duration: const Duration(milliseconds: 2200), vsync: this)..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5, end: 5).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _waveCtrl.dispose(); _floatCtrl.dispose(); super.dispose(); }

  Future<void> _loadData() async {
    final poin  = await StorageHelper().getTotalPoin();
    final level = await StorageHelper().getLevelTerbuka();
    if (mounted) setState(() { _totalPoin = poin; _levelTerbuka = level; });
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Blue header
          Container(height: size.height * 0.30, decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
          ClipRect(
            child: SizedBox(
              height: size.height * 0.30,
              child: AnimatedBuilder(
                animation: _waveAnim,
                builder: (_, __) => CustomPaint(size: Size.infinite, painter: _MenuWavePainter(_waveAnim.value)),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(r),
                SizedBox(height: r.h(16)),
                Padding(padding: EdgeInsets.symmetric(horizontal: r.pad), child: _buildPoinCard(r)),
                SizedBox(height: r.h(20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.pad),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text('Menu Utama',
                      style: GoogleFonts.poppins(fontSize: r.sp(15), fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                ),
                SizedBox(height: r.h(12)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.pad),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: r.padSm + 4,
                      mainAxisSpacing: r.padSm + 4,
                      childAspectRatio: r.gridAspect,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _menuCard(r, 0, Icons.quiz_rounded, 'QUIZ', 'Uji Pengetahuan', AppColors.primary, () async {
                          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizLevelScreen()));
                          if (res == true) _loadData();
                        }),
                        _menuCard(r, 1, Icons.extension_rounded, 'TEBAK\nGAMBAR', 'Word Puzzle', const Color(0xFF0EA5E9), () async {
                          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const GameSessionScreen()));
                          if (res == true) _loadData();
                        }),
                        _menuCard(r, 2, Icons.person_rounded, 'PROFIL', 'Lihat Progres', const Color(0xFF6366F1), () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())).then((_) => _loadData());
                        }),
                        _menuCard(r, 3, Icons.info_rounded, 'TENTANG', 'Info Aplikasi', const Color(0xFF8B5CF6), () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: r.h(12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(R r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.pad, r.padSm + 4, r.pad, 0),
      child: Row(
        children: [
          // Foto profil
          Container(
            width: r.avatarMd, height: r.avatarMd,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/ulpa.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.person_rounded, color: AppColors.primary, size: r.iconMd),
              ),
            ),
          ),

          SizedBox(width: r.padSm),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Hai, Selamat Mengerjakan! 👋',
                style: GoogleFonts.inter(fontSize: r.sp(12), color: Colors.white.withOpacity(0.85))),
              Text('MariaUlva',
                style: GoogleFonts.poppins(fontSize: r.sp(16), fontWeight: FontWeight.w700, color: Colors.white)),
            ]),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: r.padSm, vertical: r.padXs),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(children: [
              Icon(Icons.verified_rounded, color: Colors.white, size: r.iconSm - 2),
              SizedBox(width: r.w(4)),
              Text('Lv $_levelTerbuka',
                style: GoogleFonts.poppins(fontSize: r.sp(11), fontWeight: FontWeight.w700, color: Colors.white)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPoinCard(R r) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatAnim.value * 0.4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: r.pad, vertical: r.padSm + 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.radiusLg),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              Expanded(child: _statItem(r, Icons.stars_rounded, '$_totalPoin', 'Total Poin', AppColors.warning, AppColors.warningLight)),
              Container(width: 1, height: r.h(36), color: AppColors.divider),
              Expanded(child: _statItem(r, Icons.lock_open_rounded, '$_levelTerbuka / 3', 'Level Terbuka', AppColors.primary, AppColors.primaryPale)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(R r, IconData icon, String value, String label, Color color, Color bg) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.padSm),
      child: Row(children: [
        Container(
          width: r.w(40), height: r.w(40),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(r.padSm)),
          child: Icon(icon, color: color, size: r.iconMd - 2),
        ),
        SizedBox(width: r.padSm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.inter(fontSize: r.sp(10), color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.poppins(fontSize: r.sp(18), fontWeight: FontWeight.w800, color: color)),
        ]),
      ]),
    );
  }

  Widget _menuCard(R r, int idx, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + idx * 100),
      curve: Curves.easeOutBack,
      builder: (_, val, __) => Transform.scale(
        scale: val,
        child: AnimatedBuilder(
          animation: _floatCtrl,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, (idx % 2 == 0 ? _floatAnim.value : -_floatAnim.value) * 0.5),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(r.radiusLg),
                  border: Border.all(color: color.withOpacity(0.12), width: 1.5),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 5))],
                ),
                child: Stack(
                  children: [
                    Positioned(right: -8, bottom: -8,
                      child: Container(width: r.w(70), height: r.w(70),
                        decoration: BoxDecoration(color: color.withOpacity(0.06), shape: BoxShape.circle))),
                    Padding(
                      padding: EdgeInsets.all(r.pad - 2),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          width: r.w(44), height: r.w(44),
                          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(r.padSm + 2)),
                          child: Icon(icon, color: color, size: r.iconMd),
                        ),
                        SizedBox(height: r.h(10)),
                        Text(title, style: GoogleFonts.poppins(fontSize: r.sp(13), fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.2)),
                        SizedBox(height: r.h(3)),
                        Text(subtitle, style: GoogleFonts.inter(fontSize: r.sp(10), color: AppColors.textSecondary)),
                      ]),
                    ),
                    Positioned(top: r.padSm, right: r.padSm,
                      child: Container(
                        width: r.w(26), height: r.w(26),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(r.padXs + 2)),
                        child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: r.iconSm - 4),
                      )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuWavePainter extends CustomPainter {
  final double wave;
  _MenuWavePainter(this.wave);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.06)..style = PaintingStyle.fill;
    for (int i = 0; i < 2; i++) {
      final path = Path();
      final yBase = size.height * (0.65 + i * 0.15);
      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 8) {
        path.lineTo(x, yBase + math.sin((x * 0.018) + wave + i) * (16 + i * 8));
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
