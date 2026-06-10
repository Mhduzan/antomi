// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late R _r;
  int _totalPoin = 0, _levelTerbuka = 1, _s1 = 0, _s2 = 0, _s3 = 0;
  bool _loading = true;
  final _storage = StorageHelper();

  late AnimationController _pulseCtrl, _slideCtrl;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _slideAnim;

  final _maxQ = {1: 10, 2: 20, 3: 30};

  @override
  void initState() {
    super.initState();
    _loadData();
    _pulseCtrl = AnimationController(duration: const Duration(milliseconds: 1400), vsync: this)..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _slideCtrl = AnimationController(duration: const Duration(milliseconds: 700), vsync: this)..forward();
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() { _pulseCtrl.dispose(); _slideCtrl.dispose(); super.dispose(); }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    _totalPoin    = await _storage.getTotalPoin();
    _levelTerbuka = await _storage.getLevelTerbuka();
    _s1 = await _storage.getSkorLevel(1);
    _s2 = await _storage.getSkorLevel(2);
    _s3 = await _storage.getSkorLevel(3);
    if (mounted) setState(() => _loading = false);
  }

  String get _achievement {
    final p = _totalPoin / 300 * 100;
    if (p >= 90) return '🏆 Master Anatomi';
    if (p >= 70) return '⭐ Ahli Anatomi';
    if (p >= 50) return '📚 Pelajar Rajin';
    if (p >= 30) return '🌱 Pemula Semangat';
    return '🎯 Mulai Belajar';
  }

  String get _motivasi {
    if (_levelTerbuka >= 3 && _s3 >= 30) return '✨ Luar biasa! Kamu telah menguasai semua materi anatomi!';
    if (_levelTerbuka >= 2) return '💪 Terus semangat! Kamu sudah menguasai level menengah!';
    if (_totalPoin > 0) return '📖 Bagus! Terus belajar untuk membuka level berikutnya!';
    return '🎯 Mulai quiz pertamamu untuk belajar anatomi tubuh!';
  }

  @override
  Widget build(BuildContext context) {
    _r = R.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                _buildHeader(),
                _buildStatBar(),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(_r.pad, _r.pad, _r.pad, _r.pad + 8),
                      child: Column(
                        children: [
                          _sectionCard(Icons.stars_rounded, 'Total Poin', AppColors.warning, _buildPoinProgress()),
                          SizedBox(height: _r.h(12)),
                          _sectionCard(Icons.lock_open_rounded, 'Level Terbuka', AppColors.success, _buildLevelRows()),
                          SizedBox(height: _r.h(12)),
                          _sectionCard(Icons.assessment_rounded, 'Riwayat Belajar', AppColors.primary, _buildScoreRows()),
                          SizedBox(height: _r.h(12)),
                          _buildMotivasiCard(),
                          SizedBox(height: _r.h(14)),
                          _buildResetBtn(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(_r.pad, _r.padXs, _r.pad, _r.pad + 8),
          child: Column(
            children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: _r.w(36), height: _r.w(36),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(_r.padSm)),
                    child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: _r.iconSm))),
                Expanded(child: Center(child: Text('Profil Belajarku',
                  style: GoogleFonts.poppins(fontSize: _r.sp(16), fontWeight: FontWeight.w700, color: Colors.white)))),
                const SizedBox(width: 36),
              ]),
              SizedBox(height: _r.h(18)),
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => Transform.scale(scale: _pulseAnim.value,
                  child: Container(width: _r.avatarLg, height: _r.avatarLg,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.25), blurRadius: 16, spreadRadius: 4)]),
                    child: ClipOval(
              child: Image.asset(
                'assets/ulpa.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person_rounded,
                  size: _r.w(40),
                  color: AppColors.primary,
                ),
              ),
            )))),
              SizedBox(height: _r.h(8)),
              Text('MariaUlva', style: GoogleFonts.poppins(fontSize: _r.sp(18), fontWeight: FontWeight.w700, color: Colors.white)),
              SizedBox(height: _r.h(4)),
              Container(padding: EdgeInsets.symmetric(horizontal: _r.padSm + 2, vertical: _r.padXs),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                child: Text(_achievement, style: GoogleFonts.inter(fontSize: _r.sp(11), fontWeight: FontWeight.w600, color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar() {
    return Transform.translate(
      offset: const Offset(0, -1),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: _r.pad),
        padding: EdgeInsets.symmetric(horizontal: _r.pad, vertical: _r.padSm + 2),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(_r.radiusLg),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _statItem('$_totalPoin', 'Total Poin', Icons.stars_rounded, AppColors.warning),
          Container(width: 1, height: _r.h(34), color: AppColors.divider),
          _statItem('$_levelTerbuka/3', 'Level Terbuka', Icons.lock_open_rounded, AppColors.success),
          Container(width: 1, height: _r.h(34), color: AppColors.divider),
          _statItem('${(_totalPoin / 300 * 100).toStringAsFixed(0)}%', 'Progres', Icons.trending_up_rounded, AppColors.primary),
        ]),
      ),
    );
  }

  Widget _statItem(String val, String label, IconData icon, Color color) => Column(children: [
    Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: _r.iconSm, color: color), SizedBox(width: _r.w(3)),
      Text(val, style: GoogleFonts.poppins(fontSize: _r.sp(16), fontWeight: FontWeight.w800, color: color)),
    ]),
    Text(label, style: GoogleFonts.inter(fontSize: _r.sp(9), color: AppColors.textSecondary)),
  ]);

  Widget _sectionCard(IconData icon, String title, Color color, Widget body) {
    return Container(
      padding: EdgeInsets.all(_r.pad - 2),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(_r.radiusLg),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: _r.w(34), height: _r.w(34),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(_r.padSm)),
            child: Icon(icon, color: color, size: _r.iconSm)),
          SizedBox(width: _r.w(8)),
          Text(title, style: GoogleFonts.poppins(fontSize: _r.sp(14), fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
        SizedBox(height: _r.h(12)),
        Divider(height: 1, color: AppColors.divider),
        SizedBox(height: _r.h(12)),
        body,
      ]),
    );
  }

  Widget _buildPoinProgress() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('$_totalPoin / 300 Poin', style: GoogleFonts.poppins(fontSize: _r.sp(16), fontWeight: FontWeight.w700, color: AppColors.warning)),
      Text('Target: Master', style: GoogleFonts.inter(fontSize: _r.sp(10), color: AppColors.textSecondary)),
    ]),
    SizedBox(height: _r.h(8)),
    ClipRRect(borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(value: (_totalPoin / 300).clamp(0.0, 1.0),
        backgroundColor: AppColors.inputBg, color: AppColors.warning, minHeight: _r.h(8))),
  ]);

  Widget _buildLevelRows() => Column(children: [
    _levelRow(1, _levelTerbuka >= 1, AppColors.success, 'Level 1 - Dasar', 0),
    SizedBox(height: _r.h(10)),
    _levelRow(2, _levelTerbuka >= 2, AppColors.warning, 'Level 2 - Menengah', 50),
    SizedBox(height: _r.h(10)),
    _levelRow(3, _levelTerbuka >= 3, AppColors.danger, 'Level 3 - Mahir', 120),
  ]);

  Widget _levelRow(int level, bool unlocked, Color color, String label, int target) => Row(children: [
    Container(width: _r.w(38), height: _r.w(38),
      decoration: BoxDecoration(color: unlocked ? color.withOpacity(0.1) : AppColors.inputBg, borderRadius: BorderRadius.circular(_r.padSm)),
      child: Center(child: Text('$level', style: GoogleFonts.poppins(fontSize: _r.sp(15), fontWeight: FontWeight.w700, color: unlocked ? color : AppColors.textLight)))),
    SizedBox(width: _r.w(10)),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: _r.sp(12), fontWeight: FontWeight.w600, color: unlocked ? AppColors.textPrimary : AppColors.textSecondary)),
      Text(unlocked ? '✅ Terbuka' : '🔒 Terkunci', style: GoogleFonts.inter(fontSize: _r.sp(10), color: unlocked ? AppColors.success : AppColors.textLight)),
    ])),
    if (!unlocked && target > 0)
      Container(padding: EdgeInsets.symmetric(horizontal: _r.padXs + 2, vertical: _r.padXs),
        decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(_r.padXs + 2)),
        child: Text('Butuh $target Poin', style: GoogleFonts.inter(fontSize: _r.sp(9), fontWeight: FontWeight.w600, color: AppColors.warning))),
  ]);

  Widget _buildScoreRows() {
    final rows = <Widget>[_scoreTile(1, _s1, _maxQ[1]!, AppColors.success)];
    if (_levelTerbuka >= 2) { rows.add(Divider(height: _r.h(18))); rows.add(_scoreTile(2, _s2, _maxQ[2]!, AppColors.warning)); }
    if (_levelTerbuka >= 3) { rows.add(Divider(height: _r.h(18))); rows.add(_scoreTile(3, _s3, _maxQ[3]!, AppColors.danger)); }
    if (_levelTerbuka < 3) {
      rows.add(Divider(height: _r.h(18)));
      rows.add(Container(padding: EdgeInsets.all(_r.padSm), decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(_r.padSm)),
        child: Row(children: [
          Icon(Icons.lock_rounded, color: AppColors.textLight, size: _r.iconSm - 2), SizedBox(width: _r.w(6)),
          Expanded(child: Text('Selesaikan level sebelumnya untuk membuka lebih banyak',
            style: GoogleFonts.inter(fontSize: _r.sp(11), color: AppColors.textSecondary))),
        ])));
    }
    return Column(children: rows);
  }

  Widget _scoreTile(int level, int score, int maxScore, Color color) {
    const names = ['Level 1 - Dasar', 'Level 2 - Menengah', 'Level 3 - Mahir'];
    return Column(children: [
      Row(children: [
        Container(width: _r.w(34), height: _r.w(34),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(_r.padSm)),
          child: Center(child: Text('$level', style: GoogleFonts.poppins(fontSize: _r.sp(14), fontWeight: FontWeight.w700, color: color)))),
        SizedBox(width: _r.w(10)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(names[level - 1], style: GoogleFonts.inter(fontSize: _r.sp(12), fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: _r.h(4)),
          ClipRRect(borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: (score / maxScore).clamp(0.0, 1.0),
              backgroundColor: AppColors.inputBg, color: color, minHeight: _r.h(5))),
        ])),
        SizedBox(width: _r.w(10)),
        Text('$score/$maxScore', style: GoogleFonts.poppins(fontSize: _r.sp(13), fontWeight: FontWeight.w700, color: color)),
      ]),
    ]);
  }

  Widget _buildMotivasiCard() => Container(
    padding: EdgeInsets.all(_r.pad - 2),
    decoration: BoxDecoration(color: AppColors.primaryPale, borderRadius: BorderRadius.circular(_r.radiusLg),
      border: Border.all(color: AppColors.primary.withOpacity(0.15))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: _r.iconSm + 2),
      SizedBox(width: _r.w(8)),
      Expanded(child: Text(_motivasi, style: GoogleFonts.inter(fontSize: _r.sp(12), color: AppColors.primaryDark, fontWeight: FontWeight.w500))),
    ]),
  );

  Widget _buildResetBtn() => SizedBox(
    width: double.infinity, height: _r.btnHSm,
    child: OutlinedButton.icon(
      onPressed: _showResetDialog,
      icon: Icon(Icons.delete_outline_rounded, size: _r.iconSm),
      label: Text('Reset Seluruh Progres'),
      style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger,
        side: BorderSide(color: AppColors.danger.withOpacity(0.4), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_r.radius)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: _r.sp(13)))));

  void _showResetDialog() {
    showDialog(context: context, builder: (_) {
      final r = R.of(context);
      return Dialog(backgroundColor: Colors.transparent,
        child: Container(padding: EdgeInsets.all(r.pad + 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(r.radiusXl)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: r.w(60), height: r.w(60),
              decoration: const BoxDecoration(color: AppColors.dangerLight, shape: BoxShape.circle),
              child: Icon(Icons.delete_rounded, color: AppColors.danger, size: r.iconLg - 4)),
            SizedBox(height: r.h(12)),
            Text('Reset Progres?', style: GoogleFonts.poppins(fontSize: r.sp(17), fontWeight: FontWeight.w700)),
            SizedBox(height: r.h(6)),
            Text('Semua poin dan skor akan dihapus. Yakin?', textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: r.sp(12), color: AppColors.textSecondary)),
            SizedBox(height: r.h(18)),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radius))),
                child: Text('Batal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)))),
              SizedBox(width: r.w(10)),
              Expanded(child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _storage.resetProgress();
                  await _loadData();
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Progres berhasil direset'), backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.radius))),
                child: Text('Reset', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)))),
            ]),
          ])));
    });
  }
}
