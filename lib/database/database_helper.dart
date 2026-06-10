import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'barcode_checker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        category TEXT NOT NULL DEFAULT '',
        harga_cash REAL NOT NULL DEFAULT 0,
        harga_bon_normal REAL NOT NULL DEFAULT 0,
        harga_bon_wajib REAL NOT NULL DEFAULT 0,
        keterangan TEXT DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Seed data contoh
    final now = DateTime.now().toIso8601String();
    await db.insert('products', {
      'barcode': '8992761140053',
      'name': 'Indomie Goreng Original',
      'category': 'Mie Instan',
      'harga_cash': 3500,
      'harga_bon_normal': 3700,
      'harga_bon_wajib': 4000,
      'keterangan': 'Mie goreng populer',
      'created_at': now,
      'updated_at': now,
    });
    await db.insert('products', {
      'barcode': '8996001300016',
      'name': 'Aqua 600ml',
      'category': 'Minuman',
      'harga_cash': 4000,
      'harga_bon_normal': 4200,
      'harga_bon_wajib': 4500,
      'keterangan': 'Air mineral botol',
      'created_at': now,
      'updated_at': now,
    });
    await db.insert('products', {
      'barcode': '8997015900027',
      'name': 'Teh Botol Sosro 450ml',
      'category': 'Minuman',
      'harga_cash': 5000,
      'harga_bon_normal': 5200,
      'harga_bon_wajib': 5500,
      'keterangan': 'Teh manis botol',
      'created_at': now,
      'updated_at': now,
    });
  }

  // ─── CREATE ───────────────────────────────────────────────────────────────
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      'products',
      product.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ─── READ ALL ─────────────────────────────────────────────────────────────
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products', orderBy: 'name ASC');
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  // ─── READ BY BARCODE ──────────────────────────────────────────────────────
  Future<Product?> getProductByBarcode(String barcode) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode.trim()],
    );
    if (maps.isEmpty) return null;
    return Product.fromMap(maps.first);
  }

  // ─── SEARCH ───────────────────────────────────────────────────────────────
  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where: 'name LIKE ? OR barcode LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // ─── COUNT ────────────────────────────────────────────────────────────────
  Future<int> getProductCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ─── GET CATEGORIES ───────────────────────────────────────────────────────
  Future<List<String>> getCategories() async {
    final db = await database;
    final maps = await db.rawQuery(
        'SELECT DISTINCT category FROM products WHERE category != "" ORDER BY category ASC');
    return maps.map((m) => m['category'] as String).toList();
  }

  // ─── GET DB PATH (untuk info) ─────────────────────────────────────────────
  Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'barcode_checker.db');
  }
}
