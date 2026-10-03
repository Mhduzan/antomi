-- Skema database Antomi
-- Import sekali lewat phpMyAdmin (tab SQL -> paste -> Go)
--
-- CATATAN: utf8mb4 itu WAJIB, bukan utf8 biasa.
-- Avatar user disimpan sebagai emoji (🦁, 🐯, ...) dan emoji butuh 4 byte.
-- Kalau pakai utf8 biasa, avatar bakal jadi '????' atau query-nya error.

CREATE TABLE IF NOT EXISTS quiz_users (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(60)  NOT NULL,
  avatar     VARCHAR(16)  DEFAULT NULL,
  is_admin   TINYINT(1)   NOT NULL DEFAULT 0,
  created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quiz_scores (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  quiz_user_id  INT          NOT NULL,
  activity_type VARCHAR(20)  NOT NULL,   -- 'quiz' | 'word_guess' | 'matching'
  level         INT          DEFAULT NULL,
  score         INT          NOT NULL DEFAULT 0,
  max_score     INT          DEFAULT NULL,
  created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_user (quiz_user_id),
  KEY idx_user_created (quiz_user_id, created_at),
  CONSTRAINT fk_scores_user FOREIGN KEY (quiz_user_id)
    REFERENCES quiz_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
