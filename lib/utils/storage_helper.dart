import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String totalPoinKey = 'total_poin';
  static const String levelTerbukaKey = 'level_terbuka';
  static const String skorLevel1Key = 'skor_level1';
  static const String skorLevel2Key = 'skor_level2';
  static const String skorLevel3Key = 'skor_level3';

  Future<void> saveTotalPoin(int poin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(totalPoinKey, poin);
  }

  Future<int> getTotalPoin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(totalPoinKey) ?? 0;
  }

  Future<void> saveLevelTerbuka(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(levelTerbukaKey, level);
  }

  Future<int> getLevelTerbuka() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(levelTerbukaKey) ?? 1;
  }

  Future<void> saveSkorLevel(int level, int skor) async {
    final prefs = await SharedPreferences.getInstance();
    String key;
    if (level == 1) {
      key = skorLevel1Key;
    } else if (level == 2) {
      key = skorLevel2Key;
    } else {
      key = skorLevel3Key;
    }
    
    int currentBest = await getSkorLevel(level);
    if (skor > currentBest) {
      await prefs.setInt(key, skor);
    }
  }

  Future<int> getSkorLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    if (level == 1) return prefs.getInt(skorLevel1Key) ?? 0;
    if (level == 2) return prefs.getInt(skorLevel2Key) ?? 0;
    return prefs.getInt(skorLevel3Key) ?? 0;
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}