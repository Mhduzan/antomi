# 📦 Barcode Checker - Aplikasi Cek Harga 3 Jenis

Aplikasi Flutter untuk scan barcode dan menampilkan 3 jenis harga:
**Cash**, **Bon Normal**, dan **Bon Wajib**.

---

## 🚀 Cara Setup

### 1. Prerequisites
- Flutter SDK >= 3.0.0
- Android Studio / VS Code
- Android Tablet sebagai target device

### 2. Install Dependencies
```bash
cd barcode_checker
flutter pub get
```

### 3. Run ke Tablet
```bash
# Pastikan tablet sudah terhubung via USB & USB debugging aktif
flutter devices   # cek device terdeteksi
flutter run       # jalankan aplikasi
```

### 4. Build APK (untuk install langsung)
```bash
flutter build apk --release
# APK tersimpan di: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Fitur Aplikasi

| Fitur | Keterangan |
|-------|-----------|
| **Scan Barcode** | Support scanner Bluetooth & Kabel (HID keyboard mode) |
| **3 Harga** | Cash, Bon Normal, Bon Wajib tampil sekaligus |
| **Tambah Produk** | Form lengkap dengan validasi |
| **Edit Produk** | Update data produk yang sudah ada |
| **Hapus Produk** | Dengan konfirmasi sebelum hapus |
| **Cari Produk** | Search by nama, barcode, atau kategori |
| **Info DB** | Tampilkan path file .db untuk akses via PC |

---

## 🗄️ Database

- **Engine**: SQLite (`sqflite` package)
- **File**: `barcode_checker.db`
- **Struktur tabel `products`**:

```sql
CREATE TABLE products (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  barcode         TEXT NOT NULL UNIQUE,
  name            TEXT NOT NULL,
  category        TEXT NOT NULL DEFAULT '',
  harga_cash      REAL NOT NULL DEFAULT 0,
  harga_bon_normal REAL NOT NULL DEFAULT 0,
  harga_bon_wajib REAL NOT NULL DEFAULT 0,
  keterangan      TEXT DEFAULT '',
  created_at      TEXT NOT NULL,
  updated_at      TEXT NOT NULL
)
```

### Lokasi file .db di Android
```
/data/data/com.example.barcode_checker/databases/barcode_checker.db
```

### Cara buka file .db di PC
1. Download **DB Browser for SQLite**: https://sqlitebrowser.org
2. Hubungkan tablet ke PC via USB
3. Gunakan `adb pull` untuk copy file db:
   ```bash
   adb pull /data/data/com.example.barcode_checker/databases/barcode_checker.db ./
   ```
4. Buka file .db di DB Browser

> ⚠️ adb pull memerlukan device dalam mode USB Debugging

---

## 📡 Cara Pakai Scanner

Scanner barcode yang bekerja sebagai **HID Keyboard** (plug-and-play) langsung compatible:
- Hubungkan via **USB** → otomatis terdeteksi sebagai keyboard
- Pair via **Bluetooth** → otomatis terdeteksi sebagai keyboard
- Scan barcode → teks masuk ke field input → Enter otomatis → hasil langsung tampil

---

## 📁 Struktur Project

```
lib/
├── main.dart                    ← Entry point & navigasi utama
├── theme/
│   └── app_theme.dart           ← Warna & tema aplikasi
├── models/
│   └── product.dart             ← Model data produk
├── database/
│   └── database_helper.dart     ← CRUD SQLite
├── screens/
│   ├── scan_screen.dart         ← Halaman scan barcode
│   ├── product_list_screen.dart ← Daftar & kelola produk
│   └── product_form_screen.dart ← Form tambah/edit produk
└── widgets/
    └── price_card.dart          ← Widget tampilan harga
```

---

## 🔧 Kustomisasi

Untuk mengubah nama jenis harga, edit di:
- `lib/widgets/price_card.dart` → label display
- `lib/database/database_helper.dart` → nama kolom
- `lib/models/product.dart` → field model
- `lib/screens/product_form_screen.dart` → label form
