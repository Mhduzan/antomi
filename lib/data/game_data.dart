import '../models/game_puzzle.dart';
import 'dart:math';

final random = Random();

List<String> _shuffle(List<String> letters) {
  final shuffled = List<String>.from(letters);
  shuffled.shuffle(random);
  return shuffled;
}

final List<GamePuzzle> gamePuzzles = [
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Tulang Kepala',
    correctWord: 'TENGKORAK',
    cluePattern: '',
    availableLetters: _shuffle(['T', 'E', 'N', 'G', 'K', 'O', 'R', 'A']),
    clue: 'Melindungi otak',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Tulang Punggung',
    correctWord: 'VERTEBRA',
    cluePattern: '',
    availableLetters: _shuffle(['V', 'E', 'R', 'T', 'B', 'A']),
    clue: 'Tersusun dari ruas-ruas tulang',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Organ Pernapasan',
    correctWord: 'PARU',
    cluePattern: '',
    availableLetters: _shuffle(['P', 'A', 'R', 'U']),
    clue: 'Terletak di rongga dada',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Organ Pemompa Darah',
    correctWord: 'JANTUNG',
    cluePattern: '',
    availableLetters: _shuffle(['J', 'A', 'N', 'T', 'U', 'G']),
    clue: 'Berdetak sepanjang hidup',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Pusat Kendali Tubuh',
    correctWord: 'OTAK',
    cluePattern: '',
    availableLetters: _shuffle(['O', 'T', 'A', 'K']),
    clue: 'Tempat berpikir dan mengingat',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Organ Penyaring Darah',
    correctWord: 'GINJAL',
    cluePattern: '',
    availableLetters: _shuffle(['G', 'I', 'N', 'J', 'A', 'L']),
    clue: 'Bentuknya seperti kacang',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Organ Pencernaan',
    correctWord: 'HATI',
    cluePattern: '',
    availableLetters: _shuffle(['H', 'A', 'T', 'I']),
    clue: 'Berwarna kemerahan',
  ),
  GamePuzzle(
    imageAsset: 'assets/Gemini_Generated_Image_smt9pfsmt9pfsmt9.png',
    imageHint: 'Tempat Mencerna Makanan',
    correctWord: 'LAMBUNG',
    cluePattern: '',
    availableLetters: _shuffle(['L', 'A', 'M', 'B', 'U', 'N', 'G']),
    clue: 'Terletak di perut kiri atas',
  ),
];