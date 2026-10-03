<?php
// Koneksi database + helper kecil yang dipakai index.php

function config(): array
{
    static $cfg = null;
    if ($cfg === null) {
        $path = __DIR__ . '/config.php';
        if (!file_exists($path)) {
            http_response_code(500);
            echo json_encode(['error' => 'config.php belum dibuat di server']);
            exit;
        }
        $cfg = require $path;
    }
    return $cfg;
}

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $c = config();
        // charset=utf8mb4 wajib, kalau tidak avatar emoji jadi rusak
        $dsn = "mysql:host={$c['db_host']};dbname={$c['db_name']};charset=utf8mb4";
        $pdo = new PDO($dsn, $c['db_user'], $c['db_pass'], [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    }
    return $pdo;
}

/// Balas JSON lalu berhenti.
/// JSON_UNESCAPED_UNICODE supaya emoji avatar terkirim apa adanya.
function json_out($data, int $status = 200): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

/// Ambil header X-API-KEY. Dicoba dari beberapa sumber karena tiap
/// konfigurasi server menaruhnya di tempat berbeda.
function request_api_key(): string
{
    if (!empty($_SERVER['HTTP_X_API_KEY'])) {
        return $_SERVER['HTTP_X_API_KEY'];
    }
    if (!empty($_SERVER['REDIRECT_HTTP_X_API_KEY'])) {
        return $_SERVER['REDIRECT_HTTP_X_API_KEY'];
    }
    if (function_exists('getallheaders')) {
        foreach (getallheaders() as $k => $v) {
            if (strcasecmp($k, 'X-API-KEY') === 0) {
                return $v;
            }
        }
    }
    return '';
}

function require_api_key(): void
{
    $expected = config()['api_key'];
    $given    = request_api_key();
    if ($given === '' || !hash_equals($expected, $given)) {
        json_out(['error' => 'API key tidak valid'], 401);
    }
}

/// Body JSON dari request.
function body(): array
{
    $raw = file_get_contents('php://input');
    if ($raw === '' || $raw === false) {
        return [];
    }
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}
