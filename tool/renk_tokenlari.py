"""Tekrar eden iki gomulu rengi token'a baglar (gorunum degismez)."""
import io

# 1) Token ekle
p = "lib/theme/design_tokens.dart"
s = io.open(p, encoding="utf-8", newline="").read()
if "successDeep" not in s:
    eski = "  /// Mavi vurgu (bilgi, uyum puan\u0131)\r\n  static const Color info = Color(0xFF2563EB);"
    yeni = (
        "  /// Mavi vurgu (bilgi, uyum puan\u0131)\r\n"
        "  static const Color info = Color(0xFF2563EB);\r\n"
        "\r\n"
        "  /// \"Do\u011fru cevap\" ye\u015fili (Kombin D\u00fcellosu sonu\u00e7 ekran\u0131).\r\n"
        "  /// [success]'ten daha koyu; ayn\u0131 de\u011fer 8 yerde tekrar ediyordu.\r\n"
        "  static const Color successDeep = Color(0xFF2E7D5B);"
    )
    if eski not in s:
        raise SystemExit("design_tokens: hedef bulunamadi")
    s = s.replace(eski, yeni)
    io.open(p, "w", encoding="utf-8", newline="").write(s)
    print("design_tokens: successDeep eklendi")

# 2) Kombin duellosu: 8 kullanim
p = "lib/screens/kombin_duellosu_ekrani.dart"
s = io.open(p, encoding="utf-8", newline="").read()
once = s.count("Color(0xFF2E7D5B)")
s = s.replace("const Color(0xFF2E7D5B)", "AppAccents.successDeep")
s = s.replace("Color(0xFF2E7D5B)", "AppAccents.successDeep")
io.open(p, "w", encoding="utf-8", newline="").write(s)
print("kombin_duellosu: %d kullanim degisti" % once)

# 3) Bildirim servisi: 3 kullanim
p = "lib/services/bildirim_servisi.dart"
s = io.open(p, encoding="utf-8", newline="").read()
once = s.count("const Color(0xFF3B3B3B)")
s = s.replace("const Color(0xFF3B3B3B)", "AppAccents.primary")
io.open(p, "w", encoding="utf-8", newline="").write(s)
print("bildirim_servisi: %d kullanim degisti" % once)
