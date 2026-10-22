import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Tasarim butunlugu kalite kapisi test olarak calissin.
ek = """
  test('Tasarim butunlugu kalite kapisi', () {
    final sonuc = Process.runSync(
      Platform.isWindows ? 'python' : 'python3',
      ['tool/tasarim_kapisi.py'],
      workingDirectory: Directory.current.path,
    );
    final cikti = (sonuc.stdout as String) + (sonuc.stderr as String);
    // ignore: avoid_print
    print(cikti);
    expect(sonuc.exitCode, 0,
        reason: 'Tasarim butunlugu kapisi gecti:\\n' + cikti);
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
