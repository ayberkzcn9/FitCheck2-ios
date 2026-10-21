// Diğer ekranlardaki bilgi düğmeleri (Bugün, Düello, Rapor, Dolap).

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/bugun_kombin.dart';
import 'package:fitcheck/models/favori_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/bugun_ekrani.dart';
import 'package:fitcheck/screens/gardirobum_ekrani.dart';
import 'package:fitcheck/screens/kombin_duellosu_ekrani.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';
import 'package:fitcheck/services/bugun_feed_servisi.dart';
import 'package:fitcheck/services/kombin_duellosu_motoru.dart';
import 'package:fitcheck/services/kombin_duellosu_servisi.dart';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet(String id, String kategori) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: 'Siyah',
    stil: 'Regular',
    eklenmeTarihi: DateTime(2026, 1, 1),
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
  setUpAll(() {
    // Dolap ekranı açılışta .env okuyor.
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
  });

  final dolap = [
    _kiyafet('Beyaz Tişört', 'ust'),
    _kiyafet('Siyah Pantolon', 'alt'),
    _kiyafet('Beyaz Sneaker', 'ayakkabi'),
    _kiyafet('Yün Kaban', 'ceket'),
  ];

  Future<void> telefon(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// Bilgi düğmesini bulur (tooltip = ölçüt adı).
  Finder bilgiDugmesi(String olcutAdi) {
    return find.descendant(
      of: find.byTooltip(olcutAdi),
      matching: find.byIcon(Icons.info_outline_rounded),
    );
  }

  testWidgets('Bugün: kombin bilgi düğmesi açıklamayı açar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);

    final kombin = BugunKombin(
      baslik: 'Sade ofis kombini',
      aciklama: 'Nötr renkler bir arada.',
      kiyafetIdleri: [dolap[0].id, dolap[1].id],
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BugunEkrani(
            gardirobum: dolap,
            gunlukHava: 'İstanbul 21°C',
            havaYukleniyor: false,
            isAktifSekme: true,
            onSekmeSec: (_) {},
            onFotografEkle: () async {},
            onFavoriEkle: (FavoriKombin f) async {},
            onGecmiseEkle: (String b, List<Kiyafet> p) async {},
            onStilistAc: () {},
            anaRenk: Colors.indigo,
            feedServisi: _SahteFeed(
              FeedSonucu([kombin], FeedKaynagi.yapayZeka),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(bilgiDugmesi('Bugünün kombini'), findsOneWidget);

    await tester.tap(bilgiDugmesi('Bugünün kombini'));
    await tester.pumpAndSettle();

    expect(find.textContaining('en fazla bir yapay zekâ isteği'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Düello: puanlama bilgi düğmesi açıklamayı açar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: KombinDuellosuEkrani(
            gardirobum: dolap,
            motor: DuelMotoru(),
            servisi: KombinDuellosuServisi(),
            tohum: 7,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(bilgiDugmesi('Nasıl oynanır?'), findsOneWidget);

    await tester.tap(bilgiDugmesi('Nasıl oynanır?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('kural tabanlıdır'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Rapor: sayı bilgi düğmesi açıklamayı açar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StilGunluguEkrani(
            gardirobum: dolap,
            gecmisKombinler: const <Map<String, String>>[],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rapor'));
    await tester.pumpAndSettle();

    expect(bilgiDugmesi('Bu hafta giyilen kombin'), findsOneWidget);

    await tester.tap(bilgiDugmesi('Bu hafta giyilen kombin'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Son 7 günde kaydettiğin kombin sayısı'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  /// Dolap ekranında sonsuz animasyon var; pumpAndSettle yerine sabit bekleme.
  Future<void> bekle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
  }

  testWidgets('Dolap: başlık bilgi düğmesi açıklamayı açar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GardirobumEkrani(
            gardirobum: dolap,
            onKiyafetEkle: (_) {},
            onKiyafetSil: (_) {},
            onGardirobuTemizle: () {},
            onSepetToggle: (_) {},
            anaRenk: Colors.indigo,
          ),
        ),
      ),
    );
    await bekle(tester);

    expect(bilgiDugmesi('SANAL GARDIROBUM'), findsOneWidget);

    await tester.tap(bilgiDugmesi('SANAL GARDIROBUM'));
    await bekle(tester);

    expect(find.textContaining('arka plan otomatik silinir'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
