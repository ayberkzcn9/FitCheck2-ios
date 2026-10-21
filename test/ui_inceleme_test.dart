// UI inceleme için ekran görüntüsü üretir (build/ui-review/*.png).
//
// Çalıştırma: flutter test test/ui_inceleme_test.dart
// Amaç: cihaz olmadan ekranları gözle incelemek (taşma, hizalama, okunurluk).
//
// Not: Widget testlerinde varsayılan yazı tipi kutucuk olarak çizilir; bu
// yüzden gerçek bir yazı tipi (Arial) yükleniyor ve uygulamanın açık tema
// renkleri birebir kullanılıyor.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/bugun_kombin.dart';
import 'package:fitcheck/models/favori_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/bugun_ekrani.dart';
import 'package:fitcheck/screens/gardirobum_ekrani.dart';
import 'package:fitcheck/screens/profil_analiz_ekrani.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';
import 'package:fitcheck/widgets/alt_menu_cubugu.dart';
import 'package:fitcheck/screens/haftalik_planlayici_ekrani.dart';
import 'package:fitcheck/screens/kombin_duellosu_ekrani.dart';
import 'package:fitcheck/screens/seyahat_ekrani.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';
import 'package:fitcheck/services/bugun_feed_servisi.dart';
import 'package:fitcheck/services/kombin_duellosu_motoru.dart';
import 'package:fitcheck/services/kombin_duellosu_servisi.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _yaziTipi = 'ReviewFont';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

ColorScheme _acikSemas() {
  final base = ColorScheme.fromSeed(
    seedColor: const Color(0xFF3B3B3B),
    brightness: Brightness.light,
  );
  return base.copyWith(
    surface: const Color(0xFFF8F9FA),
    surfaceContainerLow: Colors.white,
    surfaceContainer: Colors.white,
    surfaceContainerHighest: const Color(0xFFEFF1F3),
    primary: const Color(0xFF3B3B3B),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFE3E3E3),
    onPrimaryContainer: const Color(0xFF1B1B1B),
    secondary: const Color(0xFF5F5F5F),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFE7E7E7),
    onSecondaryContainer: const Color(0xFF202020),
    tertiary: const Color(0xFF686868),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFEAEAEA),
    onTertiaryContainer: const Color(0xFF242424),
    onSurface: const Color(0xFF1C1B1F),
    onSurfaceVariant: const Color(0xFF49454F),
  );
}

ThemeData _tema() {
  final sema = _acikSemas();
  return ThemeData(
    useMaterial3: true,
    colorScheme: sema,
    fontFamily: _yaziTipi,
    scaffoldBackgroundColor: sema.surface,
    textTheme: Typography.material2021().black.apply(fontFamily: _yaziTipi),
    appBarTheme: AppBarTheme(
      backgroundColor: sema.surface,
      foregroundColor: const Color(0xFF1C1B1F),
      elevation: 0,
      centerTitle: false,
    ),
  );
}

Widget _uygulama(Widget child) {
  return MaterialApp(
    locale: const Locale('tr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: _tema(),
    home: child,
  );
}

Kiyafet _kiyafet(
  String id,
  String kategori, {
  String renk = 'Siyah',
  DateTime? sonGiyilme,
  DateTime? eklenme,
}) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: renk,
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

Future<void> _ekranGorusu(WidgetTester tester, String ad) async {
  // Tüm ekranı (alt sayfa/overlay dahil) yakala.
  final renderView = tester.binding.renderViews.first;
  final layer = renderView.debugLayer;
  if (layer is! OffsetLayer) return;

  await tester.runAsync(() async {
    final image = await layer.toImage(renderView.paintBounds);
    final veri = await image.toByteData(format: ui.ImageByteFormat.png);
    if (veri == null) return;

    final klasor = Directory('build/ui-review');
    if (!klasor.existsSync()) klasor.createSync(recursive: true);
    File('${klasor.path}/$ad.png')
        .writeAsBytesSync(veri.buffer.asUint8List());
  });
}

/// Döngüsel animasyonlar (yükleniyor göstergesi) pumpAndSettle'i kilitler.
Future<void> _bekle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

void main() {
  setUpAll(() async {
    final font = File(r'C:\Windows\Fonts\arial.ttf');
    if (!font.existsSync()) return;
    final loader = FontLoader(_yaziTipi)
      ..addFont(Future.value(font.readAsBytesSync().buffer.asByteData()));
    await loader.load();
  });

  final ust = _kiyafet('Beyaz Tişört', 'ust', renk: 'Beyaz');
  final alt = _kiyafet('Siyah Pantolon', 'alt');
  final kaban = _kiyafet('Yün Kaban', 'ceket',
      renk: 'Bej', sonGiyilme: DateTime(2026, 3, 1), eklenme: DateTime(2026, 1, 2));
  final ayakkabi = _kiyafet('Beyaz Sneaker', 'ayakkabi', renk: 'Beyaz');
  final gomlek = _kiyafet('Beyaz Gömlek', 'ust',
      renk: 'Beyaz', sonGiyilme: DateTime(2026, 9, 1));

  final dolap = [ust, alt, kaban, ayakkabi, gomlek];

  final kombin = BugunKombin(
    baslik: 'Sade ofis kombini',
    aciklama: 'Nötr renkler bir arada.',
    kiyafetIdleri: [ust.id, alt.id, kaban.id],
  );

  final gecmis = <Map<String, String>>[
    {
      'tarih': '2026-10-20',
      'baslik': 'Ofis kombini',
      'detay': 'Beyaz Tişört, Siyah Pantolon',
    },
    {
      'tarih': '2026-10-19',
      'baslik': 'Spor kombini',
      'detay': 'Beyaz Gömlek, Siyah Pantolon',
    },
    {
      'tarih': '2026-10-18',
      'baslik': 'Cuma kombini',
      'detay': 'Beyaz Tişört, Yün Kaban',
    },
  ];

  Future<void> telefon(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget bugunEkrani() {
    return Scaffold(
      body: BugunEkrani(
        gardirobum: dolap,
        gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
        havaYukleniyor: false,
        isAktifSekme: true,
        onSekmeSec: (_) {},
        onFotografEkle: () async {},
        onFavoriEkle: (FavoriKombin f) async {},
        onGecmiseEkle: (String b, List<Kiyafet> p) async {},
        onStilistAc: () {},
        onKiyafetGiyildi: (Kiyafet k) async {},
        onKombinIstegi: (Kiyafet k) {},
        onStilGunluguAc: () {},
        onSeyahatAc: () {},
        anaRenk: Colors.indigo,
        feedServisi: _SahteFeed(
          FeedSonucu([kombin], FeedKaynagi.yapayZeka),
        ),
      ),
    );
  }

  testWidgets('Bugun ekrani', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '01_bugun_ust');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bugun ekrani - alt kisim', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await _bekle(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await _bekle(tester);
    await _ekranGorusu(tester, '02_bugun_alt');

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await _bekle(tester);
    await _ekranGorusu(tester, '03_bugun_enalt');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bugun ekrani - raf aksiyonlari', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await _bekle(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await _bekle(tester);

    final parca = find.text('Yün Kaban').first;
    await tester.ensureVisible(parca);
    await _bekle(tester);
    await tester.tap(parca);
    await _bekle(tester);
    await _ekranGorusu(tester, '04_raf_menu');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - takvim', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '05_stil_takvim');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - gunluk', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await _bekle(tester);
    await tester.tap(find.text('Günlük'));
    await _bekle(tester);
    await _ekranGorusu(tester, '06_stil_gunluk');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - rapor', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await _bekle(tester);
    await tester.tap(find.text('Rapor'));
    await _bekle(tester);
    await _ekranGorusu(tester, '07_stil_rapor');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - takvimde plan ve gun detayi', (tester) async {
    final bugun = DateTime.now();
    final tarih =
        '${bugun.year}-${bugun.month.toString().padLeft(2, '0')}-${bugun.day.toString().padLeft(2, '0')}';
    SharedPreferences.setMockInitialValues(<String, Object>{
      'planli_kombinler': jsonEncode([
        {
          'tarih': tarih,
          'baslik': 'Ofis kombini',
          'parcalar': ['Beyaz Tişört', 'Siyah Pantolon'],
        }
      ]),
    });

    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        StilGunluguEkrani(
          gardirobum: dolap,
          gecmisKombinler: gecmis,
          favoriKombinler: [
            FavoriKombin(
              id: 'f1',
              baslik: 'Ofis kombini',
              parcalar: ['Beyaz Tişört', 'Siyah Pantolon'],
              tuyo: 'Nötr renkler',
              renkUyumuPuani: 92,
            ),
          ],
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '16_takvim_plan');

    await tester.tap(find.text('${bugun.day}').first);
    await _bekle(tester);
    await _ekranGorusu(tester, '17_gun_plani');

    await tester.tap(find.text('Değiştir'));
    await _bekle(tester);
    await _ekranGorusu(tester, '18_kombin_secimi');

    expect(tester.takeException(), isNull);
  });

  testWidgets('Seyahat modu', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(SeyahatEkrani(gardirobum: dolap)));
    await _bekle(tester);
    await _ekranGorusu(tester, '08_seyahat');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kombin Dueslosu - lobi', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '09_duello_lobi');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kombin Dueslosu - tur ve geri bildirim', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
      ),
    );
    await _bekle(tester);

    await tester.tap(find.text('Düelloya başla'));
    await _bekle(tester);
    await _ekranGorusu(tester, '10_duello_tur');
    // ignore: avoid_print
    print('DIAG once: check=' + find.byIcon(Icons.check_circle_rounded).evaluate().length.toString() + ' dogruYazi=' + find.text('Doğru!').evaluate().length.toString() + ' ipucu=' + find.text('Bir kombine dokun').evaluate().length.toString());

    final beklenen =
        DuelMotoru().uret(gardirobum: dolap, adet: 10, tohum: 7).sorular.first;
    await tester.tap(find.text(beklenen.solDogru ? 'A' : 'B'));
    await _bekle(tester);
    await _ekranGorusu(tester, '11_duello_geribildirim');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profil ve analiz - bilgi düğmeleri', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: gecmis,
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '19_profil_analiz');

    final dugme = find.byTooltip('Dolap Verimliliği').first;
    await tester.ensureVisible(dugme);
    await _bekle(tester);
    await _ekranGorusu(tester, '20_profil_bilgi_dugmesi');

    await tester.tap(dugme);
    await _bekle(tester);
    await _ekranGorusu(tester, '21_bilgi_sayfasi');

    expect(tester.takeException(), isNull);
  });

  testWidgets('Haftalik planlayici', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        HaftalikPlanlayiciEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          detayliHaftalikHava: 'Pazartesi 22°C, Salı 24°C',
          havaYukleniyor: false,
          onFavoriEkle: (FavoriKombin f) {},
          onGecmiseEkle: (String b, String d) {},
          onKonumuYenile: () {},
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '12_haftalik_plan');
    expect(tester.takeException(), isNull);
  });

  testWidgets('alt menu', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        Scaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: AltMenuCubugu(
            seciliSekme: Sekmeler.bugun,
            gorunur: true,
            onSec: (_) {},
            anahtarlar: const <int, Key>{},
          ),
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '13_alt_menu');
    expect(tester.takeException(), isNull);
  });

  testWidgets('gardirobum arama', (tester) async {    // Ekran açılışta .env okuyor.
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');

    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        GardirobumEkrani(
          gardirobum: dolap,
          onKiyafetEkle: (_) {},
          onKiyafetSil: (_) {},
          onGardirobuTemizle: () {},
          onSepetToggle: (_) {},
          onKombinIstegi: (_) {},
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '14_gardirobum');

    await tester.enterText(find.byType(TextField), 'beyaz');
    await _bekle(tester);
    await _ekranGorusu(tester, '15_gardirobum_arama');
    expect(tester.takeException(), isNull);
  });
}
