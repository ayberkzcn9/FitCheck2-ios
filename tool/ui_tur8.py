import io

def duzenle(yol, degisimler):
    s = io.open(yol, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    for eski, yeni in degisimler:
        eski = eski.replace('\n', nl)
        yeni = yeni.replace('\n', nl)
        n = s.count(eski)
        if n != 1:
            raise SystemExit('eslesme %d: %s' % (n, eski[:70]))
        s = s.replace(eski, yeni)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

# 1) Profil başlığı: diğer ekranlarla aynı sol hizalama.
duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\profil_analiz_ekrani.dart', [
    ("""      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,""",
     """      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,"""),
])

# 2) Dolap kartı: fotoğraf kendi zemininde dursun; kıyafet boyutu farklı olunca
#    oluşan boş bant artık yüzeyin parçası gibi görünsün.
duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\gardirobum_ekrani.dart', [
    ("""                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: item.sepetteMi ? 1 : 0),""",
     """                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: colors.surfaceContainer),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: item.sepetteMi ? 1 : 0),"""),
])
print('ok')
