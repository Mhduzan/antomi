// lib/screens/game_session_screen.dart
// Layar pemilihan sesi sebelum masuk game
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../utils/storage_helper.dart';
import '../data/game_data.dart';
import 'game_screen.dart';

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({super.key});
  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen>
    with TickerProviderStateMixin {
  late R _r;
  int _totalPoin = 0;
  late List<GameSession> _sessions;

  late AnimationController _waveCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _waveAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _sessions = buildGameSessions();
    _loadPoin();

    _waveCtrl = AnimationController(
        duration: const Duration(seconds: 4), vsync: this)
      ..repeat();
    _waveAnim =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(_waveCtrl);

    _floatCtrl = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5, end: 5).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPoin() async {
    final p = await StorageHelper().getTotalPoin();
    if (mounted) setState(() => _totalPoin = p);
  }

  @override
  Widget build(BuildContext context) {
    _r = R.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(_r.pad, _r.pad, _r.pad, _r.pad + 8),
              children: [
                // Info card
                Container(
                  padding: EdgeInsets.all(_r.pad - 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(_r.radius),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.primary, size: _r.iconSm),
                    SizedBox(width: _r.w(10)),
                    Expanded(
                      child: Text(
                        'Pilih sesi yang ingin kamu mainkan. Setiap sesi memberikan poin yang berbeda!',
                        style: GoogleFonts.inter(
                            fontSize: _r.sp(12), color: AppColors.primaryDark),
                      ),
                    ),
                  ]),
                ),

                SizedBox(height: _r.h(16)),

                // Kartu 3 sesi
                ..._sessions.asMap().entries.map((e) {
                  final idx = e.key;
                  final session = e.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: _r.h(12)),
                    child: _buildSessionCard(session, idx),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(_r.pad, _r.padXs, _r.pad, _r.pad + 4),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: _r.w(36), height: _r.w(36),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(_r.padSm),
                      ),
                      child: Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: _r.iconSm),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Tebak Gambar & Puzzle',
                        style: GoogleFonts.poppins(
                            fontSize: _r.sp(16),
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    ),
                  ),
                  // Poin badge
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: _r.padSm + 2, vertical: _r.padXs),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Icon(Icons.stars_rounded,
                          color: AppColors.warning, size: _r.iconSm - 2),
                      SizedBox(width: _r.w(4)),
                      Text('$_totalPoin',
                          style: GoogleFonts.poppins(
                              fontSize: _r.sp(12),
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ]),
                  ),
                ],
              ),
              SizedBox(height: _r.h(10)),
              Text('Pilih sesi untuk dimainkan',
                style: GoogleFonts.inter(
                    fontSize: _r.sp(12),
                    color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(GameSession session, int idx) {
    // Warna per sesi
    final colors = [AppColors.primary, const Color(0xFF0EA5E9), AppColors.success];
    final color = colors[idx % colors.length];

    // Tipe label
    final isMatching = session.sessionNumber == 3;
    final stageCount = session.stages.length;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + idx * 120),
      curve: Curves.easeOutBack,
      builder: (_, val, __) => Transform.scale(
        scale: val,
        child: AnimatedBuilder(
          animation: _floatCtrl,
          builder: (_, __) => Transform.translate(
            offset: Offset(
                0, (idx % 2 == 0 ? _floatAnim.value : -_floatAnim.value) * 0.4),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(session: session),
                  ),
                );
                if (result == true) _loadPoin();
              },
              child: Container(
                padding: EdgeInsets.all(_r.pad),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_r.radiusLg),
                  border:
                      Border.all(color: color.withOpacity(0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    // Emoji circle
                    Container(
                      width: _r.w(64),
                      height: _r.w(64),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(session.emoji,
                            style: TextStyle(fontSize: _r.sp(28))),
                      ),
                    ),

                    SizedBox(width: _r.w(14)),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge sesi
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: _r.padXs + 2, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('SESI ${session.sessionNumber}',
                              style: GoogleFonts.poppins(
                                  fontSize: _r.sp(9),
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                  letterSpacing: 1)),
                          ),
                          SizedBox(height: _r.h(4)),
                          Text(session.title,
                            style: GoogleFonts.poppins(
                                fontSize: _r.sp(16),
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                          SizedBox(height: _r.h(2)),
                          Text(session.subtitle,
                            style: GoogleFonts.inter(
                                fontSize: _r.sp(11),
                                color: AppColors.textSecondary)),
                          SizedBox(height: _r.h(10)),
                          // Chips info
                          Row(children: [
                            _chip(Icons.layers_rounded,
                                '$stageCount Stage', color),
                            SizedBox(width: _r.w(6)),
                            _chip(
                                isMatching
                                    ? Icons.drag_indicator_rounded
                                    : Icons.text_fields_rounded,
                                isMatching ? 'Drag & Drop' : 'Tebak Kata',
                                color),
                            SizedBox(width: _r.w(6)),
                            _chip(Icons.stars_rounded,
                                '+${stageCount * 10} Poin', AppColors.warning),
                          ]),
                        ],
                      ),
                    ),

                    // Arrow
                    Container(
                      width: _r.w(32), height: _r.w(32),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(_r.padSm),
                      ),
                      child: Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: _r.iconSm + 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) => Container(
    padding:
        EdgeInsets.symmetric(horizontal: _r.padXs + 2, vertical: _r.padXs),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(_r.padXs + 2),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: _r.sp(10), color: color),
      SizedBox(width: _r.w(3)),
      Text(label,
          style: GoogleFonts.inter(
              fontSize: _r.sp(10),
              fontWeight: FontWeight.w600,
              color: color)),
    ]),
  );
}
