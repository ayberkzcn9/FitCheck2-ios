import re
import os

file_path = r'C:\Users\Ayberk\Downloads\Yeni klasor42\lib\screens\haftalik_planlayici_ekrani.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old = """    final planGunSayisi = _planlanabilirGunSayisiniBul(temizKiyafetler);
    final mevcutHafta = _haftalikProgram?['hafta'];
    var bugununPlanIndeksi = 0;
    if (mevcutHafta is List && mevcutHafta.isNotEmpty) {
      final bugunAdi = _gunIsminiCevir(_bugununIngilizceAdi()).toLowerCase();
      final bulunanIndex = mevcutHafta.indexWhere((gun) {
        if (gun is! Map) return false;
        return _gunIsminiCevir(gun['gun']?.toString() ?? '').toLowerCase() ==
            bugunAdi;
      });
      if (bulunanIndex >= 0) bugununPlanIndeksi = bulunanIndex;
    }
    final bugununKombiniKorunacak =
        _giyilmisGunler.contains(bugununPlanIndeksi) &&
            mevcutHafta is List &&
            mevcutHafta.isNotEmpty;
    final aiPlanGunSayisi =
        bugununKombiniKorunacak ? planGunSayisi - 1 : planGunSayisi;

    if (bugununKombiniKorunacak && aiPlanGunSayisi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bugünün kombini zaten giyildi; yeni kombin oluşturulmadı.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final mevcutBugunKombini = bugununKombiniKorunacak
        ? Map<String, dynamic>.from(
            (mevcutHafta[bugununPlanIndeksi] as Map),
          )
        : null;

    setState(() {
      _yukleniyor = true;
      _hataMesaji = null;
      _eksikParcaOnerisi = null;
      _eksikParcaOnerisiYukleniyor = false;
      _favoriEklenenGunler.clear();
      _analizEdilenGunler.clear();
      _giyilmisGunler.clear();
      if (bugununKombiniKorunacak) _giyilmisGunler.add(0);
      _seciliGunIndex = 0;
    });"""

new = """    final planGunSayisi = _planlanabilirGunSayisiniBul(temizKiyafetler);
    final mevcutHafta = _haftalikProgram?['hafta'];
    var bugununPlanIndeksi = 0;
    if (mevcutHafta is List && mevcutHafta.isNotEmpty) {
      final bugunAdi = _gunIsminiCevir(_bugununIngilizceAdi()).toLowerCase();
      final bulunanIndex = mevcutHafta.indexWhere((gun) {
        if (gun is! Map) return false;
        return _gunIsminiCevir(gun['gun']?.toString() ?? '').toLowerCase() ==
            bugunAdi;
      });
      if (bulunanIndex >= 0) bugununPlanIndeksi = bulunanIndex;
    }

    // 🔧 TÜM "giyildi" günlerini topla (sadece bugün değil)
    final korunanGunIndeksleri = <int>{};
    if (mevcutHafta is List) {
      for (int i = 0; i < mevcutHafta.length; i++) {
        final gun = mevcutHafta[i];
        if (gun is Map && gun['giyildi'] == true) {
          korunanGunIndeksleri.add(i);
        }
      }
    }
    // Bugün de "giyildi" ise ekle
    if (_giyilmisGunler.contains(bugununPlanIndeksi)) {
      korunanGunIndeksleri.add(bugununPlanIndeksi);
    }

    final korunanKombinler = <int, Map<String, dynamic>>{};
    for (final idx in korunanGunIndeksleri) {
      if (idx >= 0 && idx < (mevcutHafta?.length ?? 0) && mevcutHafta[idx] is Map) {
        korunanKombinler[idx] = Map<String, dynamic>.from(mevcutHafta[idx] as Map);
      }
    }

    final aiPlanGunSayisi = planGunSayisi - korunanKombinler.length;

    if (aiPlanGunSayisi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tüm günler giyildi; yeni kombin oluşturulmadı.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Korunan kombinleri gün indekslerine göre sakla
    final korunanKombinlerSirali = korunanKombinler.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    setState(() {
      _yukleniyor = true;
      _hataMesaji = null;
      _eksikParcaOnerisi = null;
      _eksikParcaOnerisiYukleniyor = false;
      _favoriEklenenGunler.clear();
      _analizEdilenGunler.clear();
      _giyilmisGunler.clear();
      // Korunan günleri _giyilmisGunler'a geri ekle (yeni plandaki indekslere göre)
      for (int i = 0; i < korunanKombinlerSirali.length; i++) {
        _giyilmisGunler.add(i);
      }
      _seciliGunIndex = 0;
    });"""

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(old, new)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Done')