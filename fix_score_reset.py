with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix _baslat to reset game state variables
old_baslat = '''  Future<void> _baslat() async {
    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    final sonOyun = prefs.getString('moda_trivia_son_tarih') ?? '';
    if (sonOyun == bugun) {
      if (mounted) {
        setState(() {
          _gunlukKilit = true;
          _yukleniyor = false;
        });
      }
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    _gunlukSorular = _sorulariOlustur(l10n);
    if (mounted) {
      setState(() {
        _yukleniyor = false;
      });
    }
  }'''

new_baslat = '''  Future<void> _baslat() async {
    // Reset game state at start
    _skor = 0;
    _indeks = 0;
    _secilen = null;
    _bitis = false;
    _gunlukKilit = false;

    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    final sonOyun = prefs.getString('moda_trivia_son_tarih') ?? '';
    if (sonOyun == bugun) {
      if (mounted) {
        setState(() {
          _gunlukKilit = true;
          _yukleniyor = false;
        });
      }
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    _gunlukSorular = _sorulariOlustur(l10n);
    if (mounted) {
      setState(() {
        _yukleniyor = false;
      });
    }
  }'''

if old_baslat in content:
    content = content.replace(old_baslat, new_baslat)
    with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'w', encoding='utf-8') as f:
        f.write(content)
    print('SUCCESS: _baslat reset fix applied!')
else:
    print('FAILED: Old _baslat not found')
    # Debug: find the actual content
    idx = content.index('Future<void> _baslat() async {')
    print('Actual content:')
    print(repr(content[idx:idx+len(old_baslat)]))