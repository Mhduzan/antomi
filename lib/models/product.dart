class Product {
  final int? id;
  final String barcode;
  final String name;
  final String category;
  final double hargaCash;
  final double hargaBonNormal;
  final double hargaBonWajib;
  final String? keterangan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.barcode,
    required this.name,
    required this.category,
    required this.hargaCash,
    required this.hargaBonNormal,
    required this.hargaBonWajib,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'category': category,
      'harga_cash': hargaCash,
      'harga_bon_normal': hargaBonNormal,
      'harga_bon_wajib': hargaBonWajib,
      'keterangan': keterangan ?? '',
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      hargaCash: (map['harga_cash'] as num).toDouble(),
      hargaBonNormal: (map['harga_bon_normal'] as num).toDouble(),
      hargaBonWajib: (map['harga_bon_wajib'] as num).toDouble(),
      keterangan: map['keterangan'],
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at']) : null,
    );
  }

  Product copyWith({
    int? id,
    String? barcode,
    String? name,
    String? category,
    double? hargaCash,
    double? hargaBonNormal,
    double? hargaBonWajib,
    String? keterangan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      category: category ?? this.category,
      hargaCash: hargaCash ?? this.hargaCash,
      hargaBonNormal: hargaBonNormal ?? this.hargaBonNormal,
      hargaBonWajib: hargaBonWajib ?? this.hargaBonWajib,
      keterangan: keterangan ?? this.keterangan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
