// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../utils/storage_helper.dart';
import '../data/game_data.dart';
import 'game_session_screen.dart';
import '../models/game_puzzle.dart';
import 'word_puzzle_screen.dart';
import 'matching_puzzle_screen.dart';

class GameScreen extends StatefulWidget {
  final GameSession session;
  const GameScreen({super.key, required this.session});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final List<GameStage> _stages;
  int _currentStage = 0;
  int _totalScore = 0;   // jumlah jawaban benar
  int _totalPoin = 0;    // poin yang dikumpulkan
  bool _gameFinished = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _stages = widget.session.stages;

    _fadeCtrl = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onStageComplete({required int poin, required int correct}) {
    setState(() {
      _totalPoin += poin;
      _totalScore += correct;
    });

    if (_currentStage + 1 < _stages.length) {
      _fadeCtrl.reverse().then((_) {
        setState(() => _currentStage++);
        _fadeCtrl.forward();
      });
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    final storage = StorageHelper();
    final existing = await storage.getTotalPoin();
    await storage.saveTotalPoin(existing + _totalPoin);
    if (mounted) setState(() => _gameFinished = true);
  }

  @override
  Widget build(BuildContext context) {
      final r = R.of(context);
    if (_gameFinished) return _buildResultScreen();

    final stage = _stages[_currentStage];
    final totalStages = _stages.length;
    // Label dari session
    final stageLabel = '${widget.session.title} · ${_currentStage + 1}/${_stages.length}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header global ──────────────────────────────────
          _buildHeader(stageLabel, totalStages),

          // ── Konten stage (fade transition) ─────────────────
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              // ValueKey(stage+index) memaksa Flutter DESTROY & REBUILD
              // widget dari nol setiap ganti soal → tidak ada state sisa
              child: stage.type == PuzzleType.wordGuess
                  ? WordPuzzleScreen(
                      key: ValueKey('word_$_currentStage'),
                      puzzle: stage.wordPuzzle!,
                      stageNumber: _currentStage + 1,
                      onComplete: _onStageComplete,
                    )
                  : MatchingPuzzleScreen(
                      key: ValueKey('match_$_currentStage'),
                      puzzle: stage.matchingPuzzle!,
                      stageNumber: _currentStage + 1,
                      onComplete: _onStageComplete,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String stageLabel, int totalStages) {
    final progress = (_currentStage + 1) / totalStages;
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
          child: Column(
            children: [
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
                        stageLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Poin badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          '$_totalPoin',
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
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  color: Colors.white,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stage ${_currentStage + 1} dari $totalStages',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.white.withOpacity(0.8)),
                  ),
                  Text(
                    'Benar: $_totalScore',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final totalStages = _stages.length;
    final pct = (_totalScore / totalStages * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Trophy
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.warningLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events_rounded,
                    size: 56, color: AppColors.warning),
              ),
              const SizedBox(height: 20),
              Text(
                'Game Selesai!',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_totalScore / $totalStages Benar',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Stat cards
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                        '$_totalPoin', 'Total Poin', AppColors.warning),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard('$pct%', 'Akurasi', AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard('$totalStages', 'Stage', AppColors.success),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Kembali ke menu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Kembali ke Menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStage = 0;
                      _totalScore = 0;
                      _totalPoin = 0;
                      _gameFinished = false;
                    });
                    _fadeCtrl.forward(from: 0);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Main Lagi'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
