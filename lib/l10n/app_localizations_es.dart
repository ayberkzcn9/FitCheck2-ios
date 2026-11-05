// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get chatOrtamCasual => 'Casual';

  @override
  String get chatOrtamOfis => 'Oficina';

  @override
  String get chatOrtamDavet => 'Fiesta';

  @override
  String get chatOrtamSpor => 'Deporte';

  @override
  String get chatOrtamGece => 'Noche';

  @override
  String get chatOrtamRomantik => 'Romántico';

  @override
  String get chatOrtamHaftaSonu => 'Fin de semana';

  @override
  String get gardirobumAdimArkaplan => 'Eliminando el fondo';

  @override
  String get gardirobumAdimArkaplanAlt => 'Analizando la imagen con IA';

  @override
  String get gardirobumAdimAnaliz => 'Analizando la prenda';

  @override
  String get gardirobumAdimAnalizAlt => 'Detectando color, estilo y categoría';

  @override
  String get gardirobumAdimKaydet => 'Guardando';

  @override
  String get gardirobumAdimKaydetAlt => 'Añadiendo a tu armario';

  @override
  String get gardirobumLutfenBekleyin => 'Espera un momento...';

  @override
  String get authHataZayifSifre =>
      'La contraseña es demasiado débil. Debe tener al menos 6 caracteres.';

  @override
  String get authHataEpostaKullanimda =>
      'Esta dirección de correo ya está en uso.';

  @override
  String get authHataGecersizEposta =>
      'Has introducido una dirección de correo no válida.';

  @override
  String get authHataKullaniciBulunamadi =>
      'No se encontró ningún usuario para este correo.';

  @override
  String get authHataYanlisSifre =>
      'Contraseña incorrecta, inténtalo de nuevo.';

  @override
  String get authHataGecersizKimlik =>
      'Correo o contraseña incorrectos. Revisa tus datos.';

  @override
  String get authHataYontemIzinliDegil =>
      'Este método de inicio de sesión no está habilitado en la consola de Firebase.';

  @override
  String get authHataFarkliYontem =>
      'Este correo ya está registrado con otro método de inicio de sesión.';

  @override
  String get authHataAgHatasi =>
      'Revisa tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get authHataCokDeneme =>
      'Demasiados intentos. Inténtalo de nuevo más tarde.';

  @override
  String get authHataHesapDevreDisi => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get authHataYenidenGiris =>
      'Debes iniciar sesión de nuevo para completar esta acción.';

  @override
  String get authHataGenel => 'Se produjo un error. Inténtalo de nuevo.';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'No se pudo enviar el correo de restablecimiento. Inténtalo de nuevo.';

  @override
  String get authHataGoogleDogrulanamadi =>
      'No se pudo verificar el inicio de sesión con Google.';

  @override
  String get authHataGoogleFarkliKullanici =>
      'Esta cuenta de Google está vinculada a otro usuario.';

  @override
  String get authHataGoogleZatenBagli =>
      'Esta cuenta de Google ya está vinculada.';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'El inicio de sesión con Google no está configurado en este dispositivo. Informa al soporte.';

  @override
  String get authHataGooglePencereAcik =>
      'La ventana de inicio de sesión de Google sigue abierta. Espera unos segundos.';

  @override
  String get authHataGoogleTamamlanamadi =>
      'No se pudo completar el inicio de sesión con Google. Inténtalo en unos segundos.';

  @override
  String get authHataGoogleHesapSec =>
      'Debes seleccionar tu cuenta de Google para iniciar sesión.';

  @override
  String get authHataGoogleOnayBekliyor =>
      'Hay una acción pendiente en tu cuenta de Google. Inténtalo de nuevo.';

  @override
  String get authHataGoogleBeklenmeyen =>
      'Ocurrió un error inesperado al iniciar sesión con Google.';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => 'Apariencia y tema';

  @override
  String get karanlikMod => 'Modo oscuro';

  @override
  String get koyuTemaAktif => 'Tema oscuro activo';

  @override
  String get acikTemaAktif => 'Tema claro activo';

  @override
  String get dilAyarlari => 'Ajustes de idioma y región';

  @override
  String get uygulamaDili => 'Idioma de la aplicación';

  @override
  String get hakkinda => 'Acerca de la aplicación';

  @override
  String get surum => 'Versión';

  @override
  String get ayarOtomatikCihazDili => 'Automático (Idioma del dispositivo)';

  @override
  String get iptal => 'Cancelar';

  @override
  String get tamam => 'Aceptar';

  @override
  String get gardirobumTitle => 'Mi armario virtual';

  @override
  String get gardirobumYukleniyor => 'Analizando con IA...';

  @override
  String get gardirobumTopluEkle => 'Añadir prendas en lote';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return 'Analizando ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'Vaciar armario';

  @override
  String get gardirobumTemizleOnay =>
      'Se eliminarán todas las prendas de tu armario. ¿Estás seguro?';

  @override
  String get gardirobumEvet => 'Sí, vaciar todo';

  @override
  String get gardirobumHataMesaji => 'Ocurrió un error al añadir las prendas.';

  @override
  String get gardirobumKategoriTumu => 'Todo';

  @override
  String get gardirobumKategoriUst => 'Partes de arriba';

  @override
  String get gardirobumKategoriAlt => 'Partes de abajo';

  @override
  String get gardirobumKategoriAyakkabi => 'Calzado';

  @override
  String get gardirobumKategoriAksesuar => 'Accesorios';

  @override
  String get gardirobumBosKategori =>
      'No se encontraron prendas en esta categoría.';

  @override
  String get gardirobumGiymeSayisi => 'Puesto:';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'Coste: ₺$tutar / uso';
  }

  @override
  String get gardirobumDolabaAl => 'Guardar en el armario';

  @override
  String get gardirobumSepeteAt => 'Mover al cesto';

  @override
  String get gardirobumSepetteRozet => 'EN LA COLADA';

  @override
  String get gardirobumGecersizParcaBaslik => 'Objeto no válido detectado';

  @override
  String get gardirobumGecersizParcaIcerik =>
      'Nuestro sistema no pudo detectar ropa, calzado ni accesorios en esta imagen (se detectó un objeto de madera, mueble, artículo del hogar u objeto incompatible). Por favor, sube solo prendas de vestir.';

  @override
  String get gardirobumTamam => 'Aceptar';

  @override
  String get stilistTitle => 'ESTILISTA AL INSTANTE';

  @override
  String get gunlukKombinTitle => 'ATUENDO DIARIO';

  @override
  String get gunlukKombinHazirBaslik => '¿Listo para tu atuendo?';

  @override
  String get gunlukKombinHazirIcerik =>
      'Tira los dados o agita el teléfono para crear el atuendo de hoy.';

  @override
  String get gunlukKombinKartBaslik => 'Atuendo de hoy';

  @override
  String get stilistAnlikHavaDurumu => 'Tiempo actual (Toca para actualizar)';

  @override
  String get stilistKonumKontrol => 'Comprobando ubicación...';

  @override
  String get stilistNereyeGidiyorsun => '¿A dónde vas?';

  @override
  String get stilistDusunuyor => 'El estilista está pensando...';

  @override
  String get stilistBugunNeGiymeliyim => '¿Qué me pongo hoy?';

  @override
  String get stilistKombiniTemizle => 'Borrar atuendo';

  @override
  String stilistKombininTitle(Object ortam) {
    return 'Tu atuendo para $ortam';
  }

  @override
  String stilistUyum(Object puan) {
    return 'Combinación: %$puan';
  }

  @override
  String get stilistUstGiyim => 'Parte de arriba';

  @override
  String get stilistAltGiyim => 'Parte de abajo';

  @override
  String get stilistAyakkabi => 'Calzado';

  @override
  String get stilistAksesuar => 'Accesorios';

  @override
  String get stilistFavoriyeEkle => 'Añadir a favoritos';

  @override
  String get stilistBugunGiydim => 'Me lo puse hoy';

  @override
  String get bugunGiydimOnayIcerik => '¿Te pusiste este conjunto hoy?';

  @override
  String get stilistTrendyolTamamla => 'Completar en Trendyol';

  @override
  String get stilistHata => 'Ocurrió un error al generar el atuendo.';

  @override
  String get ortamCasual => 'Informal / Diario';

  @override
  String get ortamOfis => 'Oficina / Trabajo';

  @override
  String get ortamDavet => 'Boda / Evento';

  @override
  String get ortamSpor => 'Deporte / Entrenamiento';

  @override
  String get ortamGece => 'Fiesta / Noche';

  @override
  String get ortamRomantik => 'Cita romántica';

  @override
  String get stilistUyariDolapBosBaslik =>
      'Tu armario está vacío o toda la ropa está en la colada';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Para recibir recomendaciones instantáneas y personalizadas, añade ropa limpia o accesorios a tu armario.';

  @override
  String get stilistUyariUstEksikBaslik => 'Faltan partes de arriba';

  @override
  String get stilistUyariUstEksikIcerik =>
      'No tienes partes de arriba limpias en tu armario. Añade al menos una para completar un atuendo';

  @override
  String get stilistUyariAltEksikBaslik => 'Faltan partes de abajo';

  @override
  String get stilistUyariAltEksikIcerik =>
      'No tienes partes de abajo limpias en tu armario. Añade una para crear un conjunto con estilo';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Falta calzado';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Tu atuendo se ve genial, pero no encontramos calzado limpio para completarlo. Añade un par de zapatos a tu armario';

  @override
  String get stilistUyariButon => 'Entendido, añadir';

  @override
  String get anaHavaYukleniyor => 'Cargando el tiempo en tu ubicación...';

  @override
  String get anaDinliyor => 'FITCHECK está escuchando... Habla ahora';

  @override
  String get anaMikrofonHata =>
      'El permiso de micrófono o el servicio de reconocimiento de voz no están listos.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Tu preferencia se actualizó a \"$cinsiyet\"';
  }

  @override
  String get anaKonumKapaliBaslik => 'Servicio de ubicación desactivado';

  @override
  String get anaKonumKapaliIcerik =>
      'Debes activar la ubicación GPS para recibir recomendaciones de atuendos según el clima.';

  @override
  String get anaKonumuAc => 'Activar ubicación';

  @override
  String get anaIzinVer => 'Permitir';

  @override
  String get anaIptal => 'Cancelar';

  @override
  String get anaKonumIzinRedBaslik => 'Permiso de ubicación denegado';

  @override
  String get anaKonumIzinRedIcerik1 =>
      'No se pudo obtener el pronóstico del tiempo porque no se concedió el permiso.';

  @override
  String get anaKonumIzinRedIcerik2 =>
      'Debes activar los permisos en los ajustes del sistema.';

  @override
  String get anaKonumIzinGerekliBaslik => 'Permiso de ubicación requerido';

  @override
  String get anaKonumIzinGerekliIcerik =>
      'Debes activar el permiso de ubicación en la configuración para que la aplicación obtenga el pronóstico del tiempo.';

  @override
  String get anaHavaDurumuAlinamadi => 'Información del tiempo no disponible';

  @override
  String get anaHavaTahminiYuklenemedi =>
      'No se pudo cargar el pronóstico meteorológico.';

  @override
  String get anaFavoriEklendi => 'Atuendo añadido a favoritos ⭐';

  @override
  String get anaKombinTekrarUyari =>
      'Advertencia: Has usado estas prendas o unas muy similares con demasiada frecuencia últimamente. Prueba un estilo diferente hoy';

  @override
  String get anaKombinMukemmel =>
      'Excelente elección Tu estilo está muy bien equilibrado y fresco hoy.';

  @override
  String get anaYikamaUyariBaslik => 'Alerta de lavado inteligente';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Como usaste este atuendo, las prendas \"$parcalar\" se han utilizado frecuentemente y se han movido automáticamente al cesto de la ropa sucia.';
  }

  @override
  String get anaTamam => 'Aceptar';

  @override
  String get anaAyarlarTooltip => 'Ajustes';

  @override
  String get anaKadin => 'Mujer';

  @override
  String get anaErkek => 'Hombre';

  @override
  String get anaSesleKonus => 'Comando de voz';

  @override
  String get anaStilistAsistani => 'Asistente de estilo';

  @override
  String get anaSekmeGardirop => 'Armario';

  @override
  String get anaSekmeHaftalik => 'Semanal';

  @override
  String get anaSekmeAnlik => 'Al instante';

  @override
  String get anaSekmeYarismasi => 'Quiz';

  @override
  String get anaSekmeProfil => 'Perfil y Estadísticas';

  @override
  String get modaYarismasiBaslik => 'Moda y Color';

  @override
  String get modaYarismasiGunlukTamamlandi => 'Quiz de hoy completado';

  @override
  String get modaYarismasiYeniYarin =>
      'Un nuevo conjunto de 5 preguntas estará disponible mañana.';

  @override
  String get modaYarismasiSonuc => 'Resultado';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'Puntuación: $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return 'Pregunta $index / 10';
  }

  @override
  String get modaYarismasiGeri => 'Atrás';

  @override
  String get modaYarismasiAnaEkrana => 'Volver al inicio';

  @override
  String get havaParcaliBulutlu => 'Parcialmente nublado';

  @override
  String get havaSicakGunesli => 'Caluroso y soleado';

  @override
  String get havaSogukKarli => 'Frío y nevado';

  @override
  String get havaYagmurlu => 'Lluvioso';

  @override
  String get havaGunesli => 'Soleado';

  @override
  String get havaSoguk => 'Frío';

  @override
  String get gunPzt => 'Lunes';

  @override
  String get gunSal => 'Martes';

  @override
  String get gunCar => 'Miércoles';

  @override
  String get gunPer => 'Jueves';

  @override
  String get gunCum => 'Viernes';

  @override
  String get gunCmt => 'Sábado';

  @override
  String get gunPaz => 'Domingo';

  @override
  String get stilKahveBaslik => 'Café y Estilo Informal';

  @override
  String get stilKahveSoru =>
      'Sugiéreme un atuendo informal y con estilo para tomar un café con amigos';

  @override
  String get stilOfisBaslik => 'Elegancia para la Oficina';

  @override
  String get stilOfisSoru =>
      'Sugiéreme un atuendo moderno y elegante adecuado para trabajar en oficina';

  @override
  String get stilSporBaslik => 'Estilo Deportivo y Cómodo';

  @override
  String get stilSporSoru =>
      'Sugiéreme un atuendo muy cómodo y deportivo para una salida de fin de semana';

  @override
  String get stilGeceBaslik => 'Salida Nocturna / Evento';

  @override
  String get stilGeceSoru =>
      'Sugiéreme un atuendo audaz para una cena especial o un evento nocturno';

  @override
  String get ilkGorevBaslik => 'Primera Misión: Elige tu estilo';

  @override
  String get ilkGorevAciklama =>
      'La IA de FitCheck generará un atuendo al instante. ¿A dónde vas hoy?';

  @override
  String get haftalikUyariButon => 'Entendido';

  @override
  String get haftalikUyariDolapBosBaslik => 'Tu armario está vacío';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Necesitas añadir ropa a tu armario para crear un plan semanal.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Faltan partes de arriba';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'No tienes partes de arriba limpias en tu armario.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Faltan partes de abajo';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'No tienes partes de abajo limpias en tu armario.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Falta calzado';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'No hay calzado limpio en tu armario.';

  @override
  String get haftalikHata =>
      'Ocurrió un error al crear la planificación semanal.';

  @override
  String get haftalikAjandaTitle => 'Planificador de estilo semanal';

  @override
  String get haftalikAnlikHavaDurumu => 'Pronóstico del tiempo semanal';

  @override
  String get haftalikKonumKontrol => 'Cargando el tiempo...';

  @override
  String get haftalikTemizParca => 'Prendas limpias';

  @override
  String get haftalikSepette => 'En la colada';

  @override
  String get haftalikPlanAciklama =>
      'Deja que la IA prepare un plan de atuendos para 7 días basado en el pronóstico del tiempo.';

  @override
  String get haftalikProgramOlustur => 'Crear planificación semanal';

  @override
  String get haftalikPlaniTemizle => 'Borrar plan';

  @override
  String get haftalikAnalizEdiliyor => 'La IA está planificando...';

  @override
  String get haftalikUyum => 'Combinación';

  @override
  String get haftalikFavoriEkle => 'Añadir a favoritos';

  @override
  String get haftalikGiyildiIsaretle => 'Me lo puse hoy';

  @override
  String get haftalikHava => 'Tiempo:';

  @override
  String get haftalikHavaUyarisi =>
      'Nota: algunas prendas de este conjunto se actualizaron para adaptarse al clima de ese día.';

  @override
  String get haftalikUyumsuzParca => 'Prenda faltante';

  @override
  String get haftalikEksikParcaStilistNotu =>
      'El estilista tuvo en cuenta la prenda que falta y preparó las recomendaciones con las prendas limpias que tienes.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'No quedan suficientes prendas limpias para completar este día. Añade una prenda nueva o lava la ropa y el estilista sugerirá aquí un conjunto nuevo.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'Sugerencia de conjunto con IA';

  @override
  String get haftalikEksikParcaOneriYok =>
      'Renueva el plan para ver una combinación de parte superior, inferior y calzado que complete la prenda que falta.';

  @override
  String get haftalikEksikParcaOnerisiBaslik =>
      'Sugerencia de look del estilista IA';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor =>
      'El estilista está preparando una sugerencia de conjunto…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'No se puede crear un conjunto sin parte superior e inferior. El estilista ha preparado una sugerencia arriba.';

  @override
  String get haftalikNot => 'Nota';

  @override
  String get haftalikTrendyolAra => 'Buscar en Trendyol';

  @override
  String get izinZorunluMesaj =>
      'Estos permisos son necesarios para usar la aplicación.';

  @override
  String get izinGerekliBaslik => 'Permisos requeridos';

  @override
  String get izinGerekliIcerik =>
      'Se denegaron los permisos de cámara y ubicación. Actívalos en los ajustes.';

  @override
  String get ayarlaraGit => 'Ir a Ajustes';

  @override
  String get izinAnaBaslik => 'Permisos necesarios';

  @override
  String get izinAciklama =>
      'Para ofrecerte las mejores recomendaciones de atuendos, necesitamos permisos de ubicación (tiempo) y cámara (fotos).';

  @override
  String get konumIzni => 'Permiso de ubicación';

  @override
  String get kameraIzni => 'Permiso de cámara';

  @override
  String get izinVerDevamEt => 'Permitir y continuar';

  @override
  String get gunlukHavaMevcutDegil => 'Datos del tiempo no disponibles';

  @override
  String get profilAnalizTitle => 'PERFIL Y ESTADÍSTICAS';

  @override
  String get anlikDurum => 'Estado actual';

  @override
  String get toplamParca => 'Total de prendas';

  @override
  String get favoriKombin => 'Atuendo favorito';

  @override
  String get gardiropDegeri => 'Valor del armario';

  @override
  String get ortalamaMaliyet => 'Coste medio';

  @override
  String get kategoriDagilimi => 'Distribución por categorías';

  @override
  String get ustGiyim => 'Partes de arriba';

  @override
  String get altGiyim => 'Partes de abajo';

  @override
  String get ayakkabi => 'Calzado';

  @override
  String get disGiyim => 'Ropa de abrigo';

  @override
  String get aksesuar => 'Accesorios';

  @override
  String get sonGiyecekGecmisi => 'Historial de prendas usadas';

  @override
  String get kayit => 'Registro';

  @override
  String get gecmisKombinYok => 'Aún no hay historial de atuendos registrado.';

  @override
  String get parca => 'Prendas';

  @override
  String get onboardingHosGeldinBaslik => 'Bienvenido a FitCheck';

  @override
  String get onboardingDolabiniDijitallestir => 'Digitaliza tu armario';

  @override
  String get onboardingDolapAciklama =>
      'Añade tu ropa en segundos y crea tu propio armario virtual.';

  @override
  String get onboardingHavaDurumu => 'Combinación según el clima';

  @override
  String get onboardingHavaAciklama =>
      'Recibe recomendaciones adaptadas al tiempo diario en tu ubicación.';

  @override
  String get onboardingYikama => 'Control inteligente de colada';

  @override
  String get onboardingYikamaAciklama =>
      'La aplicación detecta prendas usadas con frecuencia y las mueve automáticamente al cesto.';

  @override
  String get onboardingEksikParca => 'Sugerencias de prendas faltantes';

  @override
  String get onboardingEksikAciklama =>
      'Identifica las prendas que faltan para completar tu atuendo y ofrece ideas de compra al instante.';

  @override
  String get onboardingAnalitik => 'Análisis avanzado';

  @override
  String get onboardingAnalitikAciklama =>
      'Analiza el valor total de tu armario, el coste por uso y tus tendencias favoritas.';

  @override
  String get onboardingStilist => 'Asistente de estilo IA';

  @override
  String get onboardingStilistAciklama =>
      'Solo di a dónde vas y la IA creará el atuendo perfecto en segundos.';

  @override
  String get onboardingAtla => 'Omitir';

  @override
  String get onboardingModaProfiliniz => 'Tu perfil de moda';

  @override
  String get onboardingKadin => 'Mujer';

  @override
  String get onboardingErkek => 'Hombre';

  @override
  String get onboardingBasla => 'Empezar';

  @override
  String get onboardingDevamEt => 'Continuar';

  @override
  String get cinsiyetBaslik => 'GÉNERO';

  @override
  String get tarzBaslik => 'ESTILO DIARIO (MULTISELECCIÓN)';

  @override
  String get renkTercihiBaslik => 'PREFERENCIA DE COLOR';

  @override
  String get tenRengiBaslik => 'PREFERENCIA DE TONO DE PIEL';

  @override
  String get kadin => 'Mujer';

  @override
  String get erkek => 'Hombre';

  @override
  String get cinsiyetBelirtilmemis => 'No especificado';

  @override
  String get tarzSpor => 'Deportivo';

  @override
  String get tarzKlasik => 'Clásico';

  @override
  String get tarzSokakModasi => 'Urbano / Streetwear';

  @override
  String get tarzMinimalist => 'Minimalista';

  @override
  String get renkKoyuTonlar => 'Tonos oscuros';

  @override
  String get renkPastel => 'Colores pastel';

  @override
  String get renkCanli => 'Colores vivos';

  @override
  String get renkNotr => 'Neutro';

  @override
  String get tenAcikBeyaz => 'Claro / Blanco';

  @override
  String get tenBugday => 'Medio / Moreno claro';

  @override
  String get tenEsmerKoyu => 'Oscuro / Moreno';

  @override
  String get hesabinizaGirisYapin => 'Inicia sesión en tu cuenta';

  @override
  String get yeniHesapOlusturun => 'Crea una cuenta nueva';

  @override
  String get stilDunyanaTekrarHosGeldin =>
      'Bienvenido de nuevo a tu mundo de estilo';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Únete para guardar y sincronizar tus atuendos';

  @override
  String get girisYap => 'Iniciar sesión';

  @override
  String get girisYapGoogle => 'Iniciar sesión con Google';

  @override
  String get girisYapApple => 'Iniciar sesión con Apple';

  @override
  String get aiOnayVazgec => 'Ahora no';

  @override
  String get aiOnayKabul => 'Aceptar y continuar';

  @override
  String get aiOnayIcerik =>
      'Tus fotos de prendas y textos se envían a los servicios de IA Google (Gemini) y Groq para el análisis de estilo y las sugerencias de conjuntos. Las fotos también se procesan en nuestro servidor para quitar el fondo. Los datos se usan solo para responder a tu solicitud y no los almacenamos de forma permanente. Se requiere tu consentimiento explícito para continuar.';

  @override
  String get aiOnayBaslik => 'Compartición de datos con IA';

  @override
  String get girisBeniHatirla => 'Recuérdame';

  @override
  String get girisVeya => 'o';

  @override
  String get kayitOl => 'Registrarse';

  @override
  String get adinizVeyaLakabiniz => 'Tu nombre o apodo';

  @override
  String get epostaAdresiniz => 'Correo electrónico';

  @override
  String get sifreniz => 'Contraseña';

  @override
  String get girisYapVeBasla => 'Iniciar sesión y empezar';

  @override
  String get kayitOlVeBasla => 'Registrarse y empezar';

  @override
  String get misafirOlarakDevamEt => 'Continuar como invitado';

  @override
  String get lutfenEpostaVeSifreGiriniz =>
      'Por favor, introduce tu correo electrónico y contraseña.';

  @override
  String get lutfenAdiniziGiriniz => 'Por favor, introduce tu nombre.';

  @override
  String get kullanimKosullariBaslik => 'Términos de uso y contrato';

  @override
  String get onaylamakIcinKaydirin =>
      'Desplázate hasta el final del texto para aceptar';

  @override
  String get okudumAnladimKabulEdiyorum => 'He leído, entiendo y acepto';

  @override
  String get kullanimKosullarini => 'términos de uso';

  @override
  String get okudumVeOnayliyorum => '.';

  @override
  String get onaylamadanOnceKosullariOkuyun =>
      'Por favor, lee los términos de uso antes de aceptar.';

  @override
  String get devamEtmekIcinKosullariKabulEdin =>
      'Debes aceptar los términos de uso para continuar.';

  @override
  String get kullanimKosullariMetni =>
      'TÉRMINOS DE USO Y CONTRATO DE SERVICIO DE FITCHECK\n\nÚltima actualización: 27 de agosto de 2026\n\nLee atentamente estos Términos de uso (\"Contrato\") antes de utilizar la aplicación móvil FitCheck (\"Aplicación\"). Al descargar, acceder o utilizar la Aplicación, aceptas quedar vinculado por todos los términos de este Contrato.\n\n1. PARTES Y OBJETO\nEste Contrato se celebra entre el desarrollador de la aplicación FitCheck y el usuario individual (\"Usuario\") que descarga y utiliza la Aplicación. La Aplicación ofrece gestión digital de armario, seguimiento de prendas, recomendaciones de atuendos según el clima y asesoría de estilo impulsada por IA.\n\n2. ALCANCE DEL SERVICIO Y CONDICIONES DE USO\n• Límite de edad: Debes tener al menos 13 años para utilizar la Aplicación.\n• Información del usuario: El usuario es responsable de la exactitud del nombre, género, estilo y preferencias de color proporcionadas durante la configuración del perfil.\n• Carácter orientativo: Las puntuaciones de estilo, las sugerencias de compra y los recordatorios de colada proporcionados por la inteligencia artificial son estrictamente orientativos.\n• Datos meteorológicos: Los pronósticos del tiempo se obtienen en función de la ubicación en tiempo real. La Empresa no se hace responsable de discrepancias.\n\n3. PROPIEDAD INTELECTUAL Y DERECHOS DE CONTENIDO\nConservas los derechos de propiedad intelectual sobre las fotos de ropa que subes. El logotipo, diseño, código de software y algoritmos de FitCheck pertenecen exclusivamente a FitCheck.\n\n4. PRIVACIDAD Y SEGURIDAD DE DATOS\nLas fotos que subas y el historial de atuendos se almacenan en tu dispositivo. Cuando uses funciones de IA, los datos descritos en la Política de Privacidad se envían a Gemini y Groq. Los datos de ubicación solo se utilizan para consultas meteorológicas en tiempo real. Los datos de ubicación solo se utilizan para consultas meteorológicas en tiempo real.\n\n5. LIMITACIÓN DE RESPONSABILIDAD\nFitCheck no garantiza un servicio ininterrumpido. No se responsabiliza por la pérdida de datos derivada del cambio de dispositivo o la eliminación de la aplicación.\n\n6. CONTACTO\nPara cualquier consulta, ponte en contacto a través de la sección de soporte en Ajustes o en support@fitcheckapp.com.\n\n--- FIN DEL CONTRATO ---\nPor favor, acepta los términos presionando el botón de abajo.';

  @override
  String chatKarsilama(Object hava) {
    return 'Hola Hoy fuera hace $hava. ¿Creamos un conjunto genial que vaya con tu estilo?';
  }

  @override
  String get chatGorselGonderildi => 'Imagen enviada.';

  @override
  String get chatAsistanSohbeti => 'Chat con el asistente';

  @override
  String get chatModHavaDuyarli =>
      'Sugerencias de estilo inteligentes según el clima';

  @override
  String get chatStilistHazirliyor => 'El estilista está creando un atuendo...';

  @override
  String get chatGorselEklendi => 'Imagen adjunta';

  @override
  String get chatTekrarDene => 'Reintentar';

  @override
  String get chatKamera => 'Cámara';

  @override
  String get chatGaleri => 'Elegir una imagen de la galería';

  @override
  String get chatMikrofon => 'Micrófono';

  @override
  String get chatGonder => 'Enviar mensaje';

  @override
  String get chatOneriYagmur => 'Atuendo para día lluvioso';

  @override
  String get chatOneriOfis => 'Oficina / Elegante casual';

  @override
  String get chatOneriHaftaSonu => 'Comodidad de fin de semana';

  @override
  String get chatOneriKirliSepeti => 'Revisar cesto de colada';

  @override
  String get chatDinleniyor => 'Escuchando...';

  @override
  String get chatBirSeylerYazin => 'Escribe un mensaje al asistente...';

  @override
  String get chatKombiniGiydim => 'Me puse este atuendo';

  @override
  String get chatKombinIslendi => 'Atuendo registrado para hoy';

  @override
  String get chatGorselIncele => 'Examina esta imagen y sugiere un atuendo.';

  @override
  String get profilAyarlariBaslik => 'CONFIGURACIÓN DEL PERFIL';

  @override
  String get cinsiyetTercihiBaslik => 'Preferencia de género';

  @override
  String get stilAramaHint =>
      'Ej: \'Casual con chaqueta negra\', \'Vestido de verano\'...';

  @override
  String get stilFiltreTumu => 'Todas las prendas';

  @override
  String get stilFiltreSadeceTemizler => 'Solo limpias';

  @override
  String get stilFiltreSadeceSepet => 'Solo en la colada';

  @override
  String get profilFavoriKombinlerTitle => 'Mis atuendos favoritos';

  @override
  String get profilFavoriKombinYok => 'Aún no has añadido atuendos favoritos.';

  @override
  String get profilYikamaSepetimTitle => 'Cesto de la ropa sucia';

  @override
  String get profilYikamaSepetimBos =>
      'Tu cesto de la colada está vacío, toda la ropa está limpia';

  @override
  String get profilSepetiBosalt => 'Vaciar cesto';

  @override
  String get profilSepetiBosaltOnay =>
      'Todas las prendas se marcarán como limpias. ¿Confirmas?';

  @override
  String get profilSepetiBosaltButon => 'Sí, lavar todo';

  @override
  String get profilTenRengi => 'Tono de piel / Cincelado';

  @override
  String get profilTarzTercihi => 'Preferencia de estilo';

  @override
  String get profilRenkPaleti => 'Paleta de colores favorita';

  @override
  String get rehberGardiropEkleTitle => 'Añadir foto';

  @override
  String get rehberGardiropEkleDesc =>
      'Toma o sube fotos de tus prendas de forma individual o en lote.';

  @override
  String get rehberAiStilistTitle => 'Asistente de estilo IA';

  @override
  String get rehberAiStilistDesc =>
      'Pide a la IA atuendos personalizados o consejos de estilo.';

  @override
  String get rehberSesliTitle => 'Comando de voz';

  @override
  String get rehberSesliDesc =>
      'Simplemente habla para solicitar recomendaciones de ropa con manos libres.';

  @override
  String get rehberAyarlarTitle => 'Ajustes y Perfil';

  @override
  String get rehberAyarlarDesc =>
      'Actualiza tu género, preferencias de estilo y tono de piel.';

  @override
  String get rehberGardiropNavTitle => 'Mi armario';

  @override
  String get rehberGardiropNavDesc =>
      'Consulta todas tus prendas añadidas organizadas por categorías.';

  @override
  String get rehberHaftalikNavTitle => 'Planificador semanal';

  @override
  String get rehberHaftalikNavDesc =>
      'Planifica atuendos para 7 días según el pronóstico meteorológico.';

  @override
  String get rehberDolaptanNavTitle => 'Generador de atuendos IA';

  @override
  String get rehberDolaptanNavDesc =>
      'Genera combinaciones automáticas con IA según la ocasión diaria.';

  @override
  String get rehberKendiNavTitle => 'Creador de atuendos manual';

  @override
  String get rehberKendiNavDesc =>
      'Mezcla y combina prendas manualmente para diseñar tu estilo propio.';

  @override
  String get rehberProfilNavTitle => 'Perfil y Estadísticas';

  @override
  String get rehberProfilNavDesc =>
      'Mide la rentabilidad de tu ropa y gestiona el cesto de la colada.';

  @override
  String get simdilikAtla => 'Omitir por ahora';

  @override
  String get uygulamaIzinleri => 'Permisos de la aplicación';

  @override
  String get izinEkraniAciklama =>
      'FitCheck necesita estos permisos para recomendar atuendos personalizados y enviar alertas de colada y clima.';

  @override
  String get konumIzniAciklama =>
      'Para sugerencias de ropa según el tiempo en tiempo real';

  @override
  String get kameraIzniAciklama =>
      'Para tomar fotos a tus prendas y añadirlas al armario';

  @override
  String get bildirimIzni => 'Permiso de notificaciones';

  @override
  String get bildirimIzniAciklama =>
      'Para recordatorios de colada y alertas meteorológicas';

  @override
  String get izinleriVerVeBasla => 'Conceder permisos y empezar';

  @override
  String get dahaSonraAyarla => 'Configurar más tarde';

  @override
  String get gunlukHakBittiBaslik => 'Límite diario alcanzado';

  @override
  String get dahaSonra => 'Más tarde';

  @override
  String reklamIzleHakKazan(int adet) {
    return 'Ver anuncio (+$adet crédito)';
  }

  @override
  String tebriklerHakEklendi(int adet) {
    return 'Enhorabuena +$adet crédito añadido.';
  }

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Se quitó la marca de atuendo para \"$kombinAdi\".';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" marcado como usado hoy';
  }

  @override
  String get kiyafetDetayi => 'Detalles de la prenda';

  @override
  String get parcaDetayiBaslik => 'DETALLES DE LA PRENDA';

  @override
  String get farkliParcaSec => 'Elegir otra prenda';

  @override
  String get farkliUstSec => 'Elegir otra parte de arriba';

  @override
  String get farkliAltSec => 'Elegir otra parte de abajo';

  @override
  String get farkliAyakkabiSec => 'Elegir otro calzado';

  @override
  String get farkliDisSec => 'Elegir otra ropa de abrigo';

  @override
  String get baskaTemizKiyafetYok =>
      'No tienes más prendas limpias\nen esta categoría para cambiar.';

  @override
  String get planiYenile => 'Actualizar plan';

  @override
  String get havaEtiketi => 'TIEMPO';

  @override
  String get yukleniyor => 'Cargando...';

  @override
  String get temizle => 'Limpiar';

  @override
  String get yenidenDegerlendiriliyor => 'Reevaluando...';

  @override
  String get kombinParcalariBaslik => 'PRENDAS DEL ATUENDO';

  @override
  String get parcalariKaydirIpucu =>
      'Desliza a la izquierda/derecha para ver las otras prendas';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return 'He diseñado este atuendo alrededor de $parcaAdi';
  }

  @override
  String get sihirliDokunus => 'Toque mágico';

  @override
  String get dolabiKaristirEksikUyari =>
      'Necesitas al menos 1 parte de arriba, 1 parte de abajo y calzado limpios para mezclar tu armario';

  @override
  String get zarlarAtildiYorumu =>
      'Dados lanzados Has descubierto una combinación totalmente nueva y sorprendente.';

  @override
  String get rastgeleKombinTuru => 'Aleatorio';

  @override
  String get temizAlternatifYok =>
      'No quedan alternativas limpias en esta categoría';

  @override
  String get kisiselDokunus => 'Toque personal';

  @override
  String get aiYeniParcaAnalizEdiyor =>
      'La IA está analizando la nueva prenda...';

  @override
  String get parcaDegisimVarsayilanYorum =>
      'Cambiar de prenda ha creado un excelente equilibrio general';

  @override
  String get parcaDegisimHataYorum =>
      'Cambiar de prenda adaptó este atuendo completamente a tu estilo';

  @override
  String get bilgileriDuzenleBaslik => 'Editar información';

  @override
  String get kiyafetAdiEtiketi => 'Nombre de la prenda';

  @override
  String get renkEtiketi => 'Color';

  @override
  String get kaydet => 'Guardar';

  @override
  String get yenidenZarAt => 'Volver a tirar';

  @override
  String get zarAtKaristir => 'Lanzar dados (Mezclar)';

  @override
  String get zarPopupBaslik => 'Agita los dados mágicos';

  @override
  String get zarPopupAciklama =>
      'Agita el teléfono o pulsa el botón de abajo para lanzar los dados y crear conjuntos aleatorios con tu armario.';

  @override
  String get zarlariAt => 'Lanzar los dados';

  @override
  String get zarSalla => 'Agitar dados';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Desliza o toca prendas para cambiar';

  @override
  String get favorilerdeEtiketi => 'En Favoritos';

  @override
  String get bugunGiydildiEtiketi => 'Puesto hoy';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Excelente elección Las prendas se complementan muy bien en tono y equilibrio.';

  @override
  String get kendiTasarimimBaslik => 'Mi propio diseño';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return 'Seleccionar $kategori';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'Diseña tu atuendo';

  @override
  String get secimleriSifirla => 'Restablecer selección';

  @override
  String get kombinHazirAiTavsiyesi =>
      'El atuendo se ve fantástico Analiza con la IA y guarda.';

  @override
  String get kombinBaslaIpucu =>
      '¿Qué te apetece ponerte hoy? Empieza seleccionando prendas.';

  @override
  String get ustAltModu => 'Parte de arriba + abajo';

  @override
  String get tekParcaElbiseModu => 'Una sola pieza (Vestido)';

  @override
  String get tekParcaElbise => 'Una sola pieza / Vestido';

  @override
  String get aksesuarOpsiyonel => 'Accesorios (Opcional)';

  @override
  String get stilistAnaliziBaslik => 'ANÁLISIS DEL ESTILISTA';

  @override
  String get stilistDegerlendiriyor => 'Estilista evaluando...';

  @override
  String get aiIleAnalizEtKaydet => 'Analizar con IA y guardar';

  @override
  String get bilinmiyor => 'Desconocido';

  @override
  String get karmasikSiklik => 'Elegancia compleja';

  @override
  String get gecmisiTemizleTitle => 'Borrar historial';

  @override
  String get gecmisiTemizleOnayIcerik =>
      '¿Estás seguro de que deseas borrar todo el historial de atuendos? Esta acción no se puede deshacer.';

  @override
  String get gecmisBasariylaTemizlendi => 'Historial borrado con éxito';

  @override
  String get kayitGecmistenSilindi => 'Registro eliminado del historial.';

  @override
  String get kombin => 'Atuendo';

  @override
  String get kombinDetayiUst => 'DETALLES DEL ATUENDO';

  @override
  String get giyilenParcalarUst => 'PRENDAS USADAS';

  @override
  String get detayBulunamadi => 'No se encontraron detalles.';

  @override
  String get henuzFavoriEklemediniz =>
      'Aún no has añadido atuendos a tus favoritos.';

  @override
  String get camasirSepetiTitle => 'Cesto de la ropa sucia';

  @override
  String get sepetBosTumKiyafetlerTemiz =>
      'El cesto está completamente vacío, toda la ropa está limpia';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Toda la ropa se lavó y volvió al armario';

  @override
  String get tumunuTemizIsaretle => 'Marcar todo como limpio';

  @override
  String get profilVeAnalizTitle => 'Perfil y Análisis';

  @override
  String get harikaGidiyorsun => 'Lo estás haciendo genial';

  @override
  String gundurSeridesin(Object gun) {
    return 'Racha de $gun días';
  }

  @override
  String get tumuTemiz => 'Todo limpio';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '$sayi prendas sucias';
  }

  @override
  String get stilKimligin => 'Tu identidad de estilo';

  @override
  String get dolapVerimliligi => 'Eficiencia del armario';

  @override
  String get renkPaletin => 'Tu paleta de colores';

  @override
  String get dolabinKahramanlari => 'Los imprescindibles de tu armario';

  @override
  String get derinlerdeUnutulanlar => 'Prendas olvidadas';

  @override
  String get sonGiyilenler => 'Usados recientemente';

  @override
  String get tumunuTemizle => 'Borrar todo';

  @override
  String get henuzGecmisKaydiYok => 'Aún no hay historial registrado.';

  @override
  String kezGiyildi(Object sayi) {
    return 'Puesto $sayi veces';
  }

  @override
  String get ayarlarTitle => 'Ajustes';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'CENTRO DE CUENTA Y SEGURIDAD';

  @override
  String get kullaniciHesabi => 'Cuenta de usuario';

  @override
  String get misafirKullanici => 'Usuario invitado';

  @override
  String get epostaDogrulanmis => 'Correo verificado';

  @override
  String get esitlemekIcinGirisYapin =>
      'Inicia sesión para sincronizar entre dispositivos.';

  @override
  String get cikisYapTitle => 'Cerrar sesión';

  @override
  String get cikisYapOnayIcerik =>
      '¿Estás seguro de que deseas cerrar sesión en tu cuenta?';

  @override
  String get bagliHesaplarUst => 'CUENTAS VINCULADAS';

  @override
  String get googleHesabiBagli => 'Cuenta de Google vinculada';

  @override
  String get googleHesabiniBagla => 'Vincular cuenta de Google';

  @override
  String get googleHesabiBaglandi => 'Cuenta de Google vinculada con éxito';

  @override
  String get googleHesabiBaglantisiKesildi => 'Cuenta de Google desvinculada.';

  @override
  String get sifreVeGuvenlik => 'Contraseña y seguridad';

  @override
  String get sifreYenilemeBaglantisiIste =>
      'Solicitar enlace para restablecer contraseña';

  @override
  String get sifremiUnuttum => '¿Olvidaste tu contraseña?';

  @override
  String get sifreDegistirTitle => 'Cambiar contraseña';

  @override
  String get sifreSifirlamaAciklama =>
      'Se enviará un enlace de restablecimiento de contraseña al correo vinculado a tu cuenta:';

  @override
  String get epostaAdresi => 'Correo electrónico';

  @override
  String get gecerliBirEpostaGiriniz =>
      'Introduce una dirección de correo válida';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return 'Correo para restablecer contraseña enviado a $eposta';
  }

  @override
  String get baglantiGonder => 'Enviar enlace';

  @override
  String get hesabiKaliciSilTitle => 'Eliminar cuenta permanentemente';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'Esta acción no se puede deshacer. Los datos de tu armario y perfil se borrarán permanentemente.';

  @override
  String get hesabiSilOnayKoduMetni =>
      'Escribe \"fitcheck\" a continuación para confirmar:';

  @override
  String get vazgec => 'Cancelar';

  @override
  String get hesabimiSil => 'Eliminar mi cuenta';

  @override
  String get hesabinizSilindi =>
      'Tu cuenta y los datos asociados han sido eliminados.';

  @override
  String get kisiselStilVeProfilUst => 'ESTILO PERSONAL Y PERFIL';

  @override
  String get stilVeTarzTercihleri => 'Preferencias de estilo y ajuste';

  @override
  String get secili => 'Seleccionado';

  @override
  String get tenRengiTercihinizUst => 'PREFERENCIA DE TONO DE PIEL';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'IA Y PRECISIÓN DE ESTILO';

  @override
  String get stilistKisiligiVeYantitTarziUst =>
      'PERSONALIDAD DEL ESTILISTA Y ESTILO DE RESPUESTA';

  @override
  String get aiKisilikSamimiBaslik => 'Cercana / Casual';

  @override
  String get aiKisilikSamimiAciklama =>
      'Tono cálido y alentador que hace que la moda sea divertida y accesible';

  @override
  String get aiKisilikElestirmenBaslik => 'Crítico de moda profesional';

  @override
  String get aiKisilikElestirmenAciklama =>
      'Consejos técnicos centrados en la teoría del color y proporciones corporales';

  @override
  String get aiKisilikMinimalistBaslik => 'Minimalista y directo';

  @override
  String get aiKisilikMinimalistAciklama =>
      'Sugerencias concisas y al grano sin adornos';

  @override
  String get sikiRenkTeorisiUyumModu => 'Modo estricto de teoría del color';

  @override
  String get sikiRenkTeorisiAciklama =>
      'Cuando está activo, la IA se adhiere exclusivamente a las reglas clásicas del color';

  @override
  String get bildirimlerVeHatirlaticiUst => 'NOTIFICACIONES Y RECORDATORIOS';

  @override
  String get sabahKombinOnerisi => 'Sugerencia de atuendo matutino';

  @override
  String herSabahBildirimAl(Object saat) {
    return 'Recibir notificaciones diarias a las $saat';
  }

  @override
  String get bildirimSaatiniOzellestir => 'Personalizar hora de notificación';

  @override
  String get gunlukKombinBildirimSaati =>
      'Hora de notificación de atuendo diario';

  @override
  String get sabahBildirimSaatiSec =>
      'Seleccionar hora de notificación matutina';

  @override
  String get saatKaydedildiAksama =>
      'Hora guardada, pero no se pudo conectar con el servicio de notificaciones.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return 'Notificación matutina programada para las $saat. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari =>
      'Debes conceder permiso en los ajustes del dispositivo para activar las notificaciones.';

  @override
  String get camasirSepetiUyarilari => 'Alertas de cesto de colada';

  @override
  String get camasirSepetiUyarilariAciklama =>
      'Recibe alertas inteligentes cuando se acumule la ropa sucia';

  @override
  String get haftalikStilRaporu => 'Informe semanal de estilo';

  @override
  String get haftalikStilRaporuAciklama =>
      'Recibe un resumen del uso del armario todos los domingos por la tarde';

  @override
  String get gorunumVeBolgeUst => 'APARIENCIA Y REGIÓN';

  @override
  String get lokasyonVeBirimlerUst => 'UBICACIÓN Y UNIDADES';

  @override
  String get sicaklikBirimi => 'Unidad de temperatura';

  @override
  String get varsayilanSehirBolge => 'Ciudad / Región predeterminada';

  @override
  String get sehirOrnekHint => 'Ej: Madrid, Barcelona, Buenos Aires';

  @override
  String get gpsKullan => 'Usar GPS';

  @override
  String get veriVeDepolamaYonetimiUst => 'GESTIÓN DE DATOS Y ALMACENAMIENTO';

  @override
  String get gorselOnbelleginiTemizle => 'Borrar caché de imágenes';

  @override
  String get geciciFotografHafizasiAciklama =>
      'Libera espacio de almacenamiento temporal de fotos';

  @override
  String get onbellekTemizlendiBasari =>
      'Caché de imágenes y archivos temporales borrados';

  @override
  String get onbellekTemizlerkenHata =>
      'Ocurrió un problema al borrar la caché.';

  @override
  String get gardirobuDisaAktarYedekle =>
      'Exportar armario (Copia de seguridad)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Exportar toda la ropa y datos de atuendos en formato JSON';

  @override
  String get disaAktarilacakVeriYok =>
      'No se encontraron datos del armario para exportar.';

  @override
  String get gardiropVerisiKopyalandi =>
      'Todos los datos del armario se copiaron al portapapeles en formato JSON';

  @override
  String get destekVeDegerlendirmeUst => 'SOPORTE Y VALORACIONES';

  @override
  String get uygulamayiDegerlendirin => 'Valorar la aplicación';

  @override
  String get googlePlay5YildizDestek =>
      'Apóyanos valorando con 5 estrellas en Google Play ⭐';

  @override
  String get googlePlayAcilamadi => 'No se pudo abrir Google Play.';

  @override
  String get geriBildirimVeDestek => 'Comentarios y soporte';

  @override
  String get hataBildirVeyaOneri =>
      'Notificar un error o sugerir nuevas funciones';

  @override
  String get islemTamamlanamadi =>
      'La operación no se pudo completar. Inténtalo de nuevo.';

  @override
  String get epostaUygulamasiAcilamadi =>
      'No se pudo abrir la aplicación de correo. Escribe a ayberkzcn9@gmail.com.';

  @override
  String get gizlilikPolitikasiTitle => 'Política de privacidad';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'Ver uso de datos y derechos de privacidad';

  @override
  String get sonGuncellemeTarihi =>
      'Última actualización: 20 de octubre de 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Recopilación y uso de datos';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck procesa información para optimizar la gestión de tu armario y las recomendaciones de atuendos. Las fotos, el estilo y las preferencias de género se almacenan localmente en tu dispositivo. En las funciones de IA, los datos descritos en la sección 5 se envían a Gemini y Groq.';

  @override
  String get gizlilikMadde2Baslik => '2. Permisos de ubicación';

  @override
  String get gizlilikMadde2Icerik =>
      'Si autorizas el acceso a la ubicación, la latitud y longitud se envían a Open-Meteo para consultar el tiempo y a BigDataCloud para identificar tu ciudad. FitCheck no almacena estas coordenadas en sus servidores. Cada proveedor procesa los datos conforme a su propia política de privacidad.';

  @override
  String get gizlilikMadde3Baslik => '3. Asistente de voz y micrófono';

  @override
  String get gizlilikMadde3Icerik =>
      'Al usar la creación de atuendos por comando de voz, la voz se convierte instantáneamente en texto. Las grabaciones de audio no se almacenan de forma permanente.';

  @override
  String get gizlilikMadde4Baslik => '4. Servicios de terceros';

  @override
  String get gizlilikMadde4Icerik =>
      'Se utilizan las infraestructuras de Firebase y Google AdMob para análisis de rendimiento y publicación de anuncios.';

  @override
  String get anladim => 'Entendido';

  @override
  String get stilVeModaTercihleriniz => 'Preferencias de estilo y moda';

  @override
  String get stilModalAciklama =>
      'La IA dará prioridad a estas preferencias de estilo y ajuste al crear atuendos.';

  @override
  String get favoriTarzinizUst => 'ESTILO FAVORITO';

  @override
  String get giyimKesimiFitUst => 'CORTE Y AJUSTE DE ROPA';

  @override
  String get hesapSilmeUst => 'ELIMINACIÓN DE CUENTA';

  @override
  String get tumBulutVeYerelVeriTemizlenir =>
      'Elimina todos tus datos locales y en la nube';

  @override
  String get hakkindaUst => 'ACERCA DE';

  @override
  String get topluFotografEkleTooltip => 'Añadir ropa en lote';

  @override
  String get kuponKoduKullanTitle => 'Canjear código de cupón';

  @override
  String get kuponKoduAciklama =>
      'Introduce tu código de cupón a continuación:';

  @override
  String get kuponKoduHint => 'Código de cupón';

  @override
  String get kuponKullanButon => 'Canjear';

  @override
  String get kuponBasariliMesaji => 'Cupón aplicado';

  @override
  String get kuponKullanilmisUyari => 'Ya has canjeado este código de cupón';

  @override
  String get kuponGecersizUyari =>
      'Código de cupón no válido Inténtalo de nuevo.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Créditos ilimitados';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Créditos restantes: $hak';
  }

  @override
  String get sinirsizHakAciklama =>
      'Disfruta de generaciones de atuendos y análisis de estilo ilimitados con ventajas premium.';

  @override
  String get gunlukHakAciklama =>
      'Los créditos diarios se reinician todos los días a las 00:00. Puedes ver anuncios para ganar más créditos.';

  @override
  String get kuponKullan => 'Usar cupón';

  @override
  String hakEklendiTebrikler(int adet) {
    return 'Enhorabuena +$adet crédito añadido.';
  }

  @override
  String get gardirobunDolduTitle => 'Armario lleno';

  @override
  String gardirobunDolduIcerik(int limit, int adet) {
    return 'Has alcanzado el límite de $limit prendas. ¿Quieres ver un vídeo corto para ampliar la capacidad de tu armario en +$adet prendas?';
  }

  @override
  String reklamIzleSlotEkle(int adet) {
    return 'Ver anuncio (+$adet espacios)';
  }

  @override
  String yeniSlotEklendiTebrikler(int adet) {
    return 'Enhorabuena +$adet nuevos espacios añadidos al armario.';
  }

  @override
  String get gunlukHakBittiTitle => 'Límite diario alcanzado';

  @override
  String get gunlukHakBittiIcerik =>
      'Has agotado tus operaciones diarias gratuitas. Mira un vídeo corto para obtener nuevos créditos';

  @override
  String get kuponGir => 'Introducir cupón';

  @override
  String get anaSemsiyeBildirimBaslik => 'No olvides tu paraguas';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Parece que hoy va a llover, no olvides elegir un atuendo adecuado para el tiempo húmedo.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Día de colada';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Se ha acumulado ropa sucia en tu cesto. Es hora de poner una lavadora';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '¿Qué puedo ponerme con esta prenda? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'Tu atuendo está listo ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'Ver atuendo';

  @override
  String get chatStilistKombinTasarlayor =>
      'El estilista está diseñando el atuendo...';

  @override
  String get chatStilistYaziyor => 'El estilista está escribiendo...';

  @override
  String get pazartesi => 'Lunes';

  @override
  String get sali => 'Martes';

  @override
  String get carsamba => 'Miércoles';

  @override
  String get persembe => 'Jueves';

  @override
  String get cuma => 'Viernes';

  @override
  String get cumartesi => 'Sábado';

  @override
  String get pazar => 'Domingo';

  @override
  String get rehberiAtla => 'OMITIR GUÍA';

  @override
  String get rehberAnladimBasla => 'Entendido, empezar';

  @override
  String get rehberSonrakiAdim => 'Siguiente paso';

  @override
  String get rehberGardirobuDijitallestirBaslik => 'Digitaliza tu armario';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Toca este botón para tomar fotos o subirlas desde tu galería y crear tu armario digital.';

  @override
  String get rehberSesliAsistanBaslik => 'Asistente de estilo por voz';

  @override
  String get rehberSesliAsistanAciklama =>
      'Usa comandos de voz para preguntar qué ponerte o recibir recomendaciones instantáneas.';

  @override
  String get rehberAiStilistBaslik => 'Recomendaciones con IA';

  @override
  String get rehberAiStilistAciklama =>
      'Obtén recomendaciones a medida según el clima, tono de piel y preferencias con un solo toque.';

  @override
  String get rehberAyarlarBaslik => 'Personalización y Ajustes';

  @override
  String get rehberAyarlarAciklama =>
      'Personaliza género, tono de piel, color y tema o vuelve a ver la guía de inicio.';

  @override
  String get rehberNavGardirobumBaslik => 'Mi armario';

  @override
  String get rehberNavGardirobumAciklama =>
      'Consulta, filtra y gestiona toda tu ropa de forma clara por categorías.';

  @override
  String get rehberNavHaftalikBaslik => 'Planificador semanal';

  @override
  String get rehberNavHaftalikAciklama =>
      'Planifica tus atuendos diarios con antelación según el pronóstico para 7 días.';

  @override
  String get rehberNavDolaptanBaslik => 'Atuendos IA con tu ropa';

  @override
  String get rehberNavDolaptanAciklama =>
      'Deja que la IA genere combinaciones automáticas con tu ropa actual según las condiciones diarias.';

  @override
  String get rehberNavKendiBaslik => 'Crear atuendo personalizado';

  @override
  String get rehberNavKendiAciklama =>
      'Mezcla y combina partes de arriba, de abajo y calzado manualmente para crear y guardar tu propio estilo.';

  @override
  String get rehberNavProfilBaslik => 'Estadísticas y Colada';

  @override
  String get rehberNavProfilAciklama =>
      'Revisa estadísticas de uso de tu ropa y controla prendas pendientes en el cesto.';

  @override
  String get bildirimIzinGerekliBaslik => 'Permiso de notificaciones requerido';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Recomendamos activar las notificaciones para recibir recordatorios de colada, alertas de lluvia y consejos diarios.';

  @override
  String get bildirimGunaydinBaslik => 'Buenos días';

  @override
  String get bildirimGunaydinIcerik =>
      'He diseñado un gran atuendo para el pronóstico de hoy. ¿Quieres echarle un vistazo?';

  @override
  String get bildirimKanalGenelBaslik => 'Notificaciones generales';

  @override
  String get bildirimKanalGenelAciklama =>
      'Actualizaciones generales de FitCheck';

  @override
  String get bildirimKanalGunlukBaslik => 'Sugerencias diarias de atuendos';

  @override
  String get bildirimKanalGunlukAciklama =>
      'Alertas diarias con sugerencias de atuendos';

  @override
  String get bildirimKanalYikamaBaslik => 'Recordatorios de colada';

  @override
  String get bildirimKanalYikamaAciklama =>
      'Recordatorios para el cuidado y seguimiento de prendas';

  @override
  String get bildirimKanalRaporBaslik => 'Informes semanales de estilo';

  @override
  String get bildirimKanalRaporAciklama =>
      'Informes resumen semanales del uso de tu armario';

  @override
  String get tenRengiAcik => 'Claro / Blanco';

  @override
  String get tenRengiBugday => 'Medio / Moreno claro';

  @override
  String get tenRengiEsmer => 'Oscuro / Moreno';

  @override
  String get stilStreetwear => 'Urbano / Streetwear';

  @override
  String get stilKlasik => 'Clásico / Formal';

  @override
  String get stilMinimalist => 'Minimalista';

  @override
  String get stilSpor => 'Deportivo / Athleisure';

  @override
  String get stilVintage => 'Vintage / Retro';

  @override
  String get fitSlim => 'Slim Fit (Ajustado)';

  @override
  String get fitRegular => 'Regular Fit (Estándar)';

  @override
  String get fitOversize => 'Oversize / Holgado';

  @override
  String get gardirobumBosBaslik => 'Tu armario está muy vacío';

  @override
  String get gardirobumGizlendiBaslik => 'Armario oculto';

  @override
  String get gardirobumGizlendiAciklama =>
      'Toca el icono del ojo arriba a la derecha para ver el contenido';

  @override
  String get gardirobumGoster => 'Mostrar contenido';

  @override
  String get gardirobumGizle => 'Ocultar contenido';

  @override
  String get kategoriUst => 'PARTES DE ARRIBA';

  @override
  String get kategoriAlt => 'PARTES DE ABAJO';

  @override
  String get kategoriAyakkabi => 'CALZADO';

  @override
  String get kategoriAksesuar => 'ACCESORIOS';

  @override
  String get gardirobumBosAciklama =>
      'Añade tu primera prenda ahora y descubre la magia de la IA.';

  @override
  String get gardirobumAiIslem1 => 'Escaneando tu armario...';

  @override
  String get gardirobumAiIslem2 =>
      'Analizando las condiciones meteorológicas...';

  @override
  String get gardirobumAiIslem3 => 'Calculando la armonía de colores...';

  @override
  String get gardirobumAiIslem4 => 'Seleccionando los mejores atuendos...';

  @override
  String get gardirobumAiIslem5 => 'Aplicando los últimos detalles...';

  @override
  String get gardirobumHakBittiBaslik => 'Límite diario alcanzado';

  @override
  String get gardirobumHakBittiAciklama =>
      'Has alcanzado tu límite diario de creación de conjuntos.';

  @override
  String get gardirobumHakEklendiMesaj =>
      'Enhorabuena, nuevo crédito de conjunto obtenido';

  @override
  String get ayarlariAc => 'Abrir Ajustes';

  @override
  String get kiyafetEkle => 'Añadir prenda';

  @override
  String get kameraIleCek => 'Hacer foto';

  @override
  String get galeridenSecToplu => 'Seleccionar lote de la galería';

  @override
  String get kameraIzniGerekliBaslik => 'Permiso de cámara requerido';

  @override
  String get kameraIzniGerekliAciklama =>
      'Por favor, activa el permiso de cámara para tomar fotos.';

  @override
  String get kiyafetDuzenleBaslik => 'Editar prenda';

  @override
  String get kategori => 'Categoría';

  @override
  String get evetSil => 'Sí, eliminar';

  @override
  String get favorilerdenCikarildi => 'Eliminado de favoritos';

  @override
  String get gardirobumHenuzYokEkle =>
      'Aún no se han añadido prendas. Añade ahora';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return 'Puedes seleccionar un máximo de $max fotos a la vez.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count prendas';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '%$oran de combinación';
  }

  @override
  String get kombinSohbetAc => 'Chatear sobre el conjunto';

  @override
  String get kombinSohbetBaslik => 'Chat del conjunto';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return 'Chat sobre tu conjunto del $gun';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return 'Analicemos juntos tu conjunto «$kombin» Pregúntame lo que quieras sobre la armonía de colores, el clima o prendas alternativas.';
  }

  @override
  String get kombinSohbetOneriUyum => '¿Por qué combina bien este conjunto?';

  @override
  String get kombinSohbetOneriAlternatif => 'Sugiere una prenda alternativa';

  @override
  String get kombinSohbetOneriHava => '¿Y si cambia el clima?';

  @override
  String get kombinSohbetOneriAksesuar => 'Dame ideas de accesorios';

  @override
  String get kombinSohbetAltBaslikAnlik =>
      'Charla sobre tu conjunto del momento';

  @override
  String get chatKirliSepetiBos =>
      'Tu cesto de colada está vacío Todas tus prendas están listas para usar: puedo prepararte un conjunto cuando quieras.';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return 'Tienes **$sayi** prendas esperando en el cesto de colada:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Estas prendas no se incluirán en tus conjuntos hasta que se laven. Si quieres, puedo prepararte ahora mismo un look con tus prendas limpias.';

  @override
  String get analitikVerileriPaylas => 'Compartir datos de análisis';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Los datos de uso se envían a Firebase Analytics para comprender el uso de la aplicación y mejorar la experiencia. Es opcional y puedes desactivarlo cuando quieras.';

  @override
  String get chatKarsilamaHavaYok =>
      'Hola ¿Creamos un conjunto genial que vaya con tu estilo?';

  @override
  String get premiumBaslik => 'Estilo ilimitado, cero anuncios';

  @override
  String get premiumAciklama =>
      'Usa tus conjuntos y análisis de estilo sin límites y elimina todos los anuncios con una sola suscripción.';

  @override
  String get premiumOzellikReklamsiz => 'Se eliminan todos los anuncios';

  @override
  String get premiumOzellikAylik => 'Se renueva automáticamente cada mes';

  @override
  String get premiumOzellikMagaza => 'Se gestiona a través de Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium activo. Uso ilimitado y sin anuncios.';

  @override
  String get premiumAboneOl => 'Suscríbete';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Suscríbete • $fiyat';
  }

  @override
  String get premiumGeriYukle => 'Restaurar compra';

  @override
  String get premiumMagazaHazirDegil =>
      'Google Play no está disponible ahora mismo. Inténtalo de nuevo.';

  @override
  String get premiumSatinAlmaBaslatilamadi => 'No se pudo iniciar la compra.';

  @override
  String get premiumSatinAlmaBasarisiz => 'La compra no se completó.';

  @override
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Conjuntos ilimitados • $fiyat/mes';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Hazte ilimitado • $fiyat/mes';
  }

  @override
  String get guncellemeBaslik => 'Actualización necesaria';

  @override
  String get guncellemeAciklama =>
      'Hay una nueva versión de FitCheck disponible. Actualiza la aplicación para continuar.';

  @override
  String get guncellemeButonu => 'Actualizar ahora';

  @override
  String guncellemeYeniSurum(String surum) {
    return 'Nueva versión: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok =>
      'No se pudo abrir el enlace de la tienda. Actualiza la aplicación desde la tienda.';

  @override
  String get premiumUrunBulunamadi =>
      'No se pudo cargar la información de la suscripción. Inténtalo de nuevo más tarde.';

  @override
  String get triviaQ1 =>
      '¿Qué color se sitúa frente a los tonos camel y naranja en la rueda cromática y crea un fuerte contraste?';

  @override
  String get triviaQ1o1 => 'Azul zafiro / azul petróleo';

  @override
  String get triviaQ1o2 => 'Verde Esmeralda';

  @override
  String get triviaQ1o3 => 'Borgoña';

  @override
  String get triviaQ1o4 => 'Amarillo Mostaza';

  @override
  String get triviaQ2 =>
      '¿Qué significa el estilo de ropa \"monocromática\" en la moda?';

  @override
  String get triviaQ2o1 => 'Usar diferentes tonos de un solo color juntos';

  @override
  String get triviaQ2o2 => 'Usar solo ropa blanca y negra';

  @override
  String get triviaQ2o3 =>
      'Mezcla de al menos 3 colores contrastantes al mismo tiempo';

  @override
  String get triviaQ2o4 => 'Combina solo piezas estampadas y estampadas';

  @override
  String get triviaQ3 =>
      '¿Qué tono de piel se adapta mejor a las joyas doradas, los terracota y verde oliva?';

  @override
  String get triviaQ3o1 => 'Subtono frío';

  @override
  String get triviaQ3o2 => 'Subtono cálido';

  @override
  String get triviaQ3o3 => 'Subtono azulado';

  @override
  String get triviaQ3o4 => 'Subtono rosado';

  @override
  String get triviaQ4 =>
      '¿Cuál NO pertenece a los colores neutros que combinan fácilmente con todo en un armario cápsula?';

  @override
  String get triviaQ4o1 => 'Beige / crema';

  @override
  String get triviaQ4o2 => 'azul marino';

  @override
  String get triviaQ4o3 => 'Amarillo neón';

  @override
  String get triviaQ4o4 => 'tostado / marrón';

  @override
  String get triviaQ5 =>
      '¿Cómo se llama el grupo de colores que se encuentra uno al lado del otro en la rueda de colores y proporciona una transición suave y llamativa?';

  @override
  String get triviaQ5o1 => 'Colores complementarios (en contraste)';

  @override
  String get triviaQ5o2 => 'Colores análogos';

  @override
  String get triviaQ5o3 => 'Colores pastel';

  @override
  String get triviaQ5o4 => 'Colores triádicos';

  @override
  String get triviaQ6 =>
      '¿Qué es la «regla de los tercios» aplicada a la moda para hacer que la proporción corporal sea más larga y equilibrada?';

  @override
  String get triviaQ6o1 =>
      '1/2 arriba - 1/2 abajo (tronco y piernas en la misma proporción)';

  @override
  String get triviaQ6o2 =>
      '1/3 arriba - 2/3 abajo (cintura alta / parte de arriba corta)';

  @override
  String get triviaQ6o3 =>
      '2/3 arriba - 1/3 abajo (túnica larga / parte de abajo corta)';

  @override
  String get triviaQ6o4 => 'Una prenda de cuerpo entero';

  @override
  String get triviaQ7 =>
      '¿Qué significa el término francés de moda «tono sobre tono»?';

  @override
  String get triviaQ7o1 =>
      'Capas de diferentes saturaciones y matices claros/oscuros del mismo color';

  @override
  String get triviaQ7o2 =>
      'Combinación de dos colores completamente opuestos con líneas nítidas';

  @override
  String get triviaQ7o3 => 'Mezcla de patrones en blanco y negro';

  @override
  String get triviaQ7o4 =>
      'Recopilación de diferentes texturas de tela en un solo color';

  @override
  String get triviaQ8 =>
      'De acuerdo con las reglas de la ropa clásica y formal, ¿qué color de cinturón de cuero debe coincidir exactamente?';

  @override
  String get triviaQ8o1 => 'Corbata o chal';

  @override
  String get triviaQ8o2 => 'Camisa';

  @override
  String get triviaQ8o3 => 'Zapatos';

  @override
  String get triviaQ8o4 => 'Forro de la chaqueta';

  @override
  String get triviaQ9 =>
      '¿Cuál es el estilo de combinación vívida de 3 colores (por ejemplo: rojo, amarillo, azul) espaciados uniformemente en la rueda de colores?';

  @override
  String get triviaQ9o1 => 'Armonía de color triádica';

  @override
  String get triviaQ9o2 => 'Armonía neutra';

  @override
  String get triviaQ9o3 => 'Armonía monocromática';

  @override
  String get triviaQ9o4 => 'Estilo cápsula';

  @override
  String get triviaQ10 =>
      '¿Qué efecto visual crea un zapato que combina con el tono de piel (nude) o con el pantalón?';

  @override
  String get triviaQ10o1 => 'Alarga visualmente las piernas sin interrupciones';

  @override
  String get triviaQ10o2 => 'Hace que el cuerpo parezca más ancho';

  @override
  String get triviaQ10o3 => 'Destaca la anchura de los hombros';

  @override
  String get triviaQ10o4 => 'Hace que parezcas más bajo';

  @override
  String get kombinOyunuBaslik => 'Juego de Combinaciones';

  @override
  String get kombinMevcutKombin => 'Conjunto actual';

  @override
  String get kombinParcaUst => 'Parte de arriba';

  @override
  String get kombinParcaAlt => 'Parte de abajo';

  @override
  String get kombinEksik_ayakkabi => 'Faltan: zapatos';

  @override
  String get kombinEksik_ceket => 'Falta: chaqueta';

  @override
  String get kombinEksik_aksesuar => 'Faltan: accesorios';

  @override
  String get kombinSoru_ayakkabi => '¿Qué zapatos combinan mejor?';

  @override
  String get kombinSoru_ceket => '¿Qué chaqueta combina mejor?';

  @override
  String get kombinSoru_aksesuar => '¿Qué accesorio combina mejor?';

  @override
  String get kombinKategoriAyakkabi => 'Zapatos';

  @override
  String get kombinKategoriCeket => 'Chaqueta';

  @override
  String get kombinKategoriAksesuar => 'Accesorios';

  @override
  String get kombinOrtamOfis => 'Oficina';

  @override
  String get kombinOrtamCasual => 'Informal';

  @override
  String get kombinOrtamDavet => 'Fiesta';

  @override
  String get kombinOrtamSpor => 'Deporte';

  @override
  String get kombinHavaGunesli => 'Soleado';

  @override
  String get kombinHavaYagmurlu => 'Lluvioso';

  @override
  String get kombinHavaSoguk => 'Frío';

  @override
  String get kombinHavaSicak => 'Cálido';

  @override
  String get kombinRenkBeyaz => 'Blanco';

  @override
  String get kombinRenkSiyah => 'Negro';

  @override
  String get kombinRenkKahverengi => 'Marrón';

  @override
  String get kombinRenkLacivert => 'Azul marino';

  @override
  String get kombinRenkBej => 'Beige';

  @override
  String get kombinRenkKoyuYesil => 'Verde oscuro';

  @override
  String get kombinRenkNude => 'Color piel';

  @override
  String get kombinRenkAltin => 'Dorado';

  @override
  String get kombinRenkGri => 'Gris';

  @override
  String get kombinRenkPastelMavi => 'Azul pastel';

  @override
  String get kombinRenkKirmizi => 'Rojo';

  @override
  String get kombinRenkMavi => 'Azul';

  @override
  String get kombinRenkGumus => 'Plateado';

  @override
  String get kombinRenkKoyuMavi => 'Azul oscuro';

  @override
  String get kombinRenkKamel => 'Camel';

  @override
  String get kombinRenkYesil => 'Verde';

  @override
  String get kombinRenkAcikMavi => 'Azul claro';

  @override
  String get kombinRenkNavy => 'Azul marino';

  @override
  String get kombinSecenekKahverengiOxford =>
      'Zapatos Oxford de cuero marrones';

  @override
  String get kombinSecenekSiyahDerby => 'Zapatos Derby negros';

  @override
  String get kombinSecenekBeyazSpor => 'Zapatillas blancas';

  @override
  String get kombinSecenekKahverengiCizme => 'Botas marrones';

  @override
  String get kombinSecenekSiyahSuGecirmezBot => 'Botas impermeables negras';

  @override
  String get kombinSecenekNudeBallerina => 'Bailarinas nude';

  @override
  String get kombinSecenekAltinSandalet => 'Sandalias doradas';

  @override
  String get kombinSecenekSiyahBlazer => 'Blazer negro';

  @override
  String get kombinSecenekKirmiziDeriCeket => 'Chaqueta de cuero roja';

  @override
  String get kombinSecenekAltinDetayliCeket => 'Chaqueta con detalles dorados';

  @override
  String get kombinSecenekBeyazPufy => 'Chaqueta acolchada Pufy blanca';

  @override
  String get kombinSecenekBeyazKosu => 'Zapatillas de running blancas';

  @override
  String get kombinSecenekSiyahBasketbol => 'Zapatillas de baloncesto negras';

  @override
  String get kombinSecenekMaviTerlik => 'Zapatillas azules';

  @override
  String get kombinSecenekKahverengiLoafer => 'Mocasines marrones';

  @override
  String get kombinSecenekBeyazBespan => 'Zapatos Bespan blancos';

  @override
  String get kombinSecenekSiyahGunes => 'Gafas de sol negras';

  @override
  String get kombinSecenekSiyahSirtCantasi => 'Mochila negra';

  @override
  String get kombinSecenekGumusAkilliSaat => 'Reloj inteligente plateado';

  @override
  String get kombinSecenekKamelCifteYaka => 'Chaqueta camel de doble cuello';

  @override
  String get kombinSecenekSiyahBomber => 'Chaqueta bomber negra';

  @override
  String get kombinSecenekKirmiziPufy => 'Chaqueta acolchada Pufy roja';

  @override
  String get kombinSecenekYesilDenim => 'Chaqueta vaquera verde';

  @override
  String get kombinSecenekKahverengiKemer => 'Cinturón marrón';

  @override
  String get kombinSecenekSiyahKemer => 'Cinturón negro';

  @override
  String get kombinSecenekNavyBlokSal => 'Pañuelo color block azul marino';

  @override
  String get kombinSecenekKahverengiGozluk => 'Gafas marrones';

  @override
  String get kombinSecenekGriSuGecirmez =>
      'Zapatillas de running impermeables grises';

  @override
  String get kombinSecenekKahverengiTrekking => 'Botas de trekking marrones';

  @override
  String get kombinSecenekSiyahTerlik => 'Sandalias negras';

  @override
  String get kombinSecenekBeyazTenis => 'Zapatillas de tenis blancas';

  @override
  String get kombinOyunBitti => 'Juego terminado';

  @override
  String get kombinToplamPuan => 'Puntuación total';

  @override
  String get kombinBasariOrani => 'Porcentaje de aciertos';

  @override
  String get kombinTekrarOyna => 'Jugar otra vez';

  @override
  String get kombinAnaSayfa => 'Inicio';

  @override
  String get kombinSonucUsta => 'Maestro del estilo';

  @override
  String get kombinSonucUstaMesaj =>
      'Tu sentido del color y la armonía merece un premio';

  @override
  String get kombinSonucIyi => 'Vas por buen camino';

  @override
  String get kombinSonucIyiMesaj => 'Con un poco de práctica, lo conseguirás.';

  @override
  String get kombinSonucPratik => 'Sigue practicando';

  @override
  String get kombinSonucPratikMesaj =>
      'Consulta la pestaña Análisis para ver consejos sobre teoría del color.';

  @override
  String get degerlendirmeBaslik => '¿Te gusta FitCheck?';

  @override
  String get degerlendirmeIcerik =>
      'Si te encanta la aplicación, ¿podrías dedicar 5 segundos a dejarnos una reseña? Las reseñas pequeñas son una gran ayuda';

  @override
  String get degerlendirmeEvet => 'Sí, lo evaluaré';

  @override
  String get degerlendirmeBelkiSonra => 'Quizás más tarde';

  @override
  String get yakinda => 'Próximamente';

  @override
  String get yakindaAciklama =>
      'Estamos trabajando en esta función, muy pronto estará disponible';

  @override
  String get aiOneriHazirlaniyor => 'Preparando una sugerencia...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'No se pudo preparar la sugerencia del estilista. Inténtalo de nuevo.';

  @override
  String get haftalikAiServisHatasi =>
      'No se pudo contactar con el servicio de IA. Revisa tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get haftalikAiGecerliPlanYok =>
      'La IA no devolvió un plan válido. Inténtalo de nuevo.';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'Ocurrió un error inesperado al crear el plan. Inténtalo de nuevo.';

  @override
  String get haftalikBugunGiyildi =>
      'El conjunto de hoy ya se ha usado; no se creó uno nuevo.';

  @override
  String get girisHataKullaniciAdiKisa => 'Introduce al menos 3 caracteres';

  @override
  String get girisHataEpostaGecersiz => 'Introduce un correo válido';

  @override
  String get girisHataSifreKisa => 'Introduce al menos 6 caracteres';

  @override
  String get googleKullanicisi => 'Usuario de Google';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => 'Seleccionar idioma';

  @override
  String get dilSecenekOtomatik => 'Automático (idioma del dispositivo)';

  @override
  String get kapat => 'Cerrar';

  @override
  String get bildirimBaslik => 'Notificación';

  @override
  String get ayarlarAltbilgi => 'Hecho con estilo';

  @override
  String get geriBildirimKonu => 'FitCheck Comentarios';

  @override
  String get premiumOzelliklerBaslik => 'Lo que desbloqueas con Premium';

  @override
  String get premiumOzellikSinirsizKombin => 'Creación de conjuntos ilimitada';

  @override
  String get premiumOzellikSinirsizAnaliz =>
      'Análisis de estilo con IA ilimitado';

  @override
  String get premiumOzellikSinirsizGardirob => 'Espacio de armario ilimitado';

  @override
  String get premiumPlanAylik => 'Mensual';

  @override
  String get premiumPlanYillik => 'Anual';

  @override
  String get premiumEnAvantajli => 'MEJOR OPCIÓN';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return 'Ahorra un $yuzde%';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun DÍAS GRATIS';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'Luego $fiyat';
  }

  @override
  String get premiumYenilemeNotu =>
      'La suscripción se renueva automáticamente al final de cada período. Cancela cuando quieras.';

  @override
  String get kiyafetDondur => 'Girar';

  @override
  String get stilistHafizasiBaslik => 'Memoria del estilista';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return 'Recuerda $sayi notas';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'Todavía no recuerda nada';

  @override
  String get stilistHafizasiAciklama =>
      'El estilista guarda como notas permanentes lo que aprende en tus chats y personaliza sus sugerencias. Las notas solo se guardan en este dispositivo.';

  @override
  String get stilistHafizasiNelerBiliyor => '¿Qué recuerda?';

  @override
  String get stilistHafizasiOzetBaslik => 'Resumen de tus chats recientes';

  @override
  String get stilistHafizasiBos =>
      'Todavía no he aprendido nada. Iré conociendo tu estilo mientras charlamos.';

  @override
  String get stilistHafizasiTemizle => 'Borrar memoria';

  @override
  String get stilistHafizasiTemizleOnay =>
      'Se eliminará todo lo que el estilista recuerda sobre ti. Esta acción no se puede deshacer.';

  @override
  String get stilistHafizasiTemizlendi => 'Memoria borrada';

  @override
  String get gardirobumArkaPlanSilinemediBaslik => 'Fondo no eliminado';

  @override
  String get gardirobumArkaPlanSilinemediAciklama =>
      'Puede haber un problema de conexión. Elige si quieres intentarlo de nuevo, guardar la foto con su fondo u omitir esta foto.';

  @override
  String get gardirobumArkaPlanliKaydet => 'Guardar con fondo';

  @override
  String get cekimIpucuBaslik => 'Para un mejor recorte';

  @override
  String get cekimIpucu1 =>
      'Coloca la prenda sobre una superficie plana y lisa.';

  @override
  String get cekimIpucu2 => 'Usa un color distinto al de la prenda.';

  @override
  String get cekimIpucu3 => 'Evita sombras y superficies con dibujos.';

  @override
  String kullanimKosullariOnayMetni(String terms) {
    return 'He leído y acepto los $terms.';
  }

  @override
  String get kendiTasarimimParcaSec => 'Elige una prenda';

  @override
  String get hesapSilmeBasarisiz =>
      'No se pudo completar la eliminación de la cuenta. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get bildirimTamZamanAyar => 'Notificaciones a la hora exacta';

  @override
  String get bildirimTamZamanAciklama =>
      'Permite \'Alarms & reminders\' en Android para recibirlas exactamente a la hora que elijas.';

  @override
  String get bildirimTamZamanAcik =>
      'Las notificaciones a la hora exacta están activadas.';

  @override
  String get premiumSatinAlmaDogrulamaHazirDegil =>
      'La verificación segura de la tienda aún no está disponible para esta plataforma. Las compras no están disponibles temporalmente.';

  @override
  String get islemIptalEdildi =>
      'Proceso cancelado. Las prendas añadidas hasta ahora siguen en tu armario.';

  @override
  String get islemIptalEdiliyor => 'Cancelando…';

  @override
  String get sifreGoster => 'Mostrar contraseña';

  @override
  String get sifreGizle => 'Ocultar contraseña';

  @override
  String get gunSayisiAzalt => 'Reducir el número de días';

  @override
  String get gunSayisiArttir => 'Aumentar el número de días';

  @override
  String get chatGorseliKaldir => 'Quitar imagen';

  @override
  String get kesimUyarisiBaslik => 'El recorte puede no ser preciso';

  @override
  String get kesimUyarisiAciklama =>
      'El color de la prenda es muy parecido al del fondo. La eliminación del fondo tiene dificultades: puede quedar parte del fondo o cortarse una parte de la prenda. Volver a hacer la foto sobre una superficie de otro color suele solucionarlo.';

  @override
  String get kesimUyarisiTekrarCek => 'Volver a hacer la foto';

  @override
  String get kesimUyarisiYineDeKaydet => 'Guardar igualmente';

  @override
  String get gizlilikMadde5Baslik => '5. Análisis de imágenes con IA';

  @override
  String get gizlilikMadde5Icerik =>
      'Las fotos de las prendas se procesan en nuestro propio servidor para quitar el fondo y se envían a los servicios de IA de Google (Gemini) y Groq para el análisis de estilo y las sugerencias de conjuntos. Las fotos se procesan solo para responder a tu solicitud, no las almacenamos de forma permanente ni las usamos para publicidad. La foto original también se envía solo para el análisis solicitado y no la conservamos de forma permanente.';

  @override
  String get bugunSekmesi => 'Hoy';

  @override
  String get bugunBaslik => 'Hoy';

  @override
  String get bugunGunaydin => 'Buenos días';

  @override
  String get bugunIyiGunler => 'Buenas tardes';

  @override
  String get bugunIyiAksamlar => 'Buenas noches';

  @override
  String get bugunBugununKombini => 'El conjunto de hoy';

  @override
  String get bugunNedenBuKombin => '¿Por qué este conjunto?';

  @override
  String get bugunRenkUyumu => 'Armonía de color';

  @override
  String get kombinHedefiBaslik => 'Tu objetivo de estilo';

  @override
  String get kombinHedefiAciklama =>
      '¿Qué deben priorizar las nuevas sugerencias de conjuntos y planes semanales?';

  @override
  String get kombinHedefiDenge => 'Sugerencias equilibradas';

  @override
  String get kombinHedefiRenk => 'Explorar colores';

  @override
  String get kombinHedefiUnutulan => 'Usar prendas menos usadas';

  @override
  String get kombinHedefiCokYonlu => 'Prendas versátiles';

  @override
  String get bugunHizliFotograf => 'Añadir una foto';

  @override
  String get bugunHizliKombin => 'Crear un conjunto';

  @override
  String get bugunHizliStilist => 'Preguntar al estilista';

  @override
  String get bugunHizliPlan => 'Planificar la semana';

  @override
  String get bugunHazirlaniyor => 'Preparando conjuntos…';

  @override
  String get bugunBosBaslik => 'Tu armario está vacío';

  @override
  String get bugunBosAciklama =>
      'Añade tu primera prenda; cada mañana tendrás aquí nuevas ideas de conjuntos.';

  @override
  String get bugunYenile => 'Actualizar';

  @override
  String get bugunGiydim => 'Me lo puse';

  @override
  String get bugunKaydet => 'Guardar';

  @override
  String get bugunSeninIcin => 'Para ti';

  @override
  String get bugunGiyilmediRafi => 'Sin usar desde hace 2 semanas';

  @override
  String get bugunYeniRafi => 'Añadidos recientemente';

  @override
  String get bugunHavaRafi => 'Adecuados para hoy';

  @override
  String get bugunRafIpucu =>
      'Toca: me la puse hoy, crea un look o ábrela en el armario';

  @override
  String get duelloSekmesi => 'Duelo';

  @override
  String get duelloBaslik => 'Duelo de conjuntos';

  @override
  String get duelloAltBaslik =>
      'Elige uno de los dos conjuntos y pon a prueba tu ojo.';

  @override
  String get duelloBaslat => 'Empezar el duelo';

  @override
  String get duelloNasilOynanir => '¿Cómo se juega?';

  @override
  String get duelloKural1 => 'Cada ronda muestra dos conjuntos.';

  @override
  String get duelloKural2 => 'Elige el que pide la pregunta.';

  @override
  String get duelloKural3 => 'Acertar da puntos y racha.';

  @override
  String get duelloEnIyi => 'Mejor';

  @override
  String get duelloSeri => 'Racha';

  @override
  String duelloGunSerisi(int gun) {
    return '$gun días';
  }

  @override
  String get duelloSeviye => 'Nivel';

  @override
  String duelloSeviyeDegeri(int seviye) {
    return 'Nivel $seviye';
  }

  @override
  String duelloXp(int xp) {
    return '$xp XP';
  }

  @override
  String duelloTur(int tur, int toplam) {
    return 'Ronda $tur/$toplam';
  }

  @override
  String get duelloOlcuRenk => '¿Cuál tiene mejores colores?';

  @override
  String get duelloOlcuHava => '¿Cuál va mejor con el tiempo de hoy?';

  @override
  String get duelloDokun => 'Toca un conjunto';

  @override
  String get duelloDogru => 'Correcto';

  @override
  String get duelloYanlis => 'Casi';

  @override
  String get duelloDevam => 'Continuar';

  @override
  String get duelloSonuc => 'Ver resultado';

  @override
  String get duelloBitti => 'Duelo terminado';

  @override
  String duelloSkor(int dogru, int toplam) {
    return '$dogru/$toplam correctas';
  }

  @override
  String get duelloYeniden => 'Jugar otra vez';

  @override
  String get duelloBugune => 'Volver a Hoy';

  @override
  String duelloEnIyiSeri(int seri) {
    return 'Mejor racha: $seri';
  }

  @override
  String get duelloPaletNotu =>
      'Esta ronda usa tarjetas de color. Añade prendas y los duelos usarán tu ropa.';

  @override
  String get duelloDolapEkle => 'Añadir prendas';

  @override
  String get duelloBugunOynadi =>
      'Has jugado hoy. Vuelve mañana para seguir la racha.';

  @override
  String get duelloSebepNotr => 'Los tonos neutros y tierra se equilibran.';

  @override
  String get duelloSebepMonokrom =>
      'Mantener una sola familia de color da unidad.';

  @override
  String get duelloSebepAnalog =>
      'Los tonos cercanos crean una transición suave.';

  @override
  String get duelloSebepVurgu =>
      'Un solo color de acento sobre una base neutra.';

  @override
  String get duelloSebepZit => 'Colores opuestos usados con equilibrio.';

  @override
  String get duelloSebepDagink => 'Dos colores lejanos sin nada que los una.';

  @override
  String get duelloSebepCokRenk => 'Tres colores vivos compiten entre sí.';

  @override
  String get duelloSebepHavaUygun =>
      'Las prendas van bien con la temperatura de hoy.';

  @override
  String get duelloSebepHavaAgir => 'Demasiado abrigo para este tiempo.';

  @override
  String get duelloSebepHavaHafif => 'Demasiado ligero para este tiempo.';

  @override
  String bildirimSabahKombin(String kombin) {
    return 'Tu look de hoy está listo: $kombin. Toca para verlo.';
  }

  @override
  String get bildirimPlanBaslik => 'Tu look de mañana está listo';

  @override
  String bildirimPlanKombin(String kombin) {
    return 'Para mañana: $kombin. Míralo ahora, sin prisas por la mañana.';
  }

  @override
  String get bildirimPlanBos =>
      'Aún no hay look para mañana. Planifícalo en 2 minutos.';

  @override
  String get planHatirlatimiAyar => 'Recordatorio de la tarde';

  @override
  String get planHatirlatimiAyarAciklama =>
      'Te recuerda el look de mañana a las 21:00';

  @override
  String get bugunPaylas => 'Compartir look';

  @override
  String get bugunPaylasMetni => 'He preparado mi look de hoy con FitCheck';

  @override
  String get bugunPaylasHata =>
      'No se pudo abrir compartir. Inténtalo de nuevo.';

  @override
  String get bugunParcaGiydim => 'Lo llevé hoy';

  @override
  String get bugunParcaKombin => 'Crear look con esta prenda';

  @override
  String get bugunParcaDolapta => 'Abrir en el armario';

  @override
  String bugunParcaGiydimIsaretlendi(String parca) {
    return '«$parca» marcada como usada hoy.';
  }

  @override
  String get stilGunluguBaslik => 'Mi diario de estilo';

  @override
  String get stilGunluguTakvim => 'Calendario';

  @override
  String get stilGunluguGunluk => 'Diario';

  @override
  String get stilGunluguRapor => 'Informe';

  @override
  String get stilGunluguGiyildi => 'Usado';

  @override
  String get stilGunluguPlanli => 'Planeado';

  @override
  String get stilGunluguGunBos => 'No hay registro para este día';

  @override
  String stilGunluguRaporOzet(String kombin) {
    return 'Esta semana llevaste $kombin looks';
  }

  @override
  String stilGunluguRaporGecenHafta(String fark) {
    return 'Comparado con la semana pasada: $fark';
  }

  @override
  String get stilGunluguRaporKullanim => 'Uso del armario';

  @override
  String get stilGunluguRaporEnCok => 'El más usado';

  @override
  String get stilGunluguRaporSeri => 'Racha diaria';

  @override
  String get stilGunluguRaporHicGiyilmemis => 'Nunca usado';

  @override
  String get stilGunluguRaporPaylas => 'Compartir informe';

  @override
  String stilGunluguRaporPaylasMetni(String ozet) {
    return 'Mi informe de estilo semanal: $ozet';
  }

  @override
  String get stilGunluguRaporBos =>
      'Aún no hay looks registrados esta semana. Aparecerán aquí.';

  @override
  String get seyahatBaslik => 'Modo viaje';

  @override
  String get seyahatGunSayisi => 'Días';

  @override
  String get seyahatHava => 'Clima';

  @override
  String get seyahatHavaSicak => 'Calor';

  @override
  String get seyahatHavaIliman => 'Templado';

  @override
  String get seyahatHavaSoguk => 'Frío';

  @override
  String get seyahatAmac => 'Ocasión';

  @override
  String get seyahatAmacGunluk => 'Diario';

  @override
  String get seyahatAmacIs => 'Trabajo';

  @override
  String get seyahatAmacOzel => 'Especial';

  @override
  String get seyahatPlanBaslik => 'Plan de maleta';

  @override
  String seyahatKombine(String adet) {
    return '$adet looks';
  }

  @override
  String get seyahatDiger => 'Abrigo';

  @override
  String get seyahatEksikUst => 'No hay tops limpios';

  @override
  String get seyahatEksikAlt => 'No hay bottoms limpios';

  @override
  String get seyahatEksikAyakkabi => 'No hay zapatos';

  @override
  String seyahatEksikKombin(String gun) {
    return 'No hay suficientes looks para $gun días';
  }

  @override
  String get seyahatPaylas => 'Compartir lista';

  @override
  String get seyahatPaylasMetni => 'Mi plan de maleta de FitCheck';

  @override
  String get geriAl => 'Deshacer';

  @override
  String get stilGunluguRaporSayiEtiketi => 'Conjuntos llevados esta semana';

  @override
  String get stilGunluguRaporDortHafta => 'Últimas 4 semanas';

  @override
  String get stilGunluguRaporEnCokParcalar => 'Prendas más usadas';

  @override
  String get navKombin => 'Conjunto';

  @override
  String get navProfil => 'Perfil';

  @override
  String get dolapAra => 'Buscar en tu armario';

  @override
  String get dolapEslesmeYok => 'Ninguna prenda coincide.';

  @override
  String get dolapAramayiTemizle => 'Borrar búsqueda';

  @override
  String get planGuneKombinSec => 'Elegir un look para este día';

  @override
  String get planKombinSec => 'Elegir un look';

  @override
  String get planDegistir => 'Cambiar';

  @override
  String get planKaldir => 'Quitar';

  @override
  String get planFavoriYok => 'Aún no tienes looks favoritos.';

  @override
  String get planKombinOlustur => 'Crear un look';

  @override
  String get planGuneEklendi => 'Look añadido al día';

  @override
  String get planKaldirildi => 'Plan eliminado';

  @override
  String get planHaftalikProgram => 'Programa semanal';

  @override
  String planParcaSayisi(int count) {
    return '$count prendas';
  }

  @override
  String get planBugun => 'Tu look de hoy';

  @override
  String get planTakvimdenDegistir => 'Cambiar en el calendario';

  @override
  String get planFavorilerim => 'Mis favoritos';

  @override
  String get planSonGiyilenler => 'Usados recientemente';

  @override
  String get izinGerekceKameraBaslik => 'Añade prendas con la cámara';

  @override
  String get izinGerekceKameraAciklama =>
      'Usamos la cámara para añadir tu ropa en fotos. La foto sale de tu dispositivo; el recorte de fondo y el análisis de color/estilo se hacen en nuestro servidor y no se guardan de forma permanente.';

  @override
  String get izinGerekceSimdiDegil => 'Ahora no';

  @override
  String get planOneriler => 'Sugerencias';

  @override
  String get bilgiVerimlilik =>
      'La eficiencia del armario muestra cuántas prendas has lucido al menos una vez. Por encima del 60 % se considera saludable; menos indica prendas sin usar o demasiadas prendas.';

  @override
  String get bilgiStil =>
      'Tu identidad de estilo se calcula a partir de las características más comunes de tu armario: color, categoría y etiquetas de estilo. Las recomendaciones se ordenan con ese perfil.';

  @override
  String get bilgiSeri =>
      'La racha es el número de días seguidos que te has vestido. Cada «me lo puse hoy» la aumenta; saltarte un día la reinicia.';

  @override
  String get bilgiSepet =>
      'El cesto de la ropa contiene las prendas que te has puesto y quieres lavar. No se usan en la siguiente recomendación de look.';

  @override
  String get bilgiRenkPaleti =>
      'Tu paleta de colores muestra la distribución de los cuatro colores más habituales en tu armario. Los tonos parecidos combinan mejor.';

  @override
  String get bilgiKategoriDagilimi =>
      'La distribución por categorías muestra el equilibrio entre partes de arriba, de abajo, calzado y accesorios. Si tienes muchas prendas de una categoría, crear looks cuesta más.';

  @override
  String get bilgiAnlikDurum =>
      'El estado instantáneo te da un consejo breve según el tiempo de tu ciudad y tu armario.';

  @override
  String get bilgiSeriBaslik => 'Racha de uso';

  @override
  String get bilgiKahramanlar =>
      'Los héroes de tu armario son las prendas que más llevas. Las prendas más usadas aparecen en más looks y mantienen tu armario en movimiento.';

  @override
  String get bilgiUnutulanlar =>
      'Las piezas olvidadas son aquellas que nunca has lucido o que llevas mucho tiempo sin usar. Las piezas sin usar pueden revivir con nuevos looks.';

  @override
  String get bilgiBugunKombini =>
      'Tu look del día se elige de tu armario según el tiempo. Se hace como máximo una petición a la IA al día y el resultado se guarda para el día; si la IA no está disponible, mandan las sugerencias por reglas.';

  @override
  String get bilgiRaporHafta =>
      'El número de looks que has registrado en los últimos 7 días. Cada «me lo puse hoy» cuenta como un look; puedes registrar varios el mismo día.';

  @override
  String get bilgiRaporDortHafta =>
      'El número de looks por semana de las últimas 4 semanas. El gráfico muestra tu ritmo semanal y si sube o baja.';

  @override
  String get bilgiRaporEnCokParcalar =>
      'Las prendas que más llevas esta semana. Las prendas más usadas son la base de tu armario.';

  @override
  String get bilgiRaporKullanim =>
      'La parte de tu armario usada en los últimos 7 días. Un valor bajo significa que algunas prendas aún no han entrado en ningún look.';

  @override
  String get bilgiRaporSeri =>
      'El número de días seguidos que te has vestido. Aumenta cada vez que registras un look y se reinicia si se te pasa un día.';

  @override
  String get bilgiRaporHicGiyilmemis =>
      'El número de prendas que no has lucido en los últimos 7 días. Puedes volver a usarlas con nuevos looks.';

  @override
  String get bilgiDueloPuan =>
      'En cada ronda ves dos looks y eliges uno. Acertar da puntos y mantiene la racha; fallar la reinicia. La puntuación sigue reglas: armonía de color, equilibrio de categorías y coherencia de temporada. Si tu armario tiene menos de 4 prendas, se crea una paleta con tus looks anteriores.';

  @override
  String get bilgiDolapCalisma =>
      'Cuando añades una foto, el fondo se recorta automáticamente y la IA lee el color, la categoría, el estilo y la temporada. Tu ropa se queda en el dispositivo; el recorte y el análisis se hacen en nuestro servidor.';

  @override
  String get duzenleArkaPlanBaslik => 'Fondo y colocación';

  @override
  String get duzenleIpucu =>
      'Arrastra la prenda para colocarla y pellizca para cambiar su tamaño.';

  @override
  String get duzenleZeminBeyaz => 'Blanco';

  @override
  String get duzenleZeminKirik => 'Blanco roto';

  @override
  String get duzenleZeminGri => 'Gris claro';

  @override
  String get duzenleZeminSaydam => 'Transparente';

  @override
  String get duzenleKaydet => 'Guardar';

  @override
  String get duzenleVarsayilan => 'Predeterminado';

  @override
  String get arkaPlandaEkle => 'Añadir en segundo plano';

  @override
  String get arkaPlandaEkleAciklama =>
      'Puedes seguir usando la app; tus prendas se añaden en segundo plano.';

  @override
  String arkaPlandaBasladi(int count) {
    return '$count fotos se añaden en segundo plano';
  }

  @override
  String arkaPlandaIlerleme(int count, int toplam) {
    return '$count de $toplam procesados';
  }

  @override
  String arkaPlandaTamamlandi(int count) {
    return '$count prendas añadidas a tu armario';
  }

  @override
  String arkaPlandaBaziAtlandi(int count) {
    return '$count fotos no se pudieron procesar';
  }

  @override
  String get bugunKaydedildi => 'Guardado';

  @override
  String get bugunGiydildi => 'Puesto';

  @override
  String get ozellikYakinda => 'Esta función llegará pronto';

  @override
  String get duelloGeri => 'Atrás';
}
