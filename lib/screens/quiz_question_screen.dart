import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';
import 'quiz_result_screen.dart';

class QuizQuestionScreen extends StatefulWidget {
  final int level;
  const QuizQuestionScreen({required this.level, super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _poinDariQuiz = 0;
  late StorageHelper _storage;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _questions = quizData[widget.level] ?? [];
  }

  void _answerQuestion(int selectedIndex) async {
    if (_isAnswered) return;
    _isAnswered = true;

    bool isCorrect = selectedIndex == _questions[_currentIndex].correctAnswerIndex;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isCorrect ? AppColors.success : AppColors.danger,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              isCorrect ? 'Benar! +10 Poin' : 'Salah!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (!isCorrect)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Jawaban benar: ${_questions[_currentIndex].options[_questions[_currentIndex].correctAnswerIndex]}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _lanjutKeSoalBerikutnya(isCorrect);
            },
            child: const Text('Lanjut', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (isCorrect) {
      setState(() {
        _score++;
        _poinDariQuiz += 10;
      });
    }
  }

  void _lanjutKeSoalBerikutnya(bool isCorrect) async {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
      });
    } else {
      int totalPoinSekarang = await _storage.getTotalPoin();
      int poinBaru = totalPoinSekarang + _poinDariQuiz;
      await _storage.saveTotalPoin(poinBaru);

      int levelTerbuka = await _storage.getLevelTerbuka();
      
      if (widget.level == 1 && poinBaru >= 50 && levelTerbuka < 2) {
        await _storage.saveLevelTerbuka(2);
      } else if (widget.level == 2 && poinBaru >= 120 && levelTerbuka < 3) {
        await _storage.saveLevelTerbuka(3);
      }

      await _storage.saveSkorLevel(widget.level, _score);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResultScreen(
              level: widget.level,
              score: _score,
              totalQuestions: _questions.length,
              poinDidapat: _poinDariQuiz,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Level ${widget.level}'),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(child: Text('Soal tidak tersedia')),
      );
    }

    final soal = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Level ${widget.level}'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${_currentIndex + 1}/${_questions.length}',
                        style: GoogleFonts.inter(color: Colors.grey.shade600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_poinDariQuiz Poin',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.success,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // Gambar (jika ada)
            if (soal.imageAsset.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    soal.imageAsset,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Soal
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                soal.question,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Opsi Jawaban
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(soal.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isAnswered ? null : () => _answerQuestion(index),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                soal.options[index],
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}