// lib/screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';
import 'quiz_question_screen.dart';
import 'menu_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int level;
  final int score;
  final int totalQuestions;
  final int poinDidapat;

  const QuizResultScreen({
    super.key,
    required this.level,
    required this.score,
    required this.totalQuestions,
    required this.poinDidapat,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen>
    with TickerProviderStateMixin {
  bool _nextLevelUnlocked = false;
  int _nextLevel = 2;
  int _totalPoin = 0;

  late AnimationController _scaleCtrl;
  late AnimationController _slideCtrl;
  late AnimationController _trophyCtrl;

  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _trophyAnim;

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _scaleAnim =
        CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);

    _slideCtrl = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _slideCtrl, curve: Curves.easeOutCubic));

    _trophyCtrl = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this)
      ..repeat(reverse: true);
    _trophyAnim = Tween<double>(begin: -5, end: 5).animate(
        CurvedAnimation(parent: _trophyCtrl, curve: Curves.easeInOut));

    _scaleCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideCtrl.forward();
    });

    _checkNextLevel();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _slideCtrl.dispose();
    _trophyCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkNextLevel() async {
    final storage = StorageHelper();
    _totalPoin = await storage.getTotalPoin();
    int levelTerbuka = await storage.getLevelTerbuka();

    bool unlocked = false;
    int next = widget.level + 1;

    if (widget.level == 1 && _totalPoin >= 50 && levelTerbuka >= 2) {
      unlocked = true;
    } else if (widget.level == 2 &&
        _totalPoin >= 120 &&
        levelTerbuka >= 3) {
      unlocked = true;
    }

    if (mounted) {
      setState(() {
        _nextLevelUnlocked = unlocked;
        _nextLevel = next;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPerfect = widget.score == widget.totalQuestions;
    final double percentage = widget.score / widget.totalQuestions;
    final bool lulus = percentage >= 0.7;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Blue header
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 18),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Hasil Quiz Level ${widget.level}',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Trophy / Result card
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primary.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Animated trophy
                            AnimatedBuilder(
                              animation: _trophyAnim,
                              builder: (_, __) => Transform.translate(
                                offset: Offset(0, _trophyAnim.value),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: isPerfect
                                        ? AppColors.warningLight
                                        : lulus
                                            ? AppColors.successLight
                                            : AppColors.primaryPale,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isPerfect
                                        ? Icons.emoji_events_rounded
                                        : lulus
                                            ? Icons.verified_rounded
                                            : Icons
                                                .assignment_turned_in_rounded,
                                    size: 48,
                                    color: isPerfect
                                        ? AppColors.warning
                                        : lulus
                                            ? AppColors.success
                                            : AppColors.primary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              isPerfect
                                  ? 'Sempurna! 🎉'
                                  : lulus
                                      ? 'Bagus! Kamu Lulus!'
                                      : 'Yuk Coba Lagi!',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Score
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${widget.score}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${widget.totalQuestions}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: lulus
                                    ? AppColors.successLight
                                    : AppColors.warningLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                lulus ? '🎉 LULUS' : '📚 Belajar Lagi',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: lulus
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Poin card
                    SlideTransition(
                      position: _slideAnim,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: AppColors.warningGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.warning.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_circle_rounded,
                                color: Colors.white, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Poin yang didapat',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                                Text(
                                  '+${widget.poinDidapat} Poin',
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        children: [
                          // Lanjut ke level berikutnya
                          if (_nextLevelUnlocked && widget.level < 3) ...[
                            _buildButton(
                              icon: Icons.arrow_forward_rounded,
                              label: 'Lanjut ke Level $_nextLevel',
                              color: AppColors.success,
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizQuestionScreen(
                                      level: _nextLevel),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          // Ulangi
                          _buildButton(
                            icon: Icons.refresh_rounded,
                            label: 'Ulangi Quiz',
                            color: AppColors.primary,
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizQuestionScreen(
                                    level: widget.level),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Kembali ke menu
                          _buildButton(
                            icon: Icons.home_rounded,
                            label: 'Kembali ke Menu',
                            color: AppColors.textSecondary,
                            onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MenuScreen()),
                              (route) => false,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}
