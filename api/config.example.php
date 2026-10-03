<?php
// Salin file ini jadi `config.php`, lalu isi sesuai kredensial Hostinger.
// `config.php` TIDAK ikut ke Git (lihat .gitignore) supaya password
// database tidak ikut ke-push ke GitHub.

return [
    // Dari hPanel -> Databases -> MySQL Databases.
    // Nama database & user biasanya berprefix, contoh: u123456789_antomi
    'db_host' => 'localhost',
    'db_name' => 'GANTI_NAMA_DATABASE',
    'db_user' => 'GANTI_USER_DATABASE',
    'db_pass' => 'GANTI_PASSWORD_DATABASE',

    // Harus SAMA PERSIS dengan QuizService.apiKey di aplikasi Flutter.
    // Ganti jadi string acak panjang, jangan 'rahasia123'.
    'api_key' => 'GANTI_API_KEY_ACAK_PANJANG',
];
