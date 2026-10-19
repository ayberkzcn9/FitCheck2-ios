#!/bin/bash
# FitCheck — Arka plan silme modelini tek komutla değiştirir ve olcer.
#
# Kullanım (sunucuda):
#     bash model_degistir.sh                  # mevcut modeli raporla + olc
#     bash model_degistir.sh silueta          # silueta'ya gec (1 OCPU'da ~1,7 sn)
#     bash model_degistir.sh isnet-general-use # isnet'e gec (1 OCPU'da ~10 sn,
#                                              #  2 OCPU'da ~5-6 sn, en temiz maske)
#     bash model_degistir.sh u2net            # eski model
#
# Yaptıkları: systemd unit'indeki BG_MODEL satırını değiştirir, servisi yeniden
# başlatır, /health ile doğrular ve /tmp/bgtest altındaki gerçek test
# fotoğraflarıyla uçtan uca süre ölçer.
#
# Geri alma: aynı komutu eski model adıyla çalıştırmak yeterli.
set -u

KEY="uIplFP4EIh0-9ARqmOnNc-S4g8AgOKYi-tEBZcmJ_qA"
UNIT=/etc/systemd/system/fitcheck-bg.service
TEST_DIR=/tmp/bgtest

YENI="${1:-}"

if [ -n "$YENI" ]; then
  case "$YENI" in
    u2net|silueta|isnet-general-use|birefnet-general-lite) ;;
    *) echo "Bilinmeyen model: $YENI"; echo "Gecerli: u2net | silueta | isnet-general-use"; exit 64 ;;
  esac
  echo "--- model degistiriliyor: $YENI ---"
  sudo sed -i "s/Environment=BG_MODEL=.*/Environment=BG_MODEL=$YENI/" "$UNIT"
  sudo systemctl daemon-reload
  sudo systemctl restart fitcheck-bg
  sleep 5
else
  echo "--- model degistirilmedi, mevcut durum ---"
fi

echo "--- durum ---"
systemctl is-active fitcheck-bg
curl -s http://127.0.0.1:8000/health
echo
echo "--- islemci ---"
nproc
echo "--- olcum (gercek /remove-bg) ---"
for f in beyaz_pantolon beyaz_sneaker beyaz_tisort_kisi; do
  if [ -f "$TEST_DIR/$f.jpg" ]; then
    curl -s -o "/dev/null" \
      -w "$f  %{time_total}s  http=%{http_code}\n" \
      -X POST -H "X-API-Key: $KEY" \
      -F "file=@$TEST_DIR/$f.jpg" \
      http://127.0.0.1:8000/remove-bg
  fi
done
