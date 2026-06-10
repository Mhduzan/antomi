// lib/screens/quiz_question_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import 'quiz_result_screen.dart';

class QuizQuestionScreen extends StatefulWidget {
  final int level;
  const QuizQuestionScreen({required this.level, super.key});
  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with TickerProviderStateMixin {
  late R _r;
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _poinDariQuiz = 0;
  late StorageHelper _storage;
  bool _isAnswered = false;
  int? _selectedIndex;       // index di _shuffledOptions yang dipilih
  bool _showExplanation = false;

  // Shuffle per soal
  late List<String> _shuffledOptions;  // opsi yang sudah diacak
  late int _correctShuffledIndex;      // index jawaban benar di list yang diacak

  late AnimationController _progressCtrl;

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _questions = quizData[widget.level] ?? [];
    _progressCtrl = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _prepareCurrentQuestion();
    _updateProgress();
  }

  /// Acak pilihan jawaban untuk soal saat ini
  void _prepareCurrentQuestion() {
    if (_questions.isEmpty) return;
    final soal = _questions[_currentIndex];
    final correct = soal.options[soal.correctAnswerIndex];

    // Buat list dengan index asli lalu shuffle
    final indexed = soal.options.asMap().entries.toList()..shuffle(Random());
    _shuffledOptions = indexed.map((e) => e.value).toList();
    _correctShuffledIndex = _shuffledOptions.indexOf(correct);
  }

  void _updateProgress() {
    final target = (_currentIndex + 1) / (_questions.isEmpty ? 1 : _questions.length);
    _progressCtrl.animateTo(target);
  }

  @override
  void dispose() { _progressCtrl.dispose(); super.dispose(); }

  void _answerQuestion(int shuffledIndex) async {
    if (_isAnswered) return;
    setState(() {
      _isAnswered = true;
      _selectedIndex = shuffledIndex;
      _showExplanation = true;
    });

    final isCorrect = shuffledIndex == _correctShuffledIndex;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _FeedbackDialog(
        isCorrect: isCorrect,
        correctAnswer: _shuffledOptions[_correctShuffledIndex],
        onNext: () { Navigator.pop(context); _lanjutKeSoalBerikutnya(isCorrect); },
      ),
    );

    if (isCorrect) setState(() { _score++; _poinDariQuiz += 10; });
  }

  void _lanjutKeSoalBerikutnya(bool isCorrect) async {
    setState(() { _showExplanation = false; _selectedIndex = null; });

    if (_currentIndex + 1 < _questions.length) {
      setState(() { _currentIndex++; _isAnswered = false; });
      _prepareCurrentQuestion();
      _updateProgress();
    } else {
      int totalPoin = await _storage.getTotalPoin();
      int poinBaru = totalPoin + _poinDariQuiz;
      await _storage.saveTotalPoin(poinBaru);
      int levelTerbuka = await _storage.getLevelTerbuka();
      if (widget.level == 1 && poinBaru >= 50 && levelTerbuka < 2) await _storage.saveLevelTerbuka(2);
      else if (widget.level == 2 && poinBaru >= 120 && levelTerbuka < 3) await _storage.saveLevelTerbuka(3);
      await _storage.saveSkorLevel(widget.level, _score);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizResultScreen(
          level: widget.level, score: _score,
          totalQuestions: _questions.length, poinDidapat: _poinDariQuiz,
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _r = R.of(context);
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz Level ${widget.level}'),
          backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        body: const Center(child: Text('Soal tidak tersedia')),
      );
    }

    final soal = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(_r.pad, _r.padSm, _r.pad, _r.pad + 8),
              child: Column(
                children: [
                  // Pertanyaan + gambar dalam 1 card
                  _buildQuestionWithImage(soal.question, soal.imageAsset),
                  SizedBox(height: _r.h(14)),

                  // Opsi jawaban A-D (dari shuffledOptions)
                  ...List.generate(_shuffledOptions.length, (i) => _buildOption(i)),

                  if (_showExplanation) ...[
                    SizedBox(height: _r.h(10)),
                    _buildTipCard(soal.question),
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
          padding: EdgeInsets.fromLTRB(_r.pad, _r.padXs, _r.pad, _r.pad),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: _r.w(36), height: _r.w(36),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(_r.padSm),
                      ),
                      child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: _r.iconSm),
                    ),
                  ),
                  Expanded(child: Center(child: Text('Quiz Level ${widget.level}',
                    style: GoogleFonts.poppins(fontSize: _r.sp(16), fontWeight: FontWeight.w700, color: Colors.white)))),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: _r.padSm + 2, vertical: _r.padXs),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Icon(Icons.stars_rounded, color: AppColors.warning, size: _r.iconSm - 2),
                      SizedBox(width: _r.w(4)),
                      Text('$_poinDariQuiz',
                        style: GoogleFonts.poppins(fontSize: _r.sp(12), fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ]),
                  ),
                ],
              ),
              SizedBox(height: _r.h(10)),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        color: Colors.white,
                        minHeight: _r.h(6),
                      ),
                    ),
                  ),
                  SizedBox(width: _r.w(10)),
                  Text('${_currentIndex + 1}/${_questions.length}',
                    style: GoogleFonts.poppins(fontSize: _r.sp(12), fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
              SizedBox(height: _r.h(4)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Soal ${_currentIndex + 1} dari ${_questions.length}',
                  style: GoogleFonts.inter(fontSize: _r.sp(10), color: Colors.white.withOpacity(0.75))),
                Text('Skor: $_score/${_questions.length}',
                  style: GoogleFonts.inter(fontSize: _r.sp(10), color: Colors.white.withOpacity(0.75))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // Pertanyaan di atas, gambar di bawah (sesuai bunyi soal "gambar di bawah ini")
  Widget _buildQuestionWithImage(String question, String imageAsset) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_r.radiusLg),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_r.radiusLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks pertanyaan
            Padding(
              padding: EdgeInsets.fromLTRB(_r.pad - 2, _r.pad - 2, _r.pad - 2, _r.padSm),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.all(_r.padXs + 2),
                    decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(_r.padXs + 2)),
                    child: Icon(Icons.help_rounded, color: AppColors.primary, size: _r.iconSm),
                  ),
                  SizedBox(width: _r.w(8)),
                  Text('Pertanyaan',
                    style: GoogleFonts.inter(fontSize: _r.sp(11), fontWeight: FontWeight.w600, color: AppColors.primary)),
                ]),
                SizedBox(height: _r.h(8)),
                Text(question,
                  style: GoogleFonts.poppins(
                    fontSize: _r.sp(14), fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary, height: 1.5)),
              ]),
            ),

            // Gambar di bawah pertanyaan
            if (imageAsset.isNotEmpty) ...[
              Container(
                width: double.infinity, color: AppColors.primaryPale,
                padding: EdgeInsets.symmetric(vertical: _r.padXs),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.image_rounded, size: _r.iconSm - 2, color: AppColors.primary),
                  SizedBox(width: _r.w(4)),
                  Text('Ilustrasi Anatomi',
                    style: GoogleFonts.inter(fontSize: _r.sp(10), fontWeight: FontWeight.w600, color: AppColors.primary)),
                ]),
              ),
              Image.asset(
                imageAsset,
                height: _r.imgH,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: _r.imgH, color: AppColors.inputBg,
                  child: Center(child: Icon(Icons.image_not_supported_rounded,
                    size: _r.iconLg, color: AppColors.textLight)),
                ),
              ),
            ],
            SizedBox(height: _r.h(6)),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int shuffledIndex) {
    final isSelected = _selectedIndex == shuffledIndex;
    final isCorrect  = shuffledIndex == _correctShuffledIndex;
    final label      = String.fromCharCode(65 + shuffledIndex); // A, B, C, D

    Color borderColor = AppColors.divider;
    Color bgColor     = Colors.white;
    Color labelBg     = AppColors.primary;

    if (_isAnswered) {
      if (isSelected && isCorrect)  { borderColor = AppColors.success; bgColor = AppColors.successLight; labelBg = AppColors.success; }
      else if (isSelected && !isCorrect) { borderColor = AppColors.danger; bgColor = AppColors.dangerLight; labelBg = AppColors.danger; }
      else if (!isSelected && isCorrect) { borderColor = AppColors.success.withOpacity(0.5); bgColor = AppColors.successLight.withOpacity(0.4); labelBg = AppColors.success.withOpacity(0.6); }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: _r.h(10)),
      child: GestureDetector(
        onTap: _isAnswered ? null : () => _answerQuestion(shuffledIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: _r.padSm + 2, vertical: _r.padSm + 2),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(_r.radius),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              // Label huruf
              Container(
                width: _r.w(34), height: _r.w(34),
                decoration: BoxDecoration(color: labelBg, borderRadius: BorderRadius.circular(_r.padSm)),
                child: Center(child: Text(label,
                  style: GoogleFonts.poppins(fontSize: _r.sp(14), fontWeight: FontWeight.w700, color: Colors.white))),
              ),
              SizedBox(width: _r.w(12)),
              Expanded(child: Text(_shuffledOptions[shuffledIndex],
                style: GoogleFonts.inter(
                  fontSize: _r.sp(13),
                  fontWeight: _isAnswered && isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppColors.textPrimary))),
              if (_isAnswered && isSelected)
                Icon(isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: isCorrect ? AppColors.success : AppColors.danger,
                  size: _r.iconMd),
              if (_isAnswered && !isSelected && isCorrect)
                Icon(Icons.check_circle_outlined, color: AppColors.success, size: _r.iconMd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String question) {
    String tip = '📖 Terus belajar! Memahami anatomi tubuh sangat penting untuk kesehatan.';
    if (question.toLowerCase().contains('squat') || question.toLowerCase().contains('quadriceps')) {
      tip = '✨ Otot quadriceps adalah kelompok otot terkuat di tubuh manusia!';
    } else if (question.toLowerCase().contains('push') || question.toLowerCase().contains('pectoralis')) {
      tip = '✨ Push-up melatih dada, core, trisep, dan bahu sekaligus!';
    } else if (question.toLowerCase().contains('tulang')) {
      tip = '📚 Manusia dewasa punya 206 tulang, bayi punya sekitar 270 tulang!';
    } else if (question.toLowerCase().contains('sendi')) {
      tip = '🦴 Sendi adalah penghubung antar tulang yang memungkinkan gerakan tubuh!';
    } else if (question.toLowerCase().contains('otot')) {
      tip = '💪 Tubuh manusia memiliki lebih dari 600 otot yang bekerja bersama!';
    }
    return Container(
      padding: EdgeInsets.all(_r.padSm + 2),
      decoration: BoxDecoration(
        color: AppColors.primaryPale,
        borderRadius: BorderRadius.circular(_r.radius),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: _r.iconSm),
        SizedBox(width: _r.w(8)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('💡 Tahukah kamu?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: _r.sp(12), color: AppColors.primaryDark)),
          SizedBox(height: _r.h(4)),
          Text(tip, style: GoogleFonts.inter(fontSize: _r.sp(11), color: AppColors.textPrimary, height: 1.4)),
        ])),
      ]),
    );
  }
}

// ── Feedback Dialog ───────────────────────────────────────────
class _FeedbackDialog extends StatefulWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onNext;
  const _FeedbackDialog({required this.isCorrect, required this.correctAnswer, required this.onNext});
  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final ok = widget.isCorrect;
    return ScaleTransition(
      scale: _scale,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(r.pad + 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.radiusXl),
            boxShadow: [BoxShadow(
              color: (ok ? AppColors.success : AppColors.danger).withOpacity(0.25),
              blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: r.w(80), height: r.w(80),
              decoration: BoxDecoration(
                color: ok ? AppColors.successLight : AppColors.dangerLight,
                shape: BoxShape.circle),
              child: Icon(
                ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: r.w(44), color: ok ? AppColors.success : AppColors.danger),
            ),
            SizedBox(height: r.h(14)),
            Text(ok ? 'Jawaban Benar!' : 'Jawaban Salah!',
              style: GoogleFonts.poppins(fontSize: r.sp(20), fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            SizedBox(height: r.h(8)),
            if (ok)
              Container(
                padding: EdgeInsets.symmetric(horizontal: r.pad, vertical: r.padXs + 2),
                decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.stars_rounded, color: AppColors.warning, size: r.iconSm + 2),
                  SizedBox(width: r.w(6)),
                  Text('+10 Poin', style: GoogleFonts.poppins(fontSize: r.sp(14), fontWeight: FontWeight.w700, color: AppColors.warning)),
                ]))
            else ...[
              Text('Jawaban yang benar:',
                style: GoogleFonts.inter(fontSize: r.sp(12), color: AppColors.textSecondary)),
              SizedBox(height: r.h(6)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: r.pad, vertical: r.padXs + 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(r.padSm),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2))),
                child: Text(widget.correctAnswer, textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: r.sp(13), fontWeight: FontWeight.w600, color: AppColors.primary))),
            ],
            SizedBox(height: r.h(20)),
            SizedBox(
              width: double.infinity, height: r.btnH,
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ok ? AppColors.success : AppColors.primary,
                  foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radius))),
                child: Text('Lanjut',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: r.sp(14))),
              )),
          ]),
        ),
      ),
    );
  }
}
