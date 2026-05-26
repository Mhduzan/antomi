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
  String? _selectedAnswer;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _questions = quizData[widget.level] ?? [];
  }

  void _answerQuestion(int selectedIndex) async {
    if (_isAnswered) return;
    
    setState(() {
      _isAnswered = true;
      _selectedAnswer = String.fromCharCode(65 + selectedIndex);
      _showExplanation = true;
    });

    bool isCorrect = selectedIndex == _questions[_currentIndex].correctAnswerIndex;

    // Animasi haptic feedback
    if (isCorrect) {
      // Haptic feedback untuk jawaban benar
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        alignment: Alignment.center,
        children: [
          AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCorrect 
                    ? [Color(0xFF00C853), Color(0xFF00E676)]
                    : [Color(0xFFD32F2F), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: (isCorrect ? Color(0xFF00C853) : Color(0xFFD32F2F)).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          isCorrect ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                          size: 70,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isCorrect ? 'BENAR! 🎉' : 'Yah, SALAH 😔',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (isCorrect)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+10 Poin ✨',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (!isCorrect)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Jawaban yang benar adalah:',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _questions[_currentIndex].options[_questions[_currentIndex].correctAnswerIndex],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _lanjutKeSoalBerikutnya(isCorrect);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isCorrect ? Color(0xFF00C853) : Color(0xFFD32F2F),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Lanjut', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
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
    setState(() {
      _showExplanation = false;
      _selectedAnswer = null;
    });

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
      
      String unlockMessage = '';
      if (widget.level == 1 && poinBaru >= 50 && levelTerbuka < 2) {
        await _storage.saveLevelTerbuka(2);
        unlockMessage = '✨ Level 2 Terbuka! ✨';
      } else if (widget.level == 2 && poinBaru >= 120 && levelTerbuka < 3) {
        await _storage.saveLevelTerbuka(3);
        unlockMessage = '✨ Level 3 Terbuka! ✨';
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
    final bool isCorrectSelected = _isAnswered && _selectedAnswer != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.quiz, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text('Quiz Level ${widget.level}'),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan progress card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress Quiz',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Soal ${_currentIndex + 1} dari ${_questions.length}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.stars, color: AppColors.warning, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '$_poinDariQuiz Poin',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: Colors.white,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Skor: $_score/${_questions.length}',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                      ),
                      Icon(
                        _score >= (_questions.length / 2) ? Icons.verified : Icons.trending_up,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card Gambar (jika ada)
            if (soal.imageAsset.isNotEmpty)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Ilustrasi Anatomi',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          soal.imageAsset,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  Text('Gambar tidak tersedia', style: GoogleFonts.inter(color: Colors.grey)),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Kartu Soal
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.help_outline, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pertanyaan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    soal.question,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            // Opsi Jawaban
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: Text(
                      'Pilih Jawaban:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  ...List.generate(soal.options.length, (index) {
                    final isSelected = _selectedAnswer == String.fromCharCode(65 + index);
                    final isCorrect = index == soal.correctAnswerIndex;
                    final showResult = _isAnswered && isSelected;
                    
                    Color? buttonColor = Colors.white;
                    Color? borderColor = Colors.grey.shade300;
                    
                    if (_isAnswered && isSelected) {
                      borderColor = isCorrect ? Colors.green : Colors.red;
                      buttonColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
                    } else if (_isAnswered && isCorrect && !isSelected) {
                      borderColor = Colors.green.shade200;
                      buttonColor = Colors.green.shade50;
                    }
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: _isAnswered ? null : () => _answerQuestion(index),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: buttonColor,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: borderColor!, width: 2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isAnswered && isSelected && isCorrect
                                      ? [Colors.green, Colors.green.shade700]
                                      : _isAnswered && isSelected && !isCorrect
                                      ? [Colors.red, Colors.red.shade700]
                                      : [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                soal.options[index],
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: _isAnswered && isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            if (_isAnswered && isSelected)
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Tips Edukatif
            if (_showExplanation)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade50, Colors.indigo.shade50],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡 Materi Edukatif',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getEdukasiTip(soal.question, _selectedAnswer ?? ''),
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.blue.shade900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _getEdukasiTip(String question, String selectedAnswer) {
    // Tambahkan tip edukatif berdasarkan soal
    if (question.contains('squat') || question.contains('Quadriceps')) {
      return '✨ Fakta Menarik: Otot quadriceps adalah kelompok otot terkuat di tubuh manusia! Saat melakukan squat, otot ini bekerja keras untuk menopang berat badan.';
    } else if (question.contains('push-up') || question.contains('Pectoralis')) {
      return '✨ Fakta Menarik: Push-up tidak hanya melatih dada, tapi juga melibatkan core, trisep, dan bahu untuk stabilitas!';
    } else if (question.contains('tulang')) {
      return '📚 Tahukah Kamu? Manusia memiliki 206 tulang saat dewasa, tetapi saat lahir kita memiliki sekitar 270 tulang yang menyatu seiring pertumbuhan!';
    } else if (question.contains('sendi')) {
      return '🦴 Informasi: Sendi adalah penghubung antar tulang. Tanpa sendi, tubuh kita tidak bisa bergerak dengan fleksibel!';
    }
    return '📖 Terus belajar! Memahami anatomi tubuh sangat penting untuk kesehatan dan kebugaran.';
  }
}