import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/storage_helper.dart';
import 'quiz_question_screen.dart';

class QuizLevelScreen extends StatefulWidget {
  const QuizLevelScreen({super.key});

  @override
  State<QuizLevelScreen> createState() => _QuizLevelScreenState();
}

class _QuizLevelScreenState extends State<QuizLevelScreen> {
  int _levelTerbuka = 1;
  int _totalPoin = 0;
  Map<int, int> _skorPerLevel = {1: 0, 2: 0, 3: 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = StorageHelper();
    _levelTerbuka = await storage.getLevelTerbuka();
    _totalPoin = await storage.getTotalPoin();
    
    // Load skor per level
    for (int i = 1; i <= 3; i++) {
      _skorPerLevel[i] = await storage.getSkorLevel(i);
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  String _getLevelDescription(int level) {
    switch (level) {
      case 1:
        return 'Pelajari dasar-dasar anatomi tubuh manusia, termasuk otot, tulang, dan sendi utama.';
      case 2:
        return 'Tingkatkan pemahaman tentang fungsi spesifik otot dan tulang dalam pergerakan tubuh.';
      case 3:
        return 'Kuasi pengetahuan tentang biomekanik, cedera olahraga, dan analisis gerakan.';
      default:
        return '';
    }
  }

  String _getLevelIcon(int level) {
    switch (level) {
      case 1:
        return '📚';
      case 2:
        return '⚡';
      case 3:
        return '🏆';
      default:
        return '🎯';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Level Quiz',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF0F4F8)],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Info poin dengan desain lebih menarik
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.warning, AppColors.warning.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warning.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.stars,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Poin Kamu',
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '$_totalPoin Poin',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Level $_levelTerbuka/${3}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Info edukasi
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '✨ Semakin tinggi level, semakin menantang soal dan semakin banyak poin yang bisa kamu dapatkan!',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Level Cards
                    Expanded(
                      child: ListView(
                        children: [
                          _buildLevelCard(
                            level: 1,
                            title: 'Level 1 - Dasar',
                            subtitle: 'Pengenalan Anatomi',
                            targetPoin: 0,
                            totalQuestions: 10,
                            poinPerSoal: 10,
                            targetPoinBuka: 50,
                            color: AppColors.success,
                            unlocked: true,
                          ),
                          const SizedBox(height: 16),
                          _buildLevelCard(
                            level: 2,
                            title: 'Level 2 - Menengah',
                            subtitle: 'Fungsi & Pergerakan',
                            targetPoin: 50,
                            totalQuestions: 20,
                            poinPerSoal: 10,
                            targetPoinBuka: 120,
                            color: AppColors.warning,
                            unlocked: _levelTerbuka >= 2,
                          ),
                          const SizedBox(height: 16),
                          _buildLevelCard(
                            level: 3,
                            title: 'Level 3 - Mahir',
                            subtitle: 'Analisis & Cedera',
                            targetPoin: 120,
                            totalQuestions: 30,
                            poinPerSoal: 10,
                            targetPoinBuka: 0,
                            color: AppColors.danger,
                            unlocked: _levelTerbuka >= 3,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Motivational quote
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '💪 "Pengetahuan adalah kunci untuk tubuh yang sehat dan kuat!"',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLevelCard({
    required int level,
    required String title,
    required String subtitle,
    required int targetPoin,
    required int totalQuestions,
    required int poinPerSoal,
    required int targetPoinBuka,
    required Color color,
    required bool unlocked,
  }) {
    final maxPoinLevel = totalQuestions * poinPerSoal;
    final skorLevel = (_skorPerLevel[level] ?? 0);
    final poinLevel = skorLevel * poinPerSoal;
    final isCompleted = poinLevel >= maxPoinLevel;
    
    // HITUNG PROGRESS DENGAN AMAN - CEK DIVISI BY ZERO
    double progressValue = 0.0;
    if (unlocked && !isCompleted) {
      // Progress untuk level yang sudah dibuka
      progressValue = totalQuestions > 0 ? skorLevel / totalQuestions : 0.0;
    } else if (!unlocked && level > 1) {
      // Progress untuk level terkunci - CEK targetPoinBuka TIDAK 0
      if (targetPoinBuka > 0) {
        progressValue = (_totalPoin / targetPoinBuka).clamp(0.0, 1.0);
      } else {
        progressValue = 0.0;
      }
    }
    
    // HITUNG PERSENTASE DENGAN AMAN
    int percentProgress = 0;
    if (unlocked && !isCompleted) {
      percentProgress = totalQuestions > 0 ? ((skorLevel / totalQuestions) * 100).toInt() : 0;
    } else if (!unlocked && level > 1) {
      percentProgress = targetPoinBuka > 0 ? ((_totalPoin / targetPoinBuka) * 100).toInt() : 0;
      percentProgress = percentProgress.clamp(0, 100);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: unlocked ? Matrix4.identity() : Matrix4.translationValues(0, 0, 0),
      child: GestureDetector(
        onTap: unlocked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizQuestionScreen(level: level),
                  ),
                ).then((_) => _loadData());
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: unlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.85)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey, Color(0xFF7A7A7A)],
                  ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: unlocked
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header level
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getLevelIcon(level),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      unlocked ? Icons.arrow_forward : Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Divider
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.2),
              ),
              
              const SizedBox(height: 12),
              
              // Informasi detail level
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(Icons.quiz, '$totalQuestions Soal', Colors.white.withOpacity(0.2)),
                  _buildInfoChip(Icons.stars, '+$poinPerSoal Poin/soal', Colors.white.withOpacity(0.2)),
                  if (isCompleted && unlocked)
                    _buildInfoChip(Icons.verified, 'Selesai! ✅', Colors.green.withOpacity(0.3)),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Deskripsi level
              Text(
                _getLevelDescription(level),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              
              // Progress untuk level terkunci
              if (!unlocked && level > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🔒 Terkunci',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Butuh $targetPoinBuka Poin',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          color: Colors.white,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$percentProgress% menuju pembukaan',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Progress untuk level yang sudah dibuka
              if (unlocked && !isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress Belajar',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '$skorLevel/$totalQuestions Soal',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          color: Colors.white,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$percentProgress% penguasaan materi',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Badge completion untuk level yang sudah selesai
              if (isCompleted && unlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Level Selesai! Lanjut ke level berikutnya',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}