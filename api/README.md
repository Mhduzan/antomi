# API Antomi

Backend untuk aplikasi Anatomi Quiz Game. PHP 8 + MySQL, tanpa framework.
Dipakai untuk: pendaftaran nama, pencatatan skor quiz & game, leaderboard,
dan pengelolaan admin.

Target hosting: **Cloudhebat paket Micro (panel DirectAdmin)**. Karena ini PHP
polos tanpa framework, sebenarnya jalan di hosting PHP mana pun — cPanel,
DirectAdmin, atau Plesk — tanpa perubahan kode. Butuh **PHP 7.4 ke atas**.
Langkah deploy lengkap ada di [`../RELEASE.md`](../RELEASE.md).

Folder ini **tidak ikut ter-build ke APK** — Flutter hanya membaca `lib/` dan
`assets/`. Deploy-nya terpisah: isi folder ini diunggah ke hosting.

## Isi folder

| File | Fungsi |
|---|---|
| `index.php` | Semua endpoint + routing |
| `db.php` | Koneksi PDO & helper |
| `config.example.php` | Contoh konfigurasi — salin jadi `config.php` |
| `schema.sql` | Struktur tabel, diimport sekali via phpMyAdmin |
| `.htaccess` | Rewrite ke `index.php` + proteksi file |

## Endpoint

Semua butuh header `X-API-KEY`, kecuali `/health`.

| Method | Path | Keterangan |
|---|---|---|
| `GET` | `/api/health` | Cek deploy & koneksi DB |
| `POST` | `/api/quiz-users` | Body `{name, avatar}` → `{id, name, avatar, is_admin}` |
| `GET` | `/api/quiz-users` | Daftar user + `total_poin`, urut poin tertinggi |
| `GET` | `/api/quiz-users/{id}` | Detail + `scores[]` (100 aktivitas terakhir) |
| `PATCH` | `/api/quiz-users/{id}/make-admin` | Jadikan admin |
| `POST` | `/api/quiz-scores` | Body `{quiz_user_id, activity_type, level, score, max_score}` |

`activity_type` yang diterima: `quiz`, `word_guess`, `matching`.

## Cara kerja pendaftaran

`POST /quiz-users` bersifat **cari-dulu-baru-buat**. Kalau nama sudah ada di
database, akun lama yang dikembalikan, bukan bikin akun baru. Efeknya:

- User install ulang aplikasi → poin di server tidak hilang.
- User menekan "Reset Progres" → identitas lokal terhapus, tapi begitu dia isi
  nama yang sama, dia kembali ke akun lama.

Konsekuensinya: **nama itu identitas**. Dua orang dengan nama persis sama akan
berbagi satu akun. Untuk satu kelas biasanya aman, tapi kalau ada dua "Dewi",
minta salah satunya pakai nama yang lebih spesifik.

User **pertama** yang mendaftar otomatis jadi admin, supaya tidak perlu
mengubah database manual.

## Batasan yang perlu diketahui

Endpoint `make-admin` hanya dijaga oleh `X-API-KEY`, dan API key itu ikut
ter-compile ke dalam APK. Artinya orang yang membongkar APK secara teknis bisa
mengangkat dirinya jadi admin. Untuk aplikasi kelas/skripsi ini umumnya
dianggap cukup, tapi jangan simpan data sensitif di sini. Kalau mau
diperketat, endpoint ini perlu ikut memverifikasi identitas pemanggil — itu
butuh perubahan kecil di sisi aplikasi Flutter juga.
