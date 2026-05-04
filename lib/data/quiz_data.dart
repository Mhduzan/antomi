import '../models/quiz_question.dart';

final Map<int, List<QuizQuestion>> quizData = {
  1: [
    QuizQuestion(
      question: 'Apa nama tulang paha?',
      options: ['Humerus', 'Femur', 'Tibia', 'Fibula'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Organ manakah yang berfungsi memompa darah?',
      options: ['Paru-paru', 'Hati', 'Jantung', 'Ginjal'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Apa nama bagian otak terbesar?',
      options: ['Serebelum', 'Serebrum', 'Brainstem', 'Hipotalamus'],
      correctAnswerIndex: 1,
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