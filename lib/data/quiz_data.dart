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
      question: 'Otot pada gambar di bawah ini berfungsi untuk....',
      imageAsset: 'assets/otot_lengan.png',
      options: ['Ekstensi siku', 'Fleksi siku', 'Abduksi bahu', 'Rotasi lengan'],
      correctAnswerIndex: 1, // Fleksi siku (Biceps brachii)
    ),
    QuizQuestion(
      question: 'Tulang ulna berfungsi untuk...',
      imageAsset: 'assets/tulang_ulna.png',
      options: ['Menopang tubuh bagian atas', 'Membentuk sendi lutut', 'Menstabilkan dan membantu gerakan lengan bawah', 'Melindungi otak'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Sendi engsel pada lutut memungkinkan gerakan...',
      imageAsset: 'assets/sendi_engsel_lutut.png',
      options: ['Rotasi', 'Gerak ke segala arah', 'Fleksi dan ekstensi', 'Gerak menggeser'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot pada gambar berfungsi untuk...',
      imageAsset: 'assets/otot_paha.png',
      options: ['Ekstensi lutut', 'Fleksi batang tubuh', 'Elevasi bahu', 'Rotasi leher'],
      correctAnswerIndex: 0, // Ekstensi lutut (Quadriceps)
    ),
    QuizQuestion(
      question: 'Fungsi utama tulang rusuk adalah...',
      imageAsset: 'assets/tulang_rusuk.png',
      options: ['Menopang tungkai bawah', 'Melindungi organ vital di rongga dada', 'Menggerakkan lengan atas', 'Menyimpan mineral kalsium saja'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Otot gastrocnemius berfungsi untuk...',
      imageAsset: 'assets/gastrocnemius.png',
      options: ['Fleksi lutut', 'Plantarfleksi pergelangan kaki', 'Ekstensi bahu', 'Rotasi pergelangan kaki'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang femur berfungsi untuk...',
      imageAsset: 'assets/femur.png',
      options: ['Melindungi otak', 'Menopang berat badan dan membantu proses locomotion (pergerakan tubuh)', 'Membentuk rongga dada', 'Menyaring darah'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Sendi peluru pada bahu memungkinkan...',
      imageAsset: 'assets/sendi_peluru.png',
      options: ['Gerakan satu arah', 'Gerakan rotasi terbatas', 'Gerakan multiaksial ke segala arah', 'Gerakan menggeser'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot quadriceps femoris berfungsi untuk...',
      imageAsset: 'assets/quadriceps.png',
      options: ['Fleksi lutut', 'Ekstensi lutut', 'Elevasi bahu', 'Rotasi panggul'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang vertebrae berfungsi untuk...',
      imageAsset: 'assets/vertebrae.png',
      options: ['Menopang tubuh dan melindungi medula spinalis', 'Menggerakkan pergelangan tangan', 'Membentuk sendi lutut', 'Menyimpan energi'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Otot deltoid berfungsi untuk...',
      imageAsset: 'assets/deltoid.png',
      options: ['Fleksi jari', 'Abduksi lengan', 'Fleksi paha', 'Ekstensi pergelangan kaki'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang tibia untuk...',
      imageAsset: 'assets/tibia.png',
      options: ['Menopang lengan bawah', 'Menopang berat badan dan membentuk sendi lutut', 'Melindungi jantung', 'Membentuk sendi bahu'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Sendi putar pada leher memungkinkan gerakan...',
      imageAsset: 'assets/sendi_putar.png',
      options: ['Gerak ke segala arah', 'Fleksi dan ekstensi', 'Rotasi kepala', 'Gerakan menggeser'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot latissimus dorsi berfungsi untuk...',
      imageAsset: 'assets/latissimus_dorsi.png',
      options: ['Elevasi bahu', 'Adduksi lengan ke arah tubuh', 'Ekstensi lutut', 'Fleksi jari'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Fungsi utama sendi geser adalah...',
      imageAsset: 'assets/sendi_geser.png',
      options: ['Memungkinkan rotasi', 'Memungkinkan gerak multiaksial', 'Memungkinkan tulang bergeser secara terbatas', 'Memungkinkan gerakan satu arah'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot hamstring berfungsi untuk...',
      imageAsset: 'assets/hamstring.png',
      options: ['Ekstensi lutut', 'Fleksi lutut', 'Elevasi bahu', 'Rotasi pinggul'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang scapula berfungsi untuk...',
      imageAsset: 'assets/scapula.png',
      options: ['Membentuk sendi lutut', 'Tempat perlekatan otot dan pembentuk sendi bahu', 'Menopang tungkai bawah', 'Melindungi otak'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Sendi engsel pada siku memungkinkan gerakan...',
      imageAsset: 'assets/sendi_engsel_siku.png',
      options: ['Rotasi', 'Gerak multiaksial', 'Fleksi dan ekstensi', 'Gerakan menggeser'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Otot pectoralis major berfungsi untuk...',
      imageAsset: 'assets/pectoralis_major.png',
      options: ['Fleksi lutut', 'Fleksi dan adduksi lengan', 'Rotasi kepala', 'Retraksi lengan'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Tulang tengkorak cranium berfungsi untuk...',
      imageAsset: 'assets/cranium.png',
      options: ['Menopang tubuh bagian bawah', 'Melindungi otak dan sistem saraf pusat', 'Membentuk sendi lutut', 'Menggerakkan lengan'],
      correctAnswerIndex: 1,
    ),
  ],
    3: [
    QuizQuestion(
      question: 'Seorang atlet melakukan gerakan squat. Otot utama yang bekerja saat fase naik adalah...',
      imageAsset: 'assets/squat.png', // dengan gambar
      options: ['Hamstring', 'Gastrocnemius', 'Quadriceps femoris', 'Deltoid'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Cedera pada ligamentum anterior cruciatum (ACL) paling sering terjadi pada olahraga yang melibatkan...',
      imageAsset: '', // tanpa gambar
      options: ['Gerakan rotasi dan perubahan arah mendadak', 'Gerakan pernapasan', 'Gerakan mengangkat bahu', 'Gerakan fleksi pergelangan tangan'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Saat melakukan gerakan push-up, otot utama yang paling dominan bekerja adalah...',
      imageAsset: 'assets/pushup.png', // dengan gambar
      options: ['Latissimus dorsi', 'Pectoralis major', 'Hamstring', 'Tibialis anterior'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Cedera ankle sprain umumnya terjadi akibat...',
      imageAsset: '', // tanpa gambar
      options: ['Hiperekstensi siku', 'Rotasi bahu', 'Inversi berlebihan pada pergelangan kaki', 'Fleksi lutut berlebihan'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Gerakan menendang bola dalam sepak bola melibatkan kontraksi dominan otot...',
      imageAsset: '', // tanpa gambar
      options: ['Quadriceps femoris', 'Deltoid', 'Trapezius', 'Biceps brachii'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Jika seorang atlet mengalami kesulitan melakukan plantarfleksi kaki, maka otot yang kemungkinan mengalami gangguan adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Deltoid', 'Gastrocnemius', 'Rectus abdominis', 'Triceps brachii'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Gerakan abduksi lengan saat melakukan jumping jack terutama melibatkan otot...',
      imageAsset: 'assets/jumpingjack.png', // dengan gambar
      options: ['Deltoid', 'Hamstring', 'Gastrocnemius', 'Sartorius'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Cedera dislokasi bahu paling sering terjadi pada sendi...',
      imageAsset: '', // tanpa gambar
      options: ['Engsel', 'Geser', 'Peluru', 'Putar'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Saat melakukan sit-up, otot utama yang bekerja adalah...',
      imageAsset: 'assets/situp.png', // dengan gambar
      options: ['Latissimus dorsi', 'Rectus abdominis', 'Gastrocnemius', 'Trapezius'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Gerakan sprint sangat bergantung pada kekuatan otot...',
      imageAsset: '', // tanpa gambar
      options: ['Deltoid dan trapezius', 'Quadriceps dan hamstring', 'Biceps dan triceps', 'Pectoralis dan latissimus dorsi'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Cedera hamstring paling sering terjadi pada olahraga yang membutuhkan...',
      imageAsset: '', // tanpa gambar
      options: ['Gerakan statis', 'Gerakan eksplosif dan sprint', 'Gerakan pernapasan', 'Gerakan memutar kepala'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Pada gerakan pull-up, otot utama yang dominan bekerja adalah...',
      imageAsset: 'assets/pullup.png', // dengan gambar
      options: ['Latissimus dorsi', 'Quadriceps', 'Tibialis anterior', 'Deltoid anterior'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Gerakan ekstensi lutut terutama dilakukan oleh otot...',
      imageAsset: '', // tanpa gambar
      options: ['Hamstring', 'Gastrocnemius', 'Quadriceps femoris', 'Sartorius'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Jika seorang atlet mengalami cedera rotator cuff, maka gerakan yang paling terganggu adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Gerakan bahu', 'Gerakan lutut', 'Gerakan pergelangan kaki', 'Gerakan leher'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Gerakan berjinjit pada atlet basket terutama menggunakan kontraksi otot...',
      imageAsset: '', // tanpa gambar
      options: ['Deltoid', 'Gastrocnemius', 'Biceps brachii', 'Rectus abdominis'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Sendi yang memungkinkan gerakan multiaksial pada tubuh manusia adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Sendi engsel', 'Sendi putar', 'Sendi peluru', 'Sendi geser'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Cedera shin splints umumnya terjadi pada bagian...',
      imageAsset: '', // tanpa gambar
      options: ['Tibia', 'Humerus', 'Radius', 'Clavicula'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Gerakan melempar bola melibatkan koordinasi utama antara otot...',
      imageAsset: '', // tanpa gambar
      options: ['Deltoid dan triceps brachii', 'Hamstring dan quadriceps', 'Gastrocnemius dan soleus', 'Sartorius dan tibialis anterior'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Pada gerakan deadlift, otot yang dominan bekerja adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Erector spinae dan hamstring', 'Deltoid dan biceps', 'Trapezius dan sternocleidomastoid', 'Gastrocnemius dan soleus'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Cedera meniskus pada lutut sering disebabkan oleh...',
      imageAsset: '', // tanpa gambar
      options: ['Gerakan rotasi lutut yang tiba-tiba', 'Gerakan fleksi siku', 'Gerakan memutar kepala', 'Gerakan ekstensi bahu'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Gerakan servis pada bola voli dominan menggunakan otot...',
      imageAsset: '', // tanpa gambar
      options: ['Deltoid dan pectoralis major', 'Hamstring dan quadriceps', 'Gastrocnemius dan soleus', 'Tibialis anterior dan sartorius'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Fungsi utama tulang belakang saat aktivitas olahraga adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Menghasilkan energi', 'Menopang tubuh dan menjaga stabilitas postur', 'Menggerakkan jari', 'Menyimpan oksigen'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Gerakan fleksi siku pada latihan biceps curl melibatkan otot...',
      imageAsset: '', // tanpa gambar
      options: ['Triceps brachii', 'Deltoid', 'Biceps brachii', 'Latissimus dorsi'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Cedera tennis elbow terjadi akibat gangguan pada...',
      imageAsset: '', // tanpa gambar
      options: ['Pergelangan kaki', 'Sendi bahu', 'Tendon siku', 'Sendi lutut'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Pada gerakan plank, otot yang paling berperan menjaga stabilitas tubuh adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Rectus abdominis dan core muscles (otot inti)', 'Deltoid dan trapezius', 'Quadriceps dan hamstring', 'Gastrocnemius dan soleus'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Gerakan adduksi lengan mendekati tubuh terutama dilakukan oleh otot...',
      imageAsset: '', // tanpa gambar
      options: ['Latissimus dorsi', 'Tibialis anterior', 'Gastrocnemius', 'Sartorius'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Cedera yang terjadi akibat peregangan otot berlebihan disebut...',
      imageAsset: '', // tanpa gambar
      options: ['Fraktur', 'Dislokasi', 'Strain', 'Sprain'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      question: 'Saat melakukan jumping, otot yang dominan menghasilkan daya ledak adalah...',
      imageAsset: '', // tanpa gambar
      options: ['Quadriceps dan gastrocnemius', 'Deltoid dan triceps', 'Latissimus dorsi dan trapezius', 'Biceps dan forearm'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      question: 'Gerakan rotasi kepala terutama terjadi pada sendi...',
      imageAsset: '', // tanpa gambar
      options: ['Engsel', 'Putar', 'Geser', 'Peluru'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      question: 'Cedera sprain berbeda dengan strain karena sprain terjadi pada...',
      imageAsset: '', // tanpa gambar
      options: ['Otot', 'Tendon', 'Ligamen', 'Tulang'],
      correctAnswerIndex: 2,
    ),
  ],
};