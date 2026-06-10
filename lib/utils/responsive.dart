// lib/utils/responsive.dart
//
// Helper untuk layout responsif berbasis ukuran layar nyata.
// Gunakan R.of(context) untuk mendapat instance, lalu akses:
//   R.sp(14)   → font size yang disesuaikan layar
//   R.h(100)   → height yang disesuaikan layar
//   R.w(50)    → width yang disesuaikan layar
//   R.hp(0.3)  → 30% dari tinggi layar
//   R.wp(0.5)  → 50% dari lebar layar
//   R.pad      → padding umum (16–20px)
//   R.padSm    → padding kecil (8–12px)
//   R.isSmall  → true jika lebar < 360px (HP kecil)
//   R.isMedium → 360–414px
//   R.isLarge  → > 414px

import 'package:flutter/material.dart';

class R {
  final double _w;
  final double _h;
  final double _pxRatio;

  R._(this._w, this._h, this._pxRatio);

  factory R.of(BuildContext context) {
    final mq = MediaQuery.of(context);
    return R._(mq.size.width, mq.size.height, mq.devicePixelRatio);
  }

  // ── Breakpoints ─────────────────────────────────────────────
  bool get isSmall  => _w < 360;
  bool get isMedium => _w >= 360 && _w < 415;
  bool get isLarge  => _w >= 415;

  // ── Skala referensi: desain di 390px (iPhone 14) ────────────
  static const double _baseW = 390.0;
  static const double _baseH = 844.0;

  double get _scaleW => (_w / _baseW).clamp(0.75, 1.3);
  double get _scaleH => (_h / _baseH).clamp(0.75, 1.3);

  // ── Font size: ikut lebar layar, clamp agar tidak terlalu kecil/besar
  double sp(double size) => (size * _scaleW).clamp(size * 0.8, size * 1.2);

  // ── Height: ikut tinggi layar
  double h(double size) => size * _scaleH;

  // ── Width: ikut lebar layar
  double w(double size) => size * _scaleW;

  // ── Persentase layar
  double hp(double pct) => _h * pct;
  double wp(double pct) => _w * pct;

  // ── Padding standar
  double get pad    => isSmall ? 12.0 : (isLarge ? 20.0 : 16.0);
  double get padSm  => isSmall ? 8.0  : (isLarge ? 14.0 : 10.0);
  double get padXs  => isSmall ? 4.0  : 8.0;

  // ── Border radius
  double get radius    => 14.0;
  double get radiusLg  => 20.0;
  double get radiusXl  => 28.0;

  // ── Icon size
  double get iconSm  => sp(16);
  double get iconMd  => sp(22);
  double get iconLg  => sp(28);

  // ── Button height
  double get btnH    => h(isSmall ? 44 : 50);
  double get btnHSm  => h(isSmall ? 38 : 44);

  // ── Avatar / logo size
  double get avatarSm => w(40);
  double get avatarMd => w(56);
  double get avatarLg => w(80);
  double get logoSz   => w(isSmall ? 90 : (isLarge ? 130 : 110));

  // ── Image height (gambar soal)
  double get imgH    => hp(isSmall ? 0.18 : 0.22);

  // ── Card grid aspect ratio
  double get gridAspect => isSmall ? 0.95 : 1.0;
}
