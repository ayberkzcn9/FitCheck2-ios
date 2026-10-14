with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace lock screen button (line ~324-327)
old_lock_button = '''                          ElevatedButton(
                            onPressed: () => widget.onReturnToHome ?? Navigator.of(context).pop(),
                            child: Text(l10n.modaYarismasiGeri),
                          ),'''

new_lock_button = '''                          _HapticButton(
                            onPressed: () => widget.onReturnToHome ?? Navigator.of(context).pop(),
                            child: Text(l10n.modaYarismasiGeri),
                          ),'''

content = content.replace(old_lock_button, new_lock_button)

# Replace finish screen button (line ~360-363)
old_finish_button = '''                          ElevatedButton(
                            onPressed: () => widget.onReturnToHome ?? Navigator.of(context).pop(),
                            child: Text(l10n.modaYarismasiAnaEkrana),
                          ),'''

new_finish_button = '''                          _HapticButton(
                            onPressed: () => widget.onReturnToHome ?? Navigator.of(context).pop(),
                            child: Text(l10n.modaYarismasiAnaEkrana),
                          ),'''

content = content.replace(old_finish_button, new_finish_button)

with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('SUCCESS: Button haptic fixes applied!')