// lib/models/game_puzzle.dart

enum PuzzleType { wordGuess, matching }

// ── Word Guess (Tebak Gambar) ─────────────────────────────────
class WordPuzzle {
  final String imageAsset;
  final String imageHint;
  final String correctWord;   // huruf besar, e.g. "TENGKORAK"
  final String clue;

  // Digenerate otomatis dari correctWord + extra distractors
  final List<String> extraLetters; // huruf tambahan sebagai pengecoh

  const WordPuzzle({
    required this.imageAsset,
    required this.imageHint,
    required this.correctWord,
    required this.clue,
    this.extraLetters = const [],
  });

  /// Hasilkan pool huruf: semua huruf dari correctWord + extra, lalu acak
  List<String> buildLetterPool() {
    final pool = <String>[];
    // Masukkan SEMUA huruf dari kata yang benar (termasuk duplikat)
    for (final ch in correctWord.split('')) {
      pool.add(ch);
    }
    // Tambah pengecoh
    for (final ch in extraLetters) {
      pool.add(ch);
    }
    pool.shuffle();
    return pool;
  }
}

// ── Matching Puzzle (Cocokkan Pasangan) ──────────────────────
class MatchItem {
  final String id;
  final String label;      // nama otot / nama cedera
  final String match;      // fungsi / penyebab
  final String imageAsset; // gambar kecil di kolom kiri

  const MatchItem({
    required this.id,
    required this.label,
    required this.match,
    required this.imageAsset,
  });
}

class MatchingPuzzle {
  final String title;
  final String instruction;
  final List<MatchItem> items; // 5 pasang
  final String pembahasan;     // teks pembahasan per item (opsional)

  const MatchingPuzzle({
    required this.title,
    required this.instruction,
    required this.items,
    this.pembahasan = '',
  });
}

// ── Gabungan untuk navigasi game ─────────────────────────────
class GameStage {
  final PuzzleType type;
  final WordPuzzle? wordPuzzle;
  final MatchingPuzzle? matchingPuzzle;

  const GameStage.word(this.wordPuzzle)
      : type = PuzzleType.wordGuess,
        matchingPuzzle = null;

  const GameStage.matching(this.matchingPuzzle)
      : type = PuzzleType.matching,
        wordPuzzle = null;
}
