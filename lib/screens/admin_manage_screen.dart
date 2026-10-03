// lib/screens/admin_manage_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../utils/responsive.dart';
import '../services/quiz_service.dart';
import 'user_detail_screen.dart';

class AdminManageScreen extends StatefulWidget {
  const AdminManageScreen({super.key});
  @override
  State<AdminManageScreen> createState() => _AdminManageScreenState();
}

class _AdminManageScreenState extends State<AdminManageScreen> {
  final _quizService = QuizService();
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;
  String? _error;
  int? _promotingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final users = await _quizService.getAllUsers();
      if (mounted) setState(() { _users = users; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'Gagal ambil data'; _loading = false; });
    }
  }

  Future<void> _promote(int userId) async {
    setState(() => _promotingId = userId);
    try {
      await _quizService.makeAdmin(userId);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil dijadikan admin')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal jadikan admin, coba lagi')),
        );
      }
    } finally {
      if (mounted) setState(() => _promotingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);

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
                child: Row(children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  SizedBox(width: r.padSm),
                  Text('Kelola Admin',
                      style: GoogleFonts.poppins(fontSize: r.sp(18), fontWeight: FontWeight.w700, color: Colors.white)),
                  const Spacer(),
                  IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded, color: Colors.white)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _error != null
                    ? Center(child: Text(_error!, style: GoogleFonts.inter(color: AppColors.textSecondary)))
                    : ListView.separated(
                        padding: EdgeInsets.all(r.pad),
                        itemCount: _users.length,
                        separatorBuilder: (_, __) => SizedBox(height: r.h(10)),
                        itemBuilder: (_, i) {
                          final u = _users[i];
                          final isAdmin = u['is_admin'] == true;
                          final avatar = (u['avatar'] ?? '👤').toString();
                          // Jangan pakai `as int`: kalau server mengirim id
                          // sebagai string, cast itu langsung bikin app crash.
                          final id = int.tryParse('${u['id']}') ?? 0;
                          final name = u['name'].toString();

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => UserDetailScreen(userId: id, userName: name)),
                            ),
                            child: Container(
                            padding: EdgeInsets.all(r.pad - 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(r.radiusLg),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(children: [
                              Container(
                                width: r.w(40), height: r.w(40),
                                decoration: BoxDecoration(color: AppColors.primaryPale, shape: BoxShape.circle),
                                child: Center(child: Text(avatar, style: TextStyle(fontSize: r.sp(20)))),
                              ),
                              SizedBox(width: r.padSm),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(u['name'].toString(),
                                      style: GoogleFonts.poppins(fontSize: r.sp(14), fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                  Text('${u['total_poin'] ?? 0} poin',
                                      style: GoogleFonts.inter(fontSize: r.sp(11), color: AppColors.textSecondary)),
                                ]),
                              ),
                              if (isAdmin)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: r.padSm, vertical: r.h(6)),
                                  decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20)),
                                  child: Text('Admin', style: GoogleFonts.inter(fontSize: r.sp(11), fontWeight: FontWeight.w700, color: AppColors.success)),
                                )
                              else
                                SizedBox(
                                  height: r.h(34),
                                  child: OutlinedButton(
                                    onPressed: _promotingId == id ? null : () => _promote(id),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.primary),
                                      padding: EdgeInsets.symmetric(horizontal: r.padSm),
                                    ),
                                    child: _promotingId == id
                                        ? SizedBox(
                                            width: 14, height: 14,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                                        : Text('Jadikan Admin',
                                            style: GoogleFonts.inter(fontSize: r.sp(11), fontWeight: FontWeight.w600, color: AppColors.primary)),
                                  ),
                                ),
                            ]),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
