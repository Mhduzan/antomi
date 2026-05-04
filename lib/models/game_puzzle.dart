class GamePuzzle {
  final String imageAsset;        // Path gambar dari assets
  final String imageHint;         // Petunjuk gambar
  final String correctWord;       // Kata yang benar
  final String cluePattern;       // Pola clue (contoh: TU--G K-P-LA)
  final List<String> availableLetters; // Huruf yang tersedia (6-8 huruf)
  final String clue;              // Petunjuk tambahan

  GamePuzzle({
    required this.imageAsset,
    required this.imageHint,
    required this.correctWord,
    required this.cluePattern,
    required this.availableLetters,
    required this.clue,
  });
}