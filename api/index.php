<?php
// API Antomi — Quiz Anatomi
//
// Endpoint (semua butuh header X-API-KEY, kecuali /health):
//   GET    /api/health
//   POST   /api/quiz-users                  {name, avatar}  -> {id, name, avatar, is_admin}
//   GET    /api/quiz-users                                  -> [{id, name, avatar, is_admin, total_poin}]
//   GET    /api/quiz-users/{id}                             -> {..., total_poin, scores:[...]}
//   PATCH  /api/quiz-users/{id}/make-admin                  -> {ok:true}
//   POST   /api/quiz-scores    {quiz_user_id, activity_type, level, score, max_score}
//
// PENTING soal tipe data: PDO MySQL mengembalikan angka sebagai string.
// Aplikasi Flutter melakukan `u['id'] as int` dan `map['is_admin'] == true`,
// jadi kalau JSON-nya berisi "5" atau 1 (bukan 5 dan true), aplikasi crash
// atau status admin tidak pernah terdeteksi. Karena itu setiap nilai
// di-cast eksplisit sebelum dikirim -- lihat helper user_out()/score_out().

require __DIR__ . '/db.php';

// ── Routing ──────────────────────────────────────────────────────────────
$method = $_SERVER['REQUEST_METHOD'];
$uri    = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

// Buang prefix folder tempat index.php berada (mis. '/api')
$base = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '')), '/');
if ($base !== '' && $base !== '/' && strpos($uri, $base) === 0) {
    $uri = substr($uri, strlen($base));
}
$path = trim($uri, '/');
$seg  = $path === '' ? [] : explode('/', $path);

try {
    // Health check — sengaja tanpa API key supaya bisa dibuka dari browser
    // untuk memastikan deploy & koneksi database sudah benar.
    if ($method === 'GET' && ($seg[0] ?? '') === 'health') {
        db()->query('SELECT 1');
        json_out(['ok' => true, 'db' => 'connected', 'time' => date('c')]);
    }

    require_api_key();

    // ── /quiz-users ──────────────────────────────────────────────────────
    if (($seg[0] ?? '') === 'quiz-users') {

        // POST /quiz-users  — daftar nama (atau masuk lagi dengan nama yang sama)
        if ($method === 'POST' && count($seg) === 1) {
            $in     = body();
            $name   = trim((string)($in['name'] ?? ''));
            $avatar = isset($in['avatar']) ? (string)$in['avatar'] : null;

            if ($name === '') {
                json_out(['error' => 'Nama tidak boleh kosong'], 422);
            }
            // mbstring belum tentu aktif di hosting murah, jadi ada cadangan.
            $panjang = function_exists('mb_strlen') ? mb_strlen($name) : strlen($name);
            if ($panjang > 60) {
                json_out(['error' => 'Nama terlalu panjang (maks 60 karakter)'], 422);
            }

            // Cari dulu berdasarkan nama. Kalau sudah ada, pakai akun itu —
            // jadi user yang install ulang aplikasi atau menekan "Reset Progres"
            // tetap kembali ke akun lama, poin di server tidak hilang.
            $st = db()->prepare('SELECT * FROM quiz_users WHERE name = ? LIMIT 1');
            $st->execute([$name]);
            $user = $st->fetch();

            if ($user) {
                if ($avatar !== null && $avatar !== $user['avatar']) {
                    db()->prepare('UPDATE quiz_users SET avatar = ? WHERE id = ?')
                        ->execute([$avatar, $user['id']]);
                    $user['avatar'] = $avatar;
                }
                json_out(user_out($user));
            }

            // User pertama otomatis jadi admin, supaya tidak perlu utak-atik
            // database manual untuk mengangkat admin pertama.
            $isFirst = (int)db()->query('SELECT COUNT(*) FROM quiz_users')->fetchColumn() === 0;

            $st = db()->prepare('INSERT INTO quiz_users (name, avatar, is_admin) VALUES (?, ?, ?)');
            $st->execute([$name, $avatar, $isFirst ? 1 : 0]);
            $id = (int)db()->lastInsertId();

            json_out([
                'id'       => $id,
                'name'     => $name,
                'avatar'   => $avatar,
                'is_admin' => $isFirst,
            ], 201);
        }

        // GET /quiz-users — daftar semua user + total poin (leaderboard & admin)
        if ($method === 'GET' && count($seg) === 1) {
            $rows = db()->query(
                'SELECT u.id, u.name, u.avatar, u.is_admin,
                        COALESCE(SUM(s.score), 0) AS total_poin
                   FROM quiz_users u
                   LEFT JOIN quiz_scores s ON s.quiz_user_id = u.id
                  GROUP BY u.id, u.name, u.avatar, u.is_admin
                  ORDER BY total_poin DESC, u.name ASC'
            )->fetchAll();

            json_out(array_map('user_out', $rows));
        }

        // GET /quiz-users/{id} — detail + riwayat aktivitas
        if ($method === 'GET' && count($seg) === 2) {
            $id = (int)$seg[1];

            $st = db()->prepare(
                'SELECT u.id, u.name, u.avatar, u.is_admin,
                        COALESCE(SUM(s.score), 0) AS total_poin
                   FROM quiz_users u
                   LEFT JOIN quiz_scores s ON s.quiz_user_id = u.id
                  WHERE u.id = ?
                  GROUP BY u.id, u.name, u.avatar, u.is_admin'
            );
            $st->execute([$id]);
            $user = $st->fetch();
            if (!$user) {
                json_out(['error' => 'User tidak ditemukan'], 404);
            }

            $st = db()->prepare(
                'SELECT id, activity_type, level, score, max_score, created_at
                   FROM quiz_scores
                  WHERE quiz_user_id = ?
                  ORDER BY created_at DESC, id DESC
                  LIMIT 100'
            );
            $st->execute([$id]);

            $out           = user_out($user);
            $out['scores'] = array_map('score_out', $st->fetchAll());
            json_out($out);
        }

        // PATCH /quiz-users/{id}/make-admin
        if ($method === 'PATCH' && count($seg) === 3 && $seg[2] === 'make-admin') {
            $id = (int)$seg[1];

            $st = db()->prepare('UPDATE quiz_users SET is_admin = 1 WHERE id = ?');
            $st->execute([$id]);
            if ($st->rowCount() === 0) {
                // rowCount 0 bisa berarti user tidak ada, atau sudah admin
                $chk = db()->prepare('SELECT id FROM quiz_users WHERE id = ?');
                $chk->execute([$id]);
                if (!$chk->fetch()) {
                    json_out(['error' => 'User tidak ditemukan'], 404);
                }
            }
            json_out(['ok' => true]);
        }
    }

    // ── POST /quiz-scores ────────────────────────────────────────────────
    if ($method === 'POST' && ($seg[0] ?? '') === 'quiz-scores' && count($seg) === 1) {
        $in     = body();
        $userId = (int)($in['quiz_user_id'] ?? 0);
        $type   = (string)($in['activity_type'] ?? '');
        $score  = (int)($in['score'] ?? 0);

        $allowed = ['quiz', 'word_guess', 'matching'];
        if ($userId <= 0 || !in_array($type, $allowed, true)) {
            json_out(['error' => 'Data tidak valid'], 422);
        }

        $chk = db()->prepare('SELECT id FROM quiz_users WHERE id = ?');
        $chk->execute([$userId]);
        if (!$chk->fetch()) {
            json_out(['error' => 'User tidak ditemukan'], 404);
        }

        $st = db()->prepare(
            'INSERT INTO quiz_scores (quiz_user_id, activity_type, level, score, max_score)
             VALUES (?, ?, ?, ?, ?)'
        );
        $st->execute([
            $userId,
            $type,
            isset($in['level']) && $in['level'] !== null ? (int)$in['level'] : null,
            $score,
            isset($in['max_score']) && $in['max_score'] !== null ? (int)$in['max_score'] : null,
        ]);

        json_out(['ok' => true, 'id' => (int)db()->lastInsertId()], 201);
    }

    json_out(['error' => 'Endpoint tidak ditemukan', 'path' => $path, 'method' => $method], 404);

} catch (Throwable $e) {
    // Pesan asli tidak dibocorkan ke klien, hanya masuk log server.
    error_log('[antomi-api] ' . $e->getMessage());
    json_out(['error' => 'Terjadi kesalahan di server'], 500);
}

// ── Helper konversi tipe ─────────────────────────────────────────────────

function user_out(array $r): array
{
    $out = [
        'id'       => (int)$r['id'],
        'name'     => (string)$r['name'],
        'avatar'   => $r['avatar'],
        'is_admin' => (bool)(int)$r['is_admin'],
    ];
    if (array_key_exists('total_poin', $r)) {
        $out['total_poin'] = (int)$r['total_poin'];
    }
    return $out;
}

function score_out(array $r): array
{
    return [
        'id'            => (int)$r['id'],
        'activity_type' => (string)$r['activity_type'],
        'level'         => $r['level'] === null ? null : (int)$r['level'],
        'score'         => (int)$r['score'],
        'max_score'     => $r['max_score'] === null ? null : (int)$r['max_score'],
        'created_at'    => $r['created_at'],
    ];
}
