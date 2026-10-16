import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics_servisi.dart';
import '../utils/l10n_yardimcilari.dart';

class AuthServisi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Uygulama yeniden açıldığında oturumun sessizce geri yüklenip
  // yüklenmeyeceğine karar vermek için son giriş bilgisi saklanır.
  static const String _girisYontemiAnahtari = 'son_giris_yontemi';
  static const String _girisEpostaAnahtari = 'son_giris_epostasi';
  static const String _googleYontemi = 'google';
  static const String _epostaYontemi = 'eposta';
  static const String _anonimYontemi = 'anonim';

  // Google girişinde idToken alınabilmesi için web istemci kimliği şarttır
  // (.env → GOOGLE_WEB_CLIENT_ID). Boş bırakılırsa cihazdaki varsayılan
  // kaynak (default_web_client_id) kullanılır; ancak bu kaynak release
  // build'lerinde daraltma ile silinebildiği için (bkz.
  // android/app/src/main/res/raw/keep.xml) değerin .env'de verilmesi
  // önerilir.
  //
  // Tüm ekranlar kendi `AuthServisi` örneğini oluşturduğu için örnek burada
  // paylaşılır; böylece her ekran yerine platform genelinde tek bir Google
  // oturumu yönetilir.
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _googleWebClientId,
  );

  /// Sıradaki Google işleminin bekleyeceği en uzun süre. Önceki işlem takılırsa
  /// kullanıcıyı süresiz bekletmemek için kuyruk bu süre sonunda bırakılır.
  static const Duration _googleIslemBeklemeSuresi = Duration(seconds: 10);

  /// Kuyrukta bekleyen Google işleminin tamamlanmasını temsil eder.
  static Future<void> _googleIslemKuyrugu = Future<void>.value();

  /// Google oturum açma işlemlerini sıraya alarak çalıştırır.
  ///
  /// Android tarafındaki Google Sign-In SDK aynı anda tek bir oturum açma
  /// akışına izin verir. Açılıştaki sessiz geri yükleme sürerken kullanıcı
  /// "Google ile giriş yap" derse SDK, çakışan işlemi
  /// `PlatformException(sign_in_failed, ... ApiException: 12500 ...)` ile
  /// reddeder. Bu yüzden oturum açma/kapama çağrıları buradan geçirilir.
  static Future<T> _googleIsleminiSirala<T>(Future<T> Function() islem) async {
    final Future<void> oncekiIslem = _googleIslemKuyrugu;
    final Completer<void> tamamlayici = Completer<void>();
    _googleIslemKuyrugu = tamamlayici.future;

    try {
      await oncekiIslem.timeout(
        _googleIslemBeklemeSuresi,
        onTimeout: () {},
      );
      return await islem();
    } finally {
      tamamlayici.complete();
    }
  }

  static String? get _googleWebClientId {
    // Google Web Client ID - Firebase Console > Authentication > Sign-in method > Google > Web SDK configuration
    // Bu değer public bir client ID'dir, secret değildir.
    const String clientId = '1073036685578-4l5ugub50qiso6h1l86ndh9pkt4cnfbe.apps.googleusercontent.com';
    return clientId;
  }

  // Aktif kullanıcıyı alma
  User? get mevcutKullanici => _auth.currentUser;

  Future<Map<String, dynamic>?> kullaniciProfiliniGetir() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final belge =
          await _firestore.collection('kullanicilar').doc(user.uid).get();
      return belge.data();
    } catch (_) {
      return null;
    }
  }

  // Kullanıcı Durumunu Dinleme (Oturum açık mı kapalı mı?)
  Stream<User?> get oturumDurumu => _auth.authStateChanges();

  /// Uygulama yeniden açılırken oturumu sessizce geri yükler.
  ///
  /// Oturum cihazda saklıdır; ancak yerel (native) katman açılıştaki ilk
  /// oturum olayını yutabildiği için Dart tarafı kullanıcıyı `null` görebilir.
  /// Bu durumda son giriş Google ile yapıldıysa hesap seçtirmeden yeniden
  /// giriş denenir; böylece kullanıcıdan tekrar giriş yapması istenmez.
  ///
  /// Kullanıcı çıkış yaptıysa ya da cihazdaki Google hesabı son giriş yapılan
  /// hesaptan farklıysa hiçbir şey yapılmaz.
  Future<User?> oturumuSessizceGeriYukle() async {
    if (_auth.currentUser != null) return _auth.currentUser;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(_girisYontemiAnahtari) != _googleYontemi) {
        return null;
      }

      final GoogleSignInAccount? googleUser =
          await _googleIsleminiSirala(() => _googleSignIn.signInSilently());
      if (googleUser == null) return null;

      // Son giriş yapılan hesap ile cihazdaki hesap aynı değilse, kullanıcı
      // haberi olmadan başka bir hesaba geçilmez.
      final String? sonEposta = prefs.getString(_girisEpostaAnahtari);
      if (sonEposta != null &&
          sonEposta.isNotEmpty &&
          googleUser.email.toLowerCase() != sonEposta.toLowerCase()) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Sessiz oturum geri yükleme başarısız oldu: $e');
      return null;
    }
  }

  // Başarılı girişten sonra çağrılır.
  //
  // Yerel kayıt yalnızca bir sonraki açılışta sessiz geri yüklemeyi seçmek için
  // kullanılır; yazılamazsa giriş yine de tamamlanmış sayılır.
  Future<void> _sonGirisiKaydet(String yontem, {String? email}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_girisYontemiAnahtari, yontem);
      if (email != null && email.isNotEmpty) {
        await prefs.setString(_girisEpostaAnahtari, email);
      } else {
        await prefs.remove(_girisEpostaAnahtari);
      }
    } catch (e) {
      debugPrint('Son giriş bilgisi kaydedilemedi: $e');
    }
  }

  // Görünen adı günceller. Ağ hatası alınsa bile hesap oluşturma/giriş
  // tamamlanmış sayılır; aksi halde çağıran akış yarıda kalırken Firebase
  // tarafında hesap açılmış olur ve kullanıcı ikinci denemede
  // "e-posta zaten kullanımda" hatasına takılır.
  Future<void> _kullaniciAdiniAyarla(User user, String isim) async {
    try {
      await user.updateDisplayName(isim);
    } catch (e) {
      debugPrint('Görünen ad güncellenemedi (${user.uid}): $e');
    }
  }

  // Profil belgesini Firestore'a yazar.
  //
  // Oturum açma çoktan gerçekleştiği için veritabanı kaynaklı hatalar
  // (çevrimdışı, güvenlik kuralı, kota) girişi başarısız saymaz; hatayı
  // kullanıcıya göstermek "giriş yapamıyorum" izlenimi verir. Kayıt atlanırsa
  // bir sonraki girişte yeniden denenir.
  Future<void> _profilBelgesiniKaydet(
    String uid,
    Map<String, dynamic> veri,
  ) async {
    try {
      await _firestore
          .collection('kullanicilar')
          .doc(uid)
          .set(veri, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Profil belgesi Firestore\'a yazılamadı ($uid): $e');
    }
  }

  // Google ile ilk kez giriş yapan kullanıcının profil belgesini oluşturur;
  // belge varsa dokunulmaz. Belge okunamazsa kayıt sessizce atlanır.
  Future<void> _googleProfiliniOlustur(User user, String cinsiyet) async {
    try {
      final belge =
          await _firestore.collection('kullanicilar').doc(user.uid).get();
      if (belge.exists) return;
    } catch (e) {
      debugPrint('Google profili okunamadı (${user.uid}): $e');
      return;
    }

    final l10n = await cevrimdisiL10n();
    await _profilBelgesiniKaydet(user.uid, {
      'uid': user.uid,
      'kullaniciAdi': user.displayName ?? l10n.googleKullanicisi,
      'email': user.email ?? '',
      'cinsiyet': cinsiyet,
      'isAnonymous': false,
      'olusturulmaTarihi': FieldValue.serverTimestamp(),
      'profilResmi': user.photoURL ?? '',
    });
  }

  // Çıkış veya hesap silme sonrası sessiz geri yükleme kapatılır.
  // Yerel kayıt temizliği başarısız olsa da çağıran akış (çıkış/hesap silme)
  // tamamlanmalıdır; aksi hâlde kullanıcı çıkış yapamaz durumda kalır.
  Future<void> _sonGirisiSil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_girisYontemiAnahtari);
      await prefs.remove(_girisEpostaAnahtari);
    } catch (e) {
      debugPrint('Son giriş bilgisi temizlenemedi: $e');
    }
  }

  // 1. KULLANICI KAYDI (Kullanıcı Adı + E-posta + Şifre)
  Future<UserCredential?> kayitOl({
    required String kullaniciAdi,
    required String email,
    required String sifre,
    required String cinsiyet,
  }) async {
    try {
      // Firebase Auth üzerinde hesabı oluştur
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: sifre,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Profil görüntülenecek adını ayarla
        await _kullaniciAdiniAyarla(user, kullaniciAdi);

        // Kullanıcı verilerini Firestore veritabanına kaydet
        await _profilBelgesiniKaydet(user.uid, {
          'uid': user.uid,
          'kullaniciAdi': kullaniciAdi,
          'email': email,
          'cinsiyet': cinsiyet,
          'isAnonymous': false,
          'olusturulmaTarihi': FieldValue.serverTimestamp(),
          'profilResmi': '',
        });
      }

      await AnalyticsServisi().olay('sign_up', {'method': 'password'});
      await _sonGirisiKaydet(_epostaYontemi, email: email);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _hataMesajiniGetir(e.code);
    }
  }

  // 2. KULLANICI GİRİŞİ (E-posta + Şifre)
  Future<UserCredential?> girisYap({
    required String email,
    required String sifre,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: sifre,
      );
      await AnalyticsServisi().olay('login', {'method': 'password'});
      await _sonGirisiKaydet(_epostaYontemi, email: email);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _hataMesajiniGetir(e.code);
    }
  }

  // ŞİFRE SIFIRLAMA
  //
  // Oturum açmış olmayı gerektirmez: kullanıcı şifresini hatırlamadığı için
  // zaten giriş yapamıyordur. Firebase'in gönderdiği bağlantı kullanıcıyı
  // yeni şifre belirleme ekranına götürür.
  Future<void> sifreSifirlamaEpostasiGonder({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      await AnalyticsServisi().olay('password_reset_request');
    } on FirebaseAuthException catch (e) {
      throw _hataMesajiniGetir(e.code);
    } catch (e) {
      debugPrint('Şifre sıfırlama e-postası gönderilemedi → $e');
      throw 'authHataSifreEpostasiGonderilemedi';
    }
  }

  // 3. 🌐 GOOGLE İLE GİRİŞ YAP
  Future<UserCredential?> googleIleGirisYap({String cinsiyet = 'Kadın'}) async {
    try {
      // 1. Google oturum açma penceresini tetikle
      final GoogleSignInAccount? googleUser =
          await _googleIsleminiSirala(() => _googleSignIn.signIn());

      if (googleUser == null) {
        // Kullanıcı pencereyi kapattı/iptal etti
        return null;
      }

      // 2. Kimlik doğrulama detaylarını al
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        // idToken yoksa Firebase oturumu doğrulayamaz; nedeni genellikle
        // eksik/hatalı GOOGLE_WEB_CLIENT_ID ya da eksik SHA-1 kaydıdır.
        debugPrint(
          'Google girişinde idToken alınamadı (erişim jetonu: '
          '${googleAuth.accessToken == null ? 'yok' : 'var'}). '
          'GOOGLE_WEB_CLIENT_ID ve SHA-1 kaydını kontrol edin.',
        );
      }

      // İki jeton da yoksa GoogleAuthProvider.credential anlaşılması güç bir
      // argüman hatası fırlatır; kullanıcıya ne olduğunu açıkça söyleyelim.
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw 'authHataGoogleDogrulanamadi';
      }

      // 3. Firebase credential nesnesi oluştur
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Firebase üzerinde oturum aç
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // 5. Kullanıcı Firestore'da yoksa verilerini kaydet (varsa verilerini koru)
        await _googleProfiliniOlustur(user, cinsiyet);
      }

      await AnalyticsServisi().olay('login', {'method': 'google'});
      await _sonGirisiKaydet(_googleYontemi, email: user?.email);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _googleFirebaseHataMesajiniGetir(e.code);
    } on PlatformException catch (e) {
      final String? mesaj = _googlePlatformHataMesajiniGetir(e);
      // Kullanıcı hesap seçme penceresini kendisi kapattı: giriş denemesi
      // iptal edilmiş sayılır, hata gösterilmez.
      if (mesaj == null) return null;
      throw mesaj;
    } catch (e) {
      // Yukarıdaki kontrollerden gelen bir String, yerelleştirme anahtarıdır
      // (ör. 'authHataGoogleDogrulanamadi'); genel mesajla ezilmemeli.
      if (e is String) rethrow;
      debugPrint('Google ile giriş beklenmeyen hata → $e');
      throw 'authHataGoogleBeklenmeyen';
    }
  }

  // 4. 🚀 ATLA / MİSAFİR GİRİŞİ (Anonim Oturum Açma)
  Future<UserCredential?> anonimGirisYap({String cinsiyet = 'Kadın'}) async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        final l10n = await cevrimdisiL10n();
        await _kullaniciAdiniAyarla(user, l10n.misafirKullanici);

        // Firestore'da misafir kaydı oluştur
        await _profilBelgesiniKaydet(user.uid, {
          'uid': user.uid,
          'kullaniciAdi': l10n.misafirKullanici,
          'email': '',
          'cinsiyet': cinsiyet,
          'isAnonymous': true,
          'olusturulmaTarihi': FieldValue.serverTimestamp(),
          'profilResmi': '',
        });
      }

      await AnalyticsServisi().olay('login', {'method': 'anonymous'});
      await _sonGirisiKaydet(_anonimYontemi);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _hataMesajiniGetir(e.code);
    }
  }

  // 5. ÇIKIŞ YAPMA
  Future<void> cikisYap() async {
    await AnalyticsServisi().olay('logout');
    await _auth.signOut();
    await AnalyticsServisi().kullaniciKimligiAyarla(null);
    await _sonGirisiSil();
    try {
      await _googleIsleminiSirala(() => _googleSignIn.signOut());
    } catch (_) {}
  }

  Future<void> hesabiSil() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final String uid = user.uid;

    // Önce kimlik doğrulama hesabı silinir. `delete()` `requires-recent-login`
    // ile başarısız olabilir; bu durumda Firestore belgesi de silinmemelidir,
    // aksi hâlde geriye profili olmayan ama giriş yapabilen yarım bir hesap
    // kalır ve kullanıcı yeniden kayıt olamaz.
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _hataMesajiniGetir(e.code);
    }

    // Hesap gitti; profil belgesi temizliği artık yan etkisi olmayan bir
    // "elinden geleni yap" adımıdır.
    try {
      await _firestore.collection('kullanicilar').doc(uid).delete();
    } catch (e) {
      debugPrint('Hesap silindi ancak profil belgesi silinemedi → $e');
    }

    try {
      await _googleIsleminiSirala(() => _googleSignIn.signOut());
    } catch (_) {}

    await _sonGirisiSil();
    await AnalyticsServisi().olay('account_delete');
    await AnalyticsServisi().kullaniciKimligiAyarla(null);
  }

  Future<bool> googleHesabiBagla() async {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return false;

    try {
      final googleUser =
          await _googleIsleminiSirala(() => _googleSignIn.signIn());
      if (googleUser == null) return false;
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw 'authHataGoogleDogrulanamadi';
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.linkWithCredential(credential);
      await AnalyticsServisi().olay('account_link', {'method': 'google'});
      await _sonGirisiKaydet(_googleYontemi, email: googleUser.email);
      return true;
    } on FirebaseAuthException catch (e) {
      throw _googleFirebaseHataMesajiniGetir(e.code);
    } on PlatformException catch (e) {
      // Kullanıcı pencereyi kapattıysa hata değil, vazgeçme sayılır.
      final String? mesaj = _googlePlatformHataMesajiniGetir(e);
      if (mesaj == null) return false;
      throw mesaj;
    }
  }

  Future<bool> googleHesabiBaglantisiniKes() async {
    final user = _auth.currentUser;
    if (user == null ||
        !user.providerData.any((p) => p.providerId == 'google.com')) {
      return false;
    }

    try {
      await user.unlink('google.com');
      await _googleIsleminiSirala(() => _googleSignIn.signOut());
      await _sonGirisiSil();
      await AnalyticsServisi().olay('account_unlink', {'method': 'google'});
      return true;
    } on FirebaseAuthException catch (e) {
      throw _hataMesajiniGetir(e.code);
    }
  }

  // Hata kodu → yerelleştirme anahtarı dönüştürücü.
  // Dönen değerler `authHata*` anahtarlarıdır; kullanıcıya gösterilecek
  // metne `authHatasiMetni` ile çevrilir (bkz. lib/utils/auth_hata_utils.dart).
  String _hataMesajiniGetir(String kod) {
    switch (kod) {
      case 'weak-password':
        return 'authHataZayifSifre';
      case 'email-already-in-use':
        return 'authHataEpostaKullanimda';
      case 'invalid-email':
        return 'authHataGecersizEposta';
      case 'user-not-found':
        return 'authHataKullaniciBulunamadi';
      case 'wrong-password':
        return 'authHataYanlisSifre';
      case 'invalid-credential':
        return 'authHataGecersizKimlik';
      case 'operation-not-allowed':
        return 'authHataYontemIzinliDegil';
      case 'account-exists-with-different-credential':
        return 'authHataFarkliYontem';
      case 'network-request-failed':
        return 'authHataAgHatasi';
      case 'too-many-requests':
        return 'authHataCokDeneme';
      case 'user-disabled':
        return 'authHataHesapDevreDisi';
      case 'requires-recent-login':
        return 'authHataYenidenGiris';
      default:
        return 'authHataGenel';
    }
  }

  /// Google girişinde Firebase'in döndürdüğü hata kodunu kullanıcıya
  /// gösterilecek yerelleştirme anahtarına çevirir. E-posta/şifre akışındaki
  /// genel mesajlardan farklıdır; örneğin `invalid-credential` burada "şifre
  /// hatalı" anlamına gelmez.
  String _googleFirebaseHataMesajiniGetir(String kod) {
    debugPrint('Google ile giriş Firebase hata kodu → $kod');

    switch (kod) {
      case 'invalid-credential':
      case 'internal-error':
      case 'invalid-user-token':
        return 'authHataGoogleDogrulanamadi';
      case 'credential-already-in-use':
        return 'authHataGoogleFarkliKullanici';
      case 'provider-already-linked':
        return 'authHataGoogleZatenBagli';
      default:
        return _hataMesajiniGetir(kod);
    }
  }

  /// Google SDK'sından gelen platform hatasını kullanıcıya gösterilecek
  /// yerelleştirme anahtarına çevirir. `null` dönerse hata kullanıcıya hiç
  /// gösterilmez; bu, kullanıcının hesap seçme penceresini kendi isteğiyle
  /// kapatması durumudur.
  ///
  /// Ham kod ve mesaj günlüğe yazılır: sorunun kaynağı (SHA-1 parmak izi,
  /// ağ, Google Play Hizmetleri ya da çakışan oturum akışı) yalnızca bu
  /// ayrıntıdan anlaşılır.
  String? _googlePlatformHataMesajiniGetir(PlatformException hata) {
    final String ayrinti =
        '${hata.code} | ${hata.message ?? ''} | ${hata.details ?? ''}';
    debugPrint('Google oturum hatası → $ayrinti');

    if (hata.code == GoogleSignIn.kSignInFailedError) {
      final String? apiKodu = _apiHataKodunuBul(ayrinti);

      // SIGN_IN_CANCELLED: kullanıcı pencereyi kapattı.
      if (apiKodu == '12501') return null;

      // DEVELOPER_ERROR: SHA-1 parmak izi ya da web istemci kimliği eksik.
      if (apiKodu == '10' || ayrinti.contains('DEVELOPER_ERROR')) {
        return 'authHataGoogleYapilandirilmamis';
      }

      // SIGN_IN_CURRENTLY_IN_PROGRESS / başka bir oturum akışı sürüyor.
      if (apiKodu == '12500' || apiKodu == '12502') {
        return 'authHataGooglePencereAcik';
      }

      // INTERNAL_ERROR: Google tarafında geçici hata; tekrar denemek yeterli.
      if (apiKodu == '8') {
        return 'authHataGoogleTamamlanamadi';
      }

      // NETWORK_ERROR
      if (apiKodu == '7') {
        return 'authHataAgHatasi';
      }
    }

    switch (hata.code) {
      case GoogleSignIn.kNetworkError:
        return 'authHataAgHatasi';
      case 'sign_in_required':
        return 'authHataGoogleHesapSec';
      case 'failed_to_recover_auth':
      case 'user_recoverable_auth':
        return 'authHataGoogleOnayBekliyor';
      default:
        // `sign_in_failed` kodu Google tarafında birden çok durumu kapsar
        // (iptal, çakışan akış, yapılandırma hatası...); gerçek sebep ham
        // mesajdaki `ApiException: <numara>` ifadesinde görünür ve yukarıda
        // `debugPrint` ile günlüğe yazılmıştır.
        return 'authHataGoogleBeklenmeyen';
    }
  }

  static final RegExp _apiHataKoduDeseni = RegExp(r'ApiException[:\s]+(\d+)');

  /// Hata ayrıntısındaki `ApiException: <kod>` ifadesinden sayısal kodu çıkarır.
  String? _apiHataKodunuBul(String ayrinti) =>
      _apiHataKoduDeseni.firstMatch(ayrinti)?.group(1);
}
