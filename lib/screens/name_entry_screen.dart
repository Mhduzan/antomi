// lib/screens/name_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../services/quiz_service.dart';
import 'welcome_screen.dart';

class NameEntryScreen extends StatefulWidget {
  const NameEntryScreen({super.key});
  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  final _controller = TextEditingController();
  final _quizService = QuizService();
  bool _loading = false;
  String? _error;
  String? _errorTeknis; // penyebab asli, untuk menelusuri masalah koneksi
  bool _gagalKoneksi = false; // true kalau daftar ke server pernah gagal
  String _selectedAvatar = QuizService.avatarOptions.first;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Nama tidak boleh kosong');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _quizService.registerName(name, avatar: _selectedAvatar);
      if (!mounted) return;
      _masukKeAplikasi();
    } catch (e) {
      debugPrint('[registerName] GAGAL: $e');
      setState(() {
        _error = 'Gagal menyimpan nama. Cek koneksi internet, lalu coba lagi.';
        // Pesan generik menyembunyikan bedanya masalah DNS, sertifikat TLS,
        // dan penolakan API key — padahal penanganannya beda-beda.
        _errorTeknis = e.toString();
        _gagalKoneksi = true;
        _loading = false;
      });
    }
  }

  /// Lanjut main walaupun server tidak bisa dihubungi.
  ///
  /// Tanpa ini, server yang mati atau sinyal yang hilang membuat aplikasi
  /// tidak bisa dipakai sama sekali — padahal semua soal quiz dan game
  /// tersimpan di dalam aplikasi dan sebenarnya jalan offline.
  /// Pendaftarannya dicoba lagi otomatis begitu koneksi pulih.
  Future<void> _lanjutOffline() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Nama tidak boleh kosong');
      return;
    }
    await _quizService.saveIdentityOffline(name, avatar: _selectedAvatar);
    if (mounted) _masukKeAplikasi();
  }

  void _masukKeAplikasi() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: r.pad * 1.5, vertical: r.h(24)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: r.logoSz,
                  height: r.logoSz,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(_selectedAvatar, style: TextStyle(fontSize: r.iconLg)),
                  ),
                ),
                SizedBox(height: r.h(24)),
                Text(
                  'Siapa Nama Kamu?',
                  style: GoogleFonts.poppins(
                    fontSize: r.sp(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: r.h(8)),
                Text(
                  'Nama ini dipakai buat nyimpen skor quiz\ndan game kamu',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: r.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: r.h(24)),

                // ── Pilih avatar/stiker ────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pilih Avatar',
                    style: GoogleFonts.inter(fontSize: r.sp(12), fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                ),
                SizedBox(height: r.h(10)),
                Wrap(
                  spacing: r.padSm,
                  runSpacing: r.padSm,
                  alignment: WrapAlignment.center,
                  children: QuizService.avatarOptions.map((emoji) {
                    final selected = emoji == _selectedAvatar;
                    return GestureDetector(
                      onTap: _loading ? null : () => setState(() => _selectedAvatar = emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: r.w(52),
                        height: r.w(52),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primaryPale : AppColors.inputBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: Center(child: Text(emoji, style: TextStyle(fontSize: r.sp(24)))),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: r.h(24)),
                TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  enabled: !_loading,
                  style: GoogleFonts.inter(fontSize: r.sp(16), fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kamu',
                    filled: true,
                    fillColor: AppColors.inputBg,
                    errorText: _error,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: r.h(16), horizontal: r.pad),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                SizedBox(height: r.h(24)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: r.h(16)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'Mulai Belajar',
                            style: GoogleFonts.inter(fontSize: r.sp(15), fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                  ),
                ),

                // Detail teknis: hanya muncul kalau gagal, dan sengaja dibuat
                // bisa disalin supaya mudah dilaporkan.
                if (_errorTeknis != null && !_loading) ...[
                  SizedBox(height: r.h(12)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(r.padSm),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      _errorTeknis!,
                      style: GoogleFonts.robotoMono(
                        fontSize: r.sp(10),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],

                // Muncul hanya setelah percobaan daftar gagal.
                if (_gagalKoneksi && !_loading) ...[
                  SizedBox(height: r.h(12)),
                  TextButton(
                    onPressed: _lanjutOffline,
                    child: Text(
                      'Main dulu tanpa daftar',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    'Quiz & game tetap bisa dimainkan, poin tersimpan di HP.\n'
                    'Nilai mulai masuk peringkat setelah koneksi kembali.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: r.sp(11), color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
