// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  int _totalPoin = 0;
  int _levelTerbuka = 1;
  int _skorLevel1 = 0;
  int _skorLevel2 = 0;
  int _skorLevel3 = 0;
  late StorageHelper _storage;
  bool _isLoading = true;

  final Map<int, int> _maxQuestionsPerLevel = {1: 10, 2: 20, 3: 30};

  late AnimationController _pulseCtrl;
  late AnimationController _slideCtrl;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _loadData();

    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this)
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _slideCtrl = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this)
      ..forward();
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _slideCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    int poin = await _storage.getTotalPoin();
    int level = await _storage.getLevelTerbuka();
    int s1 = await _storage.getSkorLevel(1);
    int s2 = await _storage.getSkorLevel(2);
    int s3 = await _storage.getSkorLevel(3);
    if (mounted) {
      setState(() {
        _totalPoin = poin;
        _levelTerbuka = level;
        _skorLevel1 = s1;
        _skorLevel2 = s2;
        _skorLevel3 = s3;
        _isLoading = false;
      });
    }
  }

  String _getAchievementLevel() {
    double persentase = (_totalPoin / 300) * 100;
    if (persentase >= 90) return '🏆 Master Anatomi';
    if (persentase >= 70) return '⭐ Ahli Anatomi';
    if (persentase >= 50) return '📚 Pelajar Rajin';
    if (persentase >= 30) return '🌱 Pemula Semangat';
    return '🎯 Mulai Belajar';
  }

  String _getMotivationMessage() {
    if (_levelTerbuka >= 3 && _skorLevel3 >= 30) {
      return '✨ Luar biasa! Kamu telah menguasai semua materi anatomi!';
    }
    if (_levelTerbuka >= 2) {
      return '💪 Terus semangat! Kamu sudah menguasai level menengah!';
    }
    if (_totalPoin > 0) {
      return '📖 Bagus! Terus belajar untuk membuka level berikutnya!';
    }
    return '🎯 Mulai quiz pertamamu untuk belajar anatomi tubuh!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Blue header
                Container(
                  decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                      child: Column(
                        children: [
                          // AppBar row
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.arrow_back_ios_rounded,
                                      color: Colors.white, size: 16),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Profil Belajarku',
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 36),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Avatar + name
                          AnimatedBuilder(
                            animation: _pulseCtrl,
                            builder: (_, __) => Transform.scale(
                              scale: _pulseAnim.value,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.25),
                                      blurRadius: 16,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.person_rounded,
                                    size: 42, color: AppColors.primary),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Anatomi Learner',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              _getAchievementLevel(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Stats row floating
                Transform.translate(
                  offset: const Offset(0, -1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem(
                          '$_totalPoin',
                          'Total Poin',
                          Icons.stars_rounded,
                          AppColors.warning,
                        ),
                        Container(
                            width: 1, height: 36, color: AppColors.divider),
                        _statItem(
                          '$_levelTerbuka/3',
                          'Level Terbuka',
                          Icons.lock_open_rounded,
                          AppColors.success,
                        ),
                        Container(
                            width: 1, height: 36, color: AppColors.divider),
                        _statItem(
                          '${(_totalPoin / 300 * 100).toStringAsFixed(0)}%',
                          'Progres',
                          Icons.trending_up_rounded,
                          AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        children: [
                          // Total poin progress
                          _buildSectionCard(
                            title: 'Total Poin',
                            icon: Icons.stars_rounded,
                            iconColor: AppColors.warning,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$_totalPoin / 300 Poin',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                    Text(
                                      'Target: Master',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: (_totalPoin / 300).clamp(0.0, 1.0),
                                    backgroundColor: AppColors.inputBg,
                                    color: AppColors.warning,
                                    minHeight: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Level status
                          _buildSectionCard(
                            title: 'Level Terbuka',
                            icon: Icons.lock_open_rounded,
                            iconColor: AppColors.success,
                            child: Column(
                              children: [
                                _levelRow(1, _levelTerbuka >= 1),
                                const SizedBox(height: 10),
                                _levelRow(2, _levelTerbuka >= 2),
                                const SizedBox(height: 10),
                                _levelRow(3, _levelTerbuka >= 3),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // History / scores
                          _buildSectionCard(
                            title: 'Riwayat Belajar',
                            icon: Icons.assessment_rounded,
                            iconColor: AppColors.primary,
                            child: Column(
                              children: [
                                _scoreTile(1, _skorLevel1,
                                    _maxQuestionsPerLevel[1]!, AppColors.success),
                                if (_levelTerbuka >= 2) ...[
                                  const Divider(height: 20),
                                  _scoreTile(2, _skorLevel2,
                                      _maxQuestionsPerLevel[2]!, AppColors.warning),
                                ],
                                if (_levelTerbuka >= 3) ...[
                                  const Divider(height: 20),
                                  _scoreTile(3, _skorLevel3,
                                      _maxQuestionsPerLevel[3]!, AppColors.danger),
                                ],
                                if (_levelTerbuka < 3) ...[
                                  const Divider(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.lock_rounded,
                                            color: AppColors.textLight,
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Selesaikan level sebelumnya untuk membuka lebih banyak',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Motivation
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPale,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.15),
                                  width: 1),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_rounded,
                                    color: AppColors.primary, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _getMotivationMessage(),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Reset button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: _showResetDialog,
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 18),
                              label: const Text('Reset Seluruh Progres'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: BorderSide(
                                    color: AppColors.danger.withOpacity(0.4),
                                    width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                textStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _levelRow(int level, bool isUnlocked) {
    const levelColors = [AppColors.success, AppColors.warning, AppColors.danger];
    const levelLabels = ['Level 1 - Dasar', 'Level 2 - Menengah', 'Level 3 - Mahir'];
    final color = levelColors[level - 1];
    final label = levelLabels[level - 1];
    final targetPoin = level == 2 ? 50 : (level == 3 ? 120 : 0);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isUnlocked ? color.withOpacity(0.1) : AppColors.inputBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$level',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? color : AppColors.textLight,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              Text(
                isUnlocked ? '✅ Terbuka' : '🔒 Terkunci',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isUnlocked ? AppColors.success : AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
        if (!isUnlocked && level > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Butuh $targetPoin Poin',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ),
      ],
    );
  }

  Widget _scoreTile(int level, int score, int maxScore, Color color) {
    final pct = (score / maxScore * 100).toInt();
    const levelNames = ['Level 1 - Dasar', 'Level 2 - Menengah', 'Level 3 - Mahir'];

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    levelNames[level - 1],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (score / maxScore).clamp(0.0, 1.0),
                      backgroundColor: AppColors.inputBg,
                      color: color,
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$score/$maxScore',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        if (pct > 0)
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 4),
            child: Row(
              children: [
                Icon(Icons.star_rounded, size: 11, color: color),
                const SizedBox(width: 4),
                Text(
                  '$pct% penguasaan materi',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    color: AppColors.dangerLight, shape: BoxShape.circle),
                child: const Icon(Icons.delete_rounded,
                    color: AppColors.danger, size: 30),
              ),
              const SizedBox(height: 14),
              Text('Reset Progres?',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Semua poin dan skor akan dihapus. Apakah Anda yakin?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Batal',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _storage.resetProgress();
                        await _loadData();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Progres berhasil direset'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Reset',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
