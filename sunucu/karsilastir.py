"""Model kalite karşılaştırması (u2net = eski, isnet = yeni).

Amaç: arka plan silme modelini değiştirmeden önce/sonra aynı fotoğraflarla
kanıt üretmek. Her girdi için [Orijinal | u2net | isnet | isnet+kırp]
panellerinden oluşan tek bir sayfa yazar.

Kullanım (sunucuda):
    mkdir -p /tmp/bgtest && cp ornek*.jpg /tmp/bgtest/
    python3 karsilastir.py

Notlar:
  • Girdiler uygulamanın gönderdiği gibi en uzun kenar 800 px'e indirilir
    (gerçek akışı taklit eder).
  • Çıktılar damalı zemin üzerine yerleştirilir; yarı saydam/eksik kalan
    bölgeler bu sayede hemen görünür.
  • Ölçülen süreler 1 OCPU'lu sunucu içindir: u2net ~3,6 sn, isnet ~10 sn.
"""

import io
import os
import time

from PIL import Image, ImageDraw, ImageFont
from rembg import new_session, remove

TEST_DIR = "/tmp/bgtest"
GIRDI_ADLARI = ["yunn_pantolon.jpg", "beyaz_sneaker.jpg", "beyaz_pantolon.jpg"]
PANEL_Y = 420


def yazi(boyut):
    for yol in ("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
                "/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf"):
        if os.path.exists(yol):
            return ImageFont.truetype(yol, boyut)
    return ImageFont.load_default()


def damali(z, y, kare=14):
    """Alfayı görebilmek için damalı zemin."""
    zemin = Image.new("RGB", (z, y), (255, 255, 255))
    c = ImageDraw.Draw(zemin)
    for i in range(0, z, kare):
        for j in range(0, y, kare):
            if (i // kare + j // kare) % 2:
                c.rectangle([i, j, i + kare - 1, j + kare - 1], fill=(198, 205, 214))
    return zemin


def panel(img, baslik):
    img = img.convert("RGBA")
    olcek = min(PANEL_Y / img.height, (PANEL_Y * 1.15) / img.width, 1.0)
    yeni = img.resize(
        (max(1, int(img.width * olcek)), max(1, int(img.height * olcek))), Image.LANCZOS
    )
    zemin = damali(yeni.width, PANEL_Y)
    zemin.paste(yeni, (0, (PANEL_Y - yeni.height) // 2), yeni)
    tuval = Image.new("RGB", (zemin.width, PANEL_Y + 30), (246, 247, 249))
    tuval.paste(zemin, (0, 30))
    ImageDraw.Draw(tuval).text((6, 6), baslik, font=yazi(17), fill=(10, 10, 10))
    return tuval


def kirp(img, pay_orani=0.05):
    """Uygulamanın yaptığı kırpmanın aynısı (bkz. GorselYonService.icerigeKirp)."""
    kutu = img.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
    if not kutu:
        return img
    pay = int(max(img.size) * pay_orani)
    return img.crop((max(0, kutu[0] - pay), max(0, kutu[1] - pay),
                     min(img.width, kutu[2] + pay), min(img.height, kutu[3] + pay)))


def main():
    u2 = new_session("u2net")
    isnet = new_session("isnet-general-use")

    for ad in GIRDI_ADLARI:
        yol = os.path.join(TEST_DIR, ad)
        if not os.path.exists(yol):
            print("ATLA (yok):", yol, flush=True)
            continue

        ham = Image.open(yol).convert("RGB")
        o = 800 / max(ham.size)
        if o < 1:
            ham = ham.resize((int(ham.width * o), int(ham.height * o)), Image.LANCZOS)
        buf = io.BytesIO()
        ham.save(buf, "JPEG", quality=75)
        veri = buf.getvalue()
        print("\n### %s (%dx%d)" % (ad, ham.width, ham.height), flush=True)

        paneller = [panel(ham, "ORIJINAL")]
        for m, oturum in (("u2net 320 (ESKI)", u2), ("isnet 1024 (YENI)", isnet)):
            t0 = time.time()
            kesim = remove(veri, session=oturum)
            sure = time.time() - t0
            img = Image.open(io.BytesIO(kesim)).convert("RGBA")
            kutu = img.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
            print("  %-20s %5.1fs  içerik %s" % (m, sure, str(kutu)), flush=True)
            paneller.append(panel(img, "%s (%.1fs)" % (m, sure)))
            if "isnet" in m:
                k = kirp(img)
                paneller.append(panel(k, "isnet + kırp (%dx%d)" % (k.width, k.height)))

        gen = sum(p.width for p in paneller)
        yuk = max(p.height for p in paneller)
        tuval = Image.new("RGB", (gen, yuk), (255, 255, 255))
        x = 0
        for p in paneller:
            tuval.paste(p, (x, 0))
            x += p.width
        cikis = os.path.join(TEST_DIR, "nihai_" + ad.replace(".jpg", "") + ".png")
        tuval.save(cikis)
        print("-> %s (%dx%d)" % (cikis, tuval.width, tuval.height), flush=True)


if __name__ == "__main__":
    main()
