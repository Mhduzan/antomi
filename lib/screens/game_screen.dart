import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/storage_helper.dart';
import '../data/game_data.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _poinGame = 0;
  List<String> _selectedLetters = [];
  List<String> _availableLetters = [];
  List<String> _usedLetters = [];
  String _currentAnswer = '';
  bool _isAnswered = false;
  String? _feedbackMessage;

  @override
  void initState() {
    super.initState();
    _resetPuzzle();
  }

  void _resetPuzzle() {
    final puzzle = gamePuzzles[_currentIndex];
    _selectedLetters = [];
    _usedLetters = [];
    _availableLetters = List.from(puzzle.availableLetters);
    _currentAnswer = '';
    _isAnswered = false;
    _feedbackMessage = null;
    _updateCurrentAnswer();
  }

  void _selectLetter(String letter) {
    if (_isAnswered) return;
    if (_selectedLetters.contains(letter)) return;

    setState(() {
      _selectedLetters.add(letter);
      _availableLetters.remove(letter);
      _usedLetters.add(letter);
      _updateCurrentAnswer();
    });
  }

  void _returnLetter(String letter) {
    if (_isAnswered) return;
    if (!_selectedLetters.contains(letter)) return;

    setState(() {
      _selectedLetters.remove(letter);
      _availableLetters.add(letter);
      _usedLetters.remove(letter);
      _updateCurrentAnswer();
    });
  }

  void _updateCurrentAnswer() {
    final puzzle = gamePuzzles[_currentIndex];
    String answer = '';
    for (int i = 0; i < puzzle.correctWord.length; i++) {
      String char = puzzle.correctWord[i];
      if (_selectedLetters.contains(char)) {
        answer += char;
      } else {
        answer += '_';
      }
    }
    _currentAnswer = answer;
  }

  void _checkAnswer() async {
    if (_isAnswered) return;

    bool isCorrect = _currentAnswer == gamePuzzles[_currentIndex].correctWord;

    setState(() {
      _isAnswered = true;
      if (isCorrect) {
        _score++;
        _poinGame += 10;
        _feedbackMessage = '✓ Benar! +10 poin';
      } else {
        _feedbackMessage = '✗ Salah! Jawaban: ${gamePuzzles[_currentIndex].correctWord}';
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex + 1 < gamePuzzles.length) {
        setState(() {
          _currentIndex++;
          _resetPuzzle();
        });
      } else {
        _selesaiGame();
      }
    });
  }

  Future<void> _selesaiGame() async {
    final storage = StorageHelper();
    int totalPoin = await storage.getTotalPoin();
    await storage.saveTotalPoin(totalPoin + _poinGame);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Game Selesai!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 50, color: AppColors.warning),
              const SizedBox(height: 12),
              Text(
                'Skor: $_score / ${gamePuzzles.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '+$_poinGame Poin',
                style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text('Kembali ke Menu'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = gamePuzzles[_currentIndex];
    final progress = (_currentIndex + 1) / gamePuzzles.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tebak Gambar',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${_currentIndex + 1}/${gamePuzzles.length}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(
                              '$_poinGame Poin',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
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

            // GAMBAR UTAMA
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      puzzle.imageAsset,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          children: [
                            Icon(Icons.image_not_supported, size: 60, color: AppColors.primary),
                            const SizedBox(height: 8),
                            Text(
                              puzzle.imageHint,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gambar di atas adalah?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Petunjuk: ${puzzle.clue}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BAGIAN PUZZLE KATA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Jawaban sementara
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Jawaban: ',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            _currentAnswer.isEmpty ? '_____' : _currentAnswer,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Huruf yang sudah dipilih
                  if (_selectedLetters.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Huruf Terpilih (klik untuk batal):',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _selectedLetters.map((letter) {
                              return GestureDetector(
                                onTap: () => _returnLetter(letter),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.warning,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.warning.withOpacity(0.3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      letter,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Huruf yang tersedia
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _availableLetters.map((letter) {
                      return GestureDetector(
                        onTap: _isAnswered ? null : () => _selectLetter(letter),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: _isAnswered
                                ? null
                                : const LinearGradient(
                                    colors: [AppColors.primary, AppColors.primaryDark],
                                  ),
                            color: _isAnswered ? Colors.grey.shade300 : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isAnswered
                                ? []
                                : [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isAnswered ? Colors.grey.shade600 : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Cek Jawaban
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isAnswered || _currentAnswer.contains('_') ? null : _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        _isAnswered ? 'Memeriksa...' : 'Cek Jawaban',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  if (_feedbackMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _feedbackMessage!.contains('Benar')
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _feedbackMessage!.contains('Benar') ? Icons.check_circle : Icons.cancel,
                            size: 20,
                            color: _feedbackMessage!.contains('Benar') ? AppColors.success : AppColors.danger,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _feedbackMessage!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: _feedbackMessage!.contains('Benar') ? AppColors.success : AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}