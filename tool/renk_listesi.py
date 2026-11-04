"""Ekran/widget/servislerdeki gomulu renkleri baglamla listeler (UTF-8 dosyaya)."""
import glob
import io
import re

satirlar = []
for f in sorted(glob.glob("lib/**/*.dart", recursive=True)):
    yol = f.replace("\\", "/")
    if "/l10n/" in yol or yol.endswith("theme/design_tokens.dart") or yol == "lib/main.dart":
        continue
    s = io.open(f, encoding="utf-8").read()
    for m in re.finditer(r"Color\(0x([0-9A-Fa-f]{8})\)", s):
        satir = s[: m.start()].count("\n") + 1
        bas = s.rfind("\n", 0, m.start()) + 1
        son = s.find("\n", m.start())
        satirlar.append("%s:%d  %s" % (yol, satir, s[bas:son].strip()[:110]))

io.open(
    r"C:\Users\mehmet\AppData\Local\Temp\opencode\renkler.txt", "w", encoding="utf-8"
).write("\n".join(satirlar))
print("satir:", len(satirlar))
