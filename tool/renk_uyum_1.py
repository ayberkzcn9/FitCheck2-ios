import io, os, sys, colorsys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'


def hex_hls(h):
    h = h.lstrip('#')
    r, g, b = [int(h[i:i + 2], 16) / 255.0 for i in (0, 2, 4)]
    hh, ll, ss = colorsys.rgb_to_hls(r, g, b)
    return round(hh * 360), round(ss * 100), round(ll * 100)


def hls_hex(h, s, l):
    r, g, b = colorsys.hls_to_rgb(h / 360, l / 100, s / 100)
    return '#%02X%02X%02X' % (round(r * 255), round(g * 255), round(b * 255))


# wornBg: Tailwind yeşili (ton 141) -> zümrüt ailesi (ton 155).
# wornFg (#1F5C48, ton 160) ile aynı ailede olsun.
yeni_worn = hls_hex(155, 42, 90)
# info: ton 191 -> 176 (marka zumrutunden 15 derece uzaklik, ayirt edilebilir)
yeni_info = hls_hex(176, 46, 35)

tok = os.path.join(KOK, 'theme', 'design_tokens.dart')
s = io.open(tok, encoding='utf-8', newline='').read()

s = s.replace('static const Color wornBg = Color(0xFFDCFCE7);',
              'static const Color wornBg = Color(0xFF%s);' % yeni_worn[1:])
s = s.replace('static const Color info = Color(0xFF2F7E8F);',
              'static const Color info = Color(0xFF%s);' % yeni_info[1:])
io.open(tok, 'w', encoding='utf-8', newline='').write(s)

print('wornBg  #DCFCE7 (ton 141) -> %s (ton %d)' %
      (yeni_worn, hex_hls(yeni_worn)[0]))
print('info    #2F7E8F (ton 191) -> %s (ton %d)' %
      (yeni_info, hex_hls(yeni_info)[0]))
