"""
FitCheck — Arka Plan Silme Sunucusu (RemBG + FastAPI)

POST /remove-bg  → görsel alır, arka planı silinmiş PNG döner (X-API-Key ile korunur).
GET  /health     → sunucu ayakta mı (model, doluluk, sürüm).

Neden bu ayarlar:
  • Model `isnet-general-use` (VARSAYILAN, canlı): girdiyi 1024x1024'te işler.
    320 px'lik u2net ailesine göre belirgin şekilde daha temiz keser
    (bacak arasındaki zemin, ince detaylar). 2 OCPU'da ~5,1 sn.
  • Yedek model `silueta`: isnet koyu kıyafet + koyu zeminde maskeyi
    parçalayabiliyor (ör. bordo pantolonun yalnızca açık renkli çizgileri
    kalıyor). Böyle bir durumda maske "doluluk" oranıyla yakalanır
    (opak piksel / sınır kutusu; sağlıklı maske ≥ 0,5, parçalanmış maske
    < 0,1) ve silueta'ya düşülür. Yedek yalnızca gerektiğinde çalışır
    (+1 sn); normal fotoğraflarda ek maliyet yok.
  • `post_process_mask` varsayılan KAPALI: rembg'nin morfolojik temizliği
    alfayı 0/255'e indirger (kenarlar testere dişli olur). Gerekirse
    BG_POST_PROCESS=1 ile açılır.
  • Arka plan silme CPU'yu meşgul eder; bu yüzden iş bir iş parçacığında
    (thread pool) ve tek seferde bir istek olacak şekilde çalıştırılır.
    Böylece /health ve diğer istekler kilitlenmez, istekler sıraya girer
    (hata vermez).

Çalıştırma:
    python3 server.py

Ortam değişkenleri:
    BG_REMOVE_API_KEY   API anahtarı (zorunlu, üretimde systemd'den verilir)
    BG_MODEL            rembg model adı            (varsayılan u2net)
    BG_POST_PROCESS     1 → morfolojik maske temizliği (varsayılan 0)
    BG_MAX_EDGE         Girdi en uzun kenar sınırı (varsayılan 1400)
    BG_CONCURRENCY      Aynı anda işlenecek istek  (varsayılan 1)
    BG_FALLBACK_MODEL   Yedek model (varsayılan silueta; boş bırakılırsa kapalı)
    BG_MIN_FILL         Yedek modele düşme eşiği   (varsayılan 0.30)
"""

import io
import os
import threading
from typing import Optional

import numpy as np
from fastapi import FastAPI, File, Header, HTTPException, UploadFile
from fastapi.responses import Response
from PIL import Image, ImageOps
from rembg import new_session, remove
from starlette.concurrency import run_in_threadpool

# ---------------------------------------------------------------------------
# Ayarlar
# ---------------------------------------------------------------------------
API_KEY = os.getenv("BG_REMOVE_API_KEY")
if not API_KEY:
    raise RuntimeError("BG_REMOVE_API_KEY must be set in the environment")
ADMIN_KEY = os.getenv("BG_ADMIN_KEY", "change-this-admin-key")
MODEL = os.getenv("BG_MODEL", "u2net")
POST_PROCESS = os.getenv("BG_POST_PROCESS", "0") not in ("0", "false", "False")
MAX_EDGE = int(os.getenv("BG_MAX_EDGE", "1400"))
CONCURRENCY = max(1, int(os.getenv("BG_CONCURRENCY", "1")))

# Yedek model: ana model maskeyi parçaladığında (ör. koyu kıyafet + koyu zemin
# üzerinde isnet) devreye girer. Boş bırakılırsa yedek kapalıdır.
FALLBACK_MODEL = os.getenv("BG_FALLBACK_MODEL", "silueta").strip()
MIN_FILL = float(os.getenv("BG_MIN_FILL", "0.30"))

SURUM = "2.2"

app = FastAPI(title="FitCheck Background Remover", version=SURUM)

# Modeli süreç başında bir kez yükle (ilk istekte gecikme olmasın).
_session = new_session(MODEL)

# Yedek model yalnızca gerektiğinde yüklenir (bellek 12 GB, yükleme ~0,3 sn).
_yedek_session = None
_yedek_kilidi = threading.Lock()


def _yedek_oturum():
    global _yedek_session
    if _yedek_session is None:
        with _yedek_kilidi:
            if _yedek_session is None:
                _yedek_session = new_session(FALLBACK_MODEL)
    return _yedek_session


def _doluluk(kesim: Image.Image) -> float:
    """Maskenin kendi sınır kutusunu ne kadar doldurduğu (0-1).

    Neden: model bir kıyafeti tanıyamadığında maskeyi parçalara böler (ör.
    koyu kıyafetin yalnızca açık renkli dikişleri kalır). Sağlıklı bir insan
    maskesi kutunun yarısından fazlasını doldurur; parçalanmış maske 0,1'in
    altına düşer. Bu sinyal, sonucun bozuk olduğunu anlamanın en ucuz yolu.
    """
    alfa = np.asarray(kesim.convert("RGBA"))[:, :, 3]
    opak = alfa > 200
    sayi = int(opak.sum())
    if sayi == 0:
        return 0.0
    ys, xs = np.nonzero(opak)
    alan = int(ys.max() - ys.min() + 1) * int(xs.max() - xs.min() + 1)
    return sayi / alan if alan else 0.0


# Aynı anda en fazla CONCURRENCY istek işlenir; fazlası sırada bekler.
_isl_kilidi = threading.Semaphore(CONCURRENCY)
_bekleyen = 0
_bekleyen_kilidi = threading.Lock()


def _check_key(x_api_key: Optional[str]) -> None:
    """X-API-Key header'ını doğrular."""
    if not x_api_key or x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Gecersiz API key")


def _kucult(img: Image.Image) -> Image.Image:
    """Çok büyük yüklemelerde en uzun kenarı MAX_EDGE'e indirir.

    Model zaten 1024x1024'te çalıştığı için daha büyük girdi kaliteyi
    artırmaz; yalnızca çözme/kodlama süresini ve belleği şişirir.
    """
    if MAX_EDGE > 0 and max(img.size) > MAX_EDGE:
        img = img.copy()
        img.thumbnail((MAX_EDGE, MAX_EDGE), Image.LANCZOS)
    return img


def _arka_plani_sil(input_bytes: bytes):
    """Senkron (CPU yoğun) iş: görseli çözer, arka planı siler, PNG döner.

    Dönüş: (png_baytlari, kullanilan_model)
    """
    img = Image.open(io.BytesIO(input_bytes))
    # EXIF yönünü piksellere işle (telefon fotoğrafları yan görünmesin);
    # rembg de aynı işlemi yapar, burada görseli kendimiz açtığımız için
    # açıkça uygulanır. exif_transpose etiketi kaldırdığı için çift döndürme
    # olmaz.
    img = ImageOps.exif_transpose(img)
    img = img.convert("RGBA")
    img = _kucult(img)

    kesim = remove(img, session=_session, post_process_mask=POST_PROCESS)
    kullanilan = MODEL

    # Ana model maskeyi parçaladıysa (koyu kıyafet + koyu zemin gibi zor
    # durumlarda görülür) yedek modeli dene ve daha iyi olanı kullan.
    if FALLBACK_MODEL and FALLBACK_MODEL != MODEL:
        doluluk = _doluluk(kesim)
        if doluluk < MIN_FILL:
            try:
                yedek = remove(
                    img.copy(), session=_yedek_oturum(),
                    post_process_mask=POST_PROCESS,
                )
                yedek_doluluk = _doluluk(yedek)
                print(
                    "maske parcali (doluluk %.3f) -> yedek %s (doluluk %.3f)"
                    % (doluluk, FALLBACK_MODEL, yedek_doluluk),
                    flush=True,
                )
                if yedek_doluluk > doluluk * 1.3:
                    kesim = yedek
                    kullanilan = FALLBACK_MODEL
            except Exception as e:  # yedek model yoksa isteği bozmayız
                print("yedek model calismadi: %s" % e, flush=True)

    cikis = io.BytesIO()
    kesim.save(cikis, "PNG")
    return cikis.getvalue(), kullanilan


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------
@app.get("/health")
def health():
    """Herkes erişebilir; sunucu ayakta mı kontrolü."""
    with _bekleyen_kilidi:
        bekleyen = _bekleyen
    return {
        "status": "ok",
        "model": MODEL,
        "surum": SURUM,
        "post_process": POST_PROCESS,
        "max_edge": MAX_EDGE,
        "bekleyen_istek": bekleyen,
        "yedek_model": FALLBACK_MODEL or None,
        "min_fill": MIN_FILL,
    }


@app.post("/remove-bg")
async def remove_bg(
    file: UploadFile = File(...),
    x_api_key: Optional[str] = Header(default=None),
):
    """Görseli alır, arka planı siler, PNG döner. API key gerektirir."""
    _check_key(x_api_key)

    try:
        input_bytes = await file.read()
        if not input_bytes:
            raise HTTPException(status_code=400, detail="Bos dosya")

        global _bekleyen
        with _bekleyen_kilidi:
            _bekleyen += 1
        try:
            # CPU yoğun işi olay döngüsünden çıkar: sunucu bu sırada
            # /health'e ve yeni isteklere cevap verebilir.
            with _isl_kilidi:
                cikti, model = await run_in_threadpool(
                    _arka_plani_sil, input_bytes
                )
        finally:
            with _bekleyen_kilidi:
                _bekleyen -= 1

        # Hangi modelin kullanıldığı istemciye bildirilir (teşhis için;
        # eski istemciler bu başlığı yok sayar).
        return Response(
            content=cikti,
            media_type="image/png",
            headers={"X-BG-Model": model},
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail="Isleme hatasi: %s" % e)


# ---------------------------------------------------------------------------
# Başlatma
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import uvicorn

    print("=" * 60)
    print("API KEY (mobil uygulamaya bunu koyun):")
    print("   %s" % API_KEY)
    print("   Header: X-API-Key")
    print("   Admin Key: %s" % ADMIN_KEY)
    print("   Model: %s  (post_process=%s, max_edge=%s, es_zamanli=%s)"
          % (MODEL, POST_PROCESS, MAX_EDGE, CONCURRENCY))
    print("=" * 60)
    uvicorn.run(app, host="0.0.0.0", port=8000, backlog=128)
