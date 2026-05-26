import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/storage_helper.dart';
import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _totalPoin = 0;
  int _levelTerbuka = 1;
  int _skorLevel1 = 0;
  int _skorLevel2 = 0;
  int _skorLevel3 = 0;
  late StorageHelper _storage;
  bool _isLoading = true;

  // Jumlah maksimal soal per level
  final Map<int, int> _maxQuestionsPerLevel = {
    1: 10,
    2: 20,
    3: 30,
  };

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    int poin = await _storage.getTotalPoin();
    int level = await _storage.getLevelTerbuka();
    int s1 = await _storage.getSkorLevel(1);
    int s2 = await _storage.getSkorLevel(2);
    int s3 = await _storage.getSkorLevel(3);
    
    setState(() {
      _totalPoin = poin;
      _levelTerbuka = level;
      _skorLevel1 = s1;
      _skorLevel2 = s2;
      _skorLevel3 = s3;
      _isLoading = false;
    });
  }

  String _getLevelTitle(int level) {
    switch (level) {
      case 1:
        return 'Level 1 - Dasar';
      case 2:
        return 'Level 2 - Menengah';
      case 3:
        return 'Level 3 - Mahir';
      default:
        return 'Level $level';
    }
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return AppColors.success;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  String _getAchievementLevel() {
    double persentase = (_totalPoin / 300) * 100; // Max poin 300 (10+20+30 soal * 10 poin)
    if (persentase >= 90) return '🏆 Master Anatomi';
    if (persentase >= 70) return '⭐ Ahli Anatomi';
    if (persentase >= 50) return '📚 Pelajar Rajin';
    if (persentase >= 30) return '🌱 Pemula Semangat';
    return '🎯 Mulai Belajar';
  }

  String _getMotivationMessage() {
    if (_levelTerbuka >= 3 && _skorLevel3 >= 30) {
      return '✨ Luar biasa! Kamu telah menguasai semua materi anatomi! ✨';
    }
    if (_levelTerbuka >= 2) {
      return '💪 Terus semangat! Kamu sudah menguasai level menengah!';
    }
    if (_totalPoin > 0) {
      return '📖 Bagus! Terus belajar dan kumpulkan poin untuk membuka level berikutnya!';
    }
    return '🎯 Mulai quiz pertamamu untuk belajar anatomi tubuh!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Belajarku',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF0F4F8)],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Antomi Learner',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getAchievementLevel(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Total Poin Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.warning, AppColors.warning.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warning.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.stars, color: Colors.white, size: 32),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Poin',
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '$_totalPoin',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: (_totalPoin / 300).clamp(0.0, 1.0),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: Colors.white,
                            minHeight: 6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Target: 300 Poin untuk Master',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Level Progress Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock_open, color: AppColors.success, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  'Level Terbuka',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Level $_levelTerbuka dari 3',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildLevelProgress(),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Skor Tertinggi per Level
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.assessment, color: AppColors.primary, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  'Riwayat Belajar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildScoreTile(
                              level: 1,
                              score: _skorLevel1,
                              maxScore: _maxQuestionsPerLevel[1]!,
                              color: AppColors.success,
                              unlocked: true,
                            ),
                            if (_levelTerbuka >= 2)
                              _buildScoreTile(
                                level: 2,
                                score: _skorLevel2,
                                maxScore: _maxQuestionsPerLevel[2]!,
                                color: AppColors.warning,
                                unlocked: true,
                              ),
                            if (_levelTerbuka >= 3)
                              _buildScoreTile(
                                level: 3,
                                score: _skorLevel3,
                                maxScore: _maxQuestionsPerLevel[3]!,
                                color: AppColors.danger,
                                unlocked: true,
                              ),
                            if (_levelTerbuka < 3)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.lock, color: Colors.grey.shade600, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Selesaikan level sebelumnya untuk membuka level berikutnya',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Motivational Message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue.shade50, Colors.indigo.shade50],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.blue, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getMotivationMessage(),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Reset Button
                    ElevatedButton.icon(
                      onPressed: () => _showResetDialog(),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Reset Seluruh Progres'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLevelProgress() {
    return Column(
      children: [
        _buildLevelProgressItem(1, _levelTerbuka >= 1),
        const SizedBox(height: 12),
        _buildLevelProgressItem(2, _levelTerbuka >= 2),
        const SizedBox(height: 12),
        _buildLevelProgressItem(3, _levelTerbuka >= 3),
      ],
    );
  }

  Widget _buildLevelProgressItem(int level, bool isUnlocked) {
    Color color = _getLevelColor(level);
    String status = isUnlocked ? '✅ Terbuka' : '🔒 Terkunci';
    int targetPoin = level == 2 ? 50 : (level == 3 ? 120 : 0);
    
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                _getLevelTitle(level),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isUnlocked ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (!isUnlocked && level > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Butuh $targetPoin Poin',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScoreTile({
    required int level,
    required int score,
    required int maxScore,
    required Color color,
    required bool unlocked,
  }) {
    double percentage = (score / maxScore) * 100;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
                      _getLevelTitle(level),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (score / maxScore).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      color: color,
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$score/$maxScore',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (percentage > 0)
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 4),
              child: Row(
                children: [
                  Icon(Icons.star, size: 12, color: color),
                  const SizedBox(width: 4),
                  Text(
                    '${percentage.toInt()}% penguasaan materi',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Progres?'),
        content: Text(
          'Semua poin dan skor akan dihapus. Apakah Anda yakin?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _storage.resetProgress();
              await _loadData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Progres berhasil direset'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}