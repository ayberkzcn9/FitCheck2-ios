import io

p = r'D:\indirilenler\Yeni klasor43\lib\screens\onboarding_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'


def r(a, b):
    global s
    a = a.replace('\n', nl)
    b = b.replace('\n', nl)
    if a not in s:
        raise SystemExit('bulunamadi: ' + a[:70])
    s = s.replace(a, b, 1)


r("""import '../../theme/design_tokens.dart';

class OnboardingEkrani extends StatefulWidget {""",
  """import '../../theme/design_tokens.dart';

// Onboarding'in tek vurgu rengi: marka zümrütü. (Eskiden mor/indigo
// kullanılıyordu; uygulamanın geri kalanıyla çelişiyordu.)
const Color _marka = Color(0xFF0F5F4A);
const Color _markaAltin = Color(0xFFD9A441);
const Color _markaSu = Color(0xFF2F7E8F);
const Color _markaAdacay = Color(0xFF2E6E5E);

class OnboardingEkrani extends StatefulWidget {""")

# Yasal sayfa + dil kartı: mor yerine marka zümrütü.
s = s.replace('AppAccents.celebration', '_marka')
# Dil kartının ikinci gradyan durağı.
s = s.replace('AppPermissionColors.notification' + nl + '                                          .withValues(alpha: 0.05)',
              '_markaAltin' + nl + '                                          .withValues(alpha: 0.06)')

# Konfeti de marka paletinde.
r("""              colors: const [
                _marka,
                AppPermissionColors.camera,
                AppPermissionColors.location,
                AppOnboardingColors.yellow,
                AppOnboardingColors.green,
              ],""",
  """              colors: const [
                _marka,
                _markaAltin,
                _markaSu,
                _markaAdacay,
                Color(0xFFEBD08A),
              ],""")

io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
