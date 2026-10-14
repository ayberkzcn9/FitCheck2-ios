/// Kategori çözümleme yardımcıları.
/// Tüm ekranlarda (haftalık, anlık, kendi kombin) tek kaynak kullanılır.

import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';

/// Veritabanı/ model kategorisini standart koda çevirir.
/// Dönen değer: 'ust' | 'alt' | 'ayakkabi' | 'dis' | ''
String kategoriModeldenCikar(String dbKategori) {
  final s = dbKategori.toLowerCase().trim();

  // Üst giyim
  if (s == 'ust' ||
      s.contains('üst') ||
      s.contains('top') ||
      s.contains('t-shirt') ||
      s.contains('tişört') ||
      s.contains('tshirt') ||
      s.contains('bluz') ||
      s.contains('gömlek') ||
      s.contains('gomlek') ||
      s.contains('kazak') ||
      s.contains('sweat') ||
      s.contains('hoodie') ||
      s.contains('crop') ||
      s.contains('body')) {
    return 'ust';
  }

  // Alt giyim
  if (s == 'alt' ||
      s.contains('alt') ||
      s.contains('bottom') ||
      s.contains('pantolon') ||
      s.contains('şort') ||
      s.contains('sort') ||
      s.contains('etek') ||
      s.contains('jean') ||
      s.contains('tayt') ||
      s.contains('leggings') ||
      s.contains('sweatpant')) {
    return 'alt';
  }

  // Ayakkabı
  if (s == 'ayakkabi' ||
      s.contains('ayakkab') ||
      s.contains('shoe') ||
      s.contains('bot') ||
      s.contains('sneaker') ||
      s.contains('çizme') ||
      s.contains('cizme') ||
      s.contains('loafer') ||
      s.contains('sandal') ||
      s.contains('espadrille')) {
    return 'ayakkabi';
  }

  // Dış giyim / Aksesuar
  if (s == 'dis' ||
      s.contains('dış') ||
      s.contains('dis ') ||
      s.contains('outer') ||
      s.contains('ceket') ||
      s.contains('mont') ||
      s.contains('aksesuar') ||
      s.contains('accessor') ||
      s.contains('kemer') ||
      s.contains('şapka') ||
      s.contains('sapka') ||
      s.contains('eldiven') ||
      s.contains('atki') ||
      s.contains('atkı') ||
      s.contains('çanta') ||
      s.contains('canta') ||
      s.contains('takı') ||
      s.contains('taki') ||
      s.contains('gözlük') ||
      s.contains('gozluk')) {
    return 'dis';
  }

  return '';
}

/// AI metninden (prompt yanıtında) kategori kodunu çıkarır.
/// Beklenen formatlar: [Category: ust], [Kategori: alt], (Kategori: ayakkabi) vb.
String kategoriMetindenCikar(String metin) {
  final s = metin.toLowerCase();

  // Öncelik: Açık kategori etiketi
  if (s.contains('category: ust') ||
      s.contains('kategori: ust') ||
      s.contains('[ust]') ||
      s.contains('(ust)') ||
      s.contains('category: üst') ||
      s.contains('kategori: üst')) {
    return 'ust';
  }
  if (s.contains('category: alt') ||
      s.contains('kategori: alt') ||
      s.contains('[alt]') ||
      s.contains('(alt)')) {
    return 'alt';
  }
  if (s.contains('category: ayakkabi') ||
      s.contains('kategori: ayakkabi') ||
      s.contains('[ayakkabi]') ||
      s.contains('(ayakkabi)') ||
      s.contains('category: shoes') ||
      s.contains('kategori: ayakkabı')) {
    return 'ayakkabi';
  }
  if (s.contains('category: dis') ||
      s.contains('kategori: dis') ||
      s.contains('[dis]') ||
      s.contains('(dis)') ||
      s.contains('category: outer') ||
      s.contains('kategori: dış') ||
      s.contains('kategori: dis')) {
    return 'dis';
  }

  // Fallback: Anahtar kelime tabanlı (modelden çıkarımdan farklı olarak daha geniş)
  if (s.contains('ust') || s.contains('top') || s.contains('bluz') || s.contains('tişört') || s.contains('tisort') || s.contains('gömlek') || s.contains('gomlek') || s.contains('kazak') || s.contains('sweat') || s.contains('hoodie') || s.contains('crop') || s.contains('body')) {
    return 'ust';
  }
  if (s.contains('alt') || s.contains('pantolon') || s.contains('şort') || s.contains('sort') || s.contains('etek') || s.contains('jean') || s.contains('tayt') || s.contains('leggings')) {
    return 'alt';
  }
  if (s.contains('ayakkab') || s.contains('shoe') || s.contains('bot') || s.contains('sneaker') || s.contains('çizme') || s.contains('cizme') || s.contains('loafer') || s.contains('sandal')) {
    return 'ayakkabi';
  }
  if (s.contains('dış') || s.contains('dis ') || s.contains('outer') || s.contains('ceket') || s.contains('mont') || s.contains('aksesuar') || s.contains('accessor') || s.contains('kemer') || s.contains('şapka') || s.contains('sapka') || s.contains('eldiven') || s.contains('atki') || s.contains('atkı') || s.contains('çanta') || s.contains('canta') || s.contains('takı') || s.contains('taki') || s.contains('gözlük') || s.contains('gozluk')) {
    return 'dis';
  }

  return '';
}

/// Kategori kodunu yerelleştirilmiş etikete çevirir.
String kategoriEtiketiGetir(String katCode, AppLocalizations l10n) {
  switch (katCode) {
    case 'ust':
      return l10n.ustGiyim;
    case 'alt':
      return l10n.altGiyim;
    case 'ayakkabi':
      return l10n.ayakkabi;
    case 'dis':
      return l10n.disGiyim;
    default:
      return l10n.parca;
  }
}

/// Parça metnini (AI formatındaki) parçalarına ayırır.
Map<String, String> parcaBilgileriniAyristir(
  String aciklamaMetni,
  AppLocalizations l10n,
) {
  String baslik = aciklamaMetni;
  String kategori = '';
  String renk = '';
  String stil = '';

  try {
    String temizMetin = aciklamaMetni
        .replaceAll(
          RegExp(r'(Temiz Parça|Clean Item)\s*#?\d+:\s*', caseSensitive: false),
          '',
        )
        .trim();

    final RegExp katReg = RegExp(
      r'\[(Kategori|Category):\s*([^\]]+)\]',
      caseSensitive: false,
    );
    final RegExp renkReg = RegExp(
      r'\((Renk|Color):\s*([^,)]+)',
      caseSensitive: false,
    );
    final RegExp stilReg = RegExp(
      // Style'ı virgül veya kapanan paranteze kadar al; "Season" gibi
      // sonraki alanları dahil etme.
      r'(Stil|Style):\s*([^,)]+)',
      caseSensitive: false,
    );

    final katMatch = katReg.firstMatch(temizMetin);
    final renkMatch = renkReg.firstMatch(temizMetin);
    final stilMatch = stilReg.firstMatch(temizMetin);

    if (katMatch != null) {
      kategori = kategoriEtiketiGetir(
        kategoriMetindenCikar(temizMetin),
        l10n,
      );
    }

    if (renkMatch != null) renk = renkMatch.group(2)?.trim() ?? '';
    if (stilMatch != null) stil = stilMatch.group(2)?.trim() ?? '';

    baslik = temizMetin
        .replaceAll(RegExp(r'\[.*?\]'), '')
        .replaceAll(RegExp(r'\(.*?\)'), '')
        .trim();

    if (baslik.isEmpty) baslik = l10n.kiyafetDetayi;
  } catch (_) {
    baslik = aciklamaMetni;
  }

  return {
    'baslik': baslik,
    'kategori': kategori,
    'renk': renk,
    'stil': stil,
  };
}

/// Parçaları kategori sırasına göre sıralar: ust → alt → ayakkabi → dis → diğer
List<dynamic> parcalariKategoriyeGoreSirala(
  List<dynamic> parcalar,
  String Function(String) kategoriCozucu,
) {
  final ustParcalar = <dynamic>[];
  final altParcalar = <dynamic>[];
  final ayakkabiParcalar = <dynamic>[];
  final disParcalar = <dynamic>[];
  final digerParcalar = <dynamic>[];

  for (var p in parcalar) {
    final kat = kategoriCozucu(p.toString());
    switch (kat) {
      case 'ust':
        ustParcalar.add(p);
        break;
      case 'alt':
        altParcalar.add(p);
        break;
      case 'ayakkabi':
        ayakkabiParcalar.add(p);
        break;
      case 'dis':
        disParcalar.add(p);
        break;
      default:
        digerParcalar.add(p);
    }
  }

  return [
    ...ustParcalar,
    ...altParcalar,
    ...ayakkabiParcalar,
    ...disParcalar,
    ...digerParcalar,
  ];
}

/// Kıyafet mevsim etiketi (AI prompt için)
String kiyafetMevsimEtiketi(Kiyafet kiyafet) {
  if (kiyafet.mevsim != null && kiyafet.mevsim!.isNotEmpty) {
    return kiyafet.mevsim!;
  }
  // Mevsim yoksa kategori/başlıktan tahmin et
  final kat = kategoriModeldenCikar(kiyafet.kategori);
  final baslik = kiyafet.baslik.toLowerCase();
  if (kat == 'ayakkabi') {
    if (baslik.contains('bot') || baslik.contains('çizme') || baslik.contains('cizme')) {
      return 'kishlik';
    }
    return 'dort_mevsim';
  }
  if (kat == 'dis') {
    if (baslik.contains('mont') || baslik.contains('ceket') || baslik.contains('kaban')) {
      return 'kishlik';
    }
    if (baslik.contains('hırka') || baslik.contains('hirka') || baslik.contains('cardigan')) {
      return 'dort_mevsim';
    }
  }
  if (kat == 'ust' || kat == 'alt') {
    if (baslik.contains('kazak') || baslik.contains('sweat') || baslik.contains('hoodie') ||
        baslik.contains('jean') || baslik.contains('pantolon') || baslik.contains('tayt')) {
      return 'kishlik';
    }
    if (baslik.contains('tişört') || baslik.contains('tisort') || baslik.contains('tshirt') ||
        baslik.contains('şort') || baslik.contains('sort') || baslik.contains('etek') ||
        baslik.contains('bluz') || baslik.contains('gömlek') || baslik.contains('gomlek')) {
      return 'yazlik';
    }
  }
  return 'dort_mevsim';
}