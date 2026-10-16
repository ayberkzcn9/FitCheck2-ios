import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kiyafet.dart';
import '../models/favori_kombin.dart';
import '../services/ai_service.dart';
import 'ai_chatbot_modal.dart';
import '../services/analytics_servisi.dart';
import '../services/reklam_servisi.dart';
import '../utils/hava_uygunlugu.dart' show haftalikPlaniHavayaUygunlastir, haftalikTahminGunHavasi;
import '../utils/helpers.dart';
import '../utils/kategori_utils.dart';
import '../utils/haftalik_dialoglar.dart';
import '../ai/prompts/haftalik_promptler.dart';
import '../ai/ai_dil.dart';
import '../l10n/app_localizations.dart';

// DIŞARI AKTARILAN DİYALOGLARIN İMPORTU
import '../widgets/hava_bar.dart';
import '../widgets/gun_secici.dart';
import '../widgets/ai_oneri_kutusu.dart';
import '../../theme/design_tokens.dart';
import '../../theme/tema_yardimcilari.dart';

class HaftalikPlanlayiciEkrani extends StatefulWidget {
  final List<Kiyafet> gardirobum;
  final String gunlukHava;
  final String detayliHaftalikHava;
  final bool havaYukleniyor;
  final bool havaHatasi;
  final Function(FavoriKombin) onFavoriEkle;
  final Function(FavoriKombin)? onFavoriSil;
  final Function(String, String) onGecmiseEkle;
  final Function(String, String)? onGecmistenCikar;
  final VoidCallback onKonumuYenile;
  final VoidCallback? onKonumAyarlariniAc;
  final Future<bool> Function()? onTekliKiyafetDegistir;

  final Color anaRenk;

  const HaftalikPlanlayiciEkrani({
    super.key,
    required this.gardirobum,
    required this.gunlukHava,
    required this.detayliHaftalikHava,
    required this.havaYukleniyor,
    this.havaHatasi = false,
    required this.onFavoriEkle,
    this.onFavoriSil,
    required this.onGecmiseEkle,
    this.onGecmistenCikar,
    required this.onKonumuYenile,
    this.onKonumAyarlariniAc,
    this.onTekliKiyafetDegistir,
    required this.anaRenk,
  });

  @override
  State<HaftalikPlanlayiciEkrani> createState() =>
      _HaftalikPlanlayiciEkraniState();
}

class _HaftalikPlanlayiciEkraniState extends State<HaftalikPlanlayiciEkrani> {
  bool _yukleniyor = false;
  Map<String, dynamic>? _haftalikProgram;
  String? _hataMesaji;

  /// Kombin kurulamayacak kadar eksik parça varsa (üst ve alt birlikte yok)
  /// plan yerine stilistin metin önerisi gösterilir.
  String? _eksikParcaOnerisi;
  bool _eksikParcaOnerisiYukleniyor = false;

  /// Temiz parça yetmediği için kombin kurulamayan günler (ör. cumartesi,
  /// pazar) boş görünmesin diye stilistin metin önerisi hazırlanırken true olur.
  bool _bosGunOnerileriYukleniyor = false;

  final Set<int> _favoriEklenenGunler = {};
  final Set<int> _analizEdilenGunler = {};
  final Set<int> _giyilmisGunler = {};

  int _seciliGunIndex = 0;
  int _yuklemeMesajiIndex = 0;
  Timer? _yuklemeTimer;
  List<String> _yuklemeMesajlari = [];

  @override
  void initState() {
    super.initState();
    _kayitliProgramiYukle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _yuklemeMesajlari = [
      l10n.gardirobumAiIslem1,
      l10n.gardirobumAiIslem2,
      l10n.gardirobumAiIslem3,
      l10n.gardirobumAiIslem4,
      l10n.gardirobumAiIslem5,
    ];
  }

  @override
  void dispose() {
    _yuklemeTimer?.cancel();
    super.dispose();
  }

  Future<void> _kayitliProgramiYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final kayitliVeri = prefs.getString('haftalik_program_json');
      final giyilmislerList =
          prefs.getStringList('giyilmis_haftalik_gunler') ?? [];

      if (!mounted) return;

      if (kayitliVeri != null && kayitliVeri.isNotEmpty) {
        final kayitliProgram = safeJsonDecodeMap(kayitliVeri, tag: 'haftalik_program');
        final kayitliHafta = kayitliProgram['hafta'];
        bool eskiPlanDonusturuldu = false;
        if (kayitliHafta is List && kayitliHafta.isNotEmpty) {
          final baslangicTarihi = prefs.getString(
            'haftalik_program_baslangic_tarihi',
          );
          if (baslangicTarihi != null) {
            final kayitGunu = DateTime.tryParse(baslangicTarihi);
            final bugun = DateTime.now();
            if (kayitGunu != null) {
              final kayitTakvimGunu =
                  DateTime(kayitGunu.year, kayitGunu.month, kayitGunu.day);
              final bugunTakvimGunu =
                  DateTime(bugun.year, bugun.month, bugun.day);
              final gecenGun =
                  bugunTakvimGunu.difference(kayitTakvimGunu).inDays;
              if (gecenGun > 0) {
                final silinecek = gecenGun.clamp(0, kayitliHafta.length);
                kayitliHafta.removeRange(0, silinecek);
                eskiPlanDonusturuldu = true;
              }
            }
          }

          final bugun = _gunIsminiCevir(_bugununIngilizceAdi()).toLowerCase();
          final bugunIndex = kayitliHafta.indexWhere((gun) {
            if (gun is! Map) return false;
            return _gunIsminiCevir(gun['gun']?.toString() ?? '')
                    .toLowerCase() ==
                bugun;
          });

          if (!eskiPlanDonusturuldu && bugunIndex > 0) {
            kayitliHafta.removeRange(0, bugunIndex);
            eskiPlanDonusturuldu = true;
          }
          if (kayitliHafta.length > 7) {
            kayitliHafta.removeRange(7, kayitliHafta.length);
            eskiPlanDonusturuldu = true;
          }
          _programiYediGuneTamamla(kayitliProgram);

          final guncelGunler = _gelecekGunlerinIngilizceAdlari();
          for (var i = 0; i < kayitliHafta.length && i < 7; i++) {
            final gun = kayitliHafta[i];
            if (gun is Map) {
              gun['gun'] = guncelGunler[i];
            }
          }
          // Eski kayıtlı planlarda parça metninde [ID:...] yoksa ekle; böylece
          // kıyafet çamaşıra gidince parçalar karışmaz.
          _parcalariIdIleZenginlestir(kayitliProgram);
        }
        setState(() {
          _haftalikProgram = kayitliProgram;
          _giyilmisGunler.clear();
          if (!eskiPlanDonusturuldu) {
            _giyilmisGunler.addAll(giyilmislerList
                .map((e) => int.tryParse(e) ?? -1)
                .where((e) => e != -1));
            if (kayitliHafta is List) {
              for (var i = 0; i < kayitliHafta.length; i++) {
                final gun = kayitliHafta[i];
                if (gun is Map && gun['giyildi'] == true) {
                  _giyilmisGunler.add(i);
                }
              }
            }
          }
          _seciliGunIndex = 0;
        });
        // Kayıtlı planda dolabın yetmediği boş günler varsa (ör. hafta sonu)
        // stilist metin önerisiyle doldurulur.
        _bosGunlerIcinStilistOnerileriniGetir();
      }
    } catch (e) {
      debugPrint("Error loading saved schedule: $e");
    }
  }

  Future<void> _programiCihazaKaydet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_haftalikProgram != null) {
        await prefs.setString(
            'haftalik_program_json', jsonEncode(_haftalikProgram));
        if (!prefs.containsKey('haftalik_program_baslangic_tarihi')) {
          await prefs.setString(
            'haftalik_program_baslangic_tarihi',
            DateTime.now().toIso8601String(),
          );
        }
        await prefs.setStringList('giyilmis_haftalik_gunler',
            _giyilmisGunler.map((e) => e.toString()).toList());
      } else {
        await prefs.remove('haftalik_program_json');
        await prefs.remove('giyilmis_haftalik_gunler');
        await prefs.remove('haftalik_program_baslangic_tarihi');
      }
    } catch (e) {
      debugPrint("Error saving schedule: $e");
    }
  }

  void _yuklemeAnimasyonunuBaslat() {
    _yuklemeMesajiIndex = 0;
    _yuklemeTimer?.cancel();
    _yuklemeTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted && _yuklemeMesajlari.isNotEmpty) {
        setState(() {
          _yuklemeMesajiIndex =
              (_yuklemeMesajiIndex + 1) % _yuklemeMesajlari.length;
        });
      }
    });
  }

  void _yuklemeAnimasyonunuDurdur() {
    _yuklemeTimer?.cancel();
  }

  void _kombinHakkiBittiGoster() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    HaftalikDialoglar.kombinHakkiBittiGoster(
      context: context,
      anaRenk: widget.anaRenk,
      onHakKazanildi: () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.tebriklerHakEklendi),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  Future<void> _bugunGiydimTetikle({
    required int index,
    required String kombinAdi,
    required String parcaIsimleriMetni,
  }) async {
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final bool zatenGiyildi = _giyilmisGunler.contains(index);

    if (!zatenGiyildi) {
      final onay = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.stilistBugunGiydim),
          content: Text(l10n.bugunGiydimOnayIcerik),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.iptal),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.anaTamam),
            ),
          ],
        ),
      );
      if (onay != true || !mounted) return;
    }

    setState(() {
      if (zatenGiyildi) {
        _giyilmisGunler.remove(index);
      } else {
        _giyilmisGunler.add(index);
      }

      final hafta = _haftalikProgram?['hafta'];
      if (hafta is List && index >= 0 && index < hafta.length) {
        final gun = hafta[index];
        if (gun is Map) {
          gun['giyildi'] = !zatenGiyildi;
        }
      }
    });

    if (!zatenGiyildi) {
      widget.onGecmiseEkle(kombinAdi, parcaIsimleriMetni);
    } else {
      await widget.onGecmistenCikar?.call(kombinAdi, parcaIsimleriMetni);
    }

    await _programiCihazaKaydet();

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          zatenGiyildi
              ? l10n.kombinIsaretlemeKaldirildi(kombinAdi)
              : l10n.kombinGiydimIsaretlendi(kombinAdi),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _gunIsminiCevir(String rawGun) {
    if (!mounted) return rawGun;
    final l10n = AppLocalizations.of(context)!;
    final s = rawGun.toLowerCase().trim();

    if (s == 'pzt' ||
        s == 'mon' ||
        s.contains('pazartesi') ||
        s.contains('monday') ||
        s.contains('lunes') ||
        s.contains('lundi') ||
        s.contains('montag') ||
        s.contains('lunedì')) {
      return l10n.pazartesi;
    }
    if (s == 'sal' ||
        s == 'tue' ||
        s.contains('salı') ||
        s.contains('sali') ||
        s.contains('tuesday') ||
        s.contains('martes') ||
        s.contains('mardi') ||
        s.contains('dienstag') ||
        s.contains('martedì')) {
      return l10n.sali;
    }
    if (s == 'çar' ||
        s == 'cars' ||
        s == 'wed' ||
        s.contains('çarşamba') ||
        s.contains('carsamba') ||
        s.contains('wednesday') ||
        s.contains('miércoles') ||
        s.contains('mercredi') ||
        s.contains('mittwoch') ||
        s.contains('mercoledì')) {
      return l10n.carsamba;
    }
    if (s == 'per' ||
        s == 'thu' ||
        s.contains('perşembe') ||
        s.contains('persembe') ||
        s.contains('thursday') ||
        s.contains('jueves') ||
        s.contains('jeudi') ||
        s.contains('donnerstag') ||
        s.contains('giovedì')) {
      return l10n.persembe;
    }
    if (s == 'cum' ||
        s == 'fri' ||
        s.contains('cuma') ||
        s.contains('friday') ||
        s.contains('viernes') ||
        s.contains('vendredi') ||
        s.contains('freitag') ||
        s.contains('venerdì')) {
      return l10n.cuma;
    }
    if (s == 'cmt' ||
        s == 'sat' ||
        s.contains('cumartesi') ||
        s.contains('saturday') ||
        s.contains('sábado') ||
        s.contains('samedi') ||
        s.contains('samstag') ||
        s.contains('sabato')) {
      return l10n.cumartesi;
    }
    if (s == 'pzr' ||
        s == 'sun' ||
        s.contains('pazar') ||
        s.contains('sunday') ||
        s.contains('domingo') ||
        s.contains('dimanche') ||
        s.contains('sonntag') ||
        s.contains('domenica')) {
      return l10n.pazar;
    }

    return rawGun;
  }

  /// Hava durumu açıklamasına karşılık gelen simgeyi döndürür.
  IconData _havaDurumuIkonu(String havaDurumMetni) {
    if (!mounted) return Icons.cloud_outlined;
    final l10n = AppLocalizations.of(context)!;
    final s = havaDurumMetni.toLowerCase().trim();

    bool icerir(String deger) {
      final hedef = deger.toLowerCase().trim();
      return hedef.isNotEmpty && s.contains(hedef);
    }

    if (icerir(l10n.havaYagmurlu) ||
        s.contains('yağmur') ||
        s.contains('rain')) {
      return Icons.umbrella_rounded;
    }
    if (icerir(l10n.havaSogukKarli) ||
        s.contains('kar') ||
        s.contains('snow') ||
        s.contains('nieve') ||
        s.contains('neige') ||
        s.contains('schnee')) {
      return Icons.ac_unit_rounded;
    }
    if (icerir(l10n.havaSicakGunesli) ||
        icerir(l10n.havaGunesli) ||
        s.contains('güneş') ||
        s.contains('sun') ||
        s.contains('sol') ||
        s.contains('soleil') ||
        s.contains('sonne')) {
      return Icons.wb_sunny_rounded;
    }
    if (icerir(l10n.havaParcaliBulutlu) ||
        s.contains('bulut') ||
        s.contains('cloud') ||
        s.contains('nublado') ||
        s.contains('nuage') ||
        s.contains('wolke')) {
      return Icons.wb_cloudy_rounded;
    }
    if (icerir(l10n.havaSoguk) || s.contains('soğuk') || s.contains('cold')) {
      return Icons.thermostat_rounded;
    }
    return Icons.cloud_outlined;
  }

  String _bugununIngilizceAdi() {
    const gunler = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return gunler[DateTime.now().weekday - 1];
  }

  List<String> _gelecekGunlerinIngilizceAdlari([
    int gunSayisi = 7,
    int baslangicOffset = 0,
  ]) {
    const gunler = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return List.generate(
      gunSayisi,
      (index) =>
          gunler[(DateTime.now().weekday - 1 + baslangicOffset + index) % 7],
    );
  }

  void _programiYediGuneTamamla(Map<String, dynamic> program) {
    final hafta = program['hafta'];
    if (hafta is! List || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final gunler = _gelecekGunlerinIngilizceAdlari();
    while (hafta.length < 7) {
      final index = hafta.length;
      hafta.add({
        'gun': gunler[index],
        'gunluk_hava': '',
        'kombin_adi': l10n.haftalikUyumsuzParca,
        'parcalar': <String>[],
        'tuyo': l10n.haftalikEksikParcaYeterliParcaYok,
        'eksik_parca_onerisi': '',
        'renk_uyumu_puani': 0,
      });
    }
  }

  int _planlanabilirGunSayisiniBul(List<Kiyafet> temizKiyafetler) {
    final kategoriSayilari = <String, int>{};
    for (final kiyafet in temizKiyafetler) {
      final kategori = kategoriModeldenCikar(kiyafet.kategori);
      if (kategori == 'ust' || kategori == 'alt') {
        kategoriSayilari[kategori] = (kategoriSayilari[kategori] ?? 0) + 1;
      }
    }
    // Kategori eksikse (ör. sadece üstler var) kalan kategoriye göre plan
    // yapılır; hiç üst/alt yoksa tek günlük stilist önerisi üretilir.
    if (kategoriSayilari.isEmpty) return 1;
    final enAzKategori = kategoriSayilari.values.reduce(
      (a, b) => a < b ? a : b,
    );
    if (enAzKategori < 1) return 1;
    return enAzKategori < 7 ? enAzKategori : 7;
  }

  /// Gardıropta temiz parçası olmayan kategoriler için stilist bilgilendirmesi.
  String? _eksikParcaStilistNotu(
    AppLocalizations l10n,
    List<Kiyafet> gardirop,
  ) {
    final temizKiyafetler = gardirop.where((k) => !k.sepetteMi).toList();
    if (temizKiyafetler.isEmpty) return null;

    final mevcutKategoriler = temizKiyafetler
        .map((k) => kategoriModeldenCikar(k.kategori))
        .where((k) => k.isNotEmpty)
        .toSet();

    final notlar = <String>[];
    if (!mevcutKategoriler.contains('ust')) {
      notlar.add(l10n.haftalikUyariUstEksikIcerik);
    }
    if (!mevcutKategoriler.contains('alt')) {
      notlar.add(l10n.haftalikUyariAltEksikIcerik);
    }
    if (!mevcutKategoriler.contains('ayakkabi')) {
      notlar.add(l10n.haftalikUyariAyakkabiEksikIcerik);
    }
    if (notlar.isEmpty) return null;

    return '${notlar.join(' ')} ${l10n.haftalikEksikParcaStilistNotu}';
  }

  Kiyafet? _metindenKiyafetBul(String aiMetni, List<Kiyafet> gardirop) {
    // ✅ 1) ID ile KESİN eşleşme. Parça metnine gömülü [ID:...] sayesinde
    // kıyafet çamaşıra gidip "temiz" liste değişse bile doğru kıyafet bulunur.
    final idEslesmesi = RegExp(r'\[ID:\s*([^\]]+)\]').firstMatch(aiMetni);
    if (idEslesmesi != null) {
      final arananId = idEslesmesi.group(1)!.trim();
      for (final k in gardirop) {
        if (k.id == arananId) return k;
      }
    }

    final kucukMetin = aiMetni.toLowerCase();
    final temizler = gardirop.where((k) => !k.sepetteMi).toList();

    final baslikEslesmesi = RegExp(
      r'(?:Clean Item|Temiz Parça)\s*#?\s*\d+\s*:\s*(.+?)(?:\s*\[|\s*\(|$)',
      caseSensitive: false,
    ).firstMatch(aiMetni);
    final kayitliBaslik = baslikEslesmesi?.group(1)?.trim().toLowerCase();
    if (kayitliBaslik != null && kayitliBaslik.isNotEmpty) {
      for (final kiyafet in gardirop) {
        final baslik = kiyafet.baslik.trim().toLowerCase();
        final gorunenBaslik = kiyafet.gorunenBaslik.trim().toLowerCase();
        if (kayitliBaslik == baslik || kayitliBaslik == gorunenBaslik) {
          return kiyafet;
        }
      }
    }

    final idMatch =
        RegExp(r'item\s*#?\s*(\d+)|par[cç]a\s*#?\s*(\d+)', caseSensitive: false)
            .firstMatch(kucukMetin);
    if (idMatch != null) {
      final matchGroup = idMatch.group(1) ?? idMatch.group(2);
      final index = int.tryParse(matchGroup ?? '') ?? 0;
      if (index > 0 && index <= temizler.length) {
        return temizler[index - 1];
      }
    }

    String tespitEdilenKategori = kategoriMetindenCikar(kucukMetin);
    final uygunKategoridekiler = temizler.where((k) {
      if (tespitEdilenKategori.isEmpty) return true;
      return kategoriModeldenCikar(k.kategori) == tespitEdilenKategori;
    }).toList();

    for (var k in uygunKategoridekiler) {
      final baslik = k.baslik.toLowerCase().trim();
      if (baslik.isNotEmpty && kucukMetin.contains(baslik)) {
        return k;
      }
    }

    for (var k in uygunKategoridekiler) {
      final kRenk = k.renk.toLowerCase().trim();
      if (kRenk.isNotEmpty && kucukMetin.contains(kRenk)) {
        return k;
      }
    }

    if (uygunKategoridekiler.isNotEmpty) {
      return uygunKategoridekiler.first;
    }

    return null;
  }

  /// Eski kayıtlı planlarda parça metnine [ID:...] etiketi ekler; böylece
  /// kıyafetler çamaşıra gidip "temiz" liste değişse bile parçalar sabit kalır.
  void _parcalariIdIleZenginlestir(Map<String, dynamic> program) {
    final hafta = program['hafta'];
    if (hafta is! List) return;
    for (final gun in hafta) {
      if (gun is! Map) continue;
      final parcalar = gun['parcalar'];
      if (parcalar is! List) continue;
      for (var i = 0; i < parcalar.length; i++) {
        final metin = parcalar[i].toString();
        if (metin.contains('[ID:')) continue;
        final kiyafet = _metindenKiyafetBul(metin, widget.gardirobum);
        if (kiyafet != null) {
          parcalar[i] = '$metin [ID:${kiyafet.id}]';
        }
      }
    }
  }

  /// Yapay zekânın ürettiği plandaki parçaları o günün havasına göre düzeltir
  /// ve değişiklik yapılan günlere bilgilendirme notu ekler.
  void _planParcalariniHavayaUygunlastir(
    Map<String, dynamic> program,
    List<Kiyafet> temizKiyafetler,
    AppLocalizations l10n, {
    int baslangicIndex = 0,
  }) {
    final hafta = program['hafta'];
    if (hafta is! List) return;

    final degisenGunler = haftalikPlaniHavayaUygunlastir(
      hafta: hafta,
      kiyafetler: temizKiyafetler,
      tahminSatirlari: widget.detayliHaftalikHava
          .split('\n')
          .map((satir) => satir.trim())
          .where((satir) => satir.isNotEmpty)
          .toList(),
      kategoriCozucu: kategoriModeldenCikar,
      baslangicIndex: baslangicIndex,
    );

    for (final indeks in degisenGunler) {
      final gun = hafta[indeks];
      if (gun is! Map) continue;
      final tuyo = (gun['tuyo'] ?? '').toString().trim();
      gun['tuyo'] = tuyo.isEmpty
          ? l10n.haftalikHavaUyarisi
          : '$tuyo\n\n${l10n.haftalikHavaUyarisi}';
    }
  }

  Map<String, dynamic> _programiDogrula(
      dynamic value, List<Kiyafet> temizKiyafetler,
      {int? beklenenGunSayisi}) {
    if (value is! Map<String, dynamic>) {
      throw const FormatException('AI yanıtı JSON nesnesi değil');
    }
    final hafta = value['hafta'];
    if (hafta is! List ||
        hafta.isEmpty ||
        hafta.length > 7 ||
        (beklenenGunSayisi != null && hafta.length != beklenenGunSayisi)) {
      throw FormatException(
          'Beklenen gün sayısı: $beklenenGunSayisi, gelen: ${hafta is List ? hafta.length : 'liste değil'}');
    }
    final kullanilanKiyafetIdleri = <String>{};
    // Gardıropta hiç temiz parçası olmayan kategori zorunlu tutulmaz; stilist
    // eksik kategoriyi atlayarak öneri hazırlayabilir.
    final mevcutKategoriler = temizKiyafetler
        .map((k) => kategoriModeldenCikar(k.kategori))
        .where((k) => k.isNotEmpty)
        .toSet();
    final zorunluKategoriler =
        <String>{'ust', 'alt', 'ayakkabi'}.intersection(mevcutKategoriler);
    for (final gun in hafta) {
      if (gun is! Map ||
          gun['gun'] is! String ||
          gun['kombin_adi'] is! String ||
          gun['tuyo'] is! String ||
          gun['parcalar'] is! List ||
          gun['parcalar'].isEmpty) {
        throw const FormatException('Gün alanlarından biri eksik');
      }

      final gunKategorileri = <String>{};
      for (final parca in gun['parcalar']) {
        final metin = parca.toString();
        final eslesme = RegExp(
          r'(?:Clean Item|Temiz Parça)\s*#?\s*(\d+)',
          caseSensitive: false,
        ).firstMatch(metin);
        if (eslesme == null) {
          throw FormatException('Parça numarası bulunamadı: $metin');
        }

        final index = int.tryParse(eslesme.group(1) ?? '');
        if (index == null || index < 1 || index > temizKiyafetler.length) {
          throw FormatException('Geçersiz parça numarası: $metin');
        }

        final kiyafet = temizKiyafetler[index - 1];
        final kategori = kategoriModeldenCikar(kiyafet.kategori);
        if (kategori.isEmpty ||
            (kategori != 'dis' && !gunKategorileri.add(kategori))) {
          throw FormatException(
              'Parça kategorisi geçersiz: ${kiyafet.kategori}');
        }

        if (kategori != 'ayakkabi' &&
            !kullanilanKiyafetIdleri.add(kiyafet.id)) {
          throw FormatException(
              'Aynı kıyafet birden fazla günde kullanılmış: ${kiyafet.id}');
        }
      }

      if (!zorunluKategoriler.every(gunKategorileri.contains)) {
        throw const FormatException('Üst, alt veya ayakkabı kategorisi eksik');
      }
    }
    return value;
  }

  Map<String, dynamic> _aiPlaniniOnar(
      dynamic value, List<Kiyafet> temizKiyafetler, int maksimumGun) {
    if (value is! Map<String, dynamic> || value['hafta'] is! List) {
      throw const FormatException('AI yanıtında hafta listesi yok');
    }

    final gecerliGunler = <dynamic>[];
    for (final gun in value['hafta'] as List) {
      if (gecerliGunler.length >= maksimumGun) break;

      if (gun is Map && gun['parcalar'] is List) {
        final normalizeParcalar = <String>[];
        for (final hamParca in gun['parcalar'] as List) {
          final parcaMetni = hamParca.toString();

          // Parçayı gerçek gardırop öğesinden ÇÖZ ve renk/stil dahil
          // tam meta veriyle yeniden yaz; böylece detay modalında kategori,
          // renk ve stil etiketleri her zaman görünür.
          final kiyafet = _metindenKiyafetBul(parcaMetni, temizKiyafetler);
          if (kiyafet != null) {
            final envanterIndex =
                temizKiyafetler.indexWhere((item) => item.id == kiyafet.id) + 1;
            final kategori = kategoriModeldenCikar(kiyafet.kategori);
            final renk = kiyafet.renk.trim();
            final stil = kiyafet.stil.trim();
            normalizeParcalar.add(
              'Clean Item #$envanterIndex: ${kiyafet.baslik} '
              '[Category: $kategori] '
              '(Color: ${renk.isEmpty ? '-' : renk}, '
              'Style: ${stil.isEmpty ? '-' : stil}) '
              '[ID:${kiyafet.id}]',
            );
          } else {
            normalizeParcalar.add(parcaMetni);
          }
        }
        gun['parcalar'] = normalizeParcalar;
      }

      final deneme = <String, dynamic>{
        'hafta': [...gecerliGunler, gun],
      };
      try {
        _programiDogrula(deneme, temizKiyafetler);
        gecerliGunler.add(gun);
      } on FormatException {
        // Bozuk günleri atla
      }
    }

    if (gecerliGunler.isEmpty) {
      throw const FormatException('AI yanıtında geçerli kombin bulunamadı');
    }
    return {'hafta': gecerliGunler};
  }

  Uint8List? _gucluGorselBul(String aiMetni, List<Kiyafet> gardirop) {
    final k = _metindenKiyafetBul(aiMetni, gardirop);
    return k?.resimBytes;
  }

  Future<void> _yeniKombiniAiIlePuanla(int gunIndex,
      {bool reklamGosterildi = false}) async {
    if (_haftalikProgram == null || _haftalikProgram!['hafta'] == null) return;

    // Parça değişince AI yeniden puanlaması başlamadan önce geçiş reklamı.
    if (!reklamGosterildi) {
      ReklamServisi().gecisReklamiGoster(
        onAdClosed: () {
          if (!mounted) return;
          _yeniKombiniAiIlePuanla(gunIndex, reklamGosterildi: true);
        },
      );
      return;
    }

    final gunItem = _haftalikProgram!['hafta'][gunIndex];
    final parcalar = gunItem['parcalar'] as List;
    final String gunHavasi = (gunItem['gunluk_hava'] ?? '').toString().trim();

    setState(() {
      _analizEdilenGunler.add(gunIndex);
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String tenRengi =
          aiTenRengi(prefs.getString('kullanici_ten_rengi') ?? 'Wheat');

      if (!mounted) return;
      final String dilKodu = Localizations.localeOf(context).languageCode;
      final String hedefDil = aiHedefDil(dilKodu);

      final prompt = analizPromptu(
        hedefDil: hedefDil,
        tenRengi: tenRengi,
        gunHavasi: gunHavasi,
        parcalar: parcalar,
      );
      final rawRes = await AiService().hibritAiSorgula(
        sistemPromptu: prompt['sistemPromptu']!,
        kullaniciMesaji: prompt['kullaniciMesaji']!,
      );

      String clean = rawRes.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final int firstBrace = clean.indexOf('{');
      final int lastBrace = clean.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        clean = clean.substring(firstBrace, lastBrace + 1);
      }

      final parsed = safeJsonDecodeMap(clean, tag: 'haftalik_ai_analiz');
      if (parsed == <String, dynamic>{} ||
          parsed['renk_uyumu_puani'] is! num ||
          parsed['tuyo'] is! String) {
        throw const FormatException();
      }

      if (mounted) {
        setState(() {
          _haftalikProgram!['hafta'][gunIndex]['renk_uyumu_puani'] =
              parsed['renk_uyumu_puani'] ?? 75;
          _haftalikProgram!['hafta'][gunIndex]['tuyo'] = parsed['tuyo'] ?? '';
        });
        _programiCihazaKaydet();
      }
    } catch (e) {
      debugPrint("Re-evaluating score error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _analizEdilenGunler.remove(gunIndex);
        });
      }
    }
  }

  void _parcaDegistirmeyiTetikle(int gunIndex, String degisecekMevcutMetin) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final temizKiyafetler =
        widget.gardirobum.where((k) => !k.sepetteMi).toList();
    final mevcutKiyafet =
        _metindenKiyafetBul(degisecekMevcutMetin, widget.gardirobum);
    String hedefKategori = mevcutKiyafet != null
        ? kategoriModeldenCikar(mevcutKiyafet.kategori)
        : kategoriMetindenCikar(degisecekMevcutMetin);

    final secenekler = temizKiyafetler.where((k) {
      if (hedefKategori.isNotEmpty) {
        return kategoriModeldenCikar(k.kategori) == hedefKategori;
      }
      return true;
    }).toList();

    String modalBaslik = l10n.farkliParcaSec;
    if (hedefKategori == 'ust') {
      modalBaslik = l10n.farkliUstSec;
    } else if (hedefKategori == 'alt') {
      modalBaslik = l10n.farkliAltSec;
    } else if (hedefKategori == 'ayakkabi') {
      modalBaslik = l10n.farkliAyakkabiSec;
    } else if (hedefKategori == 'dis') {
      modalBaslik = l10n.farkliDisSec;
    }

    HaftalikDialoglar.parcaDegistirModalGoster(
      context: context,
      anaRenk: widget.anaRenk,
      modalBaslik: modalBaslik,
      secenekler: secenekler,
      temizKiyafetler: temizKiyafetler,
      kategoriModeldenCikar: kategoriModeldenCikar,
      onTekliKiyafetDegistir: widget.onTekliKiyafetDegistir,
      onSecim: (yeniMetin) {
        setState(() {
          final List hamParcalar =
              _haftalikProgram!['hafta'][gunIndex]['parcalar'];
          int hedefIdx = hamParcalar
              .indexWhere((p) => p.toString() == degisecekMevcutMetin);
          if (hedefIdx != -1) {
            hamParcalar[hedefIdx] = yeniMetin;
          } else {
            hamParcalar.remove(degisecekMevcutMetin);
            hamParcalar.add(yeniMetin);
          }
        });
        _programiCihazaKaydet();
        _yeniKombiniAiIlePuanla(gunIndex);
      },
    );
  }

  Future<String> _haftalikAiYanitiAl({
    required String sistemPromptu,
    required String kullaniciMesaji,
  }) async {
    Object? sonHata;
    for (var deneme = 0; deneme < 2; deneme++) {
      try {
        return await AiService().hibritAiSorgula(
          sistemPromptu: sistemPromptu,
          kullaniciMesaji: kullaniciMesaji,
        );
      } catch (e) {
        sonHata = e;
        if (deneme == 0) {
          await Future.delayed(const Duration(milliseconds: 900));
        }
      }
    }
    throw sonHata ?? const AiServiceException();
  }

  /// Eksik parça veya dolaptan doldurulamayan boş gün için stilistin metin
  String _aiHedefDili() {
    return aiHedefDil(Localizations.localeOf(context).languageCode);
  }

  /// Üst ve alt birlikte eksik olduğu için plan üretilemez; ekranın boş
  /// kalmaması için stilistten metin kombin önerisi (üst + alt + ayakkabı) alınır.
  Future<void> _eksikParcaStilistOnerisiniGetir(
    List<Kiyafet> temizKiyafetler,
  ) async {
    setState(() {
      _eksikParcaOnerisi = null;
      _eksikParcaOnerisiYukleniyor = true;
      _hataMesaji = null;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      final String tenRengi =
          aiTenRengi(prefs.getString('kullanici_ten_rengi') ?? 'Wheat');
      final String cinsiyet = aiCinsiyet(
          prefs.getString('kullanici_cinsiyet') ?? 'Women');
      final String tarz =
          aiTarz(prefs.getString('kullanici_tarzi') ?? 'General');
      final String renkPaleti =
          aiRenkPaleti(prefs.getString('kullanici_renk_paleti') ?? 'Mixed');

      final Set<String> mevcutKategoriler = temizKiyafetler
          .map((k) => kategoriModeldenCikar(k.kategori))
          .where((k) => k.isNotEmpty)
          .toSet();
      final Set<String> eksikKategoriler =
          <String>{'ust', 'alt', 'ayakkabi'}.difference(mevcutKategoriler);

      final String envanter = temizKiyafetler.asMap().entries.map((entry) {
        final item = entry.value;
        return "- ${item.baslik} [Category: ${kategoriModeldenCikar(item.kategori)}] (Color: ${item.renk}, Style: ${item.stil}, Season: ${kiyafetMevsimEtiketi(item)})";
      }).join("\n");

      final String hedefDil = _aiHedefDili();
      final prompt = eksikParcaStilistPromptu(
        hedefDil: hedefDil,
        cinsiyet: cinsiyet,
        tarz: tarz,
        renkPaleti: renkPaleti,
        tenRengi: tenRengi,
        envanter: envanter,
        eksikKategoriler: eksikKategoriler.join(', '),
        gunlukHava: widget.gunlukHava,
        detayliHaftalikHava: widget.detayliHaftalikHava,
      );
      final rawRes = await _haftalikAiYanitiAl(
        sistemPromptu: prompt['sistemPromptu']!,
        kullaniciMesaji: prompt['kullaniciMesaji']!,
      );

      String clean = rawRes.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final int firstBrace = clean.indexOf('{');
      final int lastBrace = clean.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        clean = clean.substring(firstBrace, lastBrace + 1);
      }

      String oneri = '';
      final parsed = safeJsonDecodeMap(clean, tag: 'haftalik_oneri');
      if (parsed is Map && parsed['oneri'] is String) {
        oneri = (parsed['oneri'] as String).trim();
      }
      if (oneri.isEmpty) oneri = rawRes.trim();

      if (!mounted) return;
      setState(() {
        _eksikParcaOnerisi = oneri.isEmpty ? null : oneri;
        _eksikParcaOnerisiYukleniyor = false;
        if (oneri.isEmpty) {
          _hataMesaji = l10n.haftalikStilistOnerisiHazirlanamadi;
        }
      });
    } catch (e) {
      debugPrint('Eksik parça stilist önerisi hatası: $e');
      if (!mounted) return;
      setState(() {
        _eksikParcaOnerisiYukleniyor = false;
        _hataMesaji = e is AiServiceException
            ? l10n.haftalikAiServisHatasi
            : l10n.haftalikStilistOnerisiHazirlanamadi;
      });
    }
  }

  /// Dolaptaki temiz parçalar yetmediği için kombin kurulamayan günler (ör.
  /// cumartesi, pazar) tamamen boş kalmasın diye tek istekte stilistten metin
  /// kombin önerisi (üst + alt + ayakkabı) alınır.
  Future<void> _bosGunlerIcinStilistOnerileriniGetir() async {
    final program = _haftalikProgram;
    if (program == null || program['hafta'] is! List || !mounted) return;
    if (_bosGunOnerileriYukleniyor) return;

    final hafta = program['hafta'] as List;
    final bosGunIndexleri = <int>[];
    for (var i = 0; i < hafta.length; i++) {
      final gun = hafta[i];
      if (gun is! Map) continue;
      final parcalar = gun['parcalar'];
      final mevcutOneri = (gun['eksik_parca_onerisi'] ?? '').toString().trim();
      if ((parcalar is! List || parcalar.isEmpty) && mevcutOneri.isEmpty) {
        bosGunIndexleri.add(i);
      }
    }
    if (bosGunIndexleri.isEmpty) return;

    setState(() => _bosGunOnerileriYukleniyor = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      final String tenRengi =
          aiTenRengi(prefs.getString('kullanici_ten_rengi') ?? 'Wheat');
      final String cinsiyet = aiCinsiyet(
          prefs.getString('kullanici_cinsiyet') ?? 'Women');
      final String tarz =
          aiTarz(prefs.getString('kullanici_tarzi') ?? 'General');
      final String renkPaleti =
          aiRenkPaleti(prefs.getString('kullanici_renk_paleti') ?? 'Mixed');

      final temizKiyafetler =
          widget.gardirobum.where((k) => !k.sepetteMi).toList();
      final Set<String> mevcutKategoriler = temizKiyafetler
          .map((k) => kategoriModeldenCikar(k.kategori))
          .where((k) => k.isNotEmpty)
          .toSet();
      final Set<String> eksikKategoriler =
          <String>{'ust', 'alt', 'ayakkabi'}.difference(mevcutKategoriler);

      final String envanter = temizKiyafetler.asMap().entries.map((entry) {
        final item = entry.value;
        return "- ${item.baslik} [Category: ${kategoriModeldenCikar(item.kategori)}] (Color: ${item.renk}, Style: ${item.stil}, Season: ${kiyafetMevsimEtiketi(item)})";
      }).join("\n");

      final List<String> bosGunAdlari = [];
      final List<String> bosGunSatirlari = [];
      for (final index in bosGunIndexleri) {
        final gun = hafta[index] as Map;
        final hamGunAdi = (gun['gun'] ?? '').toString();
        final gunAdi = _gunIsminiCevir(hamGunAdi);
        var hava = (gun['gunluk_hava'] ?? '').toString().trim();
        if (hava.isEmpty) {
          hava = haftalikTahminGunHavasi(
            gunAdi: hamGunAdi,
            tahminSatirlari: widget.detayliHaftalikHava.split('\n'),
            bugununHaftaGunu: DateTime.now().weekday,
          );
          if (hava.isNotEmpty) gun['gunluk_hava'] = hava;
        }
        bosGunAdlari.add(gunAdi);
        bosGunSatirlari.add('- $gunAdi${hava.isEmpty ? '' : ' ($hava)'}');
      }
      final String gunListesi = bosGunSatirlari.join('\n');

      final String hedefDil = _aiHedefDili();
      final prompt = bosGunlerStilistPromptu(
        hedefDil: hedefDil,
        cinsiyet: cinsiyet,
        tarz: tarz,
        renkPaleti: renkPaleti,
        tenRengi: tenRengi,
        envanter: envanter,
        eksikKategoriler: eksikKategoriler.join(', '),
        detayliHaftalikHava: widget.detayliHaftalikHava,
        gunListesi: gunListesi,
        bosGunAdlari: bosGunAdlari,
      );
      final rawRes = await _haftalikAiYanitiAl(
        sistemPromptu: prompt['sistemPromptu']!,
        kullaniciMesaji: prompt['kullaniciMesaji']!,
      );

      String clean = rawRes.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final int firstBrace = clean.indexOf('{');
      final int lastBrace = clean.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        clean = clean.substring(firstBrace, lastBrace + 1);
      }

      final List<String> oneriler = [];
      final Map<String, String> oneriHaritasi = {};
      dynamic parsed;
      parsed = safeJsonDecodeMap(clean, tag: 'haftalik_oneriler');
      if (parsed != <String, dynamic>{} && parsed['gunler'] is List) {
        for (final hamGun in parsed['gunler'] as List) {
          if (hamGun is! Map) {
            oneriler.add('');
            continue;
          }
          final oneri = (hamGun['oneri'] ?? '').toString().trim();
          oneriler.add(oneri);
          if (oneri.isEmpty) continue;
          oneriHaritasi[_gunIsminiCevir((hamGun['gun'] ?? '').toString())
              .toLowerCase()
              .trim()] = oneri;
        }
      }

      var oneriEklendi = false;
      if (mounted) {
        setState(() {
          for (var i = 0; i < bosGunIndexleri.length; i++) {
            final oneri = oneriHaritasi[bosGunAdlari[i].toLowerCase().trim()] ??
                (i < oneriler.length ? oneriler[i] : '');
            if (oneri.isEmpty) continue;
            final gun = hafta[bosGunIndexleri[i]];
            if (gun is! Map) continue;
            gun['eksik_parca_onerisi'] = oneri;
            oneriEklendi = true;
          }
          _bosGunOnerileriYukleniyor = false;
        });
      }
      if (oneriEklendi) await _programiCihazaKaydet();
    } catch (e) {
      debugPrint('Boş gün stilist önerisi hatası: $e');
      if (!mounted) return;
      setState(() => _bosGunOnerileriYukleniyor = false);
    }
  }

  Future<void> _haftalikProgramUret({bool reklamGosterildi = false}) async {
    if (_yukleniyor) return;
    HapticFeedback.heavyImpact();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    bool hakDusuruldu = false;

    final int kalanHak = await ReklamServisi().kalanHakGetir();
    if (!mounted) return;

    if (kalanHak <= 0) {
      _kombinHakkiBittiGoster();
      return;
    }

    final temizKiyafetler =
        widget.gardirobum.where((k) => !k.sepetteMi).toList();

    if (temizKiyafetler.isEmpty) {
      HaftalikDialoglar.tatliUyariGoster(
          context: context,
          baslik: l10n.haftalikUyariDolapBosBaslik,
          mesaj: l10n.haftalikUyariDolapBosIcerik,
          anaRenk: widget.anaRenk);
      return;
    }

    // Plan üretimi (AI) başlamadan önce geçiş reklamı gösterilir. Premium'da ve
    // sıklık sınırında atlanır; akış kesintisiz devam eder.
    if (!reklamGosterildi) {
      ReklamServisi().gecisReklamiGoster(
        onAdClosed: () {
          if (!mounted) return;
          _haftalikProgramUret(reklamGosterildi: true);
        },
      );
      return;
    }

    final Set<String> mevcutKategoriler = temizKiyafetler
        .map((k) => kategoriModeldenCikar(k.kategori))
        .where((k) => k.isNotEmpty)
        .toSet();
    final Set<String> eksikKategoriler =
        <String>{'ust', 'alt', 'ayakkabi'}.difference(mevcutKategoriler);

    // Üst/alt eksik olsa bile stilist mevcut parçalarla öneri hazırlar; sadece
    // kombin kurulamayacak kadar eksik (üst ve alt birlikte yok) durumda plan
    // üretilmez, yapay zekâdan metin kombin önerisi istenir.
    if (!mevcutKategoriler.contains('ust') &&
        !mevcutKategoriler.contains('alt')) {
      HaftalikDialoglar.tatliUyariGoster(
          context: context,
          baslik: l10n.haftalikUyariUstEksikBaslik,
          mesaj: l10n.haftalikUyariUstEksikIcerik,
          anaRenk: widget.anaRenk);
      await _eksikParcaStilistOnerisiniGetir(temizKiyafetler);
      return;
    }

    final planGunSayisi = _planlanabilirGunSayisiniBul(temizKiyafetler);
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
        SnackBar(
          content: Text(l10n.haftalikBugunGiyildi),
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
    });

    _yuklemeAnimasyonunuBaslat();

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final String tenRengi =
        aiTenRengi(prefs.getString('kullanici_ten_rengi') ?? 'Wheat');
    final String cinsiyet = aiCinsiyet(
          prefs.getString('kullanici_cinsiyet') ?? 'Women');
    final String tarz =
        aiTarz(prefs.getString('kullanici_tarzi') ?? 'General');
    final String renkPaleti =
        aiRenkPaleti(prefs.getString('kullanici_renk_paleti') ?? 'Mixed');

    final String envanter = temizKiyafetler.asMap().entries.map((entry) {
      final idx = entry.key + 1;
      final item = entry.value;
      final kat = kategoriModeldenCikar(item.kategori);
      return "Clean Item #$idx: ${item.baslik} [Category: $kat] (Color: ${item.renk}, Style: ${item.stil}, Season: ${kiyafetMevsimEtiketi(item)})";
    }).join("\n");

    try {
      final String dilKodu = Localizations.localeOf(context).languageCode;
      final String hedefDil = aiHedefDil(dilKodu);

      final prompt = haftalikPlanPromptu(
        hedefDil: hedefDil,
        aiPlanGunSayisi: aiPlanGunSayisi,
        bugununKombiniKorunacak: bugununKombiniKorunacak,
        cinsiyet: cinsiyet,
        tarz: tarz,
        renkPaleti: renkPaleti,
        tenRengi: tenRengi,
        envanter: envanter,
        eksikKategoriler: eksikKategoriler.join(', '),
        detayliHaftalikHava: widget.detayliHaftalikHava,
      );
      final rawRes = await _haftalikAiYanitiAl(
        sistemPromptu: prompt['sistemPromptu']!,
        kullaniciMesaji: prompt['kullaniciMesaji']!,
      );

      String clean = rawRes.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final int firstBrace = clean.indexOf('{');
      final int lastBrace = clean.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        clean = clean.substring(firstBrace, lastBrace + 1);
      }

      final parsed = _aiPlaniniOnar(
        safeJsonDecodeMap(clean, tag: 'haftalik_ai_plan'),
        temizKiyafetler,
        aiPlanGunSayisi,
      );
      final beklenenGunler = _gelecekGunlerinIngilizceAdlari(
        aiPlanGunSayisi,
        bugununKombiniKorunacak ? 1 : 0,
      );
      final planGunleri = parsed['hafta'] as List;
      for (var i = 0;
          i < planGunleri.length && i < beklenenGunler.length;
          i++) {
        if (planGunleri[i] is Map) {
          planGunleri[i]['gun'] = beklenenGunler[i];
        }
      }
      if (mevcutBugunKombini != null) {
        planGunleri.insert(0, mevcutBugunKombini);
      }
      _planParcalariniHavayaUygunlastir(
        parsed,
        temizKiyafetler,
        l10n,
        baslangicIndex: mevcutBugunKombini != null ? 1 : 0,
      );
      _programiYediGuneTamamla(parsed);
      await ReklamServisi().hakDusur();
      hakDusuruldu = true;
      HapticFeedback.heavyImpact();
      if (mounted) {
        setState(() {
          _haftalikProgram = parsed;
          _yukleniyor = false;
        });
        _yuklemeAnimasyonunuDurdur();
        final planPrefs = await SharedPreferences.getInstance();
        await planPrefs.setString(
          'haftalik_program_baslangic_tarihi',
          DateTime.now().toIso8601String(),
        );
        _programiCihazaKaydet();
        await AnalyticsServisi().olay(
          'weekly_plan_generated',
          {'days': (parsed['hafta'] as List?)?.length ?? 0},
        );
        // Dolap yetmediği için boş kalan günler (ör. hafta sonu) stilistin
        // metin kombin önerisiyle doldurulur.
        _bosGunlerIcinStilistOnerileriniGetir();
        _olusturulanIlkKombiniAc(parsed);
      }
    } catch (e) {
      debugPrint('Haftalık plan oluşturma hatası: $e');
      if (mounted) {
        final String kullaniciHatasi = e is AiServiceException
            ? l10n.haftalikAiServisHatasi
            : e is FormatException
                ? l10n.haftalikAiGecerliPlanYok
                : l10n.haftalikPlanBeklenmeyenHata;
        setState(() {
          _hataMesaji = kullaniciHatasi;
          _yukleniyor = false;
        });
        _yuklemeAnimasyonunuDurdur();
        if (hakDusuruldu) {
          await ReklamServisi().hakIadeEt();
        }
      }
    }
  }

  void _programiTemizle() {
    HapticFeedback.lightImpact();
    setState(() {
      _haftalikProgram = null;
      _hataMesaji = null;
      _favoriEklenenGunler.clear();
      _analizEdilenGunler.clear();
      _giyilmisGunler.clear();
      _seciliGunIndex = 0;
    });
    _programiCihazaKaydet();
  }

  /// Seçili gündeki kombin hakkında yapay zeka ile sohbet penceresini açar.
  void _kombinSohbetiniAc({
    required String gunAdi,
    required String kombinAdi,
    required List<String> parcalar,
    required String gunlukHava,
    required String tuyo,
    required int renkUyumuPuani,
  }) {
    HapticFeedback.lightImpact();

    if (!mounted) return;

    // AI chatbot'u kombin bağlamıyla aç.
    // Görünen mesaj sadece kombin başlığı; parça/renk/hava bilgisi gizli
    // bağlam olarak AI'ya iletilir (chat ekranında görünmez).
    final String baslangicMetni = kombinAdi.isNotEmpty ? kombinAdi : gunAdi;
    final String gizliBaglam = 'Day: $gunAdi\n'
        'Outfit: $kombinAdi\n'
        'Items: ${parcalar.join(", ")}\n'
        'Color Harmony: $renkUyumuPuani%\n'
        'Weather: $gunlukHava\n'
        'AI Advice: $tuyo';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: AiChatbotPenceresi(
          gardirobum: widget.gardirobum,
          gunlukHava: widget.gunlukHava,
          ilkMesaj: baslangicMetni,
          gizliBaglam: gizliBaglam,
          anaRenk: widget.anaRenk,
        ),
      ),
    );
  }

  void _olusturulanIlkKombiniAc(Map<String, dynamic> program) {
    final hafta = program['hafta'];
    if (hafta is! List || hafta.isEmpty || hafta.first is! Map) return;

    final ilkGun = Map<String, dynamic>.from(hafta.first as Map);
    final hamParcalar = ilkGun['parcalar'];
    if (hamParcalar is! List || hamParcalar.isEmpty) return;

    final parcalar = parcalariKategoriyeGoreSirala(hamParcalar, kategoriMetindenCikar);
    if (parcalar.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      HaftalikDialoglar.netGorselModalGoster(
        context: context,
        anaRenk: widget.anaRenk,
        tumParcalarMetinleri: parcalar,
        baslangicIndex: 0,
        parcaBilgisiAyristir: (metin, l10n) => parcaBilgileriniAyristir(metin, l10n),
        gucluGorselBul: (metin) => _gucluGorselBul(metin, widget.gardirobum),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Geri butonu YALNIZCA bu ekran ayrı bir sayfa olarak açıldığında
    // (ilk route DEĞİLSE) gösterilir. Navigator.canPop, açık bir modal/dialog
    // varken de true döndüğü için yanlışlıkla geri butonu açıyordu; bunun
    // yerine ekranın kendi route'unun ilk route olup olmadığına bakıyoruz.
    final ModalRoute<dynamic>? mevcutRoute = ModalRoute.of(context);
    final bool canPop = mevcutRoute != null && !mevcutRoute.isFirst;

    final bool programVarMi =
        _haftalikProgram != null && _haftalikProgram!['hafta'] != null;

    // Eksik parça varsa kullanıcı bilgilendirilir; plan yine de üretilir.
    final String? eksikParcaNotu =
        _eksikParcaStilistNotu(l10n, widget.gardirobum);

    String formatliHavaMetni = widget.gunlukHava
        .replaceAll(
            RegExp(r'^(Konum Bugün:|Location Today:|Konum|Location):?\s*•?',
                caseSensitive: false),
            '')
        .trim();

    // "Sıcaklık — Hava Durumu" metnini ikiye ayır: durum yazısı yerine ikon
    // gösterildiği için uzun durum metinleri kırpılmıyor.
    final int havaAyiriciIndex = formatliHavaMetni.indexOf('—');
    final String havaSicaklikMetni = havaAyiriciIndex == -1
        ? formatliHavaMetni
        : formatliHavaMetni.substring(0, havaAyiriciIndex).trim();
    final String havaDurumMetni = havaAyiriciIndex == -1
        ? ''
        : formatliHavaMetni.substring(havaAyiriciIndex + 1).trim();

    // M3 Standardında Ana Aksiyon Butonu - YEŞİL BUTON
    Widget programButonu = SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: _yukleniyor ? null : _haftalikProgramUret,
        icon: const Icon(Icons.bolt_rounded, size: 22),
        label: Text(
          programVarMi ? l10n.planiYenile : l10n.haftalikProgramOlustur,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (canPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- MATERIAL DESIGN 3 SLIVER APP BAR ---
              SliverAppBar(
                pinned: false,
                floating: false,
                snap: false,
                backgroundColor: Colors.transparent,
                surfaceTintColor: colorScheme.surfaceTint,
                elevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 16,
                toolbarHeight: 64,
                title: Row(
                  children: [
                    if (canPop) ...[
                      IconButton.filledTonal(
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          Navigator.maybePop(context);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surfaceContainerHigh,
                          foregroundColor: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        l10n.haftalikAjandaTitle,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- HATA BİLDİRİM KUTUSU ---
              if (_hataMesaji != null && !programVarMi)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Card(
                      elevation: 0,
                      color: colorScheme.errorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: colorScheme.onErrorContainer,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _hataMesaji!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // --- EKSİK PARÇA / STİLİST NOTU ---
              if (programVarMi && eksikParcaNotu != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Card(
                      elevation: 0,
                      color: colorScheme.tertiaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: colorScheme.onTertiaryContainer,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.haftalikEksikParcaAiOnerisi,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onTertiaryContainer,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    eksikParcaNotu,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onTertiaryContainer,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // --- KOMBİN KURULAMAYINCA STİLİSTİN METİN ÖNERİSİ ---
              if (_eksikParcaOnerisiYukleniyor || _eksikParcaOnerisi != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Card(
                      elevation: 0,
                      color: colorScheme.tertiaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.checkroom_rounded,
                              color: colorScheme.onTertiaryContainer,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.haftalikEksikParcaOnerisiBaslik,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onTertiaryContainer,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_eksikParcaOnerisiYukleniyor)
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color:
                                                colorScheme.onTertiaryContainer,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            l10n.haftalikEksikParcaOneriHazirlaniyor,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: colorScheme
                                                  .onTertiaryContainer,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      _eksikParcaOnerisi!,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onTertiaryContainer,
                                        height: 1.45,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // --- İÇERİK ALANI ---
              if (programVarMi && !_yukleniyor)
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Üst Buton Grubu
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: _programiTemizle,
                                  icon: Icon(
                                    Icons.delete_sweep_rounded,
                                    size: 20,
                                    color: colorScheme.error,
                                  ),
                                  label: FittedBox(
                                    child: Text(
                                      l10n.temizle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: colorScheme.error
                                            .withValues(alpha: 0.4)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: programButonu),
                          ],
                        ),
                      ),

                      if (_hataMesaji != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 6.0),
                          child: Card(
                            elevation: 0,
                            color: colorScheme.errorContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: colorScheme.onErrorContainer,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _hataMesaji!,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onErrorContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // // Weather Bar Widget
                      HavaBar(
                        havaEtiketi: l10n.havaEtiketi,
                        havaSicaklikMetni: havaSicaklikMetni,
                        havaDurumMetni: havaDurumMetni,
                        havaYukleniyor: widget.havaYukleniyor,
                        havaHatasi: widget.havaHatasi,
                        onKonumuYenile: widget.onKonumuYenile,
                        onKonumAyarlariniAc: widget.onKonumAyarlariniAc,
                        havaDurumuIkonu: _havaDurumuIkonu,
                      ),

                      const SizedBox(height: 12),

                      // Gün Seçici Widget
                      GunSecici(
                        hafta: _haftalikProgram!['hafta'] as List,
                        seciliGunIndex: _seciliGunIndex,
                        giyilmisGunler: _giyilmisGunler,
                        anaRenk: widget.anaRenk,
                        gunIsminiCevir: _gunIsminiCevir,
                        onGunSecildi: (index) {
                          HapticFeedback.selectionClick();
                          setState(() => _seciliGunIndex = index);
                        },
                      ),

                      const SizedBox(height: 16),

                      // --- ANA KOMBİN KARTI ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        child: Builder(
                          builder: (context) {
                            final gunItem =
                                _haftalikProgram!['hafta'][_seciliGunIndex];
                            final hamParcalar =
                                gunItem['parcalar'] as List? ?? [];
                            final parcalarListesi =
                                parcalariKategoriyeGoreSirala(hamParcalar, kategoriMetindenCikar);

                            final rawGun = gunItem['gun']?.toString() ?? '';
                            final cevrilmisGun = _gunIsminiCevir(rawGun);
                            final kombinAdi =
                                gunItem['kombin_adi']?.toString() ?? '';
                            final gunlukHavaTahmini =
                                gunItem['gunluk_hava']?.toString() ?? '';
                            final tuyoMetni = gunItem['tuyo']?.toString() ?? '';
                            final renkPuani = gunItem['renk_uyumu_puani'] ?? 90;
                            final bool booleanBosMu = parcalarListesi.isEmpty ||
                                kombinAdi.toLowerCase().contains('uyumsuz') ||
                                kombinAdi
                                    .toLowerCase()
                                    .contains('incompatible');

                            final String eksikParcaAiOnerisi =
                                (gunItem['eksik_parca_onerisi'] ?? '')
                                    .toString()
                                    .trim();
                            final String eksikParcaOneriMetni =
                                eksikParcaAiOnerisi.isNotEmpty
                                    ? metniGuvenliYap(eksikParcaAiOnerisi)
                                    : l10n.haftalikEksikParcaOneriYok;

                            final bool isFavori =
                                _favoriEklenenGunler.contains(_seciliGunIndex);
                            final bool isAnalizEdiliyor =
                                _analizEdilenGunler.contains(_seciliGunIndex);
                            final bool isGiyildi =
                                _giyilmisGunler.contains(_seciliGunIndex);

                            final List<String> temizParcaIsimleri =
                                parcalarListesi.map((p) {
                              final b = parcaBilgileriniAyristir(p.toString(), l10n);
                              return b['baslik'] ?? p.toString();
                            }).toList();

                            final FavoriKombin favoriObjesi = FavoriKombin(
                              baslik: '$kombinAdi ($cevrilmisGun)',
                              parcalar: temizParcaIsimleri,
                              tuyo: tuyoMetni,
                              renkUyumuPuani: renkPuani,
                            );

                            return Card(
                              elevation: 0,
                              color: colorScheme.surfaceContainerLow,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.dialogRadius,
                                side: BorderSide(
                                  color: isGiyildi
                                      ? Colors.green
                                      : colorScheme.outlineVariant,
                                  width: isGiyildi ? 2.0 : 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cevrilmisGun,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),

                                    if (!booleanBosMu &&
                                        kombinAdi.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        kombinAdi,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isGiyildi
                                              ? Colors.green
                                              : widget.anaRenk,
                                        ),
                                      ),
                                    ],

                                    // Rozetler
                                    if (!booleanBosMu ||
                                        gunlukHavaTahmini.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          if (!booleanBosMu)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: colorScheme
                                                    .surfaceContainerHighest,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: isAnalizEdiliyor
                                                  ? SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .analytics_rounded,
                                                          size: 16,
                                                          color: context.uygunMetin,
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          l10n.kombinUyumYuzdesi(
                                                              renkPuani
                                                                  .toString()),
                                                          style: theme.textTheme
                                                              .labelMedium
                                                              ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: colorScheme
                                                                .onSurface,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          if (gunlukHavaTahmini.isNotEmpty)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: colorScheme
                                                    .surfaceContainerHighest,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.cloud_outlined,
                                                    size: 16,
                                                    color: context.uygunMetin,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    gunlukHavaTahmini,
                                                    style: theme
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],

                                    const SizedBox(height: 20),

                                    // Parçalar Listesi
                                    if (booleanBosMu)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          tuyoMetni.isNotEmpty
                                              ? tuyoMetni
                                              : l10n.haftalikUyumsuzParca,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      )
                                    else
                                      SizedBox(
                                        height: 160,
                                        child: ListView.separated(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: parcalarListesi.length,
                                          separatorBuilder: (context, _) =>
                                              const SizedBox(width: 12),
                                          itemBuilder: (context, i) {
                                            final metin =
                                                parcalarListesi[i].toString();
                                            final gorselBytes = _gucluGorselBul(
                                                metin, widget.gardirobum);
                                            final kategoriStr =
                                                kategoriMetindenCikar(metin);
                                            String uiKategori =
                                                kategoriEtiketiGetir(kategoriStr, l10n);

                                            return GestureDetector(
                                              onTap: () => HaftalikDialoglar
                                                  .netGorselModalGoster(
                                                context: context,
                                                anaRenk: widget.anaRenk,
                                                tumParcalarMetinleri:
                                                    parcalarListesi,
                                                baslangicIndex: i,
                                                parcaBilgisiAyristir: (metin, l10n) =>
                                                    parcaBilgileriniAyristir(metin, l10n),
                                                gucluGorselBul: (m) =>
                                                    _gucluGorselBul(
                                                        m, widget.gardirobum),
                                              ),
                                               child: SizedBox(
                                                 width: 120,
                                                 height: 120,
                                                 child: Stack(
                                                   fit: StackFit.expand,
                                                   children: [
                                                     if (gorselBytes != null)
                                                       Image.memory(
                                                         gorselBytes,
                                                         fit: BoxFit.cover,
                                                       )
                                                     else
                                                       Center(
                                                         child: Icon(
                                                           Icons
                                                               .checkroom_rounded,
                                                           size: 36,
                                                           color: context.uygunMetin,
                                                         ),
                                                       ),

                                                     // Parça Değiştir Butonu
                                                     Positioned(
                                                       top: 6,
                                                       right: 6,
                                                       child: InkWell(
                                                         onTap: () =>
                                                             _parcaDegistirmeyiTetikle(
                                                           _seciliGunIndex,
                                                           metin,
                                                         ),
                                                         child: ClipRRect(
                                                           borderRadius:
                                                               BorderRadius
                                                                   .circular(20),
                                                           child: BackdropFilter(
                                                             filter: ImageFilter
                                                                 .blur(
                                                               sigmaX: 6,
                                                               sigmaY: 6,
                                                             ),
                                                             child: Container(
                                                               padding:
                                                                   const EdgeInsets
                                                                       .all(6),
                                                               decoration:
                                                                   BoxDecoration(
                                                                 color: Colors
                                                                     .black
                                                                     .withValues(
                                                                         alpha:
                                                                             0.3),
                                                                 shape: BoxShape
                                                                     .circle,
                                                               ),
                                                               child: const Icon(
                                                                 Icons
                                                                     .sync_rounded,
                                                                 size: 16,
                                                                 color: Colors
                                                                     .white,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                            );
                                          },
                                        ),
                                      ),

                                    // Kombin kurulamayan (tamamen boş) günlerde
                                    // stilistin metin kombin önerisi gösterilir;
                                    // kombin oluşan günlerde bu kutu çıkmaz.
                                    if (booleanBosMu) ...[
                                      const SizedBox(height: 16),
                                      AiOneriKutusu(
                                        baslik: l10n.haftalikEksikParcaAiOnerisi,
                                        metin: eksikParcaOneriMetni,
                                        yukleniyor: _bosGunOnerileriYukleniyor &&
                                            eksikParcaAiOnerisi.isEmpty,
                                        onTekrarDene:
                                            eksikParcaAiOnerisi.isEmpty
                                                ? _bosGunlerIcinStilistOnerileriniGetir
                                                : null,
                                      ),
                                    ],

                                    // Stilist İpucu Kutusu (YUMUŞAK PASTEL LAVANTA TONLARI)
                                    if (!booleanBosMu) ...[
                                      const SizedBox(height: 20),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppTints.styleistBgDinamik(context),
                                          borderRadius:
                                              AppRadius.xlRadius,
                                          border: Border.all(
                                            color: AppTints.styleistBorderDinamik(context),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome_rounded,
                                              size: 18,
                                              color: AppAccents.styleist,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: isAnalizEdiliyor
                                                  ? Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: AppMiscColors
                                                                .styleistTextDinamik(
                                                                    context),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          l10n.yenidenDegerlendiriliyor,
                                                          style: theme.textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color:
                                                                AppMiscColors
                                                                    .styleistAltTextDinamik(
                                                                        context),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      metniGuvenliYap(
                                                          tuyoMetni),
                                                      style: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppMiscColors
                                                            .styleistTextDinamik(
                                                                context),
                                                        height: 1.45,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Favori Butonu
                                        IconButton.filledTonal(
                                          icon: Icon(
                                            isFavori
                                                ? Icons.star_rounded
                                                : Icons.star_outline_rounded,
                                            size: 22,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: isFavori
                                                ? AppStatusColors.favoriteBgDinamik(context)
                                                : colorScheme
                                                    .surfaceContainerHighest,
                                            foregroundColor: isFavori
                                                ? AppStatusColors.favoriteFgDinamik(context)
                                                : colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () {
                                            HapticFeedback.lightImpact();
                                            setState(() {
                                              if (isFavori) {
                                                _favoriEklenenGunler
                                                    .remove(_seciliGunIndex);
                                                widget.onFavoriSil
                                                    ?.call(favoriObjesi);
                                              } else {
                                                _favoriEklenenGunler
                                                    .add(_seciliGunIndex);
                                                widget
                                                    .onFavoriEkle(favoriObjesi);
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 8),

                                        // Giydim Butonu
                                        IconButton.filledTonal(
                                          icon: Icon(
                                            isGiyildi
                                                ? Icons.check_circle_rounded
                                                : Icons
                                                    .check_circle_outline_rounded,
                                            size: 22,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: isGiyildi
                                                ? AppStatusColors.wornBgDinamik(context)
                                                : colorScheme
                                                    .surfaceContainerHighest,
                                            foregroundColor: isGiyildi
                                                ? AppStatusColors.wornFgDinamik(context)
                                                : colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () {
                                            final List<Kiyafet> guncelParcalar =
                                                [];
                                            for (var pMetin
                                                in parcalarListesi) {
                                              final kiyafet =
                                                  _metindenKiyafetBul(
                                                      pMetin.toString(),
                                                      widget.gardirobum);
                                              if (kiyafet != null &&
                                                  !guncelParcalar
                                                      .contains(kiyafet)) {
                                                guncelParcalar.add(kiyafet);
                                              }
                                            }
                                            final String parcaIsimleriMetni =
                                                guncelParcalar.isNotEmpty
                                                    ? guncelParcalar
                                                        .map((k) =>
                                                            k.gorunenBaslik)
                                                        .join(", ")
                                                    : temizParcaIsimleri
                                                        .join(", ");

                                            _bugunGiydimTetikle(
                                              index: _seciliGunIndex,
                                              kombinAdi: kombinAdi,
                                              parcaIsimleriMetni:
                                                  parcaIsimleriMetni,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        // Sohbet Butonu
                                        Tooltip(
                                          message: l10n.kombinSohbetAc,
                                          child: IconButton.filledTonal(
                                            icon: const Icon(
                                              Icons.chat_bubble_outline_rounded,
                                              size: 22,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor: colorScheme
                                                  .surfaceContainerHighest,
                                              foregroundColor:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            onPressed: booleanBosMu
                                                ? null
                                                : () => _kombinSohbetiniAc(
                                                      gunAdi: cevrilmisGun,
                                                      kombinAdi: kombinAdi,
                                                      parcalar: parcalarListesi
                                                          .map((p) =>
                                                              p.toString())
                                                          .toList(),
                                                      gunlukHava:
                                                          gunlukHavaTahmini,
                                                      tuyo: tuyoMetni,
                                                      renkUyumuPuani: renkPuani
                                                              is num
                                                          ? renkPuani.toInt()
                                                          : 90,
                                                    ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // --- YÜKLENİYOR DURUMU ---
              if (_yukleniyor)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: colorScheme.onSurfaceVariant,
                          strokeWidth: 3.5,
                        ),
                        const SizedBox(height: 24),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 240),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: Text(
                            _yuklemeMesajlari.isNotEmpty
                                ? _yuklemeMesajlari[_yuklemeMesajiIndex]
                                : '',
                            key: ValueKey<int>(_yuklemeMesajiIndex),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // --- BOŞ EKRAN DURUMU ---
              if (!programVarMi && !_yukleniyor)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _eksikParcaOnerisi != null
                                ? Icons.checkroom_rounded
                                : Icons.auto_awesome_mosaic_rounded,
                            size: 64,
                            color: context.uygunMetin,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _eksikParcaOnerisiYukleniyor ||
                                  _eksikParcaOnerisi != null
                              ? l10n.haftalikEksikParcaPlanKurulamadi
                              : l10n.haftalikUyariDolapBosIcerik,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(width: double.infinity, child: programButonu),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
