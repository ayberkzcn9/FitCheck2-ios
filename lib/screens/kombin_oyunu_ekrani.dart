import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../l10n/app_localizations.dart';
import '../utils/l10n_combo_ext.dart';
import '../models/kiyafet.dart';
import '../../theme/design_tokens.dart';

class KombinOyunuEkrani extends StatefulWidget {
  const KombinOyunuEkrani({super.key, this.onReturnToHome, this.gardirobum});
  final VoidCallback? onReturnToHome;
  final List<Kiyafet>? gardirobum;

  @override
  State<KombinOyunuEkrani> createState() => _KombinOyunuEkraniState();
}

class _BazKombin {
  final String id;
  final String ortamKey;
  final String havaKey;
  final String ustParcaUrl;
  final String altParcaUrl;
  final String ustRenkKey;
  final String altRenkKey;
  final String kategori;
  final List<_Secenek> secenekler;
  final int dogruIndex;

  const _BazKombin({
    required this.id,
    required this.ortamKey,
    required this.havaKey,
    required this.ustParcaUrl,
    required this.altParcaUrl,
    required this.ustRenkKey,
    required this.altRenkKey,
    required this.kategori,
    required this.secenekler,
    required this.dogruIndex,
  });
}

class _Secenek {
  final String imageUrl;
  final String aciklamaKey;
  final String renkKey;

  const _Secenek({
    required this.imageUrl,
    required this.aciklamaKey,
    required this.renkKey,
  });
}

// Şablon sınıfı - kombinasyon şablonları için
class _KombinSablon {
  final String id;
  final String ortamKey;
  final String havaKey;
  final String ustParcaUrl;
  final String altParcaUrl;
  final String ustRenkKey;
  final String altRenkKey;
  final String kategori;
  final String kategoriTr;
  final List<String> uygunRenkler;
  final int fallbackDogruIndex;

  const _KombinSablon({
    required this.id,
    required this.ortamKey,
    required this.havaKey,
    required this.ustParcaUrl,
    required this.altParcaUrl,
    required this.ustRenkKey,
    required this.altRenkKey,
    required this.kategori,
    required this.kategoriTr,
    required this.uygunRenkler,
    required this.fallbackDogruIndex,
  });
}

class _KombinOyunuEkraniState extends State<KombinOyunuEkrani> with SingleTickerProviderStateMixin {
  static const int _toplamTur = 5;
  static const int _turSuresi = 25;

  /// 🚧 PLAY STORE: Oyun henüz hazır değil. Yayın için 'Yakında' ekranı gösterilir.
  /// Oyunu yeniden açmak için bu değeri true yapın.
  static const bool _oyunEtkin = false;

  late List<_BazKombin> _tumKombinler;
  int _turIndex = 0;
  int _skor = 0;
  int? _secilenIndex;
  bool _turBitti = false;
  bool _oyunBitti = false;
  bool _yukleniyor = true;
  bool _sureDolduMu = false;

  Timer? _timer;
  Timer? _gecisTimer;
  Timer? _dogruGosterTimer;

  late final AnimationController _skorAnimController;
  late final Animation<double> _skorScaleAnim;

  // Dolaptan eşleşen parçaları cache'le
  final Map<String, List<Kiyafet>> _uygunParcalarCache = {};

  @override
  void initState() {
    super.initState();
    _skorAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _skorScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _skorAnimController, curve: Curves.elasticOut),
    );
    if (_oyunEtkin) {
      _kombinleriHazirla();
      _baslat();
    }
  }

  // Kombinasyonları hazırla (şablon listesi, dolap parçaları, fallback mantığı)
  void _kombinleriHazirla() {

  // Dolaptan aynı kategorideki temiz parçaları getir (renk filtresi YOK)
  List<Kiyafet> dolaptanKategoriParcalari(String kategori) {
    final cacheKey = 'kategori:$kategori';
    if (_uygunParcalarCache.containsKey(cacheKey)) {
      return _uygunParcalarCache[cacheKey]!;
    }

    final gardirobum = widget.gardirobum ?? [];
    final sonuc = gardirobum.where((k) {
      final kategoriEslesiyor = k.kategori.toLowerCase() == kategori.toLowerCase();
      final temiz = !k.sepetteMi;
      return kategoriEslesiyor && temiz;
    }).toList();

    _uygunParcalarCache[cacheKey] = sonuc;
    return sonuc;
  }

  // Parçanın rengi, kombinin uygun renkleriyle uyumlu mu?
  bool renkUyumluMu(Kiyafet k, List<String> uygunRenkler) {
    return uygunRenkler.any((r) => k.renk.toLowerCase().contains(r.toLowerCase()));
  }

  // Kiyafet'ten _Secenek oluştur
  _Secenek kiyafettenSecenekOlustur(Kiyafet k, {required bool dogruMu}) {
    // Convert Uint8List to base64 data URL for image
    String imageUrl = 'data:image/png;base64,${base64Encode(k.resimBytes)}';
    return _Secenek(
      imageUrl: imageUrl,
      aciklamaKey: k.gorunenBaslik, // Gerçek ürün adı (örn: "Mavi Kazak") - l10n anahtarı DEĞİL
      renkKey: k.renk,
    );
  }

  // Fallback _Secenek oluştur (hazır setler için)
  _Secenek fallbackSecenekOlustur({
    required String imageUrl,
    required String aciklamaKey,
    required String renkKey,
  }) {
    return _Secenek(
      imageUrl: imageUrl,
      aciklamaKey: aciklamaKey,
      renkKey: renkKey,
    );
  }

  // Şablondan _BazKombin oluştur (dolaptan çekme + fallback)
  _BazKombin? sablondanKombinOlustur(_KombinSablon sablon, {bool forceFallback = false}) {
    // ASCII kategori kullan ('ayakkabi'), çünkü dolap kategorileri ASCII formatında
    // ('ayakkabı' Türkçe ı ile dolaptaki 'ayakkabi' ASLA eşleşmezdi!)
    final tumParcalar = forceFallback ? <Kiyafet>[] : dolaptanKategoriParcalari(sablon.kategori);

    // Renk uyumuna göre ayır: DOĞRU cevap uyumlu, YANLIŞLAR uyumsuz renkli olmalı
    // (Böylece oyuncu kombinin renklerine bakarak doğru cevabı ayırt edebilir)
    final uyumluParcalar = tumParcalar.where((k) => renkUyumluMu(k, sablon.uygunRenkler)).toList();
    final uyumsuzParcalar = tumParcalar.where((k) => !renkUyumluMu(k, sablon.uygunRenkler)).toList();

    int dogruIndex;

    if (!forceFallback && uyumluParcalar.isNotEmpty && uyumsuzParcalar.length >= 3) {
      // Doğru: renk uyumlu parça, yanlış: aynı kategoriden uyumsuz renkli parçalar
      final dogruParca = (uyumluParcalar..shuffle()).first;
      final yanlisParcalar = (uyumsuzParcalar..shuffle()).take(3).toList();

      // Doğru parçayı rastgele bir indekse yerleştir
      final random = Random();
      dogruIndex = random.nextInt(4);

      final seceneklerList = <_Secenek>[];
      for (int i = 0; i < 4; i++) {
        if (i == dogruIndex) {
          seceneklerList.add(kiyafettenSecenekOlustur(dogruParca, dogruMu: true));
        } else {
          final yanlisParca = yanlisParcalar[i < dogruIndex ? i : i - 1];
          seceneklerList.add(kiyafettenSecenekOlustur(yanlisParca, dogruMu: false));
        }
      }
      return _BazKombin(
        id: sablon.id,
        ortamKey: sablon.ortamKey,
        havaKey: sablon.havaKey,
        ustParcaUrl: sablon.ustParcaUrl,
        altParcaUrl: sablon.altParcaUrl,
        ustRenkKey: sablon.ustRenkKey,
        altRenkKey: sablon.altRenkKey,
        kategori: sablon.kategori,
        secenekler: seceneklerList,
        dogruIndex: dogruIndex,
      );
    } else {
      // Fallback: Hazır Unsplash URL'leri ile
      final fallbackSecenekler = <_Secenek>[];

      // Kategoriye göre fallback URL'leri
      final fallbackUrlMap = <String, List<String>>{
        'ayakkabi': [
          'https://images.unsplash.com/photo-1614252369475-531eba835eb1?w=300&h=300&fit=crop', // kahverengi oxford
          'https://images.unsplash.com/photo-1600269452121-4f2416e55c28?w=300&h=300&fit=crop', // siyah derby
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300&h=300&fit=crop', // beyaz spor
          'https://images.unsplash.com/photo-1520639888713-1b9b2b2c8b5e?w=300&h=300&fit=crop', // kahverengi cizme
        ],
        'ceket': [
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&h=300&fit=crop', // siyah blazer
          'https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=300&h=300&fit=crop', // kirmizi deri
          'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=300&h=300&fit=crop', // altin detayli
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=300&fit=crop', // beyaz pufy
        ],
        'aksesuar': [
          'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=300&h=300&fit=crop', // beyaz bespan
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&h=300&fit=crop', // siyah gunes
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop', // siyah cantasi
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop', // gumus saat
        ],
      };

      final urls = fallbackUrlMap[sablon.kategori] ?? fallbackUrlMap['ayakkabi']!;
      final aciklamalarMap = <String, List<String>>{
        'ayakkabi': [
          'kombinSecenekKahverengiOxford',
          'kombinSecenekSiyahDerby',
          'kombinSecenekBeyazSpor',
          'kombinSecenekKahverengiCizme',
        ],
        'ceket': [
          'kombinSecenekSiyahBlazer',
          'kombinSecenekKirmiziDeriCeket',
          'kombinSecenekAltinDetayliCeket',
          'kombinSecenekBeyazPufy',
        ],
        'aksesuar': [
          'kombinSecenekBeyazBespan',
          'kombinSecenekSiyahGunes',
          'kombinSecenekSiyahSirtCantasi',
          'kombinSecenekGumusAkilliSaat',
        ],
      };

      final aciklamalar = aciklamalarMap[sablon.kategori] ?? aciklamalarMap['ayakkabi']!;
      final renklerMap = <String, List<String>>{
        'ayakkabi': ['kombinRenkKahverengi', 'kombinRenkSiyah', 'kombinRenkBeyaz', 'kombinRenkKahverengi'],
        'ceket': ['kombinRenkSiyah', 'kombinRenkKirmizi', 'kombinRenkAltin', 'kombinRenkBeyaz'],
        'aksesuar': ['kombinRenkBeyaz', 'kombinRenkSiyah', 'kombinRenkSiyah', 'kombinRenkGumus'],
      };
      final renkler = renklerMap[sablon.kategori] ?? renklerMap['ayakkabi']!;

      for (int i = 0; i < 4; i++) {
        fallbackSecenekler.add(fallbackSecenekOlustur(
          imageUrl: urls[i],
          aciklamaKey: aciklamalar[i],
          renkKey: renkler[i],
        ));
      }

      // Doğru cevabı rastgele yerleştir
      final dogruIdx = Random().nextInt(4);
      final temp = fallbackSecenekler[dogruIdx];
      fallbackSecenekler[dogruIdx] = fallbackSecenekler[sablon.fallbackDogruIndex];
      fallbackSecenekler[sablon.fallbackDogruIndex] = temp;

      return _BazKombin(
        id: sablon.id,
        ortamKey: sablon.ortamKey,
        havaKey: sablon.havaKey,
        ustParcaUrl: sablon.ustParcaUrl,
        altParcaUrl: sablon.altParcaUrl,
        ustRenkKey: sablon.ustRenkKey,
        altRenkKey: sablon.altRenkKey,
        kategori: sablon.kategori,
        secenekler: fallbackSecenekler,
        dogruIndex: dogruIdx, // Swap sonrası doğru cevabın YENİ konumu (eski konum DEĞİL!)
      );
    }
  }

    // Temel kombinasyon şablonları
    final sablonlar = <_KombinSablon>[
      _KombinSablon(
        id: 'k1',
        ortamKey: 'kombinOrtamOfis',
        havaKey: 'kombinHavaGunesli',
        ustParcaUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkBeyaz',
        altRenkKey: 'kombinRenkLacivert',
        kategori: 'ayakkabi',
        kategoriTr: 'ayakkabı',
        uygunRenkler: ['kahverengi', 'siyah', 'beyaz', 'koyu mavi'],
        fallbackDogruIndex: 1,
      ),
      _KombinSablon(
        id: 'k2',
        ortamKey: 'kombinOrtamCasual',
        havaKey: 'kombinHavaYagmurlu',
        ustParcaUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkBej',
        altRenkKey: 'kombinRenkKoyuYesil',
        kategori: 'ayakkabi',
        kategoriTr: 'ayakkabı',
        uygunRenkler: ['siyah', 'kahverengi', 'koyu mavi', 'gri'],
        fallbackDogruIndex: 1,
      ),
      _KombinSablon(
        id: 'k3',
        ortamKey: 'kombinOrtamDavet',
        havaKey: 'kombinHavaSoguk',
        ustParcaUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1584689484140-3323b1a9a4e1?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkSiyah',
        altRenkKey: 'kombinRenkSiyah',
        kategori: 'ceket',
        kategoriTr: 'ceket',
        uygunRenkler: ['siyah', 'kirmizi', 'altin', 'koyu mavi'],
        fallbackDogruIndex: 2,
      ),
      _KombinSablon(
        id: 'k4',
        ortamKey: 'kombinOrtamSpor',
        havaKey: 'kombinHavaSicak',
        ustParcaUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkGri',
        altRenkKey: 'kombinRenkSiyah',
        kategori: 'ayakkabi',
        kategoriTr: 'ayakkabı',
        uygunRenkler: ['beyaz', 'siyah', 'mavi', 'kahverengi'],
        fallbackDogruIndex: 0,
      ),
      _KombinSablon(
        id: 'k5',
        ortamKey: 'kombinOrtamCasual',
        havaKey: 'kombinHavaGunesli',
        ustParcaUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1604176354204-9268737408c3?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkPastelMavi',
        altRenkKey: 'kombinRenkBeyaz',
        kategori: 'aksesuar',
        kategoriTr: 'aksesuar',
        uygunRenkler: ['beyaz', 'siyah', 'altin', 'gumus'],
        fallbackDogruIndex: 0,
      ),
      _KombinSablon(
        id: 'k6',
        ortamKey: 'kombinOrtamOfis',
        havaKey: 'kombinHavaSoguk',
        ustParcaUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkGri',
        altRenkKey: 'kombinRenkKahverengi',
        kategori: 'ceket',
        kategoriTr: 'ceket',
        uygunRenkler: ['kahverengi', 'siyah', 'kirmizi', 'koyu mavi'],
        fallbackDogruIndex: 0,
      ),
      _KombinSablon(
        id: 'k7',
        ortamKey: 'kombinOrtamDavet',
        havaKey: 'kombinHavaGunesli',
        ustParcaUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkAcikMavi',
        altRenkKey: 'kombinRenkBej',
        kategori: 'aksesuar',
        kategoriTr: 'aksesuar',
        uygunRenkler: ['kahverengi', 'siyah', 'navy', 'bej'],
        fallbackDogruIndex: 2,
      ),
      _KombinSablon(
        id: 'k8',
        ortamKey: 'kombinOrtamSpor',
        havaKey: 'kombinHavaYagmurlu',
        ustParcaUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=300&h=300&fit=crop',
        altParcaUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=300&h=300&fit=crop',
        ustRenkKey: 'kombinRenkKoyuMavi',
        altRenkKey: 'kombinRenkSiyah',
        kategori: 'ayakkabi',
        kategoriTr: 'ayakkabı',
        uygunRenkler: ['gri', 'kahverengi', 'siyah', 'beyaz'],
        fallbackDogruIndex: 0,
      ),
    ];

    // Şablonları karıştır ve 5 tanesini seç
    final random = Random();
    final secilenSablonlar = List<_KombinSablon>.from(sablonlar)..shuffle(random);
    final secilenSablonlar5 = secilenSablonlar.take(_toplamTur).toList();

    // Her şablon için kombinasyon oluştur
    final allKombinler = <_BazKombin>[];
    for (final sablon in secilenSablonlar5) {
      final kombin = sablondanKombinOlustur(sablon);
      if (kombin != null) {
        allKombinler.add(kombin);
      }
    }

    // Eğer az kombinasyon oluştuysa (dolap boşsa) fallback setleri de ekle
    if (allKombinler.length < _toplamTur) {
      // Fallback şablonları da karıştırıp ekle
      final fallbackSablonlar = <_KombinSablon>[
        _KombinSablon(
          id: 'fb1',
          ortamKey: 'kombinOrtamOfis',
          havaKey: 'kombinHavaGunesli',
          ustParcaUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=300&h=300&fit=crop',
          altParcaUrl: 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=300&h=300&fit=crop',
          ustRenkKey: 'kombinRenkBeyaz',
          altRenkKey: 'kombinRenkLacivert',
          kategori: 'ayakkabi',
          kategoriTr: 'ayakkabı',
          uygunRenkler: ['kahverengi', 'siyah', 'beyaz', 'koyu mavi'],
          fallbackDogruIndex: 1,
        ),
        _KombinSablon(
          id: 'fb2',
          ortamKey: 'kombinOrtamCasual',
          havaKey: 'kombinHavaYagmurlu',
          ustParcaUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=300&h=300&fit=crop',
          altParcaUrl: 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=300&h=300&fit=crop',
          ustRenkKey: 'kombinRenkBej',
          altRenkKey: 'kombinRenkKoyuYesil',
          kategori: 'ayakkabi',
          kategoriTr: 'ayakkabı',
          uygunRenkler: ['siyah', 'kahverengi', 'koyu mavi', 'gri'],
          fallbackDogruIndex: 1,
        ),
        _KombinSablon(
          id: 'fb3',
          ortamKey: 'kombinOrtamDavet',
          havaKey: 'kombinHavaSoguk',
          ustParcaUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300&h=300&fit=crop',
          altParcaUrl: 'https://images.unsplash.com/photo-1584689484140-3323b1a9a4e1?w=300&h=300&fit=crop',
          ustRenkKey: 'kombinRenkSiyah',
          altRenkKey: 'kombinRenkSiyah',
          kategori: 'ceket',
          kategoriTr: 'ceket',
          uygunRenkler: ['siyah', 'kirmizi', 'altin', 'koyu mavi'],
          fallbackDogruIndex: 2,
        ),
        _KombinSablon(
          id: 'fb4',
          ortamKey: 'kombinOrtamSpor',
          havaKey: 'kombinHavaSicak',
          ustParcaUrl: 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=300&h=300&fit=crop',
          altParcaUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=300&h=300&fit=crop',
          ustRenkKey: 'kombinRenkGri',
          altRenkKey: 'kombinRenkSiyah',
          kategori: 'ayakkabi',
          kategoriTr: 'ayakkabı',
          uygunRenkler: ['beyaz', 'siyah', 'mavi', 'kahverengi'],
          fallbackDogruIndex: 0,
        ),
      ];

      for (final fb in fallbackSablonlar) {
        if (allKombinler.length >= _toplamTur) break;
        final kombin = sablondanKombinOlustur(fb, forceFallback: true);
        if (kombin != null) {
          allKombinler.add(kombin);
        }
      }
    }

    allKombinler.shuffle();
    _tumKombinler = allKombinler.take(_toplamTur).toList();
  }

  void _baslat() {
    _skor = 0;
    _turIndex = 0;
    _secilenIndex = null;
    _turBitti = false;
    _oyunBitti = false;
    _sureDolduMu = false;
    _kalanSure = _turSuresi;
    _timerSart();
    if (mounted) setState(() => _yukleniyor = false);
  }

  int _kalanSure = _turSuresi;

  void _timerSart() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_kalanSure > 0) {
        setState(() => _kalanSure--);
      } else {
        timer.cancel();
        _sureDoldu();
      }
    });
  }

  void _sureDoldu() {
    if (!mounted) return;
    if (_secilenIndex == null) {
      _sureDolduMu = true;
      _hapticError();
      setState(() {
        _turBitti = true;
        _secilenIndex = -1;
      });
      _dogruGosterTimer = Timer(const Duration(milliseconds: 2000), () {
        if (mounted) _turSonlandi(dogruMu: false);
      });
    }
  }

  void _sec(int index) {
    if (_secilenIndex != null || _turBitti) return;
    _hapticLight();
    _timer?.cancel();
    _gecisTimer?.cancel();
    _dogruGosterTimer?.cancel();

    final kombin = _tumKombinler[_turIndex];
    final dogruMu = index == kombin.dogruIndex;

    setState(() {
      _secilenIndex = index;
      _turBitti = true;
      _sureDolduMu = false;
    });

    if (dogruMu) {
      _skor += 10;
      _skorAnimController.reset();
      _skorAnimController.forward();
      _hapticSuccess();
    } else {
      _hapticError();
    }

    _gecisTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) _turSonlandi(dogruMu: dogruMu);
    });
  }

  void _turSonlandi({required bool dogruMu}) {
    _timer?.cancel();
    _gecisTimer?.cancel();
    _dogruGosterTimer?.cancel();

    if (_turIndex + 1 >= _toplamTur) {
      _oyunBitir();
    } else {
      setState(() {
        _turIndex++;
        _secilenIndex = null;
        _turBitti = false;
        _kalanSure = _turSuresi;
        _sureDolduMu = false;
      });
      _timerSart();
    }
  }

  void _oyunBitir() {
    _hapticHeavy();
    if (mounted) setState(() => _oyunBitti = true);
  }

  Future<void> _hapticLight() async {
    if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 10);
  }
  Future<void> _hapticSuccess() async {
    if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(pattern: [0, 30, 20, 30]);
  }
  Future<void> _hapticError() async {
    if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(pattern: [0, 50, 30, 50, 30, 50]);
  }
  Future<void> _hapticHeavy() async {
    if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 60);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gecisTimer?.cancel();
    _dogruGosterTimer?.cancel();
    _skorAnimController.dispose();
    super.dispose();
  }

  Widget _buildNetworkImage(String imageUrl, {double size = 60}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    // 🚧 PLAY STORE: Oyun kapalıyken 'Yakında' ekranı gösterilir
    if (!_oyunEtkin) {
      return _yakindaEkrani(colors, l10n);
    }

    if (_yukleniyor) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_oyunBitti) {
      return _sonucEkrani(colors, l10n);
    }

    final kombin = _tumKombinler[_turIndex];
    final secenekler = kombin.secenekler;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tr('kombinOyunuBaslik') ?? 'Kombin Oyunu'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onReturnToHome ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Üst bilgi çubuğu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tur sayacı
                  _BilgiKarti(
                    icerik: Text('${_turIndex + 1} / $_toplamTur', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onPrimaryContainer, fontWeight: FontWeight.bold)),
                    arkaPlanRenk: colors.primaryContainer,
                  ),
                  // Süre sayacı
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: _BilgiKarti(
                      icerik: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer, size: 16, color: _kalanSure <= 5 ? colors.error : colors.onPrimaryContainer),
                          const SizedBox(width: 4),
                          Text('$_kalanSure sn', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _kalanSure <= 5 ? colors.error : colors.onPrimaryContainer, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      arkaPlanRenk: _kalanSure <= 5 ? colors.errorContainer : colors.primaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ortam & Hava bilgisi
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event, size: 18, color: colors.primary),
                    const SizedBox(width: 4),
                    Text('${l10n.tr(kombin.ortamKey) ?? kombin.ortamKey} • ', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.primary)),
                    Icon(Icons.wb_sunny, size: 18, color: colors.primary),
                    const SizedBox(width: 4),
                    Text(l10n.tr(kombin.havaKey) ?? kombin.havaKey, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // BAZ KOMBİN GÖRSELİ
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.xlRadius,
                  border: Border.all(color: colors.outlineVariant, width: 1),
                ),
                child: Column(
                  children: [
                    Text(l10n.tr('kombinMevcutKombin') ?? 'Mevcut Kombin', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Üst parça
                        _ParcaKarti(imageUrl: kombin.ustParcaUrl, renkKey: kombin.ustRenkKey, etiketKey: 'kombinParcaUst'),
                        const SizedBox(width: 16),
                        // Alt parça
                        _ParcaKarti(imageUrl: kombin.altParcaUrl, renkKey: kombin.altRenkKey, etiketKey: 'kombinParcaAlt'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.tr('kombinEksik_${kombin.kategori}') ?? 'Eksik: ${_kategoriAdi(l10n, kombin.kategori)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.onPrimaryContainer, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SORU
              Text(
                l10n.tr('kombinSoru_${kombin.kategori}') ?? 'Hangi ${_kategoriAdi(l10n, kombin.kategori)} en uygun?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // SEÇENEKLER GRID (2x2)
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(4, (i) {
                  final secenek = secenekler[i];
                  final secili = _secilenIndex == i;
                  final dogru = _turBitti && i == kombin.dogruIndex;
                  final yanlis = _turBitti && secili && i != kombin.dogruIndex;
                  final sureDolduSecimsiz = _turBitti && _sureDolduMu && _secilenIndex == -1;

                  Color borderColor = colors.outlineVariant;
                  Color bgColor = colors.surfaceContainerHighest;
                  if (dogru) { borderColor = colors.primary; bgColor = colors.primaryContainer; }
                  if (yanlis) { borderColor = colors.error; bgColor = colors.errorContainer; }
                  if (secili && !_turBitti) { borderColor = colors.primary; }
                  if (sureDolduSecimsiz && i == kombin.dogruIndex) { borderColor = colors.primary; bgColor = colors.primaryContainer; }

                  return Semantics(
                    button: true,
                    selected: secili,
                    label: '${l10n.tr(secenek.aciklamaKey) ?? secenek.aciklamaKey}${dogru ? ', doğru cevap' : yanlis ? ', yanlış cevap' : ''}',
                    child: Material(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: _turBitti ? null : () => _sec(i),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: (secili || dogru || yanlis || (sureDolduSecimsiz && i == kombin.dogruIndex)) ? 2.5 : 1.5),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildNetworkImage(secenek.imageUrl, size: 60),
                              const SizedBox(height: 8),
                              Flexible(
                                child: Text(
                                  l10n.tr(secenek.aciklamaKey) ?? secenek.aciklamaKey,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(l10n.tr(secenek.renkKey) ?? secenek.renkKey, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                              ),
                              if (dogru) ...[
                                const SizedBox(height: 8),
                                Icon(Icons.check_circle, color: colors.primary, size: 20),
                              ] else if (yanlis) ...[
                                const SizedBox(height: 8),
                                Icon(Icons.cancel, color: colors.error, size: 20),
                              ] else if (sureDolduSecimsiz && i == kombin.dogruIndex) ...[
                                const SizedBox(height: 8),
                                Icon(Icons.check_circle, color: colors.primary, size: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _yakindaEkrani(ColorScheme colors, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kombinOyunuBaslik),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onReturnToHome ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 72, color: colors.primary),
                const SizedBox(height: 16),
                Text(
                  l10n.yakinda,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.yakindaAciklama,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sonucEkrani(ColorScheme colors, AppLocalizations l10n) {
    final yuzde = ((_skor / (_toplamTur * 10)) * 100).round();
    String baslik, mesaj;
    IconData ikon;
    Color renk;

    if (yuzde >= 80) {
      baslik = l10n.tr('kombinSonucUsta') ?? 'Stil Ustası! 🏆';
      mesaj = l10n.tr('kombinSonucUstaMesaj') ?? 'Renk ve uyum hissini ödüllemeye değer!';
      ikon = Icons.emoji_events;
      renk = colors.primary;
    } else if (yuzde >= 60) {
      baslik = l10n.tr('kombinSonucIyi') ?? 'İyi Gidiyorsun! 👍';
      mesaj = l10n.tr('kombinSonucIyiMesaj') ?? 'Az pratikle mükemmel olacaksın.';
      ikon = Icons.thumb_up;
      renk = colors.tertiary;
    } else {
      baslik = l10n.tr('kombinSonucPratik') ?? 'Pratik Lazım 📚';
      mesaj = l10n.tr('kombinSonucPratikMesaj') ?? 'Renk teorisi ipuçları için "Analiz" sekmesine bak.';
      ikon = Icons.school;
      renk = colors.error;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tr('kombinOyunBitti') ?? 'Oyun Bitti'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _skorScaleAnim,
                child: Icon(ikon, size: 80, color: renk),
              ),
              const SizedBox(height: 16),
              Text(baslik, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(mesaj, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.xlRadius,
                ),
                child: Column(
                  children: [
                    Text(l10n.tr('kombinToplamPuan') ?? 'Toplam Puan', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    Text('$_skor / ${_toplamTur * 10}', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: colors.primary)),
                    const SizedBox(height: 4),
                    Text('%$yuzde ${l10n.tr('kombinBasariOrani') ?? 'Başarı'}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.tr('kombinTekrarOyna') ?? 'Tekrar Oyna'),
                      onPressed: () {
                        setState(() {
                          _kombinleriHazirla();
                          _baslat();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.home),
                      label: Text(l10n.tr('kombinAnaSayfa') ?? 'Ana Sayfa'),
                      onPressed: widget.onReturnToHome ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _kategoriAdi(AppLocalizations l10n, String kategori) {
    switch (kategori) {
      case 'ayakkabi': return l10n.tr('kombinKategoriAyakkabi') ?? 'Ayakkabı';
      case 'ceket': return l10n.tr('kombinKategoriCeket') ?? 'Ceket';
      case 'aksesuar': return l10n.tr('kombinKategoriAksesuar') ?? 'Aksesuar';
      default: return kategori;
    }
  }
}

class _BilgiKarti extends StatelessWidget {
  final Widget icerik;
  final Color arkaPlanRenk;
  const _BilgiKarti({required this.icerik, required this.arkaPlanRenk});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: arkaPlanRenk,
        borderRadius: BorderRadius.circular(16),
      ),
      child: icerik,
    );
  }
}

class _ParcaKarti extends StatelessWidget {
  final String imageUrl;
  final String renkKey;
  final String etiketKey;
  const _ParcaKarti({required this.imageUrl, required this.renkKey, required this.etiketKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
          ),
          imageBuilder: (context, imageProvider) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.tr(etiketKey) ?? etiketKey, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
        Text(l10n.tr(renkKey) ?? renkKey, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}