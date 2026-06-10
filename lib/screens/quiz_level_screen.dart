// lib/screens/quiz_level_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../utils/storage_helper.dart';
import 'quiz_question_screen.dart';

class QuizLevelScreen extends StatefulWidget {
  const QuizLevelScreen({super.key});
  @override
  State<QuizLevelScreen> createState() => _QuizLevelScreenState();
}

class _QuizLevelScreenState extends State<QuizLevelScreen> with TickerProviderStateMixin {
  int _levelTerbuka = 1, _totalPoin = 0;
  Map<int, int> _skor = {1: 0, 2: 0, 3: 0};
  bool _loading = true;

  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _loadData();
    _floatCtrl = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -4, end: 4).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _floatCtrl.dispose(); super.dispose(); }

  Future<void> _loadData() async {
    final st = StorageHelper();
    _levelTerbuka = await st.getLevelTerbuka();
    _totalPoin    = await st.getTotalPoin();
    for (int i = 1; i <= 3; i++) _skor[i] = await st.getSkorLevel(i);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(r.pad, r.padXs, r.pad, r.pad + 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _backBtn(r, context),
                        Expanded(child: Center(child: Text('Pilih Level Quiz',
                          style: GoogleFonts.poppins(fontSize: r.sp(16), fontWeight: FontWeight.w700, color: Colors.white)))),
                        const SizedBox(width: 36),
                      ],
                    ),
                    SizedBox(height: r.h(14)),
                    Row(
                      children: [
                        _statChip(r, Icons.stars_rounded, '$_totalPoin Poin', Colors.amber),
                        SizedBox(width: r.padSm),
                        _statChip(r, Icons.emoji_events_rounded, 'Level $_levelTerbuka/3', Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
          else
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(r.pad),
                children: [
                  // Tip
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: r.pad, vertical: r.padSm),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(r.radius),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(children: [
                      Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: r.iconSm),
                      SizedBox(width: r.padSm),
                      Expanded(child: Text('Semakin tinggi level, semakin banyak poin!',
                        style: GoogleFonts.inter(fontSize: r.sp(12), color: AppColors.primaryDark))),
                    ]),
                  ),
                  SizedBox(height: r.h(14)),
                  _levelCard(r, 1, 'Level 1', 'Dasar · Pengenalan Anatomi', '📚', 10, 0, AppColors.success, true),
                  SizedBox(height: r.h(10)),
                  _levelCard(r, 2, 'Level 2', 'Sedang · Fungsi & Pergerakan', '⚡', 20, 50, AppColors.warning, _levelTerbuka >= 2),
                  SizedBox(height: r.h(10)),
                  _levelCard(r, 3, 'Level 3', 'Sulit · Analisis & Cedera', '🏆', 30, 120, AppColors.danger, _levelTerbuka >= 3),
                  SizedBox(height: r.h(20)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _backBtn(R r, BuildContext ctx) => GestureDetector(
    onTap: () => Navigator.pop(ctx),
    child: Container(
      width: r.w(36), height: r.w(36),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(r.padSm)),
      child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: r.iconSm),
    ),
  );

  Widget _statChip(R r, IconData icon, String label, Color color) => Container(
    padding: EdgeInsets.symmetric(horizontal: r.pad - 2, vertical: r.padXs + 2),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.25)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: r.iconSm),
      SizedBox(width: r.w(5)),
      Text(label, style: GoogleFonts.poppins(fontSize: r.sp(12), fontWeight: FontWeight.w600, color: Colors.white)),
    ]),
  );

  Widget _levelCard(R r, int level, String title, String subtitle, String emoji,
      int totalQ, int targetPoin, Color color, bool unlocked) {
    final skor = _skor[level] ?? 0;
    final progress = unlocked && totalQ > 0
        ? (skor / totalQ).clamp(0.0, 1.0)
        : targetPoin > 0 ? (_totalPoin / targetPoin).clamp(0.0, 1.0) : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + level * 80),
      curve: Curves.easeOutBack,
      builder: (_, val, __) => Transform.scale(
        scale: val,
        child: GestureDetector(
          onTap: unlocked ? () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => QuizQuestionScreen(level: level)))
              .then((_) => _loadData()) : null,
          child: Container(
            padding: EdgeInsets.all(r.pad - 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.radiusLg),
              border: Border.all(color: unlocked ? color.withOpacity(0.2) : AppColors.divider, width: 1.5),
              boxShadow: [BoxShadow(color: (unlocked ? color : Colors.grey).withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: r.w(52), height: r.w(52),
                      decoration: BoxDecoration(
                        color: unlocked ? color.withOpacity(0.1) : AppColors.inputBg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(emoji, style: TextStyle(fontSize: r.sp(24)))),
                    ),
                    SizedBox(width: r.padSm),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: GoogleFonts.poppins(fontSize: r.sp(16), fontWeight: FontWeight.w700,
                          color: unlocked ? AppColors.textPrimary : AppColors.textSecondary)),
                      Text(subtitle, style: GoogleFonts.inter(fontSize: r.sp(11), color: AppColors.textSecondary)),
                    ])),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: r.padSm, vertical: r.padXs),
                      decoration: BoxDecoration(
                        color: unlocked ? color.withOpacity(0.1) : AppColors.inputBg,
                        borderRadius: BorderRadius.circular(r.padSm),
                      ),
                      child: Row(children: [
                        Icon(unlocked ? Icons.play_circle_rounded : Icons.lock_rounded,
                            size: r.iconSm - 2, color: unlocked ? color : AppColors.textLight),
                        SizedBox(width: r.w(3)),
                        Text(unlocked ? 'OPEN' : 'Terkunci',
                            style: GoogleFonts.poppins(fontSize: r.sp(10), fontWeight: FontWeight.w700,
                                color: unlocked ? color : AppColors.textLight)),
                      ]),
                    ),
                  ],
                ),

                SizedBox(height: r.h(12)),

                // Info chips
                Row(children: [
                  _chip(r, Icons.quiz_outlined, '$totalQ Soal', AppColors.primary),
                  SizedBox(width: r.w(6)),
                  _chip(r, Icons.stars_rounded, '+10 Poin/soal', AppColors.warning),
                  if (!unlocked && targetPoin > 0) ...[
                    SizedBox(width: r.w(6)),
                    _chip(r, Icons.lock_clock_rounded, 'Butuh $targetPoin Poin', AppColors.danger),
                  ],
                ]),

                SizedBox(height: r.h(10)),

                // Progress bar
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(unlocked ? 'Progress' : 'Menuju Pembukaan',
                      style: GoogleFonts.inter(fontSize: r.sp(10), color: AppColors.textSecondary)),
                  Text(unlocked ? '$skor/$totalQ Soal' : '$_totalPoin/$targetPoin Poin',
                      style: GoogleFonts.inter(fontSize: r.sp(10), fontWeight: FontWeight.w600,
                          color: unlocked ? color : AppColors.textLight)),
                ]),
                SizedBox(height: r.h(5)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.inputBg,
                    color: unlocked ? color : AppColors.textLight,
                    minHeight: r.h(6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(R r, IconData icon, String label, Color color) => Container(
    padding: EdgeInsets.symmetric(horizontal: r.padXs + 2, vertical: r.padXs),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(r.padXs + 2)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: r.sp(10), color: color),
      SizedBox(width: r.w(3)),
      Text(label, style: GoogleFonts.inter(fontSize: r.sp(10), fontWeight: FontWeight.w600, color: color)),
    ]),
  );
}
