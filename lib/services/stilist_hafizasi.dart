// Yaşayan stilist — kalıcı hafıza (v1).
//
// Sorun: sohbet penceresi kapandığında yapay zekâ kullanıcıyı tamamen unutuyor;
// her sohbet "tanımadığı biri" ile başlıyordu (yalnızca son 4 mesaj + 3 sabit
// tercih modele gidiyordu).
//
// Çözüm: kullanıcı hakkında kalıcı bilgiler (tarz, fit, sevilen/kaçınılan
// renkler, beğenmediği öneriler, sık kullanılan vesileler) cihazda saklanır ve
// sonraki sohbetlerin sistem promptuna eklenir.
//
// Nasıl çalışır:
//   • [promptBlogu] her AI isteğinde prompta eklenir; ağa çıkmaz, bellektedir.
//   • [sohbettenOgren] sohbet sonunda (ve uzun sohbetlerde ara ara) TEK bir
//     küçük AI çağrısıyla sohbetten kalıcı bilgileri çıkarır, [ogrenmeyiUygula]
//     bunları mevcut notlarla birleştirir (tekrar eden not eklenmez).
//   • Ağ/kota hatası olursa sessizce vazgeçilir; mevcut hafıza bozulmaz ve
//     sohbet akışı hiçbir şekilde etkilenmez.
//
// Gizlilik: veri yalnızca cihazda (SharedPreferences) tutulur; sunucuya
// gönderilmez. Kullanıcı [temizle] ile tamamen silebilir, [acikAyarla] ile
// kapatabilir.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers.dart';
import 'ai_service.dart';

class StilistHafizasi {
  StilistHafizasi._();
  static final StilistHafizasi _ornek = StilistHafizasi._();
  factory StilistHafizasi() => _ornek;

  /// SharedPreferences anahtarı. Şema değişirse sürüm eki artırılır.
  static const String anahtar = 'stilist_hafizasi_v1';

  /// Saklanan en fazla not sayısı; sınır aşılırsa en eski not düşer.
  static const int enFazlaNot = 40;

  /// Tek bir notun en fazla uzunluğu (karakter).
  static const int enFazlaNotUzunlugu = 160;

  /// Özetin en fazla uzunluğu (karakter).
  static const int enFazlaOzetUzunlugu = 1000;

  /// Öğrenmenin devreye girmesi için gereken en az kullanıcı mesajı.
  static const int enAzKullaniciMesaji = 2;

  /// Öğrenme için gereken en az sohbet dökümü uzunluğu (karakter).
  static const int enAzSohbetUzunlugu = 60;

  List<String> _notlar = <String>[];
  String _ozet = '';
  int _sohbetSayisi = 0;
  DateTime? _guncellenme;
  bool _acik = true;
  bool _yuklendi = false;
  bool _ogreniyor = false;

  List<String> get notlar => List.unmodifiable(_notlar);
  String get ozet => _ozet;
  int get sohbetSayisi => _sohbetSayisi;
  DateTime? get guncellenme => _guncellenme;
  bool get acik => _acik;

  /// Şu an bir öğrenme isteği sürüyor mu (aynı anda iki istek gitmesin).
  bool get ogreniyor => _ogreniyor;

  /// Hafızada hiçbir şey yok mu (not yok ve özet boş).
  bool get bosMu => _notlar.isEmpty && _ozet.trim().isEmpty;

  /// Hafızayı diskten okur. Varsayılan olarak bir kez okur ve bellekte tutar;
  /// [zorla] ile yeniden okunabilir.
  Future<void> yukle({bool zorla = false}) async {
    if (_yuklendi && !zorla) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final ham = prefs.getString(anahtar);
      if (ham != null && ham.isNotEmpty) {
        _veriyiCoz(safeJsonDecodeMap(ham, tag: 'stilist_hafizasi'));
      } else {
        // Diskte kayıt yok: belleği de boşalt (silinmiş hafıza geri gelmesin).
        _notlar = <String>[];
        _ozet = '';
        _sohbetSayisi = 0;
        _guncellenme = null;
      }
    } catch (e) {
      debugPrint('Stilist hafızası okunamadı: $e');
    }
    _yuklendi = true;
  }

  /// Hafızayı diske yazar.
  Future<void> kaydet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        anahtar,
        jsonEncode(<String, dynamic>{
          'surum': 1,
          'acik': _acik,
          'notlar': _notlar,
          'ozet': _ozet,
          'sohbet_sayisi': _sohbetSayisi,
          if (_guncellenme != null)
            'guncellenme': _guncellenme!.toIso8601String(),
        }),
      );
    } catch (e) {
      debugPrint('Stilist hafızası yazılamadı: $e');
    }
  }

  /// Sistem promptuna eklenecek hafıza bloğu. Hafıza boşsa ya da kullanıcı
  /// hafızayı kapatmışsa boş string döner.
  String promptBlogu() {
    if (!_acik || bosMu) return '';

    final satirlar = StringBuffer()
      ..writeln('[LONG-TERM MEMORY ABOUT THIS USER]')
      ..writeln(
        'Facts you learned in earlier chats with this user. Stay consistent '
        'with them and reuse them naturally:',
      );
    for (final not in _notlar) {
      satirlar.writeln('- $not');
    }
    if (_ozet.trim().isNotEmpty) {
      satirlar.writeln('[RECENT CHAT CONTEXT]: ${_ozet.trim()}');
    }
    satirlar.writeln(
      'Rules: never say that you keep notes and never quote this block '
      'verbatim. If the user says something that contradicts a note, trust '
      'the newest information and treat the old note as outdated.',
    );
    return satirlar.toString().trimRight();
  }

  /// Sohbet dökümünden kalıcı bilgileri çıkarır. Başarılıysa `true` döner.
  ///
  /// Tek bir küçük AI çağrısı yapar; hata durumunda sessizce `false` döner
  /// (sohbet akışı etkilenmez).
  Future<bool> sohbettenOgren(String sohbetDokumu) async {
    await yukle();
    if (!_acik || _ogreniyor) return false;

    final dokum = sohbetDokumu.trim();
    if (dokum.length < enAzSohbetUzunlugu) return false;

    _ogreniyor = true;
    try {
      final cevap = await AiService().sadeceMetinSorgula(
        sistemPromptu: _cikarimPromptu,
        kullaniciMesaji: dokum,
      );
      final veri = jsonCikar(cevap);
      if (veri.isEmpty) return false;
      final degisti = ogrenmeyiUygula(veri);
      _sohbetSayisi++;
      await kaydet();
      return degisti;
    } catch (e) {
      debugPrint('Stilist hafızası güncellenemedi: $e');
      return false;
    } finally {
      _ogreniyor = false;
    }
  }

  /// AI'dan gelen çıkarım verisini hafızaya işler.
  ///
  /// Ağ çağrısından ayrı tutuldu; böylece tek başına test edilebilir.
  /// Dönen değer: hafıza gerçekten değişti mi.
  @visibleForTesting
  bool ogrenmeyiUygula(Map<String, dynamic> veri) {
    var degisti = false;

    final hamNotlar = veri['notlar'];
    if (hamNotlar is List) {
      for (final ham in hamNotlar) {
        if (ham is! String) continue;
        final not = _notuTemizle(ham);
        if (not.isEmpty) continue;
        if (_notlar.any((mevcut) => _ayniNotMu(mevcut, not))) continue;
        _notlar.add(not);
        degisti = true;
      }
    }
    while (_notlar.length > enFazlaNot) {
      _notlar.removeAt(0);
    }

    final hamOzet = veri['ozet'];
    if (hamOzet is String) {
      final ozet = hamOzet.trim();
      if (ozet.isNotEmpty && ozet != _ozet) {
        _ozet = ozet.length > enFazlaOzetUzunlugu
            ? ozet.substring(0, enFazlaOzetUzunlugu)
            : ozet;
        degisti = true;
      }
    }

    if (degisti) _guncellenme = DateTime.now();
    return degisti;
  }

  /// Modelin cevabından JSON nesnesini ayıklar; cevap ```json çitleri içerse
  /// ya da etrafında fazladan metin olsa da çalışır. Bulunamazsa boş map döner.
  @visibleForTesting
  Map<String, dynamic> jsonCikar(String cevap) {
    final temiz = cevap.trim();
    if (temiz.isEmpty) return <String, dynamic>{};
    final bas = temiz.indexOf('{');
    final son = temiz.lastIndexOf('}');
    if (bas < 0 || son <= bas) return <String, dynamic>{};
    return safeJsonDecodeMap(
      temiz.substring(bas, son + 1),
      tag: 'stilist_hafizasi_cevap',
    );
  }

  /// Hafızayı tamamen siler (kullanıcı "unut beni" dediğinde).
  Future<void> temizle() async {
    _notlar = <String>[];
    _ozet = '';
    _sohbetSayisi = 0;
    _guncellenme = null;
    await kaydet();
  }

  /// Hafızayı aç/kapat. Kapalıyken prompta eklenmez ve yeni bilgi öğrenilmez.
  Future<void> acikAyarla(bool deger) async {
    _acik = deger;
    await kaydet();
  }

  void _veriyiCoz(Map<String, dynamic> veri) {
    _notlar = <String>[];
    _ozet = '';
    _sohbetSayisi = 0;
    _guncellenme = null;

    final notlar = veri['notlar'];
    if (notlar is List) {
      _notlar = notlar
          .whereType<String>()
          .map((n) => n.trim())
          .where((n) => n.isNotEmpty)
          .take(enFazlaNot)
          .toList();
    }
    final ozet = veri['ozet'];
    if (ozet is String) _ozet = ozet.trim();

    final sayi = veri['sohbet_sayisi'];
    if (sayi is int) _sohbetSayisi = sayi;

    final tarih = veri['guncellenme'];
    if (tarih is String) _guncellenme = DateTime.tryParse(tarih);

    final acik = veri['acik'];
    if (acik is bool) _acik = acik;
  }

  String _notuTemizle(String ham) {
    var not = ham.trim().replaceAll(RegExp(r'\s+'), ' ');
    while (not.startsWith('-') || not.startsWith('•') || not.startsWith('*')) {
      not = not.substring(1).trim();
    }
    if (not.length > enFazlaNotUzunlugu) {
      not = not.substring(0, enFazlaNotUzunlugu).trimRight();
    }
    return not;
  }

  /// İki notun aynı şeyi söyleyip söylemediğine kaba biçimde bakar:
  /// büyük/küçük harf, boşluk ve noktalama farkları yok sayılır; biri diğerini
  /// içeriyorsa da aynı kabul edilir. Böylece aynı not defalarca birikmez.
  ///
  /// Kısa metinlerde "içerme" kuralı yanlış eşleşme ürettiği için (örn.
  /// "note 1" ⊂ "note 10") en az [_enAzIcermeUzunlugu] karakter şartı aranır.
  bool _ayniNotMu(String a, String b) {
    String sadele(String s) => s
        .toLowerCase()
        .replaceAll(
          RegExp(r'''[\s.,;:!?()\[\]{}"'`´’“”\-_/\\|*+&#@%^~<>=]+'''),
          '',
        );
    final x = sadele(a);
    final y = sadele(b);
    if (x.isEmpty || y.isEmpty) return x == y;
    if (x == y) return true;

    final kisa = x.length <= y.length ? x : y;
    final uzun = x.length <= y.length ? y : x;
    if (kisa.length < _enAzIcermeUzunlugu) return false;
    return uzun.contains(kisa);
  }

  /// "İçeriyorsa aynı not" kuralının uygulanması için gereken en az uzunluk.
  static const int _enAzIcermeUzunlugu = 12;

  /// Hafıza çıkarımı için sistem promptu (diğer promptlar gibi İngilizce;
  /// notların dili kullanıcının diline bırakılır).
  static const String _cikarimPromptu = '''
You are the long-term memory module of a personal stylist app. You receive a transcript of a chat between "User" and "Stylist".

Extract ONLY durable facts about the user that will still matter in future chats: style taste, preferred or avoided fits, favourite or avoided colours, suggestions the user disliked, body/height notes, habitual occasions, recurring needs.

Never store temporary things: today's weather, what the user is wearing right now, one-off requests, the stylist's own suggestions, or anything you are not sure about. Never invent facts.

Reply with ONLY a JSON object, no markdown, no explanation:
{"notlar": ["..."], "ozet": "..."}

- "notlar": at most 3 short items, each at most 120 characters, written in the SAME LANGUAGE the user writes in. These notes may be shown to the user later, so keep them neutral and factual (for example: "Prefers oversize tops, dislikes tight trousers").
- "ozet": at most 400 characters summarising the user's recent chats with the stylist, in the user's language.
- If nothing durable can be learned, reply exactly: {"notlar": [], "ozet": ""}
''';
}
