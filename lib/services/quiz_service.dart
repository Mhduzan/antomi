import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  // ═══════════════════════════════════════════════════════════════════════
  //  GANTI 2 BARIS DI BAWAH SEBELUM BUILD APK RELEASE
  // ═══════════════════════════════════════════════════════════════════════
  //
  // 1. baseUrl  : alamat API di Hostinger, HARUS https (bukan http).
  //               Contoh: 'https://antomi-quiz.my.id/api'
  //               Jangan pakai garis miring di akhir.
  //
  // 2. apiKey   : harus SAMA PERSIS dengan 'api_key' di api/config.php
  //               yang ada di server.
  //
  // Untuk tes di komputer sendiri:
  //   - Emulator Android : http://10.0.2.2:8000/api
  //   - Chrome / iOS sim : http://127.0.0.1:8000/api
  //   - HP fisik satu WiFi: http://IP-LAPTOP:8000/api  (cek pakai `ipconfig`)
  //
  static const String baseUrl = 'https://ulvadomain.my.id/api';
  static const String apiKey = 'Honor4005tshdvfyuewf376t4werferg56uhtyjrtheryte56yersegw45y6';

  // 20 detik, bukan 12: resolusi DNS di HP bisa lambat pada panggilan pertama
  // setelah domain baru aktif, terutama di jaringan seluler.
  static const Duration _timeout = Duration(seconds: 20);

  /// Jalankan [aksi]; kalau gagal karena jaringan, ulangi sekali setelah jeda.
  ///
  /// Percobaan pertama ke domain yang baru aktif sering gagal resolve lalu
  /// berhasil pada percobaan berikutnya. Aman diulang karena endpoint
  /// pendaftaran di server bersifat "cari dulu, baru buat" — mengirim dua kali
  /// tidak membuat dua akun.
  static Future<T> _denganUlangan<T>(Future<T> Function() aksi) async {
    try {
      return await aksi();
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      return await aksi();
    }
  }

  /// Status admin dianggap masih segar selama ini, supaya aplikasi tidak
  /// memanggil server setiap kali layar menu dimuat ulang.
  static const Duration _adminCacheTtl = Duration(hours: 6);

  static const String _prefsKeyUserId = 'quiz_user_id';
  static const String _prefsKeyUserName = 'quiz_user_name';
  static const String _prefsKeyIsAdmin = 'quiz_is_admin';
  static const String _prefsKeyAvatar = 'quiz_user_avatar';
  static const String _prefsKeyAdminSyncedAt = 'quiz_admin_synced_at';

  // Daftar avatar/stiker yang bisa dipilih user (kayak Kahoot)
  static const List<String> avatarOptions = [
    '🦁', '🐯', '🐻', '🐼', '🐨', '🦊',
    '🐰', '🐸', '🐵', '🦄', '🐙', '🦉',
  ];

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-KEY': apiKey,
      };

  // ── Identitas tersimpan di HP ─────────────────────────────────────────────
  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefsKeyUserId);
  }

  Future<String?> getSavedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKeyUserName);
  }

  Future<bool> getSavedIsAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKeyIsAdmin) ?? false;
  }

  Future<String?> getSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKeyAvatar);
  }

  /// True kalau user sudah pernah isi nama, walaupun pendaftaran ke server
  /// belum berhasil (mode offline).
  Future<bool> hasIdentity() async {
    final name = await getSavedUserName();
    return name != null && name.trim().isNotEmpty;
  }

  /// True kalau nama sudah tersimpan lokal tapi belum punya id dari server,
  /// artinya pendaftarannya masih menunggu koneksi.
  Future<bool> hasPendingRegistration() async {
    return await hasIdentity() && await getSavedUserId() == null;
  }

  // ── Daftar nama + avatar baru ────────────────────────────────────────────
  //
  // Di sisi server ini bersifat "cari dulu, baru buat": kalau namanya sudah
  // terdaftar, akun lama yang dipakai. Jadi install ulang aplikasi tidak
  // menghilangkan poin yang sudah tersimpan di server.
  Future<int> registerName(String name, {String? avatar}) async {
    final res = await _denganUlangan(
      () => http
          .post(
            Uri.parse('$baseUrl/quiz-users'),
            headers: _headers,
            body: jsonEncode({'name': name, 'avatar': avatar}),
          )
          .timeout(_timeout),
    );

    if (res.statusCode >= 400) {
      throw Exception('Gagal daftar (${res.statusCode}): ${res.body}');
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final id = int.tryParse('${map['id']}');
    if (id == null) throw Exception('Server tidak mengirim id user');
    final isAdmin = map['is_admin'] == true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyUserId, id);
    await prefs.setString(_prefsKeyUserName, name);
    await prefs.setBool(_prefsKeyIsAdmin, isAdmin);
    await prefs.setInt(_prefsKeyAdminSyncedAt, DateTime.now().millisecondsSinceEpoch);
    if (avatar != null) await prefs.setString(_prefsKeyAvatar, avatar);

    return id;
  }

  /// Simpan nama & avatar tanpa id server, dipakai kalau user memilih lanjut
  /// main walaupun pendaftaran gagal (server mati / tidak ada sinyal).
  /// Pendaftarannya dicoba lagi otomatis nanti lewat [retryPendingRegistration].
  Future<void> saveIdentityOffline(String name, {String? avatar}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyUserName, name);
    if (avatar != null) await prefs.setString(_prefsKeyAvatar, avatar);
    await prefs.remove(_prefsKeyUserId);
    await prefs.setBool(_prefsKeyIsAdmin, false);
  }

  /// Coba daftarkan ulang user yang tadi gagal terdaftar. Aman dipanggil
  /// kapan saja: langsung berhenti kalau memang tidak ada yang tertunda.
  Future<bool> retryPendingRegistration() async {
    if (!await hasPendingRegistration()) return false;
    try {
      final name = (await getSavedUserName())!;
      final avatar = await getSavedAvatar();
      await registerName(name, avatar: avatar);
      return true;
    } catch (_) {
      return false; // masih offline, coba lagi lain kali
    }
  }

  // ── Sinkron status admin dari server ─────────────────────────────────────
  //
  // Berguna kalau user di-promote jadi admin dari HP lain. Hasilnya
  // di-cache supaya tidak memanggil server tiap kali layar menu dibuka —
  // status admin nyaris tidak pernah berubah, dan di hosting bersama
  // jumlah request per jam itu terbatas.
  Future<bool> syncAdminStatus({bool force = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getBool(_prefsKeyIsAdmin) ?? false;

    if (!force) {
      final lastMs = prefs.getInt(_prefsKeyAdminSyncedAt);
      if (lastMs != null) {
        final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastMs));
        if (age < _adminCacheTtl) return cached;
      }
    }

    try {
      final userId = await getSavedUserId();
      if (userId == null) return cached;

      final detail = await getUserDetail(userId);
      final isAdmin = detail['is_admin'] == true;

      await prefs.setBool(_prefsKeyIsAdmin, isAdmin);
      await prefs.setInt(_prefsKeyAdminSyncedAt, DateTime.now().millisecondsSinceEpoch);

      return isAdmin;
    } catch (_) {
      return cached; // offline: pakai status lama
    }
  }

  // ── Submit skor quiz/game. Aman dipanggil walau offline ──────────────────
  Future<void> submitScore({
    required String activityType, // 'quiz' | 'word_guess' | 'matching'
    int? level,
    required int score,
    int? maxScore,
  }) async {
    try {
      // Kalau pendaftaran sebelumnya gagal, coba lagi sekarang supaya skornya
      // tetap tercatat begitu koneksi pulih.
      if (await hasPendingRegistration()) {
        await retryPendingRegistration();
      }

      final userId = await getSavedUserId();
      if (userId == null) return; // masih offline, skip

      await http
          .post(
            Uri.parse('$baseUrl/quiz-scores'),
            headers: _headers,
            body: jsonEncode({
              'quiz_user_id': userId,
              'activity_type': activityType,
              'level': level,
              'score': score,
              'max_score': maxScore,
            }),
          )
          .timeout(_timeout);
    } catch (_) {
      // Sengaja diabaikan: kalau internet/server lagi mati, jangan sampai
      // mengganggu pengalaman main game/quiz. Poin lokal tetap tersimpan.
    }
  }

  // ── Daftar semua user + total poin (leaderboard & layar admin) ───────────
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final res = await http
        .get(Uri.parse('$baseUrl/quiz-users'), headers: _headers)
        .timeout(_timeout);

    if (res.statusCode >= 400) {
      throw Exception('Gagal ambil data (${res.statusCode}): ${res.body}');
    }

    final List data = jsonDecode(res.body);
    return data.cast<Map<String, dynamic>>();
  }

  // ── Detail 1 user + histori skornya ──────────────────────────────────────
  Future<Map<String, dynamic>> getUserDetail(int userId) async {
    final res = await http
        .get(Uri.parse('$baseUrl/quiz-users/$userId'), headers: _headers)
        .timeout(_timeout);

    if (res.statusCode >= 400) {
      throw Exception('Gagal ambil data (${res.statusCode}): ${res.body}');
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Jadikan user lain admin (dipanggil dari layar Kelola Admin) ──────────
  Future<void> makeAdmin(int userId) async {
    final res = await http
        .patch(Uri.parse('$baseUrl/quiz-users/$userId/make-admin'), headers: _headers)
        .timeout(_timeout);

    if (res.statusCode >= 400) {
      throw Exception('Gagal jadikan admin (${res.statusCode}): ${res.body}');
    }
  }

  // ── Logout: hapus identitas lokal ────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyUserId);
    await prefs.remove(_prefsKeyUserName);
    await prefs.remove(_prefsKeyIsAdmin);
    await prefs.remove(_prefsKeyAvatar);
    await prefs.remove(_prefsKeyAdminSyncedAt);
  }
}
