import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _db = DatabaseHelper();

  late TextEditingController _barcodeCtrl, _nameCtrl, _categoryCtrl,
      _cashCtrl, _bonNormalCtrl, _bonWajibCtrl, _keteranganCtrl;

  // FocusNode level halaman untuk scanner
  final FocusNode _pageFocus     = FocusNode();
  // FocusNode tiap field input manual
  final FocusNode _nameFocus     = FocusNode();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _cashFocus     = FocusNode();
  final FocusNode _bonNFocus     = FocusNode();
  final FocusNode _bonWFocus     = FocusNode();
  final FocusNode _ketFocus      = FocusNode();

  // Scanner buffer
  final StringBuffer _buf = StringBuffer();
  DateTime _lastKey = DateTime(0);
  static const _kTimeout = Duration(milliseconds: 80);

  bool _scanned = false;
  bool _saving  = false;
  bool get _isEdit => widget.product != null;

  // true kalau ada field input yang sedang fokus
  bool get _inputActive =>
      _nameFocus.hasFocus || _categoryFocus.hasFocus ||
      _cashFocus.hasFocus  || _bonNFocus.hasFocus    ||
      _bonWFocus.hasFocus  || _ketFocus.hasFocus;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _barcodeCtrl  = TextEditingController(text: p?.barcode ?? '');
    _nameCtrl     = TextEditingController(text: p?.name ?? '');
    _categoryCtrl = TextEditingController(text: p?.category ?? '');
    _cashCtrl     = TextEditingController(text: p != null ? p.hargaCash.toInt().toString() : '');
    _bonNormalCtrl= TextEditingController(text: p != null ? p.hargaBonNormal.toInt().toString() : '');
    _bonWajibCtrl = TextEditingController(text: p != null ? p.hargaBonWajib.toInt().toString() : '');
    _keteranganCtrl = TextEditingController(text: p?.keterangan ?? '');
    if (p?.barcode != null && p!.barcode.isNotEmpty) _scanned = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _pageFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in [_barcodeCtrl, _nameCtrl, _categoryCtrl,
        _cashCtrl, _bonNormalCtrl, _bonWajibCtrl, _keteranganCtrl]) c.dispose();
    for (final f in [_pageFocus, _nameFocus, _categoryFocus,
        _cashFocus, _bonNFocus, _bonWFocus, _ketFocus]) f.dispose();
    super.dispose();
  }

  // ─── Tangkap keystroke scanner HID ────────────────────────────────────────
  void _onKey(KeyEvent e) {
    if (e is! KeyDownEvent) return;
    if (_inputActive) return; // user sedang isi field

    final now = DateTime.now();
    if (now.difference(_lastKey) > _kTimeout) _buf.clear();
    _lastKey = now;

    final key = e.logicalKey;
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      final raw = _buf.toString().trim();
      _buf.clear();
      if (raw.isNotEmpty) _processScan(raw);
      return;
    }

    final ch = e.character;
    if (ch != null && ch.isNotEmpty && !ch.contains('\n') && !ch.contains('\r')) {
      _buf.write(ch);
      setState(() => _barcodeCtrl.text = _buf.toString());
    }
  }

  bool _isBarcode(String s) {
    if (s.length < 5 || s.length > 14) return false;
    if (s.startsWith('http') || s.contains('://')) return false;
    if (s.contains(' ')) return false;
    return true;
  }

  void _processScan(String raw) {
    if (!_isBarcode(raw)) {
      _snack('Bukan barcode produk — scan ulang', Colors.orange.shade700, Icons.block);
      setState(() { _barcodeCtrl.clear(); _scanned = false; });
      _pageFocus.requestFocus();
      return;
    }
    setState(() { _barcodeCtrl.text = raw; _scanned = true; });
    _snack('Barcode terbaca: $raw', Colors.green, Icons.check_circle);
    // Pindah ke nama setelah scan
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _nameFocus.requestFocus();
    });
  }

  void _resetBarcode() {
    _buf.clear();
    setState(() { _barcodeCtrl.clear(); _scanned = false; });
    _pageFocus.requestFocus();
  }

  void _snack(String msg, Color bg, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg, style: const TextStyle(fontSize: 13))),
      ]),
      backgroundColor: bg,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _save() async {
    if (_barcodeCtrl.text.trim().isEmpty) {
      _snack('Barcode belum di-scan', Colors.red, Icons.warning);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final p = Product(
        id: widget.product?.id,
        barcode: _barcodeCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        category: _categoryCtrl.text.trim(),
        hargaCash: double.tryParse(_cashCtrl.text.trim()) ?? 0,
        hargaBonNormal: double.tryParse(_bonNormalCtrl.text.trim()) ?? 0,
        hargaBonWajib: double.tryParse(_bonWajibCtrl.text.trim()) ?? 0,
        keterangan: _keteranganCtrl.text.trim(),
      );
      if (_isEdit) await _db.updateProduct(p); else await _db.insertProduct(p);
      if (mounted) {
        _snack(_isEdit ? 'Produk berhasil diupdate' : 'Produk berhasil ditambahkan',
            Colors.green, Icons.check_circle);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) _snack('Gagal: ${e.toString()}', Colors.red, Icons.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _pageFocus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk'),
          actions: [
            _saving
                ? const Center(child: Padding(padding: EdgeInsets.only(right: 16),
                    child: SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))))
                : TextButton.icon(onPressed: _save,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Simpan', style: TextStyle(color: Colors.white))),
          ],
        ),
        body: GestureDetector(
          // Tap area kosong → scanner aktif lagi
          onTap: () { FocusScope.of(context).unfocus(); _pageFocus.requestFocus(); },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                _label('INFORMASI PRODUK'),
                const SizedBox(height: 8),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                  _barcodeField(),
                  const SizedBox(height: 12),
                  _field(_nameCtrl, _nameFocus, 'Nama Produk', Icons.inventory_2_outlined,
                      validator: (v) => v!.trim().isEmpty ? 'Wajib diisi' : null),
                  const SizedBox(height: 12),
                  _field(_categoryCtrl, _categoryFocus, 'Kategori (opsional)', Icons.category_outlined),
                  const SizedBox(height: 12),
                  _field(_keteranganCtrl, _ketFocus, 'Keterangan (opsional)', Icons.notes_outlined, maxLines: 2),
                ]))),

                const SizedBox(height: 16),
                _label('HARGA'),
                const SizedBox(height: 8),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                  _priceField(_cashCtrl, _cashFocus, 'Harga Cash',
                      AppTheme.cashColor, AppTheme.cashLight, Icons.payments_outlined),
                  const SizedBox(height: 12),
                  _priceField(_bonNormalCtrl, _bonNFocus, 'Harga Bon Normal',
                      AppTheme.bonNormalColor, AppTheme.bonNormalLight, Icons.receipt_long_outlined),
                  const SizedBox(height: 12),
                  _priceField(_bonWajibCtrl, _bonWFocus, 'Harga Bon Wajib',
                      AppTheme.bonWajibColor, AppTheme.bonWajibLight, Icons.assignment_outlined),
                ]))),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save),
                  label: Text(_isEdit ? 'Update Produk' : 'Simpan Produk'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Barcode field (display only) ─────────────────────────────────────────
  Widget _barcodeField() {
    final hasBarcode = _barcodeCtrl.text.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Icon(_scanned ? Icons.check_circle : Icons.qr_code_scanner, size: 15,
            color: _scanned ? Colors.green : AppTheme.primaryLight),
        const SizedBox(width: 6),
        Text(
          _scanned ? 'Tap untuk scan ulang / ganti barcode' : 'Arahkan scanner ke barcode produk',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              color: _scanned ? Colors.green.shade700 : AppTheme.textSecondary),
        ),
      ]),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: _resetBarcode,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: _scanned ? Colors.green.shade50 : AppTheme.accentLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _scanned ? Colors.green.shade300 : AppTheme.accent.withOpacity(0.4),
              width: _scanned ? 1.5 : 1,
            ),
          ),
          child: Row(children: [
            Icon(_scanned ? Icons.check_circle_outline : Icons.qr_code,
                color: _scanned ? Colors.green : AppTheme.primaryLight, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(
              hasBarcode ? _barcodeCtrl.text : 'Tap di sini untuk reset & scan ulang...',
              style: TextStyle(
                fontFamily: hasBarcode ? 'monospace' : null,
                fontSize: hasBarcode ? 16 : 13,
                fontWeight: hasBarcode ? FontWeight.w700 : FontWeight.normal,
                color: _scanned ? Colors.green.shade700 : hasBarcode ? AppTheme.textPrimary : AppTheme.textHint,
                letterSpacing: hasBarcode ? 1 : 0,
              ),
            )),
            if (hasBarcode)
              Icon(Icons.refresh, size: 18,
                  color: _scanned ? Colors.green.shade400 : AppTheme.textHint),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppTheme.surface,
            borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.divider)),
        child: const Row(children: [
          Icon(Icons.info_outline, size: 14, color: AppTheme.textHint),
          SizedBox(width: 8),
          Expanded(child: Text('Scanner langsung aktif — tidak perlu tap field barcode',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
        ]),
      ),
    ]);
  }

  Widget _label(String t) => Text(t, style: const TextStyle(
      fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2));

  Widget _field(TextEditingController ctrl, FocusNode fn, String label, IconData icon,
      {String? Function(String?)? validator, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl, focusNode: fn, maxLines: maxLines, validator: validator,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _priceField(TextEditingController ctrl, FocusNode fn,
      String label, Color color, Color bg, IconData icon) {
    return TextFormField(
      controller: ctrl, focusNode: fn,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      validator: (v) {
        if (v == null || v.trim().isEmpty) return '$label wajib diisi';
        if (double.tryParse(v) == null) return 'Format tidak valid';
        return null;
      },
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: color),
        prefixText: 'Rp ', filled: true, fillColor: bg, labelStyle: TextStyle(color: color),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
      ),
    );
  }
}
