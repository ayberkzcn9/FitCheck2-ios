import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_servisi.dart';
import '../utils/auth_hata_utils.dart';
import '../utils/ayarlar_dialoglar.dart';
import 'ana_ekran.dart';
import '../../theme/design_tokens.dart';

class GirisEkrani extends StatefulWidget {
  final Color? anaRenk;
  const GirisEkrani({super.key, this.anaRenk});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  bool _girisModu = true; // true: Giriş Yap, false: Kayıt Ol
  bool _sifreGizli = true;
  bool _yukleniyor = false;
  bool _beniHatirla = true;

  final _formKey = GlobalKey<FormState>();
  final _kullaniciAdiController = TextEditingController();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  final AuthServisi _authServisi = AuthServisi();

  @override
  void initState() {
    super.initState();
    _hatirlananGirisiYukle();
  }

  Future<void> _hatirlananGirisiYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final beniHatirla = prefs.getBool('beni_hatirla') ?? true;
    final hatirlananEposta = prefs.getString('hatirlanan_eposta');

    if (!mounted) return;
    setState(() {
      _beniHatirla = beniHatirla;
      if (hatirlananEposta != null && hatirlananEposta.isNotEmpty) {
        _emailController.text = hatirlananEposta;
      }
    });
  }

  @override
  void dispose() {
    _kullaniciAdiController.dispose();
    _emailController.dispose();
    _sifreController.dispose();
    super.dispose();
  }

  // E-posta / Şifre ile Giriş veya Kayıt Olma
  void _islemTetikle() async {
    if (!_formKey.currentState!.validate()) return;

    final colors = Theme.of(context).colorScheme;
    HapticFeedback.mediumImpact();
    setState(() => _yukleniyor = true);

    try {
      final userCredential = _girisModu
          ? await _authServisi.girisYap(
              email: _emailController.text.trim(),
              sifre: _sifreController.text.trim(),
            )
          : await _authServisi.kayitOl(
              kullaniciAdi: _kullaniciAdiController.text.trim(),
              email: _emailController.text.trim(),
              sifre: _sifreController.text.trim(),
              cinsiyet: 'Belirtilmedi',
            );

      final prefs = await SharedPreferences.getInstance();
      final profil = await _authServisi.kullaniciProfiliniGetir();
      final kayitliIsim = profil?['kullaniciAdi']?.toString() ??
          userCredential?.user?.displayName;

      if (kayitliIsim != null && kayitliIsim.trim().isNotEmpty) {
        await prefs.setString('kullanici_ismi', kayitliIsim.trim());
      }
      await prefs.setBool('beni_hatirla', _beniHatirla);
      if (_beniHatirla) {
        await prefs.setString(
          'hatirlanan_eposta',
          _emailController.text.trim(),
        );
      } else {
        await prefs.remove('hatirlanan_eposta');
      }
      await prefs.setBool('onboarding_tamamlandi', true);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkraniNavigasyon()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authHatasiMetni(e, AppLocalizations.of(context)!),
              style:
                  TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
            ),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  // GOOGLE İLE GİRİŞ TETİKLEYİCİSİ
  void _googleGirisTetikle() async {
    final colors = Theme.of(context).colorScheme;
    HapticFeedback.lightImpact();
    setState(() => _yukleniyor = true);

    try {
      final userCredential = await _authServisi.googleIleGirisYap();

      // Kullanıcı Google penceresini kapattıysa giriş yapılmadı; ana ekrana
      // geçilmemeli.
      if (userCredential == null) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_tamamlandi', true);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkraniNavigasyon()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authHatasiMetni(e, AppLocalizations.of(context)!),
              style:
                  TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
            ),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  // ŞİFREMİ UNUTTUM TETİKLEYİCİSİ
  //
  // Kullanıcı şifresini hatırlamadığı için giriş yapamıyordur; bu yüzden
  // sıfırlama akışına ayarlar ekranından değil, doğrudan giriş ekranından
  // erişilebilmelidir.
  Future<void> _sifreSifirlamaTetikle() async {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.lightImpact();

    final girilenEposta = _emailController.text.trim();

    // Alan doldurulmuşsa kullanıcı yeniden yazmasın diye diyaloğa taşınır.
    final eposta = await AyarlarDialoglar.sifreDegistirGoster(
      context: context,
      mevcutEmail: girilenEposta.isEmpty ? null : girilenEposta,
    );
    if (eposta == null || eposta.isEmpty || !mounted) return;

    setState(() => _yukleniyor = true);

    try {
      await _authServisi.sifreSifirlamaEpostasiGonder(email: eposta);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.sifreEpostasiGonderildi(eposta),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppAccents.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authHatasiMetni(e, AppLocalizations.of(context)!),
            style:
                TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  // ATLA / MİSAFİR GİRİŞİ TETİKLEYİCİSİ
  void _anonimGirisTetikle() async {
    final colors = Theme.of(context).colorScheme;
    HapticFeedback.lightImpact();
    setState(() => _yukleniyor = true);

    try {
      await _authServisi.anonimGirisYap(cinsiyet: 'Belirtilmedi');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_tamamlandi', true);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkraniNavigasyon()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authHatasiMetni(e, AppLocalizations.of(context)!),
              style:
                  TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
            ),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = widget.anaRenk ?? colors.primary;
    final backgroundLight = Color.lerp(
      theme.scaffoldBackgroundColor,
      primaryColor,
      0.035,
    )!;
    final backgroundDeep = Color.lerp(
      theme.scaffoldBackgroundColor,
      primaryColor,
      0.10,
    )!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundLight, backgroundDeep],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ÜST BAR: ATLA / MİSAFİR GİRİŞİ BUTONU
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _yukleniyor ? null : _anonimGirisTetikle,
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                      label: Text(
                        l10n.onboardingAtla,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.xlRadius),
                        backgroundColor: colors.surfaceContainerHighest,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo ve Başlık
                            Icon(Icons.checkroom_rounded,
                                size: 60, color: primaryColor),
                            const SizedBox(height: 8),
                            Text(
                              "FitCheck",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _girisModu
                                  ? l10n.stilDunyanaTekrarHosGeldin
                                  : l10n.kombinleriniSaklamakIcinKatil,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Sekme Switcher (Giriş Yap / Kayıt Ol)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _girisModu = true),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _girisModu
                                              ? AppAccents.successDark
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          l10n.girisYap,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: _girisModu
                                                ? Colors.white
                                                : colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _girisModu = false),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: !_girisModu
                                              ? AppAccents.successDark
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          l10n.kayitOl,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: !_girisModu
                                                ? Colors.white
                                                : colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Kullanıcı Adı Field (Sadece Kayıt modunda)
                            if (!_girisModu) ...[
                              TextFormField(
                                controller: _kullaniciAdiController,
                                style: TextStyle(color: colors.onSurface),
                                decoration: InputDecoration(
                                  labelText: l10n.adinizVeyaLakabiniz,
                                  labelStyle:
                                      TextStyle(color: colors.onSurfaceVariant),
                                  prefixIcon: Icon(Icons.person_outline_rounded,
                                      size: 20, color: colors.onSurfaceVariant),
                                  filled: true,
                                  fillColor: colors.surfaceContainerHighest,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: AppAccents.successDark, width: 2)),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().length < 3) {
                                    return l10n.girisHataKullaniciAdiKisa;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // E-Posta Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: colors.onSurface),
                              decoration: InputDecoration(
                                labelText: l10n.epostaAdresiniz,
                                labelStyle:
                                    TextStyle(color: colors.onSurfaceVariant),
                                prefixIcon: Icon(Icons.email_outlined,
                                    size: 20, color: colors.onSurfaceVariant),
                                filled: true,
                                fillColor: colors.surfaceContainerHighest,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: AppAccents.successDark, width: 2)),
                              ),
                              validator: (val) {
                                if (val == null || !val.contains("@")) {
                                  return l10n.girisHataEpostaGecersiz;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Şifre Field
                            TextFormField(
                              controller: _sifreController,
                              obscureText: _sifreGizli,
                              style: TextStyle(color: colors.onSurface),
                              decoration: InputDecoration(
                                labelText: l10n.sifreniz,
                                labelStyle:
                                    TextStyle(color: colors.onSurfaceVariant),
                                prefixIcon: Icon(Icons.lock_outline_rounded,
                                    size: 20, color: colors.onSurfaceVariant),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _sifreGizli
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  onPressed: () => setState(
                                      () => _sifreGizli = !_sifreGizli),
                                ),
                                filled: true,
                                fillColor: colors.surfaceContainerHighest,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                        color: AppAccents.successDark, width: 2)),
                              ),
                              validator: (val) {
                                if (val == null || val.length < 6) {
                                  return l10n.girisHataSifreKisa;
                                }
                                return null;
                              },
                            ),

                            // Şifremi unuttum bağlantısı (yalnızca giriş modunda)
                            if (_girisModu)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _yukleniyor
                                      ? null
                                      : _sifreSifirlamaTetikle,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    minimumSize: const Size(0, 36),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    l10n.sifremiUnuttum,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppAccents.successDark,
                                    ),
                                  ),
                                ),
                              ),

                            if (_girisModu)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: _beniHatirla,
                                activeColor: AppAccents.successDark,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  l10n.girisBeniHatirla,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w500),
                                ),
                                onChanged: (value) {
                                  setState(() => _beniHatirla = value ?? true);
                                },
                              ),

                            const SizedBox(height: 20),

                            // Tetikleyici Ana Buton
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppAccents.successDark,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 52),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: _yukleniyor ? null : _islemTetikle,
                              child: _yukleniyor
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      _girisModu
                                          ? l10n.girisYapVeBasla
                                          : l10n.kayitOlVeBasla,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 16),

                            // Ayraç OR / VEYA
                            Row(
                              children: [
                                Expanded(
                                    child:
                                        Divider(color: colors.outlineVariant)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    l10n.girisVeya,
                                    style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                    child:
                                        Divider(color: colors.outlineVariant)),
                              ],
                            ),

                            const SizedBox(height: 16),

                            const SizedBox(height: 16),

                            // Google ile Giriş Yap Butonu - Tema uyumlu modern tasarım
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                side: BorderSide(color: colors.outlineVariant, width: 1.5),
                                backgroundColor: colors.surfaceContainerLow,
                                foregroundColor: colors.onSurface,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed:
                                  _yukleniyor ? null : () { _googleGirisTetikle(); },
                              icon: Image.asset(
                                'assets/images/google_logo.png',
                                height: 24,
                                width: 24,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.g_mobiledata_rounded,
                                  size: 26,
                                  color: AppMiscColors.googleBlue,
                                ),
                              ),
                              label: Text(
                                l10n.girisYapGoogle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colors.onSurface,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
