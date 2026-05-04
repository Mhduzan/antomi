import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../utils/storage_helper.dart';
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

    // Tampilkan feedback
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isCorrect ? Colors.green : Colors.red,
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
      // Quiz selesai - simpan skor dan poin
      int totalPoinSekarang = await _storage.getTotalPoin();
      int poinBaru = totalPoinSekarang + _poinDariQuiz;
      await _storage.saveTotalPoin(poinBaru);

      // Cek unlock level berikutnya
      int levelTerbuka = await _storage.getLevelTerbuka();
      
      if (widget.level == 1 && poinBaru >= 50 && levelTerbuka < 2) {
        await _storage.saveLevelTerbuka(2);
      } else if (widget.level == 2 && poinBaru >= 120 && levelTerbuka < 3) {
        await _storage.saveLevelTerbuka(3);
      }

      // Simpan skor tertinggi
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
          title: const Text('Quiz'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text('Soal tidak tersedia untuk level ini'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Level ${widget.level}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Progress Bar
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${_currentIndex + 1} dari ${_questions.length}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '$_poinDariQuiz Poin',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Card Soal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Soal
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        _questions[_currentIndex].question,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pilihan Jawaban
                    Expanded(
                      child: ListView.builder(
                        itemCount: _questions[_currentIndex].options.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildAnswerButton(
                              idx,
                              _questions[_currentIndex].options[idx],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int index, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isAnswered ? null : () => _answerQuestion(index),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade700,
          elevation: 2,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blue.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}