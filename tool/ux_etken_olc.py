import io, os, re, sys, json
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'


def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            yield os.path.join(dizin, ad)


print('=' * 70)
print('DOKUNMA HEDEFI (WCAG 2.5.8: en az 24x24, Apple 44x44)')
print('=' * 70)

# Explicit olarak kucuk dokunma hedefi veren yerler
kucuk = []
for yol in dosyalar():
    s = io.open(yol, encoding='utf-8', errors='replace').read()
    for i, satir in enumerate(s.splitlines(), 1):
        if re.search(r'minimumSize:\s*const? ?Size\((\d+),\s*(\d+)\)', satir):
            m = re.search(r'minimumSize:\s*const? ?Size\((\d+),\s*(\d+)\)', satir)
            w, h = int(m.group(1)), int(m.group(2))
            if w < 44 or h < 44:
                kucuk.append((os.path.basename(yol), i, w, h, satir.strip()[:60]))

print('minimumSize ile dar hedef tanimlanan yerler: %d' % len(kucuk))
for ad, i, w, h, t in kucuk:
    print('  %-30s :%-5d %dx%d  %s' % (ad, i, w, h, t))

print()
print('=' * 70)
print('ANIMASYON SURESI/EGRISI TUTARLILIGI')
print('=' * 70)
sure = Counter()
egri = Counter()
for yol in dosyalar():
    s = io.open(yol, encoding='utf-8', errors='replace').read()
    for m in re.findall(r'Duration\(milliseconds:\s*(\d+)\)', s):
        sure[int(m)] += 1
    for m in re.findall(r'Duration\(seconds:\s*([\d.]+)\)', s):
        sure[int(float(m) * 1000)] += 1
    for m in re.findall(r'Curves\.(\w+)', s):
        egri[m] += 1

print('sureler (ms -> adet):')
for k, v in sorted(sure.items()):
    print('  %6d ms  x%d' % (k, v))
print('egriler:')
for k, v in egri.most_common():
    print('  %-22s x%d' % (k, v))

print()
print('=' * 70)
print('SECIM GORUNUMLERI (tum ana ekranlarda var mi?)')
print('=' * 70)
ana = ['bugun_ekrani.dart', 'gardirobum_ekrani.dart', 'profil_analiz_ekrani.dart',
       'stil_gunlugu_ekrani.dart', 'kombin_duellosu_ekrani.dart',
       'haftalik_planlayici_ekrani.dart', 'kendi_kombinim_ekrani.dart',
       'dolaptan_kombin_ekrani.dart', 'giris_ekrani.dart', 'onboarding_ekrani.dart',
       'reklamsiz_premium_ekrani.dart', 'seyahat_ekrani.dart', 'ayarlar_ekrani.dart']
print('%-32s %-8s %-8s %-8s %-8s' % ('ekran', 'bos', 'yuklen', 'hata', 'bilgi'))
for ad in ana:
    yol = None
    for d, _, fs in os.walk(KOK):
        if ad in fs:
            yol = os.path.join(d, ad)
            break
    if not yol:
        continue
    s = io.open(yol, encoding='utf-8', errors='replace').read()
    bos = 'yes' if re.search(r'BosDurum|bosDurum|bos durum|Bos', s) else '-'
    yuk = 'yes' if 'CircularProgressIndicator' in s or 'LinearProgressIndicator' in s else '-'
    hata = 'yes' if re.search(r'HataDurum|hataDurum|catch \(', s) else '-'
    bilgi = 'yes' if 'BilgiButonu' in s else '-'
    print('%-32s %-8s %-8s %-8s %-8s' % (ad, bos, yuk, hata, bilgi))
