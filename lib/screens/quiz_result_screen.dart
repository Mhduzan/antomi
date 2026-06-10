// lib/screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import 'quiz_question_screen.dart';
import 'menu_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int level, score, totalQuestions, poinDidapat;
  const QuizResultScreen({super.key, required this.level, required this.score, required this.totalQuestions, required this.poinDidapat});
  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> with TickerProviderStateMixin {
  bool _nextLevelUnlocked = false;
  int _nextLevel = 2, _totalPoin = 0;

  late AnimationController _scaleCtrl, _slideCtrl, _trophyCtrl;
  late Animation<double> _scaleAnim, _trophyAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _slideCtrl = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _trophyCtrl = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this)..repeat(reverse: true);
    _trophyAnim = Tween<double>(begin: -5, end: 5).animate(CurvedAnimation(parent: _trophyCtrl, curve: Curves.easeInOut));
    _scaleCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), () => _slideCtrl.forward());
    _checkNextLevel();
  }

  @override
  void dispose() { _scaleCtrl.dispose(); _slideCtrl.dispose(); _trophyCtrl.dispose(); super.dispose(); }

  Future<void> _checkNextLevel() async {
    final st = StorageHelper();
    _totalPoin = await st.getTotalPoin();
    int levelTerbuka = await st.getLevelTerbuka();
    bool unlocked = false;
    if (widget.level == 1 && _totalPoin >= 50 && levelTerbuka >= 2) unlocked = true;
    else if (widget.level == 2 && _totalPoin >= 120 && levelTerbuka >= 3) unlocked = true;
    if (mounted) setState(() { _nextLevelUnlocked = unlocked; _nextLevel = widget.level + 1; });
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final isPerfect = widget.score == widget.totalQuestions;
    final pct = widget.score / widget.totalQuestions;
    final lulus = pct >= 0.7;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(r.pad, r.padXs, r.pad, r.pad + 4),
                child: Row(children: [
                  const SizedBox(width: 36),
                  Expanded(child: Center(child: Text('Hasil Quiz Level ${widget.level}',
                    style: GoogleFonts.poppins(fontSize: r.sp(16), fontWeight: FontWeight.w700, color: Colors.white)))),
                  const SizedBox(width: 36),
                ]),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(r.pad),
              child: Column(
                children: [
                  // Score card
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(r.pad + 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(r.radiusXl),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 6))]),
                      child: Column(children: [
                        AnimatedBuilder(
                          animation: _trophyAnim,
                          builder: (_, __) => Transform.translate(
                            offset: Offset(0, _trophyAnim.value),
                            child: Container(
                              width: r.w(88), height: r.w(88),
                              decoration: BoxDecoration(
                                color: isPerfect ? AppColors.warningLight : lulus ? AppColors.successLight : AppColors.primaryPale,
                                shape: BoxShape.circle),
                              child: Icon(
                                isPerfect ? Icons.emoji_events_rounded : lulus ? Icons.verified_rounded : Icons.assignment_turned_in_rounded,
                                size: r.w(46),
                                color: isPerfect ? AppColors.warning : lulus ? AppColors.success : AppColors.primary),
                            ),
                          ),
                        ),
                        SizedBox(height: r.h(14)),
                        Text(isPerfect ? 'Sempurna! 🎉' : lulus ? 'Bagus! Kamu Lulus!' : 'Yuk Coba Lagi!',
                          style: GoogleFonts.poppins(fontSize: r.sp(20), fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        SizedBox(height: r.h(4)),
                        RichText(text: TextSpan(children: [
                          TextSpan(text: '${widget.score}',
                            style: GoogleFonts.poppins(fontSize: r.sp(44), fontWeight: FontWeight.w900, color: AppColors.primary)),
                          TextSpan(text: ' / ${widget.totalQuestions}',
                            style: GoogleFonts.poppins(fontSize: r.sp(22), fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                        ])),
                        SizedBox(height: r.h(8)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: r.pad, vertical: r.padXs + 2),
                          decoration: BoxDecoration(
                            color: lulus ? AppColors.successLight : AppColors.warningLight,
                            borderRadius: BorderRadius.circular(20)),
                          child: Text(lulus ? '🎉 LULUS' : '📚 Belajar Lagi',
                            style: GoogleFonts.poppins(fontSize: r.sp(12), fontWeight: FontWeight.w700,
                              color: lulus ? AppColors.success : AppColors.warning))),
                      ]),
                    ),
                  ),

                  SizedBox(height: r.h(14)),

                  // Poin card
                  SlideTransition(
                    position: _slideAnim,
                    child: Container(
                      padding: EdgeInsets.all(r.pad),
                      decoration: BoxDecoration(
                        gradient: AppColors.warningGradient, borderRadius: BorderRadius.circular(r.radiusLg),
                        boxShadow: [BoxShadow(color: AppColors.warning.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6))]),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.add_circle_rounded, color: Colors.white, size: r.iconLg - 4),
                        SizedBox(width: r.w(10)),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Poin yang didapat', style: GoogleFonts.inter(fontSize: r.sp(11), color: Colors.white.withOpacity(0.85))),
                          Text('+${widget.poinDidapat} Poin', style: GoogleFonts.poppins(fontSize: r.sp(24), fontWeight: FontWeight.w800, color: Colors.white)),
                        ]),
                      ]),
                    ),
                  ),

                  SizedBox(height: r.h(20)),

                  // Buttons
                  SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        if (_nextLevelUnlocked && widget.level < 3) ...[
                          _btn(r, Icons.arrow_forward_rounded, 'Lanjut ke Level $_nextLevel', AppColors.success, () =>
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizQuestionScreen(level: _nextLevel)))),
                          SizedBox(height: r.h(10)),
                        ],
                        _btn(r, Icons.refresh_rounded, 'Ulangi Quiz', AppColors.primary, () =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizQuestionScreen(level: widget.level)))),
                        SizedBox(height: r.h(10)),
                        _btn(r, Icons.home_rounded, 'Kembali ke Menu', AppColors.textSecondary, () =>
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MenuScreen()), (r) => false)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(R r, IconData icon, String label, Color color, VoidCallback onTap) =>
    SizedBox(width: double.infinity, height: r.btnH,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: r.iconSm),
        label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radius)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: r.sp(14)))));
}
