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
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/bugun_kombin.dart';
import 'package:fitcheck/models/favori_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/theme/app_tema.dart';
import 'package:fitcheck/theme/design_tokens.dart';
import 'package:fitcheck/screens/bugun_ekrani.dart';
import 'package:fitcheck/screens/gardirobum_ekrani.dart';
import 'package:fitcheck/screens/profil_analiz_ekrani.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';
import 'package:fitcheck/widgets/alt_menu_cubugu.dart';
import 'package:fitcheck/widgets/ai_oneri_kutusu.dart';
import 'package:fitcheck/widgets/kiyafet_duzenleyici.dart';
import 'package:fitcheck/screens/haftalik_planlayici_ekrani.dart';
import 'package:fitcheck/screens/kombin_duellosu_ekrani.dart';
import 'package:fitcheck/screens/giris_ekrani.dart';
import 'package:fitcheck/screens/onboarding_ekrani.dart';
import 'package:fitcheck/screens/izin_ekrani.dart';
import 'package:fitcheck/screens/reklamsiz_premium_ekrani.dart';
import 'package:fitcheck/screens/kendi_kombinim_ekrani.dart';
import 'package:fitcheck/screens/dolaptan_kombin_ekrani.dart';
import 'package:fitcheck/screens/seyahat_ekrani.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';
import 'package:fitcheck/services/bugun_feed_servisi.dart';
import 'package:fitcheck/services/kombin_duellosu_motoru.dart';
import 'package:fitcheck/services/kombin_duellosu_servisi.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _yaziTipi = 'ReviewFont';

/// Koyu tema görüntüleri için testlerde değiştirilir.
Brightness _parlaklik = Brightness.light;

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

ThemeData _tema({Brightness parlaklik = Brightness.light}) {
  final sema = AppTema.renkSemasi(parlaklik);
  final koyu = parlaklik == Brightness.dark;
  final taban = koyu
      ? Typography.material2021().white
      : Typography.material2021().black;
  return ThemeData(
    useMaterial3: true,
    colorScheme: sema,
    fontFamily: _yaziTipi,
    scaffoldBackgroundColor: sema.surface,
    textTheme: taban.apply(
      fontFamily: _yaziTipi,
      bodyColor: sema.onSurface,
      displayColor: sema.onSurface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: sema.surface,
      foregroundColor: sema.onSurface,
      elevation: 0,
      centerTitle: false,
    ),
  );
}

/// Testte olmayan donanım kanallarını (sensör, titreşim) boş yanıtla susturur.
void _donanimKanallariniSustur() {
  final haberci = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  for (final kanal in <String>[
    'dev.fluttercommunity.plus/sensors/method',
    'dev.fluttercommunity.plus/sensors/accelerometer',
    'dev.fluttercommunity.plus/sensors/gyroscope',
    'dev.fluttercommunity.plus/sensors/magnetometer',
    'vibration',
  ]) {
    haberci.setMockMethodCallHandler(MethodChannel(kanal), (_) async => null);
  }
}

int _uygulamaSayaci = 0;

Widget _uygulama(Widget child, {Locale? dil}) {
  return MaterialApp(
    // Her çağrı için benzersiz anahtar: Navigator durumu (açık modal, rota)
    // bir sonraki ekrana taşmasın.
    key: ValueKey('uygulama-${_uygulamaSayaci++}'),
    debugShowCheckedModeBanner: false,
    locale: dil ?? const Locale('tr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: _tema(parlaklik: _parlaklik),
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

Future<void> goruntu(WidgetTester tester, String ad) async {
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
/// Firebase gibi servisler testte hazır olmadığı için fırlatılan hataları
/// yutar; yalnızca yerleşim (taşma) hataları testi düşürür.
void _yerlesimHatasiniBildir(WidgetTester tester, String ekran) {
  Object? hata;
  while ((hata = tester.takeException()) != null) {
    final metin = '$hata';
    if (metin.contains('overflowed') || metin.contains('RenderFlex')) {
      fail('$ekran: yerleşim hatası -> $metin');
    }
    // ignore: avoid_print
    print('[ATLANDI/$ekran] ${metin.split('\n').first}');
  }
}

Future<void> bekle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  // Dokunma dalgası (ink splash) sönmeden görüntü alınırsa seçili sekmenin
  // arkasında geçici bir blok görünüyor; bitmesini bekle.
  await tester.pump(const Duration(milliseconds: 600));
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
    await bekle(tester);
    await goruntu(tester, '01_bugun_ust');

    // Bilgi düğmesi: "Bugünün kombini nasıl seçiliyor?"
    await tester.tap(find.byTooltip('Bugünün kombini'));
    await bekle(tester);
    await goruntu(tester, '22_bugun_bilgi');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bugun ekrani - giydim durumu', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await bekle(tester);

    // "Giydim" → düğme dolu "Giydildi" olur.
    await tester.tap(find.text('Giydim').first);
    await bekle(tester);
    await goruntu(tester, '25_bugun_giydildi');

    expect(find.text('Giydildi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bugun ekrani - alt kisim', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await bekle(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await bekle(tester);
    await goruntu(tester, '02_bugun_alt');

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await bekle(tester);
    await goruntu(tester, '03_bugun_enalt');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bugun ekrani - raf aksiyonlari', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await bekle(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await bekle(tester);

    final parca = find.text('Yün Kaban').first;
    await tester.ensureVisible(parca);
    await bekle(tester);
    await tester.tap(parca);
    await bekle(tester);
    await goruntu(tester, '04_raf_menu');
    expect(tester.takeException(), isNull);
  });

  testWidgets('dolap - ekleme secenekleri (arka planda ekle)', (tester) async {
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(
        GardirobumEkrani(
          gardirobum: const <Kiyafet>[],
          onKiyafetEkle: (_) {},
          onKiyafetSil: (_) {},
          onGardirobuTemizle: () {},
          onSepetToggle: (_) {},
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await bekle(tester);

    // Boş dolapta ortadaki "fotoğraf ekle" düğmesi seçenekleri açar.
    await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
    await bekle(tester);

    await goruntu(tester, '24_dolap_ekleme_secenekleri');
    expect(find.text('Arka planda ekle'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - takvim', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await goruntu(tester, '05_stil_takvim');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - gunluk', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await tester.tap(find.text('Günlük'));
    await bekle(tester);
    await goruntu(tester, '06_stil_gunluk');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stil gunlugu - rapor', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await tester.tap(find.text('Rapor'));
    await bekle(tester);
    await goruntu(tester, '07_stil_rapor');
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
    await bekle(tester);
    await goruntu(tester, '16_takvim_plan');

    await tester.tap(find.text('${bugun.day}').first);
    await bekle(tester);
    await goruntu(tester, '17_gun_plani');

    await tester.tap(find.text('Değiştir'));
    await bekle(tester);
    await goruntu(tester, '18_kombin_secimi');

    expect(tester.takeException(), isNull);
  });

  testWidgets('Seyahat modu', (tester) async {
    await telefon(tester);
    await tester.pumpWidget(_uygulama(SeyahatEkrani(gardirobum: dolap)));
    await bekle(tester);
    await goruntu(tester, '08_seyahat');
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
    await bekle(tester);
    await goruntu(tester, '09_duello_lobi');
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
    await bekle(tester);

    await tester.tap(find.text('Düelloya başla'));
    await bekle(tester);
    await goruntu(tester, '10_duello_tur');
    // ignore: avoid_print
    print('DIAG once: check=' + find.byIcon(Icons.check_circle_rounded).evaluate().length.toString() + ' dogruYazi=' + find.text('Doğru!').evaluate().length.toString() + ' ipucu=' + find.text('Bir kombine dokun').evaluate().length.toString());

    final beklenen =
        DuelMotoru().uret(gardirobum: dolap, adet: 10, tohum: 7).sorular.first;
    await tester.tap(find.text(beklenen.solDogru ? 'A' : 'B'));
    await bekle(tester);
    await goruntu(tester, '11_duello_geribildirim');

    // İkinci soru cevaplanır, ardından "Geri" ile 1. soruya dönülür.
    await tester.tap(find.text('Devam'));
    await bekle(tester);
    final ikinci =
        DuelMotoru().uret(gardirobum: dolap, adet: 10, tohum: 7).sorular[1];
    await tester.tap(find.text(ikinci.solDogru ? 'A' : 'B'));
    await bekle(tester);
    await tester.tap(find.text('Geri'));
    await bekle(tester);
    await goruntu(tester, '26_duello_geri');

    expect(tester.takeException(), isNull);
  });

  testWidgets('Kiyafet duzenleyici - arka plan ve yerlesim', (tester) async {
    await telefon(tester);

    // Örnek kesim: yarı saydam kırmızı kare.
    final gorsel = img.Image(width: 200, height: 200, numChannels: 4);
    img.fill(gorsel, color: img.ColorRgba8(0, 0, 0, 0));
    img.fillRect(
      gorsel,
      x1: 50,
      y1: 50,
      x2: 150,
      y2: 150,
      color: img.ColorRgba8(214, 62, 62, 255),
    );

    await tester.pumpWidget(
      _uygulama(
        Scaffold(
          body: KiyafetDuzenleyici(kesim: img.encodePng(gorsel)),
        ),
      ),
    );
    await bekle(tester);
    // Görsel asenkron çözülür; çözülmesini bekle.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 400)),
    );
    await bekle(tester);
    await goruntu(tester, '23_kiyfet_duzenleyici');
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
    await bekle(tester);
    await goruntu(tester, '19_profil_analiz');

    final dugme = find.byTooltip('Dolap Verimliliği').first;
    await tester.ensureVisible(dugme);
    await bekle(tester);
    await goruntu(tester, '20_profil_bilgi_dugmesi');

    await tester.tap(dugme);
    await bekle(tester);
    await goruntu(tester, '21_bilgi_sayfasi');

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
    await bekle(tester);
    await goruntu(tester, '12_haftalik_plan');
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
    await bekle(tester);
    await goruntu(tester, '13_alt_menu');
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
    await bekle(tester);
    await goruntu(tester, '14_gardirobum');

    await tester.enterText(find.byType(TextField), 'beyaz');
    await bekle(tester);
    await goruntu(tester, '15_gardirobum_arama');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Koyu tema - Bugun, Dolap, Duello', (tester) async {
    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await bekle(tester);
    await goruntu(tester, '27_koyu_bugun');

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
    await bekle(tester);
    await goruntu(tester, '28_koyu_dolap');

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
    await bekle(tester);
    await goruntu(tester, '29_koyu_duello');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Giris ekrani cizilir (normal ve dar)', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await bekle(tester);
    await goruntu(tester, '30_giris');
    _yerlesimHatasiniBildir(tester, 'Giriş');

    // Dar ekran (320 pt): giriş formu taşmamalı.
    tester.view.physicalSize = const Size(320 * 2, 700 * 2);
    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await bekle(tester);
    await goruntu(tester, '33_giris_dar');
    _yerlesimHatasiniBildir(tester, 'Giriş (dar)');
  });

  testWidgets('Premium ve Izin ekranlari cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    await tester.pumpWidget(_uygulama(const ReklamsizPremiumEkrani()));
    await bekle(tester);
    await goruntu(tester, '35_premium');
    _yerlesimHatasiniBildir(tester, 'Premium');

    await tester.pumpWidget(
      _uygulama(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => IzinDiyalogu.goster(context),
                child: const Text('ac'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ac'));
    await bekle(tester);
    await goruntu(tester, '36_izin');
    _yerlesimHatasiniBildir(tester, 'Izin');
  });

  testWidgets('Alt ekranlar: kendi kombinim ve dolaptan kombin cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);
    _donanimKanallariniSustur();

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_, __) {},
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '37_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Kendi kombinim');

    await tester.pumpWidget(
      _uygulama(
        DolaptanKombinStilistiEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          havaYukleniyor: false,
          onFavoriEkle: (_) {},
          onGecmiseEkle: (_, __) async {},
          onKonumuYenile: () {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '38_dolaptan_kombin');
    _yerlesimHatasiniBildir(tester, 'Dolaptan kombin');
  });

  testWidgets('Koyu tema - ana ekranlar taramasi', (tester) async {
    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
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
    await bekle(tester);
    await goruntu(tester, '39_koyu_profil');
    _yerlesimHatasiniBildir(tester, 'Koyu profil');

    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await tester.tap(find.text('Rapor'));
    await bekle(tester);
    await goruntu(tester, '40_koyu_rapor');
    _yerlesimHatasiniBildir(tester, 'Koyu rapor');

    await tester.pumpWidget(_uygulama(SeyahatEkrani(gardirobum: dolap)));
    await bekle(tester);
    await goruntu(tester, '41_koyu_seyahat');
    _yerlesimHatasiniBildir(tester, 'Koyu seyahat');

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_, __) {},
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '42_koyu_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Koyu kendi kombinim');

    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await bekle(tester);
    await goruntu(tester, '43_koyu_giris');
    _yerlesimHatasiniBildir(tester, 'Koyu giriş');
  });

  testWidgets('Cok dilli kontrol: ar (RTL), de, ru - tasma ve yon denetimi', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    for (final dil in ['ar', 'de', 'ru']) {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);

      await tester.pumpWidget(_uygulama(bugunEkrani(), dil: Locale(dil)));
      await bekle(tester);
      await goruntu(tester, '44_dil_' + dil + '_bugun');
      _yerlesimHatasiniBildir(tester, 'Bugun/' + dil);

      await tester.pumpWidget(
        _uygulama(
          GardirobumEkrani(
            gardirobum: dolap,
            onKiyafetEkle: (_) {},
            onKiyafetSil: (_) {},
            onGardirobuTemizle: () {},
            onSepetToggle: (_) {},
            onKombinIstegi: (_) {},
            anaRenk: const Color(0xFF0F5F4A),
          ),
          dil: Locale(dil),
        ),
      );
      await bekle(tester);
      await goruntu(tester, '45_dil_' + dil + '_dolap');
      _yerlesimHatasiniBildir(tester, 'Dolap/' + dil);

      await tester.pumpWidget(_uygulama(const GirisEkrani(), dil: Locale(dil)));
      await bekle(tester);
      await goruntu(tester, '46_dil_' + dil + '_giris');
      _yerlesimHatasiniBildir(tester, 'Giris/' + dil);

      tester.view.physicalSize = const Size(320 * 2, 700 * 2);
      await tester.pumpWidget(_uygulama(const GirisEkrani(), dil: Locale(dil)));
      await bekle(tester);
      await goruntu(tester, '47_dil_' + dil + '_giris_dar');
      _yerlesimHatasiniBildir(tester, 'Giris dar/' + dil);
    }
  });

  test('Tasarim butunlugu kalite kapisi', () {
    final sonuc = Process.runSync(
      Platform.isWindows ? 'python' : 'python3',
      ['tool/tasarim_kapisi.py'],
      workingDirectory: Directory.current.path,
    );
    final cikti = (sonuc.stdout as String) + (sonuc.stderr as String);
    // ignore: avoid_print
    print(cikti);
    expect(sonuc.exitCode, 0,
        reason: 'Tasarim butunlugu kapisi gecti:\n' + cikti);
  });

  testWidgets('Erisilebilirlik: yazi boyutu %200 - tasma denetimi', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    // WCAG 1.4.4: metin %200 buyutulebilmeli.
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await bekle(tester);
    await goruntu(tester, '48_olcek_bugun');
    _yerlesimHatasiniBildir(tester, 'Bugun x2');

    await tester.pumpWidget(
      _uygulama(
        GardirobumEkrani(
          gardirobum: dolap,
          onKiyafetEkle: (_) {},
          onKiyafetSil: (_) {},
          onGardirobuTemizle: () {},
          onSepetToggle: (_) {},
          onKombinIstegi: (_) {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '49_olcek_dolap');
    _yerlesimHatasiniBildir(tester, 'Dolap x2');

    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await bekle(tester);
    await goruntu(tester, '50_olcek_giris');
    _yerlesimHatasiniBildir(tester, 'Giris x2');

    await tester.pumpWidget(
      _uygulama(
        ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: gecmis,
          gunlukHava: 'İstanbul 21°C',
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '51_olcek_profil');
    _yerlesimHatasiniBildir(tester, 'Profil x2');

    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await goruntu(tester, '52_olcek_stil');
    _yerlesimHatasiniBildir(tester, 'Stil x2');

    await tester.pumpWidget(_uygulama(SeyahatEkrani(gardirobum: dolap)));
    await bekle(tester);
    await goruntu(tester, '53_olcek_seyahat');
    _yerlesimHatasiniBildir(tester, 'Seyahat x2');

    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C',
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '54_olcek_duello');
    _yerlesimHatasiniBildir(tester, 'Duello x2');

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_, __) {},
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '55_olcek_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Kendi kombinim x2');

    await tester.pumpWidget(_uygulama(const OnboardingEkrani()));
    await bekle(tester);
    await goruntu(tester, '56_olcek_onboarding');
    _yerlesimHatasiniBildir(tester, 'Onboarding x2');

    await tester.pumpWidget(_uygulama(const ReklamsizPremiumEkrani()));
    await bekle(tester);
    await goruntu(tester, '57_olcek_premium');
    _yerlesimHatasiniBildir(tester, 'Premium x2');
  });

  testWidgets('Kapsam: koyu tema ve RTL ile kalan ekranlar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    _donanimKanallariniSustur();
    await telefon(tester);

    // --- KOYU TEMA: daha önce kapsanmayan ekranlar
    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);

    await tester.pumpWidget(
      _uygulama(
        HaftalikPlanlayiciEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C',
          detayliHaftalikHava: 'Pazartesi 22°C, Salı 24°C',
          havaYukleniyor: false,
          onFavoriEkle: (_) {},
          onGecmiseEkle: (_, __) {},
          onKonumuYenile: () {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '58_koyu_haftalik');
    _yerlesimHatasiniBildir(tester, 'Koyu haftalik');

    await tester.pumpWidget(
      _uygulama(
        DolaptanKombinStilistiEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gunlukHava: 'İstanbul 21°C',
          havaYukleniyor: false,
          onFavoriEkle: (_) {},
          onGecmiseEkle: (_, __) async {},
          onKonumuYenile: () {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '59_koyu_dolaptan');
    _yerlesimHatasiniBildir(tester, 'Koyu dolaptan');

    await tester.pumpWidget(_uygulama(const ReklamsizPremiumEkrani()));
    await bekle(tester);
    await goruntu(tester, '61_koyu_premium');
    _yerlesimHatasiniBildir(tester, 'Koyu premium');

    // --- RTL (ar): daha önce kapsanmayan ekranlar
    _parlaklik = Brightness.light;

    await tester.pumpWidget(
      _uygulama(
        StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '62_dil_ar_stil');
    _yerlesimHatasiniBildir(tester, 'Ar stil');

    await tester.pumpWidget(
      _uygulama(
        ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: gecmis,
          gunlukHava: 'İstanbul 21°C',
          anaRenk: const Color(0xFF0F5F4A),
        ),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '63_dil_ar_profil');
    _yerlesimHatasiniBildir(tester, 'Ar profil');

    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C',
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '64_dil_ar_duello');
    _yerlesimHatasiniBildir(tester, 'Ar duello');

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_, __) {},
        ),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '66_dil_ar_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Ar kendi kombinim');
  });

  testWidgets('Uyari kutusu: zemin ve metin', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    _donanimKanallariniSustur();
    await telefon(tester);

    Widget kutu() => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AiOneriKutusu(
                  baslik: 'Hafta icin eksik parca onerisi',
                  metin:
                      'Ust giyim ve ayakkabi eksik. Notr tonlarda bir ust ile '
                      'gunu tamamlayabilirsin.',
                  yukleniyor: false,
                  onTekrarDene: () {},
                ),
              ],
            ),
          ),
        );

    await tester.pumpWidget(_uygulama(kutu()));
    await bekle(tester);
    await goruntu(tester, '67_uyari_kutusu');
    _yerlesimHatasiniBildir(tester, 'Uyari kutusu');

    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);
    await tester.pumpWidget(_uygulama(kutu()));
    await bekle(tester);
    await goruntu(tester, '68_koyu_uyari_kutusu');
    _yerlesimHatasiniBildir(tester, 'Koyu uyari kutusu');
  });
}
