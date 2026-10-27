# -*- coding: utf-8 -*-
"""Reklam odulu metinlerindeki sabit sayiyi parametreye cevirir.

Sorun: odul miktari kodda tek yerden veriliyor
(ReklamServisi.reklamOduluKredi = 2, reklamOduluSlot = 2) ama ARB
metinlerinde sayi sabit yaziliydi. Odul 3'ten 2'ye dusurulunce sadece
Turkce metin guncellenmis, 11 dilde "+3" kalmisti; kullanici reklami
izleyip 2 alinca "eksik verdi" algisi olusuyordu.

Cozum: metinlerde sayi yok, {adet} parametresi var. Deger cagri aninda
ReklamServisi sabitinden gelir; boylece sayi bir daha kayamaz.

Kullanim: python tool/odul_metni_duzelt.py
"""
import glob
import io
import json
import os
import re
import sys

ANAHTARLAR = {
    'reklamIzleHakKazan',
    'tebriklerHakEklendi',
    'hakEklendiTebrikler',
    'gardirobunDolduIcerik',
    'reklamIzleSlotEkle',
    'yeniSlotEklendiTebrikler',
}

# Sablon dosyada (app_tr.arb) yer tutucu tipleri. Tip verilmezse gen-l10n
# parametreleri Object yapar; ayrica siralamayi metindeki gorunume gore degil
# isme gore yapar. Bu yuzden sira burada acikca belirtilir.
YER_TUTUCULAR = {
    'reklamIzleHakKazan': [('adet', 'int')],
    'tebriklerHakEklendi': [('adet', 'int')],
    'hakEklendiTebrikler': [('adet', 'int')],
    'gardirobunDolduIcerik': [('limit', 'int'), ('adet', 'int')],
    'reklamIzleSlotEkle': [('adet', 'int')],
    'yeniSlotEklendiTebrikler': [('adet', 'int')],
}

SATIR_ANAHTARI = re.compile(r'\s*"([^"]+)"\s*:')
SAYI = re.compile(r'\+\s*\d+')


def duzelt(yol):
    ham = open(yol, 'rb').read()
    bom = ham.startswith(b'\xef\xbb\xbf')
    metin = ham.decode('utf-8-sig')
    satirlar = metin.splitlines(keepends=True)
    degisen = 0

    for i, satir in enumerate(satirlar):
        m = SATIR_ANAHTARI.match(satir)
        if not m or m.group(1) not in ANAHTARLAR:
            continue
        if '+{adet}' in satir:
            continue
        yeni, adet = SAYI.subn('+{adet}', satir, count=1)
        if adet:
            satirlar[i] = yeni
            degisen += 1

    if degisen:
        veri = ''.join(satirlar).encode('utf-8')
        with open(yol, 'wb') as f:
            f.write((b'\xef\xbb\xbf' if bom else b'') + veri)
    return degisen


def meta_ekle(yol):
    """Sablon ARB'ye yer tutucu tanimlarini ekler (varsa dokunmaz)."""
    ham = open(yol, 'rb').read()
    bom = ham.startswith(b'\xef\xbb\xbf')
    metin = ham.decode('utf-8-sig')
    satirlar = metin.splitlines(keepends=True)
    var_olan = set()

    for satir in satirlar:
        m = SATIR_ANAHTARI.match(satir)
        if m and m.group(1).startswith('@'):
            var_olan.add(m.group(1)[1:])

    eklenen = 0
    yeni = []
    for satir in satirlar:
        yeni.append(satir)
        m = SATIR_ANAHTARI.match(satir)
        if not m:
            continue
        k = m.group(1)
        if k not in YER_TUTUCULAR or k in var_olan:
            continue
        blok = ['  "@%s": {\n' % k,
                '    "placeholders": {\n']
        parcalar = []
        for ad, tip in YER_TUTUCULAR[k]:
            parcalar.append(
                '      "%s": {\n        "type": "%s"\n      }' % (ad, tip))
        blok.append(',\n'.join(parcalar))
        blok.append('\n    }\n  },\n')
        yeni.extend(blok)
        eklenen += 1

    if eklenen:
        veri = ''.join(yeni).encode('utf-8')
        with open(yol, 'wb') as f:
            f.write((b'\xef\xbb\xbf' if bom else b'') + veri)
    return eklenen


def degerlendirme_temizle(yol):
    """Yorum istegi metninden odul vaadini kaldirir.

    Google Play politikasi: yorum/puan karsiliginda odul teklif edilemez.
    Ayrica uygulama boyle bir kredi de vermiyordu; metin yanlis vaatti.
    """
    ham = open(yol, 'rb').read()
    bom = ham.startswith(b'\xef\xbb\xbf')
    metin = ham.decode('utf-8-sig')
    satirlar = metin.splitlines(keepends=True)
    degisen = 0

    for i, satir in enumerate(satirlar):
        m = SATIR_ANAHTARI.match(satir)
        if not m or m.group(1) != 'degerlendirmeIcerik':
            continue
        if '⭐' not in satir:
            continue
        yeni = re.sub(r'\s*⭐.*?(?=")', '', satir)
        if yeni != satir:
            satirlar[i] = yeni
            degisen += 1

    if degisen:
        veri = ''.join(satirlar).encode('utf-8')
        with open(yol, 'wb') as f:
            f.write((b'\xef\xbb\xbf' if bom else b'') + veri)
    return degisen


def dogrula(yol):
    d = json.load(io.open(yol, encoding='utf-8-sig'))
    sorunlar = []
    for k in sorted(ANAHTARLAR):
        deger = d.get(k)
        if deger is None:
            sorunlar.append('%s yok' % k)
            continue
        if '{adet}' not in deger:
            sorunlar.append('%s icinde {adet} yok' % k)
        if SAYI.search(deger):
            sorunlar.append('%s hala sabit sayi iceriyor: %s' % (k, deger[:50]))
    return sorunlar


def main():
    sys.stdout.reconfigure(encoding='utf-8')
    kok = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    toplam = 0
    for yol in sorted(glob.glob(os.path.join(kok, 'lib', 'l10n', 'app_*.arb'))):
        ad = os.path.basename(yol)
        n = duzelt(yol)
        toplam += n
        print('%s: %d metin guncellendi' % (ad, n))

    print('-' * 60)
    sablon = os.path.join(kok, 'lib', 'l10n', 'app_tr.arb')
    n = meta_ekle(sablon)
    print('app_tr.arb: %d yer tutucu tanimi eklendi' % n)

    for yol in sorted(glob.glob(os.path.join(kok, 'lib', 'l10n', 'app_*.arb'))):
        m = degerlendirme_temizle(yol)
        if m:
            print('%s: yorum metninden odul vaadi kaldirildi'
                  % os.path.basename(yol))

    hata = 0
    for yol in sorted(glob.glob(os.path.join(kok, 'lib', 'l10n', 'app_*.arb'))):
        for s in dogrula(yol):
            print('HATA %s: %s' % (os.path.basename(yol), s))
            hata += 1
    print('TOPLAM: %d metin, %d hata' % (toplam, hata))
    return 1 if hata else 0


if __name__ == '__main__':
    sys.exit(main())
