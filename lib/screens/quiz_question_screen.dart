// lib/screens/quiz_question_screen.dart
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

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with TickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _poinDariQuiz = 0;
  late StorageHelper _storage;
  bool _isAnswered = false;
  String? _selectedAnswer;
  bool _showExplanation = false;

  late AnimationController _bounceCtrl;
  late AnimationController _progressCtrl;
  late Animation<double> _bounceAnim;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _questions = quizData[widget.level] ?? [];

    _bounceCtrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _bounceAnim = CurvedAnimation(
        parent: _bounceCtrl, curve: Curves.elasticOut);

    _progressCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOut);
    _updateProgress();
  }

  void _updateProgress() {
    final target = (_currentIndex + 1) / (_questions.isEmpty ? 1 : _questions.length);
    _progressCtrl.animateTo(target);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _answerQuestion(int selectedIndex) async {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = String.fromCharCode(65 + selectedIndex);
      _showExplanation = true;
    });

    final isCorrect =
        selectedIndex == _questions[_currentIndex].correctAnswerIndex;

    _bounceCtrl.forward(from: 0);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _FeedbackDialog(
        isCorrect: isCorrect,
        correctAnswer: _questions[_currentIndex]
            .options[_questions[_currentIndex].correctAnswerIndex],
        onNext: () {
          Navigator.pop(context);
          _lanjutKeSoalBerikutnya(isCorrect);
        },
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
      _updateProgress();
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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Quiz Level ${widget.level}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Soal tidak tersedia')),
      );
    }

    final soal = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with progress
          _buildHeader(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Gambar soal
                  if (soal.imageAsset.isNotEmpty)
                    _buildImageCard(soal.imageAsset),

                  const SizedBox(height: 16),

                  // Pertanyaan
                  _buildQuestionCard(soal.question),

                  const SizedBox(height: 16),

                  // Opsi jawaban
                  ...List.generate(soal.options.length, (i) {
                    return _buildOptionButton(soal, i);
                  }),

                  // Tip edukatif
                  if (_showExplanation) ...[
                    const SizedBox(height: 12),
                    _buildTipCard(soal.question, _selectedAnswer ?? ''),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final progress = (_currentIndex + 1) / _questions.length;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
              // Top row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Quiz Level ${widget.level}',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded,
                            color: AppColors.warning, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$_poinDariQuiz',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Progress
              Row(
                children: [
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _progressAnim,
                      builder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          color: Colors.white,
                          minHeight: 7,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_currentIndex + 1}/${_questions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soal ${_currentIndex + 1} dari ${_questions.length}',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.75)),
                  ),
                  Text(
                    'Skor: $_score/${_questions.length}',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.75)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageAsset) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primaryPale,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_rounded,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
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
              imageAsset,
              height: 170,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                height: 170,
                color: AppColors.inputBg,
                child: const Center(
                  child: Icon(Icons.image_not_supported_rounded,
                      size: 48, color: AppColors.textLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.help_rounded,
                    color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Pertanyaan',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(QuizQuestion soal, int index) {
    final isSelected =
        _selectedAnswer == String.fromCharCode(65 + index);
    final isCorrect = index == soal.correctAnswerIndex;

    Color borderColor = AppColors.divider;
    Color bgColor = Colors.white;
    Color labelBg = AppColors.primary;
    Color textColor = AppColors.textPrimary;

    if (_isAnswered) {
      if (isSelected && isCorrect) {
        borderColor = AppColors.success;
        bgColor = AppColors.successLight;
        labelBg = AppColors.success;
        textColor = AppColors.textPrimary;
      } else if (isSelected && !isCorrect) {
        borderColor = AppColors.danger;
        bgColor = AppColors.dangerLight;
        labelBg = AppColors.danger;
        textColor = AppColors.textPrimary;
      } else if (!isSelected && isCorrect) {
        borderColor = AppColors.success.withOpacity(0.5);
        bgColor = AppColors.successLight.withOpacity(0.4);
        labelBg = AppColors.success.withOpacity(0.6);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: _isAnswered ? null : () => _answerQuestion(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Label huruf
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: labelBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  soal.options[index],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: _isAnswered && isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: textColor,
                  ),
                ),
              ),

              if (_isAnswered && isSelected)
                Icon(
                  isCorrect
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String question, String selectedAnswer) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryPale,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Materi Edukatif',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getEdukasiTip(question, selectedAnswer),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEdukasiTip(String question, String selectedAnswer) {
    if (question.contains('squat') || question.contains('Quadriceps')) {
      return '✨ Fakta Menarik: Otot quadriceps adalah kelompok otot terkuat di tubuh manusia!';
    } else if (question.contains('push-up') ||
        question.contains('Pectoralis')) {
      return '✨ Push-up tidak hanya melatih dada, tapi juga melibatkan core, trisep, dan bahu!';
    } else if (question.contains('tulang')) {
      return '📚 Manusia memiliki 206 tulang saat dewasa, tetapi saat lahir kita memiliki sekitar 270 tulang!';
    } else if (question.contains('sendi')) {
      return '🦴 Sendi adalah penghubung antar tulang. Tanpa sendi, tubuh kita tidak bisa bergerak dengan fleksibel!';
    }
    return '📖 Terus belajar! Memahami anatomi tubuh sangat penting untuk kesehatan dan kebugaran.';
  }
}

// ─── Feedback Dialog ──────────────────────────────────────
class _FeedbackDialog extends StatefulWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onNext;

  const _FeedbackDialog({
    required this.isCorrect,
    required this.correctAnswer,
    required this.onNext,
  });

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _scaleAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.isCorrect;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: (isCorrect ? AppColors.success : AppColors.danger)
                    .withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.successLight
                      : AppColors.dangerLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 48,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              if (isCorrect)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: AppColors.warning, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '+10 Poin',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),

              if (!isCorrect) ...[
                Text(
                  'Jawaban yang benar:',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Text(
                    widget.correctAnswer,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCorrect
                        ? AppColors.success
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Lanjut',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
