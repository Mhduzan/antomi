import 'package:flutter/material.dart';
import '../utils/storage_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _storage = StorageHelper();
    _loadData();
  }

  Future<void> _loadData() async {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'Total Poin: $_totalPoin',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_open, color: Colors.green),
                title: const Text('Level Terbuka'),
                trailing: Text('Level $_levelTerbuka dari 3', style: const TextStyle(fontSize: 18)),
              ),
            ),
            const Divider(),
            const ListTile(title: Text('Skor Tertinggi Quiz:', style: TextStyle(fontWeight: FontWeight.bold))),
            ListTile(leading: const Text('Level 1'), trailing: Text('$_skorLevel1 / 3')),
            if (_levelTerbuka >= 2) ListTile(leading: const Text('Level 2'), trailing: Text('$_skorLevel2 / 2')),
            if (_levelTerbuka >= 3) ListTile(leading: const Text('Level 3'), trailing: Text('$_skorLevel3 / 1')),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await _storage.resetProgress();
                await _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progres berhasil direset')),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('Reset Progres'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}