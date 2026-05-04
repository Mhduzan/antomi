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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = StorageHelper();
    _levelTerbuka = await storage.getLevelTerbuka();
    _totalPoin = await storage.getTotalPoin();
    setState(() {});
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF0F4F8)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Info poin
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      'Total Poin Kamu: $_totalPoin',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Level Cards (BESAR)
              Expanded(
                child: ListView(
                  children: [
                    _buildLevelCard(
                      level: 1,
                      title: 'Level 1 - Dasar',
                      targetPoin: 0,
                      color: AppColors.success,
                      unlocked: true,
                    ),
                    const SizedBox(height: 20),
                    _buildLevelCard(
                      level: 2,
                      title: 'Level 2 - Menengah',
                      targetPoin: 50,
                      color: AppColors.warning,
                      unlocked: _levelTerbuka >= 2,
                    ),
                    const SizedBox(height: 20),
                    _buildLevelCard(
                      level: 3,
                      title: 'Level 3 - Mahir',
                      targetPoin: 120,
                      color: AppColors.danger,
                      unlocked: _levelTerbuka >= 3,
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

  Widget _buildLevelCard({
    required int level,
    required String title,
    required int targetPoin,
    required Color color,
    required bool unlocked,
  }) {
    return GestureDetector(
      onTap: unlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizQuestionScreen(level: level),
                ),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: unlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey, Colors.grey],
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
              : [],
        ),
        child: Column(
          children: [
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
                      '$level',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (!unlocked)
                        Text(
                          '🔒 Terkunci - Butuh $targetPoin Poin',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      if (unlocked)
                        Text(
                          '✨ Klik untuk mulai',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  unlocked ? Icons.arrow_forward : Icons.lock,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}