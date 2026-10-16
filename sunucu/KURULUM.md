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

## Neden `isnet-general-use` (kalite kararı)

Ölçümler bu sunucuda (Ampere A1, **1 OCPU**, 6 GB RAM), 800 px'lik gerçek
fotoğraflarla yapıldı:

| Model | Girdi | Süre | Bellek | Sonuç |
|---|---|---|---|---|
| `u2net` (eski) | 320×320 | 3,6 sn | 0,8 GB | Kollar/uçlar kesiliyor, beyaz kıyafette yarı saydam lekeler, kenarlarda hale |
| **`isnet-general-use` (yeni)** | 1024×1024 | **10,1 sn** | 1,4 GB | Detaylar tam, kenarlar temiz, beyaz-açık renklerde belirgin üstünlük |
| `bria-rmbg` (RMBG 2.0) | 1024×1024 | — | >6 GB | **RAM yetmedi (OOM), elendi** (1,02 GB model) |
| `birefnet-general-lite` | 1024×1024 | >10 dk | — | Aşırı yavaş (takas), elendi |
| `isnet` 512/640/768 | — | — | — | ONNX grafiği **sabit 1024**; küçük girdi hata veriyor |

Örnek farklar (aynı fotoğraf, eski → yeni):

- Yatay çekilmiş kişide: u2net sol kolu dirsekten kesiyordu, çoraplar bulanıktı.
- Beyaz spor ayakkabıda: u2net sol ayakkabının burnunu yarı saydam bırakıyordu.
- Beyaz pamuklu pantolonda: u2net kenarlarda gri hale bırakıyordu.

### Kalite ayarları

| Ayarlar | Karar | Neden |
|---|---|---|
| `BG_POST_PROCESS` | **0 (kapalı)** | rembg'nin morfolojik temizliği alfayı 0/255'e indirger → kenarlar testere dişli olur. Modelin yumuşak alfası görsel olarak daha iyi. |
| `alpha_matting` | kullanılmıyor | Yalnızca +0,5 sn ama kazanç marjinal; saç/tüy gibi durumlarda gerekirse denenebilir. |
| `BG_MAX_EDGE=1400` | girdi sınırı | Model zaten 1024'te çalışır; daha büyük girdi kaliteyi artırmaz, yalnızca çözme/kodlama süresini ve belleği şişirir. |

### Hız (isteğe bağlı, ücretsiz iyileştirme)

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

- **2.0** — Model `u2net` → `isnet-general-use` (kalite); iş artık ayrı bir
  iş parçacığında ve tek seferde bir istek (CPU uzun süre meşgul olsa da
  `/health` ve yeni bağlantılar kilitlenmiyor, istekler sıraya giriyor);
  girdi boyutu sınırı (`BG_MAX_EDGE`); EXIF yönü açıkça uygulanıyor.
- **1.0** — İlk sürüm: FastAPI + rembg `u2net`, `X-API-Key` doğrulaması.
