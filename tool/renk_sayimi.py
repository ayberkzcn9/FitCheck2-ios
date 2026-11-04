"""Renk borcu: dosya gruplarina gore tekil/kullanim sayilari."""
import collections
import glob
import io
import os
import re

kayit = collections.defaultdict(list)
for f in glob.glob("lib/**/*.dart", recursive=True):
    yol = f.replace("\\", "/")
    if "/l10n/" in yol:
        continue
    s = io.open(f, encoding="utf-8").read()
    for m in re.finditer(r"Color\(0x([0-9A-Fa-f]{8})\)", s):
        kayit[m.group(1).upper()].append(yol)

grup = collections.defaultdict(lambda: [0, set()])
for renk, yerler in kayit.items():
    for y in yerler:
        if y.endswith("theme/design_tokens.dart"):
            g = "theme/design_tokens.dart"
        elif y == "lib/main.dart":
            g = "lib/main.dart"
        else:
            g = "ekranlar/widget/servis"
        grup[g][0] += 1
        grup[g][1].add(renk)

for g in sorted(grup):
    print("%-26s kullanim=%3d  tekil=%3d" % (g, grup[g][0], len(grup[g][1])))

print("-" * 40)
print("TOPLAM kullanim=%d tekil=%d" % (sum(v[0] for v in grup.values()), len(kayit)))
