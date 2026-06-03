// lib/data/game_data.dart
import '../models/game_puzzle.dart';

// ═══════════════════════════════════════════════════════════════
//  WORD GUESS — 15 soal tebak gambar (semua huruf benar + extra)
// ═══════════════════════════════════════════════════════════════

const List<WordPuzzle> wordPuzzles = [
  WordPuzzle(
    imageAsset: 'assets/game/kranium.png',
    imageHint: 'Tulang Kepala',
    correctWord: 'KRANIUM',
    clue: 'Melindungi otak',
    extraLetters: ['S', 'T'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/femur.png',
    imageHint: 'Tulang Paha',
    correctWord: 'FEMUR',
    clue: 'Tulang terpanjang tubuh',
    extraLetters: ['D', 'K'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/biceps.png',
    imageHint: 'Otot Lengan Atas',
    correctWord: 'BICEPS',
    clue: 'Membentuk fleksi siku',
    extraLetters: ['T', 'R'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/gastrocnemius.png',
    imageHint: 'Otot Betis',
    correctWord: 'GASTROCNEMIUS',
    clue: 'Membantu berjinjit',
    extraLetters: ['F', 'K'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/sendi_peluru.png',
    imageHint: 'Sendi Bahu',
    correctWord: 'PELURU',
    clue: 'Bisa bergerak ke segala arah',
    extraLetters: ['D', 'N'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/tibia.png',
    imageHint: 'Tulang Kering',
    correctWord: 'TIBIA',
    clue: 'Menopang tungkai bawah',
    extraLetters: ['R', 'S'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/abdomen.png',
    imageHint: 'Otot Perut',
    correctWord: 'ABDOMEN',
    clue: 'Membantu sit-up',
    extraLetters: ['K', 'L'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/sendi_engsel.png',
    imageHint: 'Sendi Lutut',
    correctWord: 'ENGSEL',
    clue: 'Bergerak satu arah',
    extraLetters: ['T', 'R'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/skapula.png',
    imageHint: 'Tulang Belikat',
    correctWord: 'SKAPULA',
    clue: 'Tempat melekat otot bahu',
    extraLetters: ['T', 'N'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/quadriceps.png',
    imageHint: 'Otot Paha Depan',
    correctWord: 'QUADRICEPS',
    clue: 'Meluruskan lutut',
    extraLetters: ['F', 'M'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/vertebra.png',
    imageHint: 'Tulang Belakang',
    correctWord: 'VERTEBRA',
    clue: 'Melindungi sumsum tulang belakang',
    extraLetters: ['S', 'N'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/pektoral.png',
    imageHint: 'Otot Dada',
    correctWord: 'PEKTORAL',
    clue: 'Dominan saat push-up',
    extraLetters: ['S', 'N'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/sendi_putar.png',
    imageHint: 'Sendi Leher',
    correctWord: 'PUTAR',
    clue: 'Membantu menoleh',
    extraLetters: ['D', 'K'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/latissimus.png',
    imageHint: 'Otot Punggung',
    correctWord: 'LATISSIMUS',
    clue: 'Dominan saat pull-up',
    extraLetters: ['F', 'R'],
  ),
  WordPuzzle(
    imageAsset: 'assets/game/sprain.png',
    imageHint: 'Cedera Sendi',
    correctWord: 'SPRAIN',
    clue: 'Keseleo / cedera ligamen',
    extraLetters: ['T', 'D'],
  ),
];

// ═══════════════════════════════════════════════════════════════
//  MATCHING PUZZLE — 3 puzzle dari dokumen
// ═══════════════════════════════════════════════════════════════

const List<MatchingPuzzle> matchingPuzzles = [
  // ── Puzzle 1: Otot ↔ Fungsi ───────────────────────────────
  MatchingPuzzle(
    title: 'Cocokkan Otot dengan Fungsinya!',
    instruction: 'Tarik jawaban yang tepat ke kotak di sebelah kiri.',
    items: [
      MatchItem(
        id: 'mp1_1',
        label: 'Biceps Brachii',
        match: 'Fleksi siku',
        imageAsset: 'assets/game/biceps.png',
      ),
      MatchItem(
        id: 'mp1_2',
        label: 'Quadriceps Femoris',
        match: 'Ekstensi lutut',
        imageAsset: 'assets/game/quadriceps.png',
      ),
      MatchItem(
        id: 'mp1_3',
        label: 'Gastrocnemius',
        match: 'Plantarfleksi kaki',
        imageAsset: 'assets/game/gastrocnemius.png',
      ),
      MatchItem(
        id: 'mp1_4',
        label: 'Deltoid',
        match: 'Abduksi lengan',
        imageAsset: 'assets/game/skapula.png',
      ),
      MatchItem(
        id: 'mp1_5',
        label: 'Rectus Abdominis',
        match: 'Fleksi batang tubuh',
        imageAsset: 'assets/game/abdomen.png',
      ),
    ],
    pembahasan:
        '• Biceps Brachii → Fleksi siku dan membantu gerakan lengan bawah.\n'
        '• Quadriceps Femoris → Ekstensi lutut saat berjalan, berlari, squat.\n'
        '• Gastrocnemius → Plantarfleksi pergelangan kaki (berjinjit).\n'
        '• Deltoid → Abduksi lengan menjauh dari tubuh.\n'
        '• Rectus Abdominis → Fleksi batang tubuh seperti sit-up.',
  ),

  // ── Puzzle 2: Gerakan ↔ Otot Dominan ─────────────────────
  MatchingPuzzle(
    title: 'Cocokkan Gerakan dengan Otot Dominan!',
    instruction: 'Tarik jawaban yang tepat ke kotak di sebelah kiri.',
    items: [
      MatchItem(
        id: 'mp2_1',
        label: 'Squat',
        match: 'Quadriceps femoris',
        imageAsset: 'assets/game/squat.png',
      ),
      MatchItem(
        id: 'mp2_2',
        label: 'Push-up',
        match: 'Pectoralis major',
        imageAsset: 'assets/game/pushup.png',
      ),
      MatchItem(
        id: 'mp2_3',
        label: 'Pull-up',
        match: 'Latissimus dorsi',
        imageAsset: 'assets/game/pullup.png',
      ),
      MatchItem(
        id: 'mp2_4',
        label: 'Sit-up',
        match: 'Rectus abdominis',
        imageAsset: 'assets/game/situp.png',
      ),
      MatchItem(
        id: 'mp2_5',
        label: 'Sprint',
        match: 'Hamstring & quadriceps',
        imageAsset: 'assets/game/sprint.png',
      ),
    ],
    pembahasan:
        '• Squat → Quadriceps femoris dominan untuk ekstensi lutut.\n'
        '• Push-up → Pectoralis major melatih dada dan lengan atas.\n'
        '• Pull-up → Latissimus dorsi melatih punggung.\n'
        '• Sit-up → Rectus abdominis melatih otot inti depan.\n'
        '• Sprint → Hamstring & quadriceps untuk daya ledak paha.',
  ),

  // ── Puzzle 3: Cedera ↔ Penyebab ──────────────────────────
  MatchingPuzzle(
    title: 'Cocokkan Cedera dengan Penyebabnya!',
    instruction: 'Tarik jawaban yang tepat ke kotak di sebelah kiri.',
    items: [
      MatchItem(
        id: 'mp3_1',
        label: 'Sprain',
        match: 'Peregangan ligamen',
        imageAsset: 'assets/game/cedera_sprain.png',
      ),
      MatchItem(
        id: 'mp3_2',
        label: 'Strain',
        match: 'Peregangan otot berlebihan',
        imageAsset: 'assets/game/cedera_strain.png',
      ),
      MatchItem(
        id: 'mp3_3',
        label: 'ACL Injury',
        match: 'Gerakan rotasi mendadak',
        imageAsset: 'assets/game/cedera_acl.png',
      ),
      MatchItem(
        id: 'mp3_4',
        label: 'Shin Splints',
        match: 'Overuse pada tibia',
        imageAsset: 'assets/game/cedera_shin.png',
      ),
      MatchItem(
        id: 'mp3_5',
        label: 'Tennis Elbow',
        match: 'Gangguan tendon siku',
        imageAsset: 'assets/game/cedera_tennis.png',
      ),
    ],
    pembahasan:
        '• Sprain → Peregangan atau robekan ligamen.\n'
        '• Strain → Peregangan atau robekan otot/tendon.\n'
        '• ACL Injury → Perubahan arah mendadak / rotasi lutut.\n'
        '• Shin Splints → Nyeri tibia akibat overuse.\n'
        '• Tennis Elbow → Cedera tendon siku akibat penggunaan berlebihan.',
  ),
];

// ═══════════════════════════════════════════════════════════════
//  URUTAN STAGE GAME (word dulu, lalu matching)
// ═══════════════════════════════════════════════════════════════

List<GameStage> buildGameStages() {
  final stages = <GameStage>[];
  for (final w in wordPuzzles) {
    stages.add(GameStage.word(w));
  }
  for (final m in matchingPuzzles) {
    stages.add(GameStage.matching(m));
  }
  return stages;
}
