# Checklist Rilis Antomi

Urutannya penting: API dulu, baru APK. Aplikasi butuh alamat API yang sudah
jadi sebelum di-build.

## A. Deploy API ke Cloudhebat (DirectAdmin)

Paket: **Micro, Rp15.000/bulan** — tagihan bulanan asli, tanpa kontrak.
Panelnya **DirectAdmin**, bukan cPanel.

Paket ini tidak memberi domain gratis, jadi domain dibeli terpisah. Termurah
**.my.id** sekitar Rp5.000/tahun (mis. di IDCloudHost atau registrar lain).

Kode API-nya jalan di **PHP 7.4 ke atas**, jadi versi PHP apa pun yang
tersedia di sana aman.

- [ ] **Beli domain & arahkan ke Cloudhebat.** Setelah pesan hosting, kamu
      dapat email berisi **nameserver** (biasanya `ns1.cloudhebat.com` dan
      `ns2.`). Masukkan itu di panel registrar tempat kamu beli domain.
      Propagasi bisa sampai beberapa jam.
- [ ] **Buat database.** DirectAdmin → **Account Manager → Databases** →
      **Create new Database**. DirectAdmin membuat database + user + hak
      aksesnya sekaligus dalam satu form (tidak seperti cPanel yang perlu
      langkah "Add User To Database" terpisah).
      Nama database dan user otomatis berprefix username DirectAdmin, contoh
      `zuednejw_antomi`. **Pakai nama berprefix itu** di `config.php`.
- [ ] **Import tabel.** DirectAdmin → **Extra Features → phpMyAdmin** → pilih
      database → tab **SQL** → paste isi [`api/schema.sql`](api/schema.sql)
      → Go. Harus muncul 2 tabel.
- [ ] **Upload.** DirectAdmin → **System Info & Files → File Manager**.
      Perhatikan: web root di DirectAdmin ada di
      **`domains/namadomainmu.my.id/public_html`**, bukan `public_html` di
      root seperti cPanel. Masuk ke situ, buat folder `api`, lalu upload
      `index.php`, `db.php`, `.htaccess`, `config.example.php`.
      Jangan upload `schema.sql` dan `README.md`.
- [ ] **Isi konfigurasi.** Rename `config.example.php` → `config.php`, isi
      kredensial database (host tetap `localhost`), dan ganti `api_key` jadi
      string acak panjang.
- [ ] **SSL.** DirectAdmin → **Account Manager → SSL Certificates** → pilih
      **Free & automatic certificate from Let's Encrypt** → Save.
      Lalu aktifkan **Force SSL/HTTPS redirect** di menu Domain Setup.
- [ ] **Tes:** buka `https://domainmu.my.id/api/health` di browser.
      Harus keluar `{"ok":true,"db":"connected",...}`.

> **Kalau nanti pindah hosting:** karena ini PHP polos tanpa framework,
> pindahnya cuma upload 4 file yang sama + import `schema.sql` di tempat baru,
> lalu ganti `baseUrl` di aplikasi. Tidak ada yang mengikat ke Cloudhebat.

## B. Siapkan aplikasi

- [ ] **Isi alamat API.** [`lib/services/quiz_service.dart`](lib/services/quiz_service.dart),
      dua baris bertanda `GANTI`:
      - `baseUrl` → `https://domainmu.com/api` (https, tanpa garis miring di akhir)
      - `apiKey` → sama persis dengan `api_key` di `config.php` server
- [ ] **Cek tidak ada error:** `flutter analyze` → harus 0 error, 0 warning.
- [ ] **Jalankan test:** `flutter test` → 4 test harus lolos.
- [ ] **Build:** `flutter build apk --release`
      APK ada di `build/app/outputs/flutter-apk/app-release.apk`

## C. Sebelum dibagikan ke user

- [ ] **Daftar duluan pakai HP sendiri.** User pertama yang mendaftar otomatis
      jadi admin. Kalau siswa yang duluan, dia yang jadi admin.
- [ ] **Tes satu putaran penuh:** isi nama → kerjakan 1 quiz → buka menu
      Peringkat → nama dan poin muncul.
- [ ] **Cek data masuk di phpMyAdmin:** tabel `quiz_users` dan `quiz_scores`
      terisi.
- [ ] **Tes mode offline:** matikan data HP, buka app baru, isi nama →
      harus muncul tombol "Main dulu tanpa daftar" dan quiz tetap bisa
      dimainkan.

## Yang belum dikerjakan (opsional)

- **Antrean skor offline.** Saat ini skor yang didapat sewaktu HP offline
  tidak dikirim menyusul ke server — poin lokal tetap aman, tapi tidak masuk
  peringkat. Kalau banyak user main di tempat bersinyal buruk, ini layak
  dibuat.
- **Kompresi aset.** 4 gambar di `assets/` berukuran 1,4–1,9 MB
  (`tebak gambar.png`, `quiz.png`, 2 file `Gemini_Generated_*`), total ~6,5 MB
  dari ukuran APK. Dikompres bisa hemat banyak.
- **`withOpacity` deprecated.** 130-an peringatan `info` dari `flutter
  analyze`. Tidak mengganggu jalannya aplikasi.
- **Keamanan endpoint admin.** Lihat catatan di [`api/README.md`](api/README.md).
