import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/storage_helper.dart';
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

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _nextLevelUnlocked = false;
  int _nextLevel = 2;
  int _totalPoin = 0;

  @override
  void initState() {
    super.initState();
    _checkNextLevel();
  }

  Future<void> _checkNextLevel() async {
    final storage = StorageHelper();
    _totalPoin = await storage.getTotalPoin();
    int levelTerbuka = await storage.getLevelTerbuka();

    bool unlocked = false;
    int next = widget.level + 1;

    if (widget.level == 1 && _totalPoin >= 50 && levelTerbuka >= 2) {
      unlocked = true;
    } else if (widget.level == 2 && _totalPoin >= 120 && levelTerbuka >= 3) {
      unlocked = true;
    }

    setState(() {
      _nextLevelUnlocked = unlocked;
      _nextLevel = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPerfect = widget.score == widget.totalQuestions;
    final double percentage = widget.score / widget.totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil Quiz Level ${widget.level}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isPerfect ? Colors.amber.shade100 : Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPerfect ? Icons.emoji_events : Icons.assignment_turned_in,
                    size: 70,
                    color: isPerfect ? Colors.amber : Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Skor
              Text(
                'Skor Anda',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.score} / ${widget.totalQuestions}',
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: percentage >= 0.7 ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentage >= 0.7 ? '🎉 Lulus 🎉' : '📚 Belajar Lagi Yuk',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: percentage >= 0.7 ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Poin didapat
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Poin yang didapat',
                          style: TextStyle(fontSize: 12, color: Colors.brown),
                        ),
                        Text(
                          '+${widget.poinDidapat} Poin',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tombol-tombol
              Column(
                children: [
                  // Tombol LANJUT (hanya jika level berikutnya terbuka)
                  if (_nextLevelUnlocked && widget.level < 3)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizQuestionScreen(level: _nextLevel),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Lanjut ke Level Berikutnya'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                  if (_nextLevelUnlocked && widget.level < 3)
                    const SizedBox(height: 12),

                  // Tombol ULANGI
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizQuestionScreen(level: widget.level),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Ulangi Quiz'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tombol KEMBALI KE MENU
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MenuScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Kembali ke Menu'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}