import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:antomi/main.dart';
import 'package:antomi/screens/splash_screen.dart';
import 'package:antomi/screens/name_entry_screen.dart';
import 'package:antomi/utils/storage_helper.dart';
import 'package:antomi/services/quiz_service.dart';

void main() {
  testWidgets('Aplikasi mulai di splash lalu ke layar isi nama', (tester) async {
    SharedPreferences.setMockInitialValues({}); // belum pernah isi nama

    await tester.pumpWidget(const AnatomiApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('ANATOMI'), findsOneWidget);

    // Splash menunggu 3 detik sebelum pindah layar.
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(); // proses pengecekan identitas (async)
    await tester.pump(const Duration(milliseconds: 600)); // transisi fade

    expect(find.byType(NameEntryScreen), findsOneWidget);
  });

  testWidgets('User yang sudah punya nama tidak disuruh isi nama lagi', (tester) async {
    SharedPreferences.setMockInitialValues({'quiz_user_name': 'Fauzan'});

    await tester.pumpWidget(const AnatomiApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(NameEntryScreen), findsNothing);
  });

  test('resetProgress menghapus poin tapi TIDAK menghapus identitas user', () async {
    // Regression test: dulu resetProgress() memakai prefs.clear() sehingga
    // user ikut ter-logout diam-diam saat menekan "Reset Progres".
    SharedPreferences.setMockInitialValues({
      'total_poin': 150,
      'level_terbuka': 3,
      'skor_level1': 10,
      'quiz_user_id': 7,
      'quiz_user_name': 'Fauzan',
      'quiz_user_avatar': '🦁',
      'quiz_is_admin': true,
    });

    await StorageHelper().resetProgress();

    final storage = StorageHelper();
    expect(await storage.getTotalPoin(), 0);
    expect(await storage.getLevelTerbuka(), 1);
    expect(await storage.getSkorLevel(1), 0);

    final quiz = QuizService();
    expect(await quiz.getSavedUserId(), 7);
    expect(await quiz.getSavedUserName(), 'Fauzan');
    expect(await quiz.getSavedAvatar(), '🦁');
    expect(await quiz.getSavedIsAdmin(), true);
  });

  test('saveIdentityOffline menyimpan nama tanpa id server', () async {
    SharedPreferences.setMockInitialValues({});
    final quiz = QuizService();

    await quiz.saveIdentityOffline('Budi', avatar: '🐯');

    expect(await quiz.getSavedUserName(), 'Budi');
    expect(await quiz.getSavedUserId(), isNull);
    expect(await quiz.hasIdentity(), isTrue);
    expect(await quiz.hasPendingRegistration(), isTrue);
  });
}
