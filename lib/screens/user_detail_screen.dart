// lib/screens/user_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../services/quiz_service.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  final String userName;
  const UserDetailScreen({super.key, required this.userId, required this.userName});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _quizService = QuizService();
  Map<String, dynamic>? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final detail = await _quizService.getUserDetail(widget.userId);
      if (mounted) setState(() { _detail = detail; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Gagal ambil data'; _loading = false; });
    }
  }

  String _labelActivity(String type) {
    switch (type) {
      case 'quiz': return 'Quiz';
      case 'word_guess': return 'Tebak Gambar';
      case 'matching': return 'Puzzle Matching';
      default: return type;
    }
  }

  IconData _iconActivity(String type) {
    switch (type) {
      case 'quiz': return Icons.quiz_rounded;
      case 'word_guess': return Icons.extension_rounded;
      case 'matching': return Icons.grid_view_rounded;
      default: return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final scores = (_detail?['scores'] as List?) ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(r.pad, r.padXs, r.pad, r.pad),
                child: Column(children: [
                  Row(children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                    SizedBox(width: r.padSm - 4),
                    if (_detail != null) ...[
                      Container(
                        width: r.w(32), height: r.w(32),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(child: Text((_detail!['avatar'] ?? '👤').toString(), style: TextStyle(fontSize: r.sp(16)))),
                      ),
                      SizedBox(width: r.padSm),
                    ],
                    Expanded(
                      child: Text(widget.userName,
                          style: GoogleFonts.poppins(fontSize: r.sp(18), fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ]),
                  if (_detail != null) ...[
                    SizedBox(height: r.h(12)),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: r.h(14)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(r.radiusLg),
                      ),
                      child: Column(children: [
                        Text('${_detail!['total_poin'] ?? 0}',
                            style: GoogleFonts.poppins(fontSize: r.sp(26), fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('Total Poin', style: GoogleFonts.inter(fontSize: r.sp(12), color: Colors.white.withOpacity(0.85))),
                      ]),
                    ),
                  ],
                ]),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _error != null
                    ? Center(child: Text(_error!, style: GoogleFonts.inter(color: AppColors.textSecondary)))
                    : scores.isEmpty
                        ? Center(child: Text('Belum ada aktivitas', style: GoogleFonts.inter(color: AppColors.textSecondary)))
                        : ListView.separated(
                            padding: EdgeInsets.all(r.pad),
                            itemCount: scores.length,
                            separatorBuilder: (_, __) => SizedBox(height: r.h(8)),
                            itemBuilder: (_, i) {
                              final s = scores[i] as Map<String, dynamic>;
                              final type = (s['activity_type'] ?? '').toString();
                              final level = s['level'];
                              final score = s['score'] ?? 0;
                              final maxScore = s['max_score'];

                              return Container(
                                padding: EdgeInsets.all(r.pad - 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(r.radiusLg),
                                  border: Border.all(color: AppColors.divider),
                                ),
                                child: Row(children: [
                                  Container(
                                    width: r.w(36), height: r.w(36),
                                    decoration: BoxDecoration(color: AppColors.primaryPale, shape: BoxShape.circle),
                                    child: Icon(_iconActivity(type), color: AppColors.primary, size: r.iconSm),
                                  ),
                                  SizedBox(width: r.padSm),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(_labelActivity(type),
                                          style: GoogleFonts.poppins(fontSize: r.sp(13), fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                      if (level != null)
                                        Text('Level $level', style: GoogleFonts.inter(fontSize: r.sp(11), color: AppColors.textSecondary)),
                                    ]),
                                  ),
                                  Text(
                                    maxScore != null ? '$score/$maxScore' : '$score',
                                    style: GoogleFonts.poppins(fontSize: r.sp(14), fontWeight: FontWeight.w800, color: AppColors.primary),
                                  ),
                                ]),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
