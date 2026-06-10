import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../models/product.dart';
import '../widgets/price_card.dart';
import '../theme/app_theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  final FocusNode _pageFocus = FocusNode();
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchCtrl = TextEditingController();

  Product? _foundProduct;
  bool _isLoading = false;
  bool _notFound = false;
  String _lastScanned = '';
  List<Product> _searchResults = [];
  bool _showDropdown = false;

  // Scanner buffer — cepat, timeout 80ms
  final StringBuffer _buf = StringBuffer();
  DateTime _lastKey = DateTime(0);
  static const _kTimeout = Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _pageFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _pageFocus.dispose();
    _searchFocus.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ─── Terima keystroke dari scanner HID ────────────────────────────────────
  void _onKey(KeyEvent e) {
    if (e is! KeyDownEvent) return;
    if (_searchFocus.hasFocus) return; // user sedang ketik nama

    final now = DateTime.now();
    if (now.difference(_lastKey) > _kTimeout) _buf.clear(); // reset kalau timeout
    _lastKey = now;

    final key = e.logicalKey;
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      final raw = _buf.toString().trim();
      _buf.clear();
      if (raw.isNotEmpty) _handleScan(raw);
      return;
    }

    final ch = e.character;
    if (ch != null && ch.isNotEmpty && !ch.contains('\n') && !ch.contains('\r')) {
      _buf.write(ch);
    }
  }

  // ─── Validasi barcode ─────────────────────────────────────────────────────
  bool _isBarcode(String s) {
    if (s.length < 5 || s.length > 14) return false;       // panjang 5–14
    if (s.startsWith('http') || s.contains('://')) return false; // bukan URL
    if (s.contains(' ')) return false;                       // bukan teks bebas
    return true;
  }

  // ─── Proses scan ──────────────────────────────────────────────────────────
  Future<void> _handleScan(String raw) async {
    if (!_isBarcode(raw)) {
      _snack('Bukan barcode produk (${raw.length} karakter): ${raw.length > 20 ? "${raw.substring(0,20)}..." : raw}',
          Colors.orange.shade700, Icons.block);
      return;
    }
    if (_showDropdown) _closeSearch();
    setState(() { _isLoading = true; _notFound = false; _foundProduct = null; _lastScanned = raw; });
    final p = await _db.getProductByBarcode(raw);
    if (!mounted) return;
    setState(() { _isLoading = false; _foundProduct = p; _notFound = p == null; });
    _pageFocus.requestFocus();
  }

  // ─── Search by nama ───────────────────────────────────────────────────────
  Future<void> _onSearch(String q) async {
    if (q.trim().isEmpty) { setState(() { _searchResults = []; _showDropdown = false; }); return; }
    final results = await _db.searchProducts(q.trim());
    if (!mounted) return;
    setState(() { _searchResults = results; _showDropdown = results.isNotEmpty; });
  }

  void _selectProduct(Product p) {
    setState(() {
      _foundProduct = p; _notFound = false; _lastScanned = p.barcode;
      _showDropdown = false; _searchResults = []; _searchCtrl.clear();
    });
    _searchFocus.unfocus();
    _pageFocus.requestFocus();
  }

  void _closeSearch() {
    setState(() { _showDropdown = false; _searchResults = []; _searchCtrl.clear(); });
  }

  void _clear() {
    setState(() { _foundProduct = null; _notFound = false; _lastScanned = ''; });
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

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _pageFocus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: GestureDetector(
        onTap: () {
          if (_showDropdown) _closeSearch();
          if (!_searchFocus.hasFocus) _pageFocus.requestFocus();
        },
        child: Scaffold(
          backgroundColor: AppTheme.surface,
          body: Column(children: [
            _buildHeader(),
            if (_showDropdown) _buildDropdown(),
            Expanded(child: _buildBody()),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryMid],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Status scanner
        const Text('SCAN BARCODE', style: TextStyle(
            color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isLoading ? AppTheme.accent : Colors.white.withOpacity(0.15),
              width: _isLoading ? 2 : 1,
            ),
          ),
          child: Row(children: [
            Icon(Icons.qr_code_scanner,
                color: _isLoading ? AppTheme.accent : Colors.white38, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(
              _isLoading ? 'Mencari produk...' : 'Arahkan scanner ke barcode produk...',
              style: TextStyle(
                color: _isLoading ? Colors.white : Colors.white38,
                fontSize: 13,
                fontStyle: _isLoading ? FontStyle.italic : FontStyle.normal,
              ),
            )),
            if (_isLoading)
              const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2)),
          ]),
        ),

        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Container(height: 1, color: Colors.white12)),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('atau cari nama produk',
                  style: TextStyle(color: Colors.white38, fontSize: 11))),
          Expanded(child: Container(height: 1, color: Colors.white12)),
        ]),
        const SizedBox(height: 12),

        const Text('CARI NAMA PRODUK', style: TextStyle(
            color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextField(
          controller: _searchCtrl,
          focusNode: _searchFocus,
          onChanged: _onSearch,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Ketik nama produk...',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: AppTheme.accent, size: 20),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                    onPressed: () { _closeSearch(); _pageFocus.requestFocus(); })
                : null,
            filled: true, fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.accent, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
          ),
        ),
      ]),
    );
  }

  Widget _buildDropdown() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: const BoxDecoration(color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
      child: ListView.separated(
        shrinkWrap: true, padding: EdgeInsets.zero,
        itemCount: _searchResults.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
        itemBuilder: (_, i) {
          final p = _searchResults[i];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.inventory_2_outlined, color: AppTheme.primary, size: 18),
            ),
            title: Text(p.name, style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textPrimary)),
            subtitle: Text('${p.category.isNotEmpty ? "${p.category} · " : ""}${p.barcode}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textHint)),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textHint, size: 18),
            onTap: () => _selectProduct(p),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
    if (_foundProduct != null) return _buildResult(_foundProduct!);
    if (_notFound) return _buildNotFound();
    return _buildEmpty();
  }

  Widget _buildResult(Product p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.divider)),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.inventory_2_outlined, color: AppTheme.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                if (p.category.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.accentLight,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(p.category, style: const TextStyle(
                        color: AppTheme.primaryLight, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ])),
            ]),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.qr_code, size: 13, color: AppTheme.textHint),
              const SizedBox(width: 6),
              Text(p.barcode, style: const TextStyle(
                  fontFamily: 'monospace', color: AppTheme.textSecondary, fontSize: 13)),
            ]),
            if (p.keterangan != null && p.keterangan!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.info_outline, size: 13, color: AppTheme.textHint),
                const SizedBox(width: 6),
                Expanded(child: Text(p.keterangan!,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
              ]),
            ],
          ]),
        ),
        const SizedBox(height: 14),
        const Text('DAFTAR HARGA', style: TextStyle(fontSize: 11,
            fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        PriceDisplay(hargaCash: p.hargaCash, hargaBonNormal: p.hargaBonNormal, hargaBonWajib: p.hargaBonWajib),
        const SizedBox(height: 16),
        OutlinedButton.icon(onPressed: _clear, icon: const Icon(Icons.refresh),
            label: const Text('Scan Produk Lain')),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _buildNotFound() {
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle,
              border: Border.all(color: Colors.red.shade100, width: 2)),
          child: Icon(Icons.search_off_rounded, size: 52, color: Colors.red.shade300),
        ),
        const SizedBox(height: 20),
        const Text('Produk Tidak Ditemukan', style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(color: AppTheme.surface,
              borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.divider)),
          child: Text(_lastScanned, style: const TextStyle(
              fontFamily: 'monospace', fontSize: 15,
              color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 8),
        const Text('Belum terdaftar di Master Produk',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        const SizedBox(height: 28),
        ElevatedButton.icon(onPressed: _clear,
            icon: const Icon(Icons.refresh), label: const Text('Scan Lagi')),
      ]),
    ));
  }

  Widget _buildEmpty() {
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppTheme.primary.withOpacity(0.08), AppTheme.accent.withOpacity(0.08)]),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withOpacity(0.12), width: 2),
          ),
          child: const Icon(Icons.qr_code_scanner, size: 68, color: AppTheme.primary),
        ),
        const SizedBox(height: 24),
        const Text('Siap Digunakan', style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: AppTheme.primary, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        const Text('Arahkan scanner ke barcode produk\natau ketik nama produk di atas',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.6)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.divider)),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.bluetooth, size: 15, color: AppTheme.accent),
            SizedBox(width: 6),
            Icon(Icons.usb, size: 15, color: AppTheme.accent),
            SizedBox(width: 8),
            Text('Support Bluetooth & Kabel (USB HID)',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ]),
        ),
      ]),
    ));
  }
}
