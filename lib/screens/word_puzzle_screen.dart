// lib/screens/word_puzzle_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_puzzle.dart';
import '../utils/colors.dart';

class WordPuzzleScreen extends StatefulWidget {
  final WordPuzzle puzzle;
  final int stageNumber;
  final void Function({required int poin, required int correct}) onComplete;

  const WordPuzzleScreen({
    super.key,
    required this.puzzle,
    required this.stageNumber,
    required this.onComplete,
  });

  @override
  State<WordPuzzleScreen> createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────
  late List<String> _pool;          // huruf yang tersedia
  late List<String?> _slots;        // slot jawaban (index per huruf correctWord)
  bool _isChecked = false;
  bool? _isCorrect;

  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double> _shakeAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _initPuzzle();

    _shakeCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(_shakeCtrl);

    _bounceCtrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _bounceAnim = CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut);
  }

  void _initPuzzle() {
    _pool = widget.puzzle.buildLetterPool();
    _slots = List.filled(widget.puzzle.correctWord.length, null);
    _isChecked = false;
    _isCorrect = null;
  }

  // ── PENTING: reset state saat puzzle berubah (soal baru) ─────
  @override
  void didUpdateWidget(WordPuzzleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puzzle.correctWord != widget.puzzle.correctWord ||
        oldWidget.stageNumber != widget.stageNumber) {
      setState(() {
        _initPuzzle();
        _shakeCtrl.reset();
        _bounceCtrl.reset();
      });
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  // ── Logika pilih huruf (berdasarkan INDEX pool, bukan nilai) ─
  void _pickLetter(int poolIndex) {
    if (_isChecked) return;

    // Cari slot kosong pertama
    final slotIndex = _slots.indexWhere((s) => s == null);
    if (slotIndex == -1) return; // semua slot sudah terisi

    setState(() {
      // Simpan poolIndex sebagai marker di slot (kita track pakai list terpisah)
      // Tapi kita simpan hurufnya, dan tandai pool[poolIndex] sebagai 'used'
      _slots[slotIndex] = _pool[poolIndex];
      _pool[poolIndex] = ''; // tandai sudah dipakai (empty string)
    });
  }

  void _removeSlot(int slotIndex) {
    if (_isChecked) return;
    final letter = _slots[slotIndex];
    if (letter == null || letter.isEmpty) return;

    setState(() {
      // Kembalikan huruf ke pool (cari slot '' pertama)
      final emptyPoolIdx = _pool.indexWhere((c) => c.isEmpty);
      if (emptyPoolIdx != -1) {
        _pool[emptyPoolIdx] = letter;
      } else {
        _pool.add(letter);
      }
      _slots[slotIndex] = null;
    });
  }

  void _clearAll() {
    if (_isChecked) return;
    setState(() {
      // Kembalikan semua huruf dari slot ke pool
      for (int i = 0; i < _slots.length; i++) {
        if (_slots[i] != null && _slots[i]!.isNotEmpty) {
          final emptyPoolIdx = _pool.indexWhere((c) => c.isEmpty);
          if (emptyPoolIdx != -1) {
            _pool[emptyPoolIdx] = _slots[i]!;
          }
          _slots[i] = null;
        }
      }
    });
  }

  bool get _isFull => _slots.every((s) => s != null && s.isNotEmpty);

  String get _currentAnswer =>
      _slots.map((s) => s ?? '').join('');

  void _checkAnswer() {
    if (!_isFull || _isChecked) return;

    final correct = _currentAnswer == widget.puzzle.correctWord;
    setState(() {
      _isChecked = true;
      _isCorrect = correct;
    });

    if (correct) {
      _bounceCtrl.forward(from: 0);
    } else {
      _shakeCtrl.forward(from: 0);
    }

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        widget.onComplete(poin: correct ? 10 : 0, correct: correct ? 1 : 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = widget.puzzle;
    final word = puzzle.correctWord;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          // ── Gambar + hint ─────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    puzzle.imageAsset,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 170,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryPale,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image_rounded,
                              size: 52, color: AppColors.primary),
                          const SizedBox(height: 6),
                          Text(
                            puzzle.imageHint,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Gambar di atas adalah?',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded,
                                size: 12, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(
                              puzzle.clue,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Slot jawaban (per huruf) ───────────────────────
          AnimatedBuilder(
            animation: _shakeCtrl,
            builder: (_, child) => Transform.translate(
              offset: Offset(_isCorrect == false ? _shakeAnim.value : 0, 0),
              child: child,
            ),
            child: AnimatedBuilder(
              animation: _bounceCtrl,
              builder: (_, child) => Transform.scale(
                scale: _isCorrect == true
                    ? 1.0 + (_bounceAnim.value * 0.04)
                    : 1.0,
                child: child,
              ),
              child: _buildSlots(word),
            ),
          ),

          const SizedBox(height: 16),

          // ── Pool huruf ────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih huruf:',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!_isChecked)
                      GestureDetector(
                        onTap: _clearAll,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.dangerLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.refresh_rounded,
                                  size: 12, color: AppColors.danger),
                              const SizedBox(width: 4),
                              Text(
                                'Reset',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_pool.length, (i) {
                    final letter = _pool[i];
                    final used = letter.isEmpty;
                    return GestureDetector(
                      onTap: used || _isChecked
                          ? null
                          : () => _pickLetter(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: used
                              ? AppColors.inputBg
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: used
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: Text(
                            used ? '' : letter,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: used
                                  ? Colors.transparent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Feedback bar ──────────────────────────────────
          if (_isChecked) _buildFeedback(),

          const SizedBox(height: 14),

          // ── Tombol cek ────────────────────────────────────
          if (!_isChecked)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isFull ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.inputBg,
                  disabledForegroundColor: AppColors.textLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Cek Jawaban',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlots(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isChecked == false
              ? AppColors.divider
              : _isCorrect == true
                  ? AppColors.success.withOpacity(0.5)
                  : AppColors.danger.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (_isCorrect == true
                    ? AppColors.success
                    : _isCorrect == false
                        ? AppColors.danger
                        : AppColors.primary)
                .withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Susun jawabanmu:',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: List.generate(word.length, (i) {
              final letter = _slots[i];
              final filled = letter != null && letter.isNotEmpty;

              Color slotColor = AppColors.inputBg;
              Color borderColor = AppColors.divider;
              Color textColor = AppColors.textPrimary;

              if (_isChecked && filled) {
                final correct = letter == word[i];
                slotColor = correct
                    ? AppColors.successLight
                    : AppColors.dangerLight;
                borderColor =
                    correct ? AppColors.success : AppColors.danger;
                textColor =
                    correct ? AppColors.success : AppColors.danger;
              } else if (filled) {
                slotColor = AppColors.primaryPale;
                borderColor = AppColors.primary;
                textColor = AppColors.primary;
              }

              return GestureDetector(
                onTap: filled && !_isChecked ? () => _removeSlot(i) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 38,
                  height: 44,
                  decoration: BoxDecoration(
                    color: slotColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      filled ? letter! : '',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    final correct = _isCorrect == true;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: correct ? AppColors.successLight : AppColors.dangerLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: correct
              ? AppColors.success.withOpacity(0.4)
              : AppColors.danger.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: correct ? AppColors.success : AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correct ? 'Benar! +10 Poin 🎉' : 'Kurang tepat 😔',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: correct ? AppColors.success : AppColors.danger,
                  ),
                ),
                if (!correct)
                  Text(
                    'Jawaban: ${widget.puzzle.correctWord}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.danger,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
