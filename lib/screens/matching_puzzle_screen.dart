// lib/screens/matching_puzzle_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_puzzle.dart';
import '../utils/colors.dart';

class MatchingPuzzleScreen extends StatefulWidget {
  final MatchingPuzzle puzzle;
  final int stageNumber;
  final void Function({required int poin, required int correct}) onComplete;

  const MatchingPuzzleScreen({
    super.key,
    required this.puzzle,
    required this.stageNumber,
    required this.onComplete,
  });

  @override
  State<MatchingPuzzleScreen> createState() => _MatchingPuzzleScreenState();
}

class _MatchingPuzzleScreenState extends State<MatchingPuzzleScreen>
    with TickerProviderStateMixin {

  // ── State matching ────────────────────────────────────────
  late List<MatchItem> _items;           // soal kiri (urutan tetap)
  late List<String> _answerPool;         // jawaban kanan (diacak)
  late Map<String, String?> _userAnswer; // id soal → jawaban yg dipilih user
  String? _draggingAnswer;               // jawaban yg sedang di-drag

  bool _isChecked = false;
  Map<String, bool> _resultMap = {};     // id soal → benar/salah

  // ── Timer ─────────────────────────────────────────────────
  static const int _initialSeconds = 60;
  int _secondsLeft = _initialSeconds;
  Timer? _timer;
  bool _timeUp = false;

  // ── Combo ─────────────────────────────────────────────────
  int _combo = 0;
  int _poin = 0;

  // ── Animasi ───────────────────────────────────────────────
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _initPuzzle();
    _startTimer();

    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  void _initPuzzle() {
    _items = widget.puzzle.items;
    _answerPool = _items.map((e) => e.match).toList()..shuffle();
    _userAnswer = {for (final item in _items) item.id: null};
    _isChecked = false;
    _resultMap = {};
    _timeUp = false;
    _combo = 0;
    _poin = 0;
  }

  // PENTING: reset saat puzzle berubah (stage baru)
  @override
  void didUpdateWidget(MatchingPuzzleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stageNumber != widget.stageNumber ||
        oldWidget.puzzle.title != widget.puzzle.title) {
      _timer?.cancel();
      setState(() => _initPuzzle());
      _startTimer();
    }
  }

  void _startTimer() {
    _secondsLeft = _initialSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timeUp = true;
          t.cancel();
          _autoCheck();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Assign jawaban ke soal ────────────────────────────────
  void _assignAnswer(String itemId, String answer) {
    if (_isChecked) return;
    setState(() {
      // Cek apakah answer sudah dipakai di soal lain → swap
      final existingItemId = _userAnswer.entries
          .firstWhere(
            (e) => e.value == answer,
            orElse: () => const MapEntry('__none__', null),
          )
          .key;

      if (existingItemId != '__none__') {
        // Swap: kembalikan jawaban lama ke soal yg sebelumnya punya answer
        _userAnswer[existingItemId] = _userAnswer[itemId];
      }
      _userAnswer[itemId] = answer;
    });
  }

  void _removeAnswer(String itemId) {
    if (_isChecked) return;
    setState(() => _userAnswer[itemId] = null);
  }

  bool get _allFilled => _userAnswer.values.every((v) => v != null);

  // ── Cek Jawaban ───────────────────────────────────────────
  void _checkAnswer() {
    if (!_allFilled || _isChecked) return;
    _timer?.cancel();

    int correct = 0;
    final result = <String, bool>{};
    for (final item in _items) {
      final matched = _userAnswer[item.id] == item.match;
      result[item.id] = matched;
      if (matched) correct++;
    }

    // Combo & poin
    int combo = correct == _items.length ? 3 : (correct >= 4 ? 2 : 1);
    int poin = correct * 10 * combo;

    setState(() {
      _isChecked = true;
      _resultMap = result;
      _combo = combo;
      _poin = poin;
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        widget.onComplete(poin: poin, correct: correct);
      }
    });
  }

  void _autoCheck() {
    if (_isChecked) return;
    // Isi slot kosong dengan null → langsung cek
    int correct = 0;
    final result = <String, bool>{};
    for (final item in _items) {
      final matched = _userAnswer[item.id] == item.match;
      result[item.id] = matched;
      if (matched) correct++;
    }
    setState(() {
      _isChecked = true;
      _resultMap = result;
      _combo = 1;
      _poin = correct * 10;
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onComplete(poin: _poin, correct: correct);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          // ── Info bar: Timer + Poin + Combo ────────────────
          _buildInfoBar(),

          const SizedBox(height: 12),

          // ── Judul & instruksi ─────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.puzzle.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.puzzle.instruction,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Area matching ─────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom kiri: soal + slot drop
              Expanded(
                flex: 5,
                child: Column(
                  children: _items.map((item) {
                    final ans = _userAnswer[item.id];
                    final checked = _isChecked;
                    final correct = checked ? (_resultMap[item.id] ?? false) : null;

                    return _buildDropSlot(
                      item: item,
                      droppedAnswer: ans,
                      isCorrect: correct,
                      onDrop: (answer) => _assignAnswer(item.id, answer),
                      onRemove: () => _removeAnswer(item.id),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(width: 10),

              // Kolom kanan: pool jawaban (drag source)
              Expanded(
                flex: 5,
                child: Column(
                  children: _answerPool.map((ans) {
                    // Sudah dipakai?
                    final used = _userAnswer.values.contains(ans);
                    return _buildDragChip(ans, used);
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Pembahasan (setelah dicek) ─────────────────────
          if (_isChecked) _buildPembahasan(),

          const SizedBox(height: 14),

          // ── Tombol Cek ────────────────────────────────────
          if (!_isChecked)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _allFilled ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.inputBg,
                  disabledForegroundColor: AppColors.textLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'CEK JAWABAN',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

          // ── Tombol Lanjut / Coba Lagi setelah dicek ───────
          if (_isChecked) _buildResultButtons(),
        ],
      ),
    );
  }

  // ── Widgets ───────────────────────────────────────────────

  Widget _buildInfoBar() {
    final timerColor = _secondsLeft <= 10
        ? AppColors.danger
        : _secondsLeft <= 30
            ? AppColors.warning
            : AppColors.primary;

    return Row(
      children: [
        // Timer
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: timerColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Transform.scale(
                    scale: _secondsLeft <= 10 ? _pulseAnim.value : 1.0,
                    child: Icon(Icons.timer_rounded,
                        color: timerColor, size: 18),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: timerColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Poin
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars_rounded,
                    color: AppColors.warning, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$_poin',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Combo
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.danger.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    color: AppColors.danger, size: 18),
                const SizedBox(width: 6),
                Text(
                  'x$_combo',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.danger,
                  ),
                ),
                Text(
                  ' COMBO',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropSlot({
    required MatchItem item,
    required String? droppedAnswer,
    required bool? isCorrect,
    required void Function(String) onDrop,
    required VoidCallback onRemove,
  }) {
    Color borderColor = AppColors.divider;
    Color bgColor = Colors.white;
    Color chipColor = AppColors.primary;
    IconData? statusIcon;

    if (isCorrect != null) {
      borderColor = isCorrect ? AppColors.success : AppColors.danger;
      bgColor = isCorrect ? AppColors.successLight : AppColors.dangerLight;
      chipColor = isCorrect ? AppColors.success : AppColors.danger;
      statusIcon = isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
    } else if (droppedAnswer != null) {
      borderColor = AppColors.primary.withOpacity(0.4);
      bgColor = AppColors.primaryPale;
    }

    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => !_isChecked,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: hovering ? AppColors.primaryPale : bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hovering ? AppColors.primary : borderColor,
              width: hovering ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              // ── Gambar kecil (thumbnail) di kiri ──────────
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.imageAsset,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ── Label nama soal ────────────────────────────
              Expanded(
                flex: 3,
                child: Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // ── Slot drop jawaban ──────────────────────────
              Expanded(
                flex: 4,
                child: droppedAnswer != null
                    ? GestureDetector(
                        onTap: _isChecked ? null : onRemove,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: chipColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: chipColor.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  droppedAnswer,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: chipColor,
                                  ),
                                ),
                              ),
                              if (statusIcon != null)
                                Icon(statusIcon, size: 14, color: chipColor),
                              if (statusIcon == null && !_isChecked)
                                Icon(Icons.close_rounded,
                                    size: 12,
                                    color: chipColor.withOpacity(0.6)),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: hovering
                              ? AppColors.primary.withOpacity(0.08)
                              : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hovering
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            hovering ? 'Lepaskan!' : '← Tarik ke sini',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: hovering
                                  ? AppColors.primary
                                  : AppColors.textLight,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragChip(String answer, bool used) {
    return Draggable<String>(
      data: answer,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _chipContainer(answer, used),
      ),
      child: GestureDetector(
        // Tap juga bisa assign ke slot kosong pertama
        onTap: _isChecked || used
            ? null
            : () {
                final emptyId = _userAnswer.entries
                    .firstWhere(
                      (e) => e.value == null,
                      orElse: () => const MapEntry('__none__', null),
                    )
                    .key;
                if (emptyId != '__none__') _assignAnswer(emptyId, answer);
              },
        child: _chipContainer(answer, used),
      ),
    );
  }

  Widget _chipContainer(String answer, bool used) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: used ? AppColors.inputBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: used ? AppColors.divider : AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: used
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          if (!used)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(Icons.drag_indicator_rounded,
                  size: 14, color: AppColors.primary.withOpacity(0.5)),
            ),
          Expanded(
            child: Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: used ? FontWeight.w400 : FontWeight.w600,
                color: used ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPembahasan() {
    final correctCount =
        _resultMap.values.where((v) => v).length;
    final allCorrect = correctCount == _items.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: allCorrect ? AppColors.successLight : AppColors.primaryPale,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: allCorrect
              ? AppColors.success.withOpacity(0.4)
              : AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                allCorrect
                    ? Icons.emoji_events_rounded
                    : Icons.lightbulb_rounded,
                color: allCorrect ? AppColors.success : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                allCorrect
                    ? 'Semua Benar! +$_poin Poin (x$_combo Combo) 🎉'
                    : '$correctCount/${_items.length} Benar · +$_poin Poin',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: allCorrect ? AppColors.success : AppColors.primary,
                ),
              ),
            ],
          ),
          if (widget.puzzle.pembahasan.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 6),
            Text(
              '📖 Pembahasan:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.puzzle.pembahasan,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultButtons() {
    final correctCount = _resultMap.values.where((v) => v).length;
    final allCorrect = correctCount == _items.length;

    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => widget.onComplete(
              poin: _poin,
              correct: correctCount,
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: Text(allCorrect ? 'Lanjut' : 'Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  allCorrect ? AppColors.success : AppColors.danger,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              textStyle:
                  GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
