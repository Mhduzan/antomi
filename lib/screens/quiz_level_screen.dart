// lib/screens/quiz_level_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../utils/colors.dart';
import '../utils/storage_helper.dart';
import 'quiz_question_screen.dart';

class QuizLevelScreen extends StatefulWidget {
  const QuizLevelScreen({super.key});

  @override
  State<QuizLevelScreen> createState() => _QuizLevelScreenState();
}

class _QuizLevelScreenState extends State<QuizLevelScreen>
    with TickerProviderStateMixin {
  int _levelTerbuka = 1;
  int _totalPoin = 0;
  Map<int, int> _skorPerLevel = {1: 0, 2: 0, 3: 0};
  bool _isLoading = true;

  late AnimationController _pulseCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _loadData();

    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _floatCtrl = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -5, end: 5).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final storage = StorageHelper();
    _levelTerbuka = await storage.getLevelTerbuka();
    _totalPoin = await storage.getTotalPoin();
    for (int i = 1; i <= 3; i++) {
      _skorPerLevel[i] = await storage.getSkorLevel(i);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Pilih Level Quiz',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Blue header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Row(
                    children: [
                      _statChip(
                          Icons.stars_rounded,
                          '$_totalPoin Poin',
                          Colors.amber),
                      const SizedBox(width: 10),
                      _statChip(
                          Icons.emoji_events_rounded,
                          'Level $_levelTerbuka/3',
                          Colors.white),
                    ],
                  ),
                ),

                // Tip card
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Semakin tinggi level, semakin banyak poin yang kamu dapatkan!',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildLevelCard(
                        level: 1,
                        title: 'Level 1',
                        subtitle: 'Dasar · Pengenalan Anatomi',
                        emoji: '📚',
                        totalQ: 10,
                        targetBuka: 0,
                        color: AppColors.success,
                        unlocked: true,
                      ),
                      const SizedBox(height: 12),
                      _buildLevelCard(
                        level: 2,
                        title: 'Level 2',
                        subtitle: 'Sedang · Fungsi & Pergerakan',
                        emoji: '⚡',
                        totalQ: 20,
                        targetBuka: 50,
                        color: AppColors.warning,
                        unlocked: _levelTerbuka >= 2,
                      ),
                      const SizedBox(height: 12),
                      _buildLevelCard(
                        level: 3,
                        title: 'Level 3',
                        subtitle: 'Sulit · Analisis & Cedera',
                        emoji: '🏆',
                        totalQ: 30,
                        targetBuka: 120,
                        color: AppColors.danger,
                        unlocked: _levelTerbuka >= 3,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required int level,
    required String title,
    required String subtitle,
    required String emoji,
    required int totalQ,
    required int targetBuka,
    required Color color,
    required bool unlocked,
  }) {
    final skor = _skorPerLevel[level] ?? 0;
    final isCompleted = skor >= totalQ;
    final progress = unlocked && totalQ > 0
        ? (skor / totalQ).clamp(0.0, 1.0)
        : targetBuka > 0
            ? (_totalPoin / targetBuka).clamp(0.0, 1.0)
            : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + level * 100),
      curve: Curves.easeOutBack,
      builder: (_, val, __) => Transform.scale(
        scale: val,
        child: GestureDetector(
          onTap: unlocked
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizQuestionScreen(level: level),
                    ),
                  ).then((_) => _loadData())
              : null,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: unlocked
                      ? color.withOpacity(0.12)
                      : Colors.grey.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: unlocked
                    ? color.withOpacity(0.2)
                    : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Emoji circle
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: unlocked
                            ? color.withOpacity(0.1)
                            : AppColors.inputBg,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 26)),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: unlocked
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: unlocked
                            ? color.withOpacity(0.1)
                            : AppColors.inputBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            unlocked
                                ? (isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.play_circle_rounded)
                                : Icons.lock_rounded,
                            size: 14,
                            color: unlocked ? color : AppColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unlocked
                                ? (isCompleted ? 'Selesai' : 'OPEN')
                                : 'Terkunci',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color:
                                  unlocked ? color : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Info chips
                Row(
                  children: [
                    _infoChip(Icons.quiz_outlined, '$totalQ Soal',
                        AppColors.primary),
                    const SizedBox(width: 8),
                    _infoChip(Icons.stars_rounded, '+10 Poin/soal',
                        AppColors.warning),
                    if (!unlocked && targetBuka > 0) ...[
                      const SizedBox(width: 8),
                      _infoChip(Icons.lock_clock_rounded,
                          'Butuh $targetBuka Poin', AppColors.danger),
                    ],
                  ],
                ),

                const SizedBox(height: 12),

                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          unlocked ? 'Progress Belajar' : 'Menuju Pembukaan',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          unlocked
                              ? '$skor/$totalQ Soal'
                              : '$_totalPoin/$targetBuka Poin',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: unlocked ? color : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.inputBg,
                        color: unlocked ? color : AppColors.textLight,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
