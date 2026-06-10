// lib/data/quiz_data.dart
import '../models/quiz_question.dart';

// Jawaban benar selalu index 0 sebelum diacak.
// correctAnswerIndex dihitung dari posisi jawaban benar dalam list options di bawah.

final Map<int, List<QuizQuestion>> quizData = {

  // ══════════════════════════════════════════════════════════════
  // LEVEL 1 — Identifikasi nama otot, tulang, dan sendi (10 soal)
  // ══════════════════════════════════════════════════════════════
  1: [
    QuizQuestion(
      question: 'Nama otot pada gambar di bawah ini adalah?',
      options: ['Biceps brachii', 'Triceps brachii', 'Deltoid', 'Pectoralis major'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_biceps.png',
    ),
    QuizQuestion(
      question: 'Tulang pada gambar di bawah ini disebut?',
      options: ['Femur', 'Tibia', 'Ulna', 'Radius'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_femur.png',
    ),
    QuizQuestion(
      question: 'Jenis sendi pada gambar di bawah ini adalah?',
      options: ['Sendi peluru', 'Sendi engsel', 'Sendi putar', 'Sendi geser'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_peluru.png',
    ),
    QuizQuestion(
      question: 'Otot pada gambar di bawah ini adalah?',
      options: ['Gastrocnemius', 'Quadriceps', 'Deltoid', 'Trapezius'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_gastrocnemius.png',
    ),
    QuizQuestion(
      question: 'Nama tulang pada gambar di bawah ini adalah?',
      options: ['Humerus', 'Femur', 'Fibula', 'Scapula'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_humerus.png',
    ),
    QuizQuestion(
      question: 'Nama otot pada gambar di bawah ini adalah?',
      options: ['Pectoralis major', 'Deltoid', 'Rectus abdominis', 'Latissimus dorsi'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_pectoralis.png',
    ),
    QuizQuestion(
      question: 'Tulang pada gambar di bawah ini disebut?',
      options: ['Costa (tulang rusuk)', 'Sternum', 'Scapula', 'Clavicula'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_costa.png',
    ),
    QuizQuestion(
      question: 'Jenis sendi pada gambar di bawah ini adalah?',
      options: ['Sendi engsel', 'Sendi peluru', 'Sendi putar', 'Sendi geser'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_engsel.png',
    ),
    QuizQuestion(
      question: 'Nama otot pada gambar di bawah ini adalah?',
      options: ['Rectus abdominis', 'Obliquus externus', 'Erector spinae', 'Sartorius'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_rectus_abd.png',
    ),
    QuizQuestion(
      question: 'Jenis sendi pada gambar di bawah ini adalah?',
      options: ['Sendi putar', 'Sendi engsel', 'Sendi peluru', 'Sendi geser'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_putar.png',
    ),
  ],

  // ══════════════════════════════════════════════════════════════
  // LEVEL 2 — Fungsi otot, tulang, dan sendi (20 soal)
  // ══════════════════════════════════════════════════════════════
  2: [
    QuizQuestion(
      question: 'Otot pada gambar di bawah ini berfungsi untuk...',
      options: ['Fleksi siku', 'Ekstensi siku', 'Abduksi bahu', 'Rotasi lengan'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_biceps.png',
    ),
    QuizQuestion(
      question: 'Tulang ulna berfungsi untuk...',
      options: [
        'Menstabilkan dan membantu gerakan lengan bawah',
        'Menopang tubuh bagian atas',
        'Membentuk sendi lutut',
        'Melindungi otak',
      ],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Sendi engsel pada lutut memungkinkan gerakan...',
      options: ['Fleksi dan ekstensi', 'Rotasi', 'Gerak ke segala arah', 'Gerak menggeser'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_engsel.png',
    ),
    QuizQuestion(
      question: 'Otot pada gambar berfungsi untuk...',
      options: ['Ekstensi lutut', 'Fleksi batang tubuh', 'Elevasi bahu', 'Rotasi leher'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_quadriceps.png',
    ),
    QuizQuestion(
      question: 'Fungsi utama tulang rusuk adalah...',
      options: [
        'Melindungi organ vital di rongga dada',
        'Menopang tungkai bawah',
        'Menggerakkan lengan atas',
        'Menyimpan mineral kalsium saja',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_costa.png',
    ),
    QuizQuestion(
      question: 'Otot gastrocnemius berfungsi untuk...',
      options: [
        'Plantarfleksi pergelangan kaki',
        'Fleksi lutut',
        'Ekstensi bahu',
        'Rotasi pergelangan kaki',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_gastrocnemius.png',
    ),
    QuizQuestion(
      question: 'Tulang femur berfungsi untuk...',
      options: [
        'Menopang berat badan dan membantu proses locomotion',
        'Melindungi otak',
        'Membentuk rongga dada',
        'Menyaring darah',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_femur.png',
    ),
    QuizQuestion(
      question: 'Sendi peluru pada bahu memungkinkan...',
      options: [
        'Gerakan multiaksial ke segala arah',
        'Gerakan satu arah',
        'Gerakan rotasi terbatas',
        'Gerakan menggeser',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_peluru.png',
    ),
    QuizQuestion(
      question: 'Otot quadriceps femoris berfungsi untuk...',
      options: ['Ekstensi lutut', 'Fleksi lutut', 'Elevasi bahu', 'Rotasi panggul'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_quadriceps.png',
    ),
    QuizQuestion(
      question: 'Tulang vertebrae berfungsi untuk...',
      options: [
        'Menopang tubuh dan melindungi medula spinalis',
        'Menggerakkan pergelangan tangan',
        'Membentuk sendi lutut',
        'Menyimpan energi',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_vertebrae.png',
    ),
    QuizQuestion(
      question: 'Otot deltoid berfungsi untuk...',
      options: ['Abduksi lengan', 'Fleksi jari', 'Fleksi paha', 'Ekstensi pergelangan kaki'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_deltoid.png',
    ),
    QuizQuestion(
      question: 'Tulang tibia berfungsi untuk...',
      options: [
        'Menopang berat badan dan membentuk sendi lutut',
        'Menopang lengan bawah',
        'Melindungi jantung',
        'Membentuk sendi bahu',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_tibia.png',
    ),
    QuizQuestion(
      question: 'Sendi putar pada leher memungkinkan gerakan...',
      options: ['Rotasi kepala', 'Gerak ke segala arah', 'Fleksi dan ekstensi', 'Gerakan menggeser'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_putar.png',
    ),
    QuizQuestion(
      question: 'Otot latissimus dorsi berfungsi untuk...',
      options: [
        'Adduksi lengan ke arah tubuh',
        'Elevasi bahu',
        'Ekstensi lutut',
        'Fleksi jari',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_latissimus.png',
    ),
    QuizQuestion(
      question: 'Fungsi utama sendi geser adalah...',
      options: [
        'Memungkinkan tulang bergeser secara terbatas',
        'Memungkinkan rotasi',
        'Memungkinkan gerak multiaksial',
        'Memungkinkan gerakan satu arah',
      ],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Otot hamstring berfungsi untuk...',
      options: ['Fleksi lutut', 'Ekstensi lutut', 'Elevasi bahu', 'Rotasi pinggul'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_hamstring.png',
    ),
    QuizQuestion(
      question: 'Tulang scapula berfungsi untuk...',
      options: [
        'Tempat perlekatan otot dan pembentuk sendi bahu',
        'Membentuk sendi lutut',
        'Menopang tungkai bawah',
        'Melindungi otak',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_scapula.png',
    ),
    QuizQuestion(
      question: 'Sendi engsel pada siku memungkinkan gerakan...',
      options: ['Fleksi dan ekstensi', 'Rotasi', 'Gerak multiaksial', 'Gerakan menggeser'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_sendi_siku.png',
    ),
    QuizQuestion(
      question: 'Otot pectoralis major berfungsi untuk...',
      options: [
        'Fleksi dan adduksi lengan',
        'Fleksi lutut',
        'Rotasi kepala',
        'Retraksi lengan',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_pectoralis.png',
    ),
    QuizQuestion(
      question: 'Tulang tengkorak (cranium) berfungsi untuk...',
      options: [
        'Melindungi otak dan sistem saraf pusat',
        'Menopang tubuh bagian bawah',
        'Membentuk sendi lutut',
        'Menggerakkan lengan',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_cranium.png',
    ),
  ],

  // ══════════════════════════════════════════════════════════════
  // LEVEL 3 — Analisis gerakan, cedera, dan olahraga (30 soal)
  // ══════════════════════════════════════════════════════════════
  3: [
    QuizQuestion(
      question: 'Seorang atlet melakukan squat. Otot utama yang bekerja saat fase naik adalah...',
      options: ['Quadriceps femoris', 'Hamstring', 'Gastrocnemius', 'Deltoid'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q3_squat.png',
    ),
    QuizQuestion(
      question: 'Cedera ACL paling sering terjadi pada olahraga yang melibatkan...',
      options: [
        'Gerakan rotasi dan perubahan arah mendadak',
        'Gerakan pernapasan',
        'Gerakan mengangkat bahu',
        'Gerakan fleksi pergelangan tangan',
      ],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Saat push-up, otot utama yang paling dominan bekerja adalah...',
      options: ['Pectoralis major', 'Latissimus dorsi', 'Hamstring', 'Tibialis anterior'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q3_pushup.png',
    ),
    QuizQuestion(
      question: 'Cedera ankle sprain umumnya terjadi akibat...',
      options: [
        'Inversi berlebihan pada pergelangan kaki',
        'Hiperekstensi siku',
        'Rotasi bahu',
        'Fleksi lutut berlebihan',
      ],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q3_ankle.png',
    ),
    QuizQuestion(
      question: 'Gerakan menendang bola dalam sepak bola melibatkan kontraksi dominan otot...',
      options: ['Quadriceps femoris', 'Deltoid', 'Trapezius', 'Biceps brachii'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Jika atlet kesulitan plantarfleksi kaki, otot yang kemungkinan terganggu adalah...',
      options: ['Gastrocnemius', 'Deltoid', 'Rectus abdominis', 'Triceps brachii'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan abduksi lengan saat jumping jack terutama melibatkan otot...',
      options: ['Deltoid', 'Hamstring', 'Gastrocnemius', 'Sartorius'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q3_jumpjack.png',
    ),
    QuizQuestion(
      question: 'Cedera dislokasi bahu paling sering terjadi pada sendi...',
      options: ['Peluru', 'Engsel', 'Geser', 'Putar'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Saat melakukan sit-up, otot utama yang bekerja adalah...',
      options: ['Rectus abdominis', 'Latissimus dorsi', 'Gastrocnemius', 'Trapezius'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q3_situp.png',
    ),
    QuizQuestion(
      question: 'Gerakan sprint sangat bergantung pada kekuatan otot...',
      options: ['Quadriceps dan hamstring', 'Deltoid dan trapezius', 'Biceps dan triceps', 'Pectoralis dan latissimus dorsi'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Cedera hamstring paling sering terjadi pada olahraga yang membutuhkan...',
      options: ['Gerakan eksplosif dan sprint', 'Gerakan statis', 'Gerakan pernapasan', 'Gerakan memutar kepala'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Pada gerakan pull-up, otot utama yang dominan bekerja adalah...',
      options: ['Latissimus dorsi', 'Quadriceps', 'Tibialis anterior', 'Deltoid anterior'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q3_pullup.png',
    ),
    QuizQuestion(
      question: 'Gerakan ekstensi lutut terutama dilakukan oleh otot...',
      options: ['Quadriceps femoris', 'Hamstring', 'Gastrocnemius', 'Sartorius'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Jika atlet mengalami cedera rotator cuff, gerakan yang paling terganggu adalah...',
      options: ['Gerakan bahu', 'Gerakan lutut', 'Gerakan pergelangan kaki', 'Gerakan leher'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan berjinjit pada atlet basket terutama menggunakan kontraksi otot...',
      options: ['Gastrocnemius', 'Deltoid', 'Biceps brachii', 'Rectus abdominis'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Sendi yang memungkinkan gerakan multiaksial pada tubuh manusia adalah...',
      options: ['Sendi peluru', 'Sendi engsel', 'Sendi putar', 'Sendi geser'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Cedera shin splints umumnya terjadi pada bagian...',
      options: ['Tibia', 'Humerus', 'Radius', 'Clavicula'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan melempar bola melibatkan koordinasi utama antara otot...',
      options: ['Deltoid dan triceps brachii', 'Hamstring dan quadriceps', 'Gastrocnemius dan soleus', 'Sartorius dan tibialis anterior'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Pada gerakan deadlift, otot yang dominan bekerja adalah...',
      options: ['Erector spinae dan hamstring', 'Deltoid dan biceps', 'Trapezius dan sternocleidomastoid', 'Gastrocnemius dan soleus'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Cedera meniskus pada lutut sering disebabkan oleh...',
      options: ['Gerakan rotasi lutut yang tiba-tiba', 'Gerakan fleksi siku', 'Gerakan memutar kepala', 'Gerakan ekstensi bahu'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan servis pada bola voli dominan menggunakan otot...',
      options: ['Deltoid dan pectoralis major', 'Hamstring dan quadriceps', 'Gastrocnemius dan soleus', 'Tibialis anterior dan sartorius'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Fungsi utama tulang belakang saat aktivitas olahraga adalah...',
      options: ['Menopang tubuh dan menjaga stabilitas postur', 'Menghasilkan energi', 'Menggerakkan jari', 'Menyimpan oksigen'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan fleksi siku pada biceps curl melibatkan otot...',
      options: ['Biceps brachii', 'Triceps brachii', 'Deltoid', 'Latissimus dorsi'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q2_biceps.png',
    ),
    QuizQuestion(
      question: 'Cedera tennis elbow terjadi akibat gangguan pada...',
      options: ['Tendon siku', 'Pergelangan kaki', 'Sendi bahu', 'Sendi lutut'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Pada gerakan plank, otot yang paling berperan menjaga stabilitas tubuh adalah...',
      options: ['Rectus abdominis dan core muscles', 'Deltoid dan trapezius', 'Quadriceps dan hamstring', 'Gastrocnemius dan soleus'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan adduksi lengan mendekati tubuh terutama dilakukan oleh otot...',
      options: ['Latissimus dorsi', 'Tibialis anterior', 'Gastrocnemius', 'Sartorius'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Cedera yang terjadi akibat peregangan otot berlebihan disebut...',
      options: ['Strain', 'Fraktur', 'Dislokasi', 'Sprain'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Saat melakukan jumping, otot yang dominan menghasilkan daya ledak adalah...',
      options: ['Quadriceps dan gastrocnemius', 'Deltoid dan triceps', 'Latissimus dorsi dan trapezius', 'Biceps dan forearm'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
    QuizQuestion(
      question: 'Gerakan rotasi kepala terutama terjadi pada sendi...',
      options: ['Putar', 'Engsel', 'Geser', 'Peluru'],
      correctAnswerIndex: 0,
      imageAsset: 'assets/quiz/q1_sendi_putar.png',
    ),
    QuizQuestion(
      question: 'Cedera sprain berbeda dengan strain karena sprain terjadi pada...',
      options: ['Ligamen', 'Otot', 'Tendon', 'Tulang'],
      correctAnswerIndex: 0,
      imageAsset: '',
    ),
  ],
};
