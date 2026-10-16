"""
FitCheck — Arka Plan Silme Sunucusu (RemBG + FastAPI)

POST /remove-bg  → görsel alır, arka planı silinmiş PNG döner (X-API-Key ile korunur).
GET  /health     → sunucu ayakta mı (model, doluluk, sürüm).

Neden bu ayarlar:
  • Model `isnet-general-use` (IS-Net/DIS): girdiyi 1024x1024'te işler.
    Eski model `u2net` 320x320'de çalışıyordu; ince detaylar (askı, düğme,
    kol ucu, çorap deseni) ve beyaz/açık renkli kıyafetler bu yüzden kötü
    çıkıyordu. Ölçüm (1 OCPU): u2net ~3,7 sn / isnet ~10 sn.
  • `post_process_mask` varsayılan KAPALI: rembg'nin morfolojik temizliği
    alfayı 0/255'e indirger (kenarlar testere dişli olur). Modelin yumuşak
    alfası görsel olarak daha iyi. Gerekirse BG_POST_PROCESS=1 ile açılır.
  • Arka plan silme CPU'yu uzun süre meşgul eder; bu yüzden iş bir iş
    parçacığında (thread pool) ve tek seferde bir istek olacak şekilde
    çalıştırılır. Böylece /health ve diğer istekler kilitlenmez, istekler
    sıraya girer (hata vermez).

Çalıştırma:
    python3 server.py

Ortam değişkenleri:
    BG_REMOVE_API_KEY   API anahtarı (zorunlu, üretimde systemd'den verilir)
    BG_MODEL            rembg model adı            (varsayılan isnet-general-use)
    BG_POST_PROCESS     1 → morfolojik maske temizliği (varsayılan 0)
    BG_MAX_EDGE         Girdi en uzun kenar sınırı (varsayılan 1400)
    BG_CONCURRENCY      Aynı anda işlenecek istek  (varsayılan 1)
"""

import io
import os
import threading
from typing import Optional

from fastapi import FastAPI, File, Header, HTTPException, UploadFile
from fastapi.responses import Response
from PIL import Image, ImageOps
from rembg import new_session, remove
from starlette.concurrency import run_in_threadpool

# ---------------------------------------------------------------------------
# Ayarlar
# ---------------------------------------------------------------------------
API_KEY = os.getenv(
    "BG_REMOVE_API_KEY", "uIplFP4EIh0-9ARqmOnNc-S4g8AgOKYi-tEBZcmJ_qA"
)
ADMIN_KEY = os.getenv("BG_ADMIN_KEY", "change-this-admin-key")
MODEL = os.getenv("BG_MODEL", "isnet-general-use")
POST_PROCESS = os.getenv("BG_POST_PROCESS", "0") not in ("0", "false", "False")
MAX_EDGE = int(os.getenv("BG_MAX_EDGE", "1400"))
CONCURRENCY = max(1, int(os.getenv("BG_CONCURRENCY", "1")))
SURUM = "2.0"

app = FastAPI(title="FitCheck Background Remover", version=SURUM)

# Modeli süreç başında bir kez yükle (ilk istekte gecikme olmasın).
_session = new_session(MODEL)

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


def _arka_plani_sil(input_bytes: bytes) -> bytes:
    """Senkron (CPU yoğun) iş: görseli çözer, arka planı siler, PNG döner."""
    img = Image.open(io.BytesIO(input_bytes))
    # EXIF yönünü piksellere işle (telefon fotoğrafları yan görünmesin);
    # rembg de aynı işlemi yapar, burada görseli kendimiz açtığımız için
    # açıkça uygulanır. exif_transpose etiketi kaldırdığı için çift döndürme
    # olmaz.
    img = ImageOps.exif_transpose(img)
    img = img.convert("RGBA")
    img = _kucult(img)

    kesim = remove(img, session=_session, post_process_mask=POST_PROCESS)

    cikis = io.BytesIO()
    kesim.save(cikis, "PNG")
    return cikis.getvalue()


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
                cikti = await run_in_threadpool(_arka_plani_sil, input_bytes)
        finally:
            with _bekleyen_kilidi:
                _bekleyen -= 1

        return Response(content=cikti, media_type="image/png")
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
