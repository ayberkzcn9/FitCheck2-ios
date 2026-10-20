// "Bugün" ekranının arayüz testleri.
//
// Amaç: ekranın gerçekten çizilebildiğini (taşma/çökme olmadan), düğmelerin
// doğru veriyi yukarı bildirdiğini ve boş dolap durumunun kullanıcıyı doğru
// yönlendirdiğini görmek. Ağa çıkılmaz: sahte bir [BugunFeedServisi] verilir.
//
// Çalıştırma: flutter test test/bugun_ekrani_gorunum_test.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/bugun_kombin.dart';
import 'package:fitcheck/models/favori_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/bugun_ekrani.dart';
import 'package:fitcheck/services/bugun_feed_servisi.dart';

/// 1×1 saydam PNG: Image.memory'nin gerçekten çözebileceği en küçük görsel.
final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet({
  required String id,
  required String kategori,
  required String baslik,
  DateTime? eklenme,
  DateTime? sonGiyilme,
}) {
  return Kiyafet(
    id: id,
    baslik: baslik,
    kategori: kategori,
    resimBytes: _png,
    renk: 'Siyah',
    stil: 'Regular',
    mevsim: 'dort_mevsim',
    sonGiyilmeTarihi: sonGiyilme,
    eklenmeTarihi: eklenme ?? DateTime(2026, 1, 1),
  );
}

class _SahteFeed extends BugunFeedServisi {
  _SahteFeed(this.sonuc) : super.test();

  final FeedSonucu sonuc;

  @override
  Future<FeedSonucu> getir({
    required List<Kiyafet> dolap,
    required String hava,
    required String dil,
    bool zorla = false,
    DateTime? simdi,
  }) async {
    return sonuc;
  }
}

void main() {
  final ust = _kiyafet(id: 'u1', kategori: 'ust', baslik: 'Beyaz Tişört');
  final alt = _kiyafet(id: 'a1', kategori: 'alt', baslik: 'Siyah Pantolon');
  final kaban = _kiyafet(
    id: 'd1',
    kategori: 'ceket',
    baslik: 'Yün Kaban',
    eklenme: DateTime(2026, 1, 2),
    sonGiyilme: DateTime(2026, 3, 1),
  );

  final kombin = BugunKombin(
    baslik: 'Sade ofis kombini',
    aciklama: 'Nötr renkler bir arada.',
    kiyafetIdleri: [ust.id, alt.id],
  );

  Future<void> kur(
    WidgetTester tester, {
    required List<Kiyafet> dolap,
    required List<BugunKombin> kombinler,
    List<FavoriKombin>? favoriler,
    List<String>? gecmis,
    Map<String, List<Kiyafet>>? giyilenler,
    VoidCallback? onFotograf,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BugunEkrani(
            gardirobum: dolap,
            gunlukHava: 'İstanbul • 21°C • Parçalı Bulutlu',
            havaYukleniyor: false,
            isAktifSekme: true,
            onSekmeSec: (_) {},
            onFotografEkle: () async => onFotograf?.call(),
            onFavoriEkle: (favori) async => favoriler?.add(favori),
            onGecmiseEkle: (baslik, parcalar) async {
              gecmis?.add(baslik);
              giyilenler?[baslik] = parcalar;
            },
            onStilistAc: () {},
            anaRenk: Colors.indigo,
            feedServisi: _SahteFeed(
              FeedSonucu(kombinler, FeedKaynagi.yapayZeka),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('kombin kartı, aksiyonlar ve raflar çizilir', (tester) async {
    await kur(
      tester,
      dolap: [ust, alt, kaban],
      kombinler: [kombin],
    );

    expect(find.text('Bugünün kombini'), findsOneWidget);
    expect(find.text('Sade ofis kombini'), findsOneWidget);
    expect(find.text('Giydim'), findsOneWidget);
    expect(find.text('Kaydet'), findsOneWidget);
    expect(find.text('2 haftadır giymediklerin'), findsOneWidget);

    // Üçüncü raf ekranın altında kalıyor; kaydırınca çizilir.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Bugüne uygun'), findsOneWidget);

    // Taşma/çizim hatası olmamalı.
    expect(tester.takeException(), isNull);
  });

  testWidgets('"Giydim" doğru parçaları bildirir', (tester) async {
    final gecmis = <String>[];
    final giyilen = <String, List<Kiyafet>>{};

    await kur(
      tester,
      dolap: [ust, alt],
      kombinler: [kombin],
      gecmis: gecmis,
      giyilenler: giyilen,
    );

    await tester.tap(find.text('Giydim'));
    await tester.pumpAndSettle();

    expect(gecmis, ['Sade ofis kombini']);
    expect(giyilen['Sade ofis kombini']!.map((k) => k.id), ['u1', 'a1']);
  });

  testWidgets('"Kaydet" favori oluşturur ve uyum 85-97 arasıdır', (tester) async {
    final favoriler = <FavoriKombin>[];

    await kur(
      tester,
      dolap: [ust, alt],
      kombinler: [kombin],
      favoriler: favoriler,
    );

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(favoriler, hasLength(1));
    expect(favoriler.single.parcalar, ['Beyaz Tişört', 'Siyah Pantolon']);
    expect(favoriler.single.renkUyumuPuani, inInclusiveRange(85, 97));
  });

  testWidgets('boş dolapta fotoğraf eklemeye yönlendirir', (tester) async {
    var fotografIstendi = false;

    await kur(
      tester,
      dolap: const <Kiyafet>[],
      kombinler: const <BugunKombin>[],
      onFotograf: () => fotografIstendi = true,
    );

    expect(find.text('Dolabın henüz boş'), findsOneWidget);

    await tester.tap(find.text('Fotoğrafla ekle').first);
    await tester.pumpAndSettle();

    expect(fotografIstendi, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dar ekranda taşma olmaz', (tester) async {
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await kur(
      tester,
      dolap: [ust, alt, kaban],
      kombinler: [kombin],
    );

    expect(tester.takeException(), isNull);
  });
}
