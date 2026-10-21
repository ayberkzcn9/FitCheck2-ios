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
import 'package:fitcheck/services/planli_kombin_deposu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Future<void> Function(Kiyafet)? onGiydi,
    void Function(Kiyafet)? onKombin,
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
            onStilGunluguAc: () {},
            onSeyahatAc: () {},
            onKiyafetGiyildi: onGiydi,
            onKombinIstegi: onKombin,
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

    // Aynı parça iki rafta birden görünmemeli: bu küçük dolapta "bugüne
    // uygun" rafı tamamen boşaldığı için gizlenir.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(find.text('Bugüne uygun'), findsNothing);

    // Taşma/çizim hatası olmamalı.
    expect(tester.takeException(), isNull);
  });

  testWidgets('raflar aynı parçayı tekrarlamaz', (tester) async {
    // Büyük dolap: "bugüne uygun" rafında kalan parçalar görünmeli.
    final ekGiysi = List.generate(
      6,
      (i) => _kiyafet(
        id: 'y$i',
        kategori: i.isEven ? 'ust' : 'alt',
        baslik: 'Yeni Parça $i',
        sonGiyilme: DateTime.now().subtract(Duration(days: 1)),
        eklenme: DateTime.now().subtract(Duration(days: 30)),
      ),
    );

    await kur(
      tester,
      dolap: [ust, alt, kaban, ...ekGiysi],
      kombinler: [kombin],
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Bugüne uygun'), findsOneWidget);
    // "Yün Kaban" üstteki rafta var, altta tekrarlanmamalı.
    expect(find.text('Yün Kaban'), findsOneWidget);
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

    // 3 sütunlu ızgara dar ekranda da altı aracı gösterir.
    for (final etiket in [
      'Fotoğrafla ekle',
      'Kombin üret',
      'Stiliste sor',
      'Haftayı planla',
      'Stil Günlüğüm',
      'Seyahat Modu',
    ]) {
      expect(find.text(etiket), findsOneWidget, reason: '$etiket görünmüyor');
    }
  });

  testWidgets('kombin varken paylas dugmesi etkin', (tester) async {
    await kur(tester, dolap: [ust, alt], kombinler: [kombin]);

    expect(find.byTooltip('Kombini payla\u015f'), findsOneWidget);
    final dugme = find.widgetWithIcon(IconButton, Icons.ios_share_rounded);
    expect(dugme, findsOneWidget);
    expect(tester.widget<IconButton>(dugme).onPressed, isNotNull);
  });

  testWidgets('kombin yokken paylas dugmesi pasif', (tester) async {
    await kur(tester, dolap: [ust, alt], kombinler: const <BugunKombin>[]);

    expect(find.byTooltip('Kombini payla\u015f'), findsOneWidget);
    final dugme = find.widgetWithIcon(IconButton, Icons.ios_share_rounded);
    expect(dugme, findsOneWidget);
    expect(tester.widget<IconButton>(dugme).onPressed, isNull);
  });

  testWidgets('raftaki parcaya dokununca hizli aksiyonlar acilir', (tester) async {
    await kur(tester, dolap: [ust, alt, kaban], kombinler: [kombin]);

    final parca = find.text('Yün Kaban').first;
    await tester.ensureVisible(parca);
    await tester.pumpAndSettle();
    await tester.tap(parca);
    await tester.pumpAndSettle();

    expect(find.text('Dolapta aç'), findsOneWidget);
    // Geri cagri verilmediginde giydim/kombin aksiyonlari gizli.
    expect(find.text('Bugün giydim'), findsNothing);
  });

  testWidgets('rafta bugun giydim parcayi yukari bildirir', (tester) async {
    Kiyafet? giyilen;

    await kur(
      tester,
      dolap: [ust, alt, kaban],
      kombinler: [kombin],
      onGiydi: (kiyafet) async => giyilen = kiyafet,
      onKombin: (_) {},
    );

    final parca = find.text('Yün Kaban').first;
    await tester.ensureVisible(parca);
    await tester.pumpAndSettle();
    await tester.tap(parca);
    await tester.pumpAndSettle();

    expect(find.text('Bununla kombin kur'), findsOneWidget);
    await tester.tap(find.text('Bugün giydim'));
    await tester.pumpAndSettle();

    expect(giyilen?.id, kaban.id);
  });

  testWidgets('bugüne atanmış plan kartı görünür', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PlanliKombinDeposu.anahtar: jsonEncode([
        {
          'tarih': BugunFeedServisi.gunAnahtari(DateTime.now()),
          'baslik': 'Klasik Kombin',
          'parcalar': ['Beyaz Tişört', 'Siyah Pantolon'],
        }
      ]),
    });

    await kur(
      tester,
      dolap: [ust, alt, kaban],
      kombinler: [kombin],
    );

    expect(find.text('BUGÜN PLANIN'), findsOneWidget);
    expect(find.text('Klasik Kombin'), findsOneWidget);
    expect(find.text('Takvimden değiştir'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('plan yoksa plan kartı çizilmez', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await kur(
      tester,
      dolap: [ust, alt, kaban],
      kombinler: [kombin],
    );

    expect(find.text('BUGÜN PLANIN'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
