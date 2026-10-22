import io

def duzenle(yol, degisimler, say=1):
    s = io.open(yol, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    for eski, yeni in degisimler:
        eski = eski.replace('\n', nl)
        yeni = yeni.replace('\n', nl)
        if eski not in s:
            raise SystemExit('bulunamadi: ' + eski[:70])
        s = s.replace(eski, yeni, say)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

# 1) Günlük kombin ekranı: iki AnimationController tek ticker'la çalışmıyor.
#    Debug'da "multiple tickers" istisnası fırlıyor, release'te animasyon bozuluyor.
duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\gunluk_kombin_ekrani.dart', [
    ('    with SingleTickerProviderStateMixin {',
     '    with TickerProviderStateMixin {'),
])

# 2) Bugün boş durum kartı: sabit 190 px yüksekliğe sığmayan metinler
#    (uzun diller, büyük yazı) 16 px taşıyordu. Alt sınır verip büyümesine izin ver.
duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\bugun_ekrani.dart', [
    ("""    return SizedBox(
      height: 190,
      child: Center(""",
     """    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 190),
      child: Center("""),
])

print('ok')
