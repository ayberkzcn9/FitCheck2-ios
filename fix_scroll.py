with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add Timer import at top if not present
if 'import \'dart:async\';' not in content:
    # Add after the first import
    content = content.replace(
        "import 'package:flutter/material.dart';",
        "import 'package:flutter/material.dart';\nimport 'dart:async';"
    )

# 2. Add Timer field after _skorScaleAnim
old_fields = '''  late final ScrollController _scrollController;
  late final AnimationController _skorAnimController;
  late final Animation<double> _skorScaleAnim;'''

new_fields = '''  late final ScrollController _scrollController;
  late final AnimationController _skorAnimController;
  late final Animation<double> _skorScaleAnim;
  Timer? _scrollDebounce;'''

content = content.replace(old_fields, new_fields)

# 3. Update _onScroll method with debounce
old_on_scroll = '''  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      // finger dragging down -> content moving up -> hide nav bar
      triviaNavBarVisible.value = false;
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      // finger dragging up -> content moving down -> show nav bar
      triviaNavBarVisible.value = true;
    }
  }'''

new_on_scroll = '''  void _onScroll() {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      final dir = _scrollController.position.userScrollDirection;
      if (dir == ScrollDirection.forward) {
        triviaNavBarVisible.value = false;
      } else if (dir == ScrollDirection.reverse) {
        triviaNavBarVisible.value = true;
      }
    });
  }'''

content = content.replace(old_on_scroll, new_on_scroll)

# 4. Update dispose to cancel timer
old_dispose = '''  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _skorAnimController.dispose();
    super.dispose();
  }'''

new_dispose = '''  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _skorAnimController.dispose();
    super.dispose();
  }'''

content = content.replace(old_dispose, new_dispose)

# 5. Increase delay in _sec from 600ms to 1500ms
old_sec_delay = '''    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (_indeks + 1 >= _gunlukSorular.length) {
        _bitir();
      } else {
        setState(() {
          _indeks++;
          _secilen = null;
        });
      }
    });'''

new_sec_delay = '''    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_indeks + 1 >= _gunlukSorular.length) {
        _bitir();
      } else {
        setState(() {
          _indeks++;
          _secilen = null;
        });
      }
    });'''

content = content.replace(old_sec_delay, new_sec_delay)

# Write back
with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('SUCCESS: Scroll and delay fixes applied!')