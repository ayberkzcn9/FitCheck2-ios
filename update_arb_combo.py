import json
import os

# List of ARB files to update
arb_files = [
    'lib/l10n/app_tr.arb',
    'lib/l10n/app_en.arb',
    'lib/l10n/app_de.arb',
    'lib/l10n/app_es.arb',
    'lib/l10n/app_fr.arb',
    'lib/l10n/app_it.arb',
    'lib/l10n/app_ja.arb',
    'lib/l10n/app_ko.arb',
    'lib/l10n/app_pt.arb',
    'lib/l10n/app_ru.arb',
    'lib/l10n/app_zh.arb',
    'lib/l10n/app_ar.arb',
]

base_path = r'C:\Users\mehmet\Downloads\Yeni klasor26'

# New keys to add (Turkish values)
new_keys = {
    "kombinOyunuBaslik": "Kombin Oyunu",
    "kombinMevcutKombin": "Mevcut Kombin",
    "kombinParcaUst": "Üst",
    "kombinParcaAlt": "Alt",
    "kombinEksik_ayakkabi": "Eksik: Ayakkabı",
    "kombinEksik_ceket": "Eksik: Ceket",
    "kombinEksik_aksesuar": "Eksik: Aksesuar",
    "kombinSoru_ayakkabi": "Hangi ayakkabı en uygun?",
    "kombinSoru_ceket": "Hangi ceket en uygun?",
    "kombinSoru_aksesuar": "Hangi aksesuar en uygun?",
    "kombinKategoriAyakkabi": "Ayakkabı",
    "kombinKategoriCeket": "Ceket",
    "kombinKategoriAksesuar": "Aksesuar",
    "kombinOrtamOfis": "Ofis",
    "kombinOrtamCasual": "Casual",
    "kombinOrtamDavet": "Davet",
    "kombinOrtamSpor": "Spor",
    "kombinHavaGunesli": "Güneşli",
    "kombinHavaYagmurlu": "Yağmurlu",
    "kombinHavaSoguk": "Soğuk",
    "kombinHavaSicak": "Sıcak",
    "kombinRenkBeyaz": "Beyaz",
    "kombinRenkSiyah": "Siyah",
    "kombinRenkKahverengi": "Kahverengi",
    "kombinRenkLacivert": "Lacivert",
    "kombinRenkBej": "Bej",
    "kombinRenkKoyuYesil": "Koyu Yeşil",
    "kombinRenkNude": "Nude",
    "kombinRenkAltin": "Altın",
    "kombinRenkGri": "Gri",
    "kombinRenkPastelMavi": "Pastel Mavi",
    "kombinRenkKirmizi": "Kırmızı",
    "kombinRenkMavi": "Mavi",
    "kombinRenkGumus": "Gümüş",
    "kombinRenkKoyuMavi": "Koyu Mavi",
    "kombinRenkKamel": "Kamel",
    "kombinRenkYesil": "Yeşil",
    "kombinRenkAcikMavi": "Açık Mavi",
    "kombinRenkNavy": "Navy",
    "kombinSecenekKahverengiOxford": "Kahverengi Deri Oxford",
    "kombinSecenekSiyahDerby": "Siyah Deri Derby",
    "kombinSecenekBeyazSpor": "Beyaz Spor Ayakkabı",
    "kombinSecenekKahverengiCizme": "Kahverengi Çizme",
    "kombinSecenekSiyahSuGecirmezBot": "Siyah Su Geçirmez Bot",
    "kombinSecenekNudeBallerina": "Nude Ballerina",
    "kombinSecenekAltinSandalet": "Altın Sandalet",
    "kombinSecenekSiyahBlazer": "Siyah Blazer",
    "kombinSecenekKirmiziDeriCeket": "Kırmızı Deri Ceket",
    "kombinSecenekAltinDetayliCeket": "Altın Detaylı Ceket",
    "kombinSecenekBeyazPufy": "Beyaz Pufy Ceket",
    "kombinSecenekBeyazKosu": "Beyaz Koşu Ayakkabısı",
    "kombinSecenekSiyahBasketbol": "Siyah Basketbol Ayakkabısı",
    "kombinSecenekMaviTerlik": "Mavi Terlik",
    "kombinSecenekKahverengiLoafer": "Kahverengi Loafer",
    "kombinSecenekBeyazBespan": "Beyaz Beşpan",
    "kombinSecenekSiyahGunes": "Siyah Güneş Gözlüğü",
    "kombinSecenekSiyahSirtCantasi": "Siyah Sırt Çantası",
    "kombinSecenekGumusAkilliSaat": "Gümüş Akıllı Saat",
    "kombinSecenekKamelCifteYaka": "Kamel Renkli Çifte Yaka",
    "kombinSecenekSiyahBomber": "Siyah Bomber",
    "kombinSecenekKirmiziPufy": "Kırmızı Pufy",
    "kombinSecenekYesilDenim": "Yeşil Denim Ceket",
    "kombinSecenekKahverengiKemer": "Kahverengi Kemer",
    "kombinSecenekSiyahKemer": "Siyah Kemer",
    "kombinSecenekNavyBlokSal": "Navy Blok Şal",
    "kombinSecenekKahverengiGozluk": "Kahverengi Gözlük",
    "kombinSecenekGriSuGecirmez": "Gri Su Geçirmez Koşu",
    "kombinSecenekKahverengiTrekking": "Kahverengi Trekking Botu",
    "kombinSecenekSiyahTerlik": "Siyah Terlik",
    "kombinSecenekBeyazTenis": "Beyaz Tenis Ayakkabısı",
    "kombinOyunBitti": "Oyun Bitti",
    "kombinToplamPuan": "Toplam Puan",
    "kombinBasariOrani": "Başarı Oranı",
    "kombinTekrarOyna": "Tekrar Oyna",
    "kombinAnaSayfa": "Ana Sayfa",
    "kombinSonucUsta": "Stil Ustası! 🏆",
    "kombinSonucUstaMesaj": "Renk ve uyum hissini ödüllemeye değer!",
    "kombinSonucIyi": "İyi Gidiyorsun! 👍",
    "kombinSonucIyiMesaj": "Az pratikle mükemmel olacaksın.",
    "kombinSonucPratik": "Pratik Lazım 📚",
    "kombinSonucPratikMesaj": "Renk teorisi ipuçları için \"Analiz\" sekmesine bak."
}

for arb_file in arb_files:
    full_path = os.path.join(base_path, arb_file)
    if not os.path.exists(full_path):
        print(f'Skipping {arb_file} (not found)')
        continue
    
    with open(full_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f'Error parsing {arb_file}: {e}')
        continue
    
    # Add new keys
    for key, value in new_keys.items():
        if key not in data:
            data[key] = value
    
    # Write back with proper formatting
    with open(full_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f'{arb_file}: UPDATED with {len(new_keys)} new keys')

print('All ARB files updated!')