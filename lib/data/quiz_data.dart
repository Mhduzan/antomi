import '../models/quiz_question.dart';

final Map<int, List<QuizQuestion>> quizData = {
  1: [
    QuizQuestion(
      question: 'Otot lengan atas yang berfungsi untuk menekuk siku adalah...',
      imageAsset: 'assets/1 bicepss.PNG',
      options: ['Triceps Brachii', 'Biceps Brachii', 'Deltoid', 'Pectoralis Major'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang paha terpanjang pada tubuh manusia disebut...',
      imageAsset: 'assets/2 femur.PNG',
      options: ['Tibia', 'Fibula', 'Femur', 'Humerus'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Sendi yang memungkinkan gerakan ke segala arah (rotasi) adalah...',
      imageAsset: 'assets/3 sendi peluru.PNG',
      options: ['Sendi Engsel', 'Sendi Peluru', 'Sendi Putar', 'Sendi Geser'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Otot betis yang berperan dalam gerakan berjalan dan melompat adalah...',
      imageAsset: 'assets/4 gasstrocnemius.PNG',
      options: ['Soleus', 'Gastrocnemius', 'Tibialis Anterior', 'Quadriceps'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang lengan atas yang terhubung dengan bahu dan siku disebut...',
      imageAsset: 'assets/5 humerus.PNG',
      options: ['Radius', 'Ulna', 'Humerus', 'Klavikula'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot dada besar yang berfungsi untuk menarik lengan ke depan adalah...',
      imageAsset: 'assets/6 pectroalis major.PNG',
      options: ['Latissimus Dorsi', 'Pectoralis Major', 'Deltoid', 'Trapezius'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang rusuk yang melindungi jantung dan paru-paru disebut...',
      imageAsset: 'assets/7 costa.PNG',
      options: ['Sternum', 'Klavikula', 'Costa (Tulang Rusuk)', 'Skapula'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Sendi yang hanya memungkinkan gerakan seperti engsel pintu adalah...',
      imageAsset: 'assets/sendi_engsel.png',
      options: ['Sendi Peluru', 'Sendi Putar', 'Sendi Engsel', 'Sendi Luncur'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot perut yang membentuk six-pack adalah...',
      imageAsset: 'assets/9 rectis abdominis.PNG',
      options: ['Oblikus Eksternal', 'Rectus Abdominis', 'Transversus Abdominis', 'Diafragma'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Sendi yang memungkinkan gerakan memutar kepala adalah...',
      imageAsset: 'assets/10 sendi putar.PNG',
      options: ['Sendi Peluru', 'Sendi Engsel', 'Sendi Putar', 'Sendi Geser'],
      correctAnswerIndex: 2,
    ),
  ],
  2: [
    QuizQuestion(
      question: 'Apa nama tulang belikat?',
      options: ['Klavikula', 'Skapula', 'Sternum', 'Koksiks'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Organ apa yang menghasilkan insulin?',
      options: ['Lambung', 'Hati', 'Pankreas', 'Limpa'],
      correctAnswerIndex: 2,
    ),
  ],
  3: [
    QuizQuestion(
      question: 'Apa nama sendi yang memungkinkan gerakan rotasi?',
      options: ['Engsel', 'Peluru', 'Putar', 'Luncur'],
      correctAnswerIndex: 2,
    ),
  ],
};