// Kıyafet fotoğrafının yapay zekâ ile analizi.
//
// Neden ayrı dosya: aynı analiz hem ön plan akışında (kullanıcı yükleme
// ekranını beklerken) hem de arka plan akışında (kullanıcı uygulamayı
// kullanmaya devam ederken) çalışıyor. Prompt ve cevap ayrıştırma tek yerde
// tutuluyor ki iki akış aynı sonucu versin.

import 'dart:typed_data';

import '../services/ai_service.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/helpers.dart';

/// Analiz sonucu (dolap kaydının alanları).
class KiyafetAnalizi {
  const KiyafetAnalizi({
    required this.baslik,
    required this.kategori,
    required this.renk,
    required this.stil,
    this.mevsim,
  });

  final String baslik;
  final String kategori;
  final String renk;
  final String stil;
  final String? mevsim;
}

class KiyafetAnalizServisi {
  const KiyafetAnalizServisi._();

  /// Deneme sayısı (ağ dalgalanmalarına karşı).
  static const int denemeSayisi = 3;

  /// Analiz için kullanılan sistem promptu.
  static String sistemPromptu(String dil) {
    return "Sen uzman bir moda analiz sistemisin. Görseli KUMAŞ KESİMİ, SİLÜETİ VE TÜRÜNE göre incele.\n"
        "ETEK vs PANTOLON: Bacak arası ağ dikişi VARSA 'alt' (pantolon/şort). Bacak ayrımı YOKSA ve tek parça aşağı iniyorsa ETEKtir ('alt').\n\n"
        "ÜRÜN İSİMLENDİRME KURALI (ÇOK ÖNEMLİ):\n"
        "Ürün adını ('baslik') KESİNLİKLE VE SADECE 3 KELİME olarak yaz. Ne eksik, ne fazla.\n"
        "Format: [Renk] [Desen veya Kumaş] [Tür].\n"
        "Doğru Örnekler: 'Mavi Kot Pantolon', 'Siyah Deri Ceket', 'Beyaz Spor Ayakkabı'.\n"
        "Yanlış Örnekler: 'Çok Şık Siyah Elbise' (4 kelime - YASAK), 'Kırmızı Tişört' (2 kelime - YASAK).\n"
        "ASLA 'Şık', 'Güzel', 'Modern' gibi sıfatlar kullanma!\n\n"
        "MEVSİM KURALI: Kıyafetin kalınlığına ve kumaşına göre 'mevsim' alanına SADECE şu üç değerden birini yaz: 'kislik' (mont, kaban, yün, kalın triko, bot gibi soğuk hava parçaları), 'yazlik' (şort, keten, askılı, sandalet gibi ince yaz parçaları), 'dort_mevsim' (tişört, kot, spor ayakkabı gibi her mevsim giyilebilen parçalar). Bu değerleri ÇEVİRME, aynen yaz.\n\n"
        "SADECE şu JSON formatında ver ($dil dilinde):\n"
        "{\n  \"baslik\": \"3 Kelimelik Ürün Adı\",\n  \"kategori\": \"ust veya alt veya ayakkabi veya aksesuar\",\n  \"renk\": \"Renk\",\n  \"stil\": \"Tarz\",\n  \"mevsim\": \"kislik veya yazlik veya dort_mevsim\"\n}";
  }

  /// Sorgu cümlesi.
  static const String kullaniciMesaji = "Bu kıyafeti detaylı analiz et ve JSON ver.";

  /// Görseli analiz eder; hata durumunda istisna fırlatır.
  static Future<KiyafetAnalizi> analizEt({
    required Uint8List resim,
    required String dil,
    int deneme = denemeSayisi,
  }) async {
    final cevap = await _sorgula(
      sistemPromptu: sistemPromptu(dil),
      kullaniciMesaji: kullaniciMesaji,
      resim: resim,
      deneme: deneme,
    );
    return coz(cevap);
  }

  /// Ağ çağrısı; hata durumunda yeniden dener.
  static Future<String> _sorgula({
    required String sistemPromptu,
    required String kullaniciMesaji,
    required Uint8List resim,
    required int deneme,
  }) async {
    Object? sonHata;

    for (var i = 1; i <= deneme; i++) {
      try {
        return await AiService().hibritAiSorgula(
          sistemPromptu: sistemPromptu,
          kullaniciMesaji: kullaniciMesaji,
          resimler: <Uint8List>[resim],
        );
      } catch (e) {
        sonHata = e;
        if (i < deneme) {
          await Future<void>.delayed(Duration(seconds: i * 2));
        }
      }
    }

    throw sonHata ?? const AiServiceException();
  }

  /// Model cevabını (JSON metni) alanlara ayırır.
  ///
  /// Başlık en fazla 3 kelimeye kırpılır; kategori küçük harfe indirilir;
  /// mevsim standart değerlere normalleştirilir.
  static KiyafetAnalizi coz(String hamCevap) {
    var clean = hamCevap.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
    final ilkSusal = clean.indexOf('{');
    final sonSusal = clean.lastIndexOf('}');
    if (ilkSusal != -1 && sonSusal != -1) {
      clean = clean.substring(ilkSusal, sonSusal + 1);
    }

    final parsed = safeJsonDecodeMap(clean, tag: 'ai_analiz');

    var baslik = metniGuvenliYap(parsed['baslik'] ?? 'Yeni Giyim Parçası');
    final kelimeler =
        baslik.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (kelimeler.length > 3) {
      baslik = kelimeler.take(3).join(' ');
    }

    return KiyafetAnalizi(
      baslik: baslik,
      kategori: (parsed['kategori'] ?? 'ust').toString().toLowerCase(),
      renk: metniGuvenliYap(parsed['renk'] ?? 'Bilinmiyor'),
      stil: metniGuvenliYap(parsed['stil'] ?? 'Casual'),
      mevsim: mevsimEtiketiniNormallestir(parsed['mevsim']),
    );
  }
}
