// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../services/quiz_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  final _quizService = QuizService();
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;
  String? _error;
  int? _myUserId;

  late AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 900), vsync: this)..forward();
    _load();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  /// Baca total_poin sebagai int, apa pun bentuk aslinya di JSON.
  static int _poin(Map<String, dynamic> u) {
    final v = u['total_poin'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('${v ?? 0}') ?? 0;
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final users = await _quizService.getAllUsers();
      // Urut dari poin tertinggi. Dibaca lewat _poin() supaya tetap benar
      // kalau server mengirim angka sebagai string ("90"), yang kalau
      // dibandingkan apa adanya bikin urutan jadi alfabetis: "9" > "100".
      users.sort((a, b) => _poin(b).compareTo(_poin(a)));
      final myId = await _quizService.getSavedUserId();
      if (mounted) setState(() { _users = users; _myUserId = myId; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Gagal ambil data leaderboard'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final top3 = _users.take(3).toList();
    final rest = _users.length > 3 ? _users.sublist(3) : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header gradient + judul ──────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(r.pad, r.padXs, r.pad, r.pad + 8),
                child: Column(
                  children: [
                    Row(children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      ),
                      Expanded(
                        child: Column(children: [
                          Text('🏆 LEADERBOARD',
                              style: GoogleFonts.poppins(fontSize: r.sp(18), fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
                          Text('Peringkat Poin Tertinggi',
                              style: GoogleFonts.inter(fontSize: r.sp(11), color: Colors.white.withOpacity(0.85))),
                        ]),
                      ),
                      IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded, color: Colors.white)),
                    ]),
                    if (!_loading && top3.isNotEmpty) ...[
                      SizedBox(height: r.h(20)),
                      _buildPodium(r, top3),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // ── List rank 4 dst ───────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _error != null
                    ? Center(child: Text(_error!, style: GoogleFonts.inter(color: AppColors.textSecondary)))
                    : _users.isEmpty
                        ? Center(child: Text('Belum ada yang main', style: GoogleFonts.inter(color: AppColors.textSecondary)))
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: ListView.separated(
                              padding: EdgeInsets.fromLTRB(r.pad, r.pad, r.pad, r.pad + 8),
                              itemCount: rest.length,
                              separatorBuilder: (_, __) => SizedBox(height: r.h(8)),
                              itemBuilder: (_, i) => _buildRow(r, rest[i], i + 4),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(R r, List<Map<String, dynamic>> top3) {
    final first = top3.isNotEmpty ? top3[0] : null;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return AnimatedBuilder(
      animation: _entryCtrl,
      builder: (_, __) {
        return SizedBox(
          height: r.h(190),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (second != null) _podiumSlot(r, second, 2, r.h(120), const Color(0xFFCBD5E1), 0.15),
              if (first != null) _podiumSlot(r, first, 1, r.h(150), const Color(0xFFFDE68A), 0.0),
              if (third != null) _podiumSlot(r, third, 3, r.h(96), const Color(0xFFFED7AA), 0.3),
            ],
          ),
        );
      },
    );
  }

  Widget _podiumSlot(R r, Map<String, dynamic> user, int rank, double barHeight, Color barColor, double delay) {
    final name = (user['name'] ?? '-').toString();
    final avatar = (user['avatar'] ?? '👤').toString();
    final poin = _poin(user);
    final isMe = user['id'] == _myUserId;
    final medal = rank == 1 ? '🥇' : (rank == 2 ? '🥈' : '🥉');

    final t = Curves.easeOutBack.transform(
      (( _entryCtrl.value - delay).clamp(0.0, 1.0) / (1.0 - delay)).clamp(0.0, 1.0),
    );

    return Transform.translate(
      offset: Offset(0, (1 - t) * 40),
      child: Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: SizedBox(
          width: r.w(96),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(medal, style: TextStyle(fontSize: r.sp(rank == 1 ? 30 : 24))),
              SizedBox(height: r.h(4)),
              Container(
                width: r.w(rank == 1 ? 58 : 48),
                height: r.w(rank == 1 ? 58 : 48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: isMe ? AppColors.warning : Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Center(child: Text(avatar, style: TextStyle(fontSize: r.sp(rank == 1 ? 26 : 20)))),
              ),
              SizedBox(height: r.h(6)),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: r.sp(12), fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Text('$poin pt', style: GoogleFonts.inter(fontSize: r.sp(11), color: Colors.white.withOpacity(0.9))),
              SizedBox(height: r.h(8)),
              Container(
                width: double.infinity,
                height: barHeight,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: r.h(8)),
                child: Text('$rank', style: GoogleFonts.poppins(fontSize: r.sp(20), fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(R r, Map<String, dynamic> user, int rank) {
    final name = (user['name'] ?? '-').toString();
    final avatar = (user['avatar'] ?? '👤').toString();
    final poin = _poin(user);
    final isMe = user['id'] == _myUserId;

    return Container(
      padding: EdgeInsets.all(r.pad - 4),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primaryPale : Colors.white,
        borderRadius: BorderRadius.circular(r.radiusLg),
        border: Border.all(color: isMe ? AppColors.primary.withOpacity(0.4) : AppColors.divider),
      ),
      child: Row(children: [
        SizedBox(
          width: r.w(28),
          child: Text('$rank', textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: r.sp(13), fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
        ),
        SizedBox(width: r.padSm),
        Container(
          width: r.w(36), height: r.w(36),
          decoration: BoxDecoration(color: AppColors.inputBg, shape: BoxShape.circle),
          child: Center(child: Text(avatar, style: TextStyle(fontSize: r.sp(18)))),
        ),
        SizedBox(width: r.padSm),
        Expanded(
          child: Text(name, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: r.sp(13), fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
        Text('$poin', style: GoogleFonts.poppins(fontSize: r.sp(15), fontWeight: FontWeight.w800, color: AppColors.primary)),
        SizedBox(width: r.w(4)),
        Text('pt', style: GoogleFonts.inter(fontSize: r.sp(11), color: AppColors.textSecondary)),
      ]),
    );
  }
}
