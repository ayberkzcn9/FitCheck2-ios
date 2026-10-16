# FitCheck Arka Plan Silme Sunucusu

Gardıroba kıyafet eklenirken fotoğrafın arka planını silen küçük bir
FastAPI + [rembg](https://github.com/danielgatis/rembg) sunucusu.

- **Adres:** `http://129.159.12.161:8000` (Oracle Cloud, Frankfurt, `fitcheck2`)
- **Dosya (sunucuda):** `/home/opc/server.py`
- **Servis:** `fitcheck-bg` (systemd) — `sudo systemctl restart fitcheck-bg`
- **Ayar dosyası:** `/etc/systemd/system/fitcheck-bg.service`

## API

| Yöntem | Yol | Anahtar | Açıklama |
|---|---|---|---|
| `GET` | `/health` | gerekmez | `{"status","model","surum","post_process","max_edge","bekleyen_istek"}` |
| `POST` | `/remove-bg` | `X-API-Key` | `multipart/form-data`, alan adı **`file`** → arka planı silinmiş **PNG** |

Uygulama tarafı: `lib/services/background_remover_service.dart`
(`BG_REMOVE_BASE_URL` / `BG_REMOVE_API_KEY`, yoksa koddaki yedek değerler).

## Model seçimi (varsayılan: `u2net`, hız odaklı)

Ölçümler bu sunucuda (Ampere A1, **1 OCPU**, 6 GB RAM), 800 px'lik gerçek
fotoğraflarla yapıldı:

| Model | Girdi | Süre | Bellek | Kalite |
|---|---|---|---|---|
| **`u2net` (varsayılan)** | 320×320 | **3,6 sn** | 0,8 GB | Kollar/uçlar kesilebiliyor, beyaz kıyafette yarı saydam lekeler, kenarlarda hale |
| `isnet-general-use` | 1024×1024 | 10,1 sn | 1,4 GB | Detaylar tam, kenarlar temiz, beyaz/açık renklerde belirgin üstünlük |
| `bria-rmbg` (RMBG 2.0) | 1024×1024 | — | >6 GB | **RAM yetmedi (OOM), elendi** (1,02 GB model) |
| `birefnet-general-lite` | 1024×1024 | >10 dk | — | Aşırı yavaş (takas), elendi |
| `isnet` 512/640/768 | — | — | — | ONNX grafiği **sabit 1024**; küçük girdi hata veriyor |

**Karar:** `isnet-general-use` kaliteyi belirgin artırıyor ama 1 OCPU'da
fotoğraf başına ~10 sn sürüyor; bu süre kullanıcı deneyimi için uzun bulundu,
bu yüzden **varsayılan `u2net` olarak bırakıldı**. Kalite öncelikli bir dönem
istenirse tek satır yeter (aşağıdaki örnek), ya da sunucu 4 OCPU'ya çıkarılıp
isnet ~3 sn'ye indirilebilir.

Ölçülen kalite farkları (aynı fotoğraf, `u2net` → `isnet`):

- Beyaz spor ayakkabıda sol ayakkabının burnu u2net'te **yarı saydam** kalıyordu.
- Yatay çekilmiş kişide u2net sol kolu dirsekten kesiyor, çoraplar bulanıyordu.
- Beyaz pamuklu pantolonda u2net kenarlarda gri hale bırakıyordu.

`sunucu/karsilastir.py` ile bu karşılaştırma her zaman yeniden üretilebilir.

### Kalite ayarları

| Ayar | Karar | Neden |
|---|---|---|
| `BG_POST_PROCESS` | **0 (kapalı)** | rembg'nin morfolojik temizliği alfayı 0/255'e indirger → kenarlar testere dişli olur. |
| `alpha_matting` | kullanılmıyor | Yalnızca +0,5 sn ama kazanç marjinal. |
| `BG_MAX_EDGE=1400` | girdi sınırı | Daha büyük girdi kaliteyi artırmaz, yalnızca çözme/kodlama süresini ve belleği şişirir. |

### Kaliteli modele geçmek / hızlı modelde kalmak

```bash
# Kaliteli model (1024x1024, ~10 sn)
sudo systemctl edit fitcheck-bg            # Environment=BG_MODEL=isnet-general-use
sudo systemctl restart fitcheck-bg

# Hızlı modele dönüş (320x320, ~3,6 sn)
sudo systemctl edit fitcheck-bg            # Environment=BG_MODEL=u2net
sudo systemctl restart fitcheck-bg
```

### Hız için donanım (isteğe bağlı, ücretsiz)

Sunucu **1 OCPU** çalışıyor; Oracle'ın ücretsiz Ampere hakkı **4 OCPU / 24 GB**.
Instans 4 OCPU'ya çıkarılırsa tek fotoğraf ~10 sn → **~3 sn** düşer ve aynı
anda birden çok kullanıcı sırada beklemez.

> ⚠️ Dikkat: Instans tipi değiştirilirken (durdur → şekli değiştir → başlat)
> **genel IP değişebilir**. Genel IP şu an "ephemeral" (rezerve değil) ve
> uygulamada sabit yazılı olduğu için IP değişirse **yayındaki eski sürümler
> bağlanamaz**. Bu yüzden işlem öncesi IP'nin sabitlenmesi (rezerve IP) veya
> işlem sonrası IP'nin hemen doğrulanması gerekir.

## Kurulum (sıfırdan)

```bash
# 1) Paketler
python3 -m pip install --user fastapi uvicorn rembg pillow python-multipart onnxruntime

# 2) Kodu yerleştir
cp server.py /home/opc/server.py

# 3) Servis
sudo cp fitcheck-bg.service /etc/systemd/system/fitcheck-bg.service
sudo systemctl daemon-reload
sudo systemctl enable --now fitcheck-bg

# 4) İlk çalıştırmada model indirilir (~170 MB, ~/.u2net)
sudo systemctl restart fitcheck-bg
```

`BG_MODEL` değiştirilirse ilgili model dosyası `~/.u2net/` altına iner.

## Test

```bash
# Sağlık
curl http://129.159.12.161:8000/health

# Arka plan silme (dosya alanı adı: file)
curl -X POST http://129.159.12.161:8000/remove-bg \
  -H "X-API-Key: <KEY>" \
  -F "file=@ornek.jpg" \
  -o cikti.png -w 'http=%{http_code} sure=%{time_total}sn\n'

# Yanlış anahtar → 401 beklenir
curl -o /dev/null -w '%{http_code}\n' -X POST http://129.159.12.161:8000/remove-bg \
  -H "X-API-Key: yanlis" -F "file=@ornek.jpg"
```

## Geri alma

Eski (u2net) sürüm sunucuda `server.py.u2net-yedek` olarak duruyor:

```bash
sudo cp /home/opc/server.py.u2net-yedek /home/opc/server.py
sudo systemctl restart fitcheck-bg
```

Kod değiştirmeden model değiştirmek için:

```bash
sudo systemctl edit fitcheck-bg   # Environment=BG_MODEL=u2net  (varsayılan: isnet-general-use)
sudo systemctl restart fitcheck-bg
```

## Sürüm notları

- **2.1** — Model tekrar `u2net`'e alındı (hız tercihi). 2.0'ın altyapı
  iyileştirmeleri (iş parçacığı, sıra, EXIF, girdi sınırı) korunuyor.
  `isnet-general-use` tek satırla açılabilir (bkz. yukarıdaki bölüm).
- **2.0** — Model `u2net` → `isnet-general-use` (kalite); iş artık ayrı bir
  iş parçacığında ve tek seferde bir istek (CPU uzun süre meşgul olsa da
  `/health` ve yeni bağlantılar kilitlenmiyor, istekler sıraya giriyor);
  girdi boyutu sınırı (`BG_MAX_EDGE`); EXIF yönü açıkça uygulanıyor.
- **1.0** — İlk sürüm: FastAPI + rembg `u2net`, `X-API-Key` doğrulaması.
