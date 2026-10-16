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
  String get ayarOtomatikCihazDili => '🌐 Automático (Idioma del dispositivo)';

  @override
  String get iptal => 'Cancelar';

  @override
  String get tamam => 'Aceptar';

  @override
  String get gardirobumTitle => 'MI ARMARIO VIRTUAL';

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
    return '🎨 Combinación: %$puan';
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
      '¡Tu armario está vacío o toda la ropa está en la colada! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Para recibir recomendaciones instantáneas y personalizadas, añade ropa limpia o accesorios a tu armario.';

  @override
  String get stilistUyariUstEksikBaslik => '¡Faltan partes de arriba! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'No tienes partes de arriba limpias en tu armario. ¡Añade al menos una para completar un atuendo!';

  @override
  String get stilistUyariAltEksikBaslik => '¡Faltan partes de abajo! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'No tienes partes de abajo limpias en tu armario. ¡Añade una para crear un conjunto con estilo!';

  @override
  String get stilistUyariAyakkabiEksikBaslik => '¡Falta calzado! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Tu atuendo se ve genial, pero no encontramos calzado limpio para completarlo. ¡Añade un par de zapatos a tu armario!';

  @override
  String get stilistUyariButon => '¡Entendido, añadir!';

  @override
  String get anaHavaYukleniyor => 'Cargando el tiempo en tu ubicación...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK está escuchando... ¡Habla ahora!';

  @override
  String get anaMikrofonHata =>
      'El permiso de micrófono o el servicio de reconocimiento de voz no están listos.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Tu preferencia se actualizó a \"$cinsiyet\" ✨';
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
  String get anaFavoriEklendi => '¡Atuendo añadido a favoritos! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ Advertencia: Has usado estas prendas o unas muy similares con demasiada frecuencia últimamente. ¡Prueba un estilo diferente hoy!';

  @override
  String get anaKombinMukemmel =>
      '✨ ¡Excelente elección! Tu estilo está muy bien equilibrado y fresco hoy.';

  @override
  String get anaYikamaUyariBaslik => 'Alerta de lavado inteligente';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Como usaste este atuendo, las prendas \"$parcalar\" se han utilizado frecuentemente y se han movido automáticamente al cesto de la ropa sucia. 🧺';
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
  String get stilKahveBaslik => '☕ Café y Estilo Informal';

  @override
  String get stilKahveSoru =>
      'Sugiéreme un atuendo informal y con estilo para tomar un café con amigos';

  @override
  String get stilOfisBaslik => '💼 Elegancia para la Oficina';

  @override
  String get stilOfisSoru =>
      'Sugiéreme un atuendo moderno y elegante adecuado para trabajar en oficina';

  @override
  String get stilSporBaslik => '🏃 Estilo Deportivo y Cómodo';

  @override
  String get stilSporSoru =>
      'Sugiéreme un atuendo muy cómodo y deportivo para una salida de fin de semana';

  @override
  String get stilGeceBaslik => '🌙 Salida Nocturna / Evento';

  @override
  String get stilGeceSoru =>
      'Sugiéreme un atuendo audaz para una cena especial o un evento nocturno';

  @override
  String get ilkGorevBaslik => '🎯 Primera Misión: ¡Elige tu estilo!';

  @override
  String get ilkGorevAciklama =>
      'La IA de FitCheck generará un atuendo al instante. ¿A dónde vas hoy?';

  @override
  String get haftalikUyariButon => 'Entendido';

  @override
  String get haftalikUyariDolapBosBaslik => '¡Tu armario está vacío!';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Necesitas añadir ropa a tu armario para crear un plan semanal.';

  @override
  String get haftalikUyariUstEksikBaslik => '¡Faltan partes de arriba!';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'No tienes partes de arriba limpias en tu armario.';

  @override
  String get haftalikUyariAltEksikBaslik => '¡Faltan partes de abajo!';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'No tienes partes de abajo limpias en tu armario.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => '¡Falta calzado!';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'No hay calzado limpio en tu armario.';

  @override
  String get haftalikHata =>
      'Ocurrió un error al crear la planificación semanal.';

  @override
  String get haftalikAjandaTitle => 'PLANIFICADOR DE ESTILO SEMANAL';

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
  String get onboardingHosGeldinBaslik => '¡Bienvenido a FitCheck! ✨';

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
      'Bienvenido de nuevo a tu mundo de estilo ✨';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Únete para guardar y sincronizar tus atuendos 🚀';

  @override
  String get girisYap => 'Iniciar sesión';

  @override
  String get girisYapGoogle => 'Iniciar sesión con Google';

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
  String get kullanimKosullarini => 'los Términos de uso';

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
      'TÉRMINOS DE USO Y CONTRATO DE SERVICIO DE FITCHECK\n\nÚltima actualización: 27 de agosto de 2026\n\nLee atentamente estos Términos de uso (\"Contrato\") antes de utilizar la aplicación móvil FitCheck (\"Aplicación\"). Al descargar, acceder o utilizar la Aplicación, aceptas quedar vinculado por todos los términos de este Contrato.\n\n1. PARTES Y OBJETO\nEste Contrato se celebra entre el desarrollador de la aplicación FitCheck y el usuario individual (\"Usuario\") que descarga y utiliza la Aplicación. La Aplicación ofrece gestión digital de armario, seguimiento de prendas, recomendaciones de atuendos según el clima y asesoría de estilo impulsada por IA.\n\n2. ALCANCE DEL SERVICIO Y CONDICIONES DE USO\n• Límite de edad: Debes tener al menos 13 años para utilizar la Aplicación.\n• Información del usuario: El usuario es responsable de la exactitud del nombre, género, estilo y preferencias de color proporcionadas durante la configuración del perfil.\n• Carácter orientativo: Las puntuaciones de estilo, las sugerencias de compra y los recordatorios de colada proporcionados por la inteligencia artificial son estrictamente orientativos.\n• Datos meteorológicos: Los pronósticos del tiempo se obtienen en función de la ubicación en tiempo real. La Empresa no se hace responsable de discrepancias.\n\n3. PROPIEDAD INTELECTUAL Y DERECHOS DE CONTENIDO\nConservas los derechos de propiedad intelectual sobre las fotos de ropa que subes. El logotipo, diseño, código de software y algoritmos de FitCheck pertenecen exclusivamente a FitCheck.\n\n4. PRIVACIDAD Y SEGURIDAD DE DATOS\nLas fotos que subas y el historial de atuendos se almacenan localmente en tu dispositivo de forma predeterminada. Los datos de ubicación solo se utilizan para consultas meteorológicas en tiempo real.\n\n5. LIMITACIÓN DE RESPONSABILIDAD\nFitCheck no garantiza un servicio ininterrumpido. No se responsabiliza por la pérdida de datos derivada del cambio de dispositivo o la eliminación de la aplicación.\n\n6. CONTACTO\nPara cualquier consulta, ponte en contacto a través de la sección de soporte en Ajustes o en support@fitcheckapp.com.\n\n--- 📜 FIN DEL CONTRATO ---\nPor favor, acepta los términos presionando el botón de abajo.';

  @override
  String chatKarsilama(Object hava) {
    return '¡Hola! 👋 Hoy fuera hace $hava. ¿Creamos un conjunto genial que vaya con tu estilo? ✨';
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
  String get chatOneriYagmur => '🌧️ Atuendo para día lluvioso';

  @override
  String get chatOneriOfis => '💼 Oficina / Elegante casual';

  @override
  String get chatOneriHaftaSonu => '☕ Comodidad de fin de semana';

  @override
  String get chatOneriKirliSepeti => '🧺 Revisar cesto de colada';

  @override
  String get chatDinleniyor => 'Escuchando...';

  @override
  String get chatBirSeylerYazin => 'Escribe un mensaje al asistente...';

  @override
  String get chatKombiniGiydim => 'Me puse este atuendo 👗';

  @override
  String get chatKombinIslendi => '¡Atuendo registrado para hoy! 📅';

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
      '¡Tu cesto de la colada está vacío, toda la ropa está limpia! ✨';

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
  String get gunlukHakBittiBaslik => '¡Límite diario alcanzado!';

  @override
  String get dahaSonra => 'Más tarde';

  @override
  String get reklamIzleHakKazan => 'Ver anuncio (+3 crédito)';

  @override
  String get tebriklerHakEklendi => '¡Enhorabuena! +3 crédito añadido. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Se quitó la marca de atuendo para \"$kombinAdi\".';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '¡\"$kombinAdi\" marcado como usado hoy! 👕✨';
  }

  @override
  String get kiyafetDetayi => 'Detalles de la prenda';

  @override
  String get parcaDetayiBaslik => 'DETALLES DE LA PRENDA';

  @override
  String get farkliParcaSec => 'Elegir otra prenda';

  @override
  String get farkliUstSec => 'Elegir otra parte de arriba 👕';

  @override
  String get farkliAltSec => 'Elegir otra parte de abajo 👖';

  @override
  String get farkliAyakkabiSec => 'Elegir otro calzado 👟';

  @override
  String get farkliDisSec => 'Elegir otra ropa de abrigo 🧥';

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
      'Desliza a la izquierda/derecha para ver las otras prendas 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ ¡He diseñado este atuendo alrededor de $parcaAdi!';
  }

  @override
  String get sihirliDokunus => 'Toque mágico';

  @override
  String get dolabiKaristirEksikUyari =>
      '¡Necesitas al menos 1 parte de arriba, 1 parte de abajo y calzado limpios para mezclar tu armario! 👕👖👟';

  @override
  String get zarlarAtildiYorumu =>
      '🎲 ¡Dados lanzados! Has descubierto una combinación totalmente nueva y sorprendente.';

  @override
  String get rastgeleKombinTuru => 'Aleatorio';

  @override
  String get temizAlternatifYok =>
      '¡No quedan alternativas limpias en esta categoría! 🧺';

  @override
  String get kisiselDokunus => 'Toque personal';

  @override
  String get aiYeniParcaAnalizEdiyor =>
      'La IA está analizando la nueva prenda... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ ¡Cambiar de prenda ha creado un excelente equilibrio general!';

  @override
  String get parcaDegisimHataYorum =>
      '✨ ¡Cambiar de prenda adaptó este atuendo completamente a tu estilo!';

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
  String get zarPopupBaslik => '¡Agita los dados mágicos!';

  @override
  String get zarPopupAciklama =>
      'Agita el teléfono o pulsa el botón de abajo para lanzar los dados y crear conjuntos aleatorios con tu armario.';

  @override
  String get zarlariAt => 'Lanzar los dados';

  @override
  String get zarSalla => 'Agitar dados';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Desliza o toca prendas para cambiar 👈👉';

  @override
  String get favorilerdeEtiketi => 'En Favoritos';

  @override
  String get bugunGiydildiEtiketi => 'Puesto hoy ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      '¡Excelente elección! Las prendas se complementan muy bien en tono y equilibrio.';

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
      '¡El atuendo se ve fantástico! Analiza con la IA y guarda.';

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
  String get gecmisBasariylaTemizlendi => 'Historial borrado con éxito 🗑️';

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
      '¡El cesto está completamente vacío, toda la ropa está limpia!';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Toda la ropa se lavó y volvió al armario 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'Marcar todo como limpio';

  @override
  String get profilVeAnalizTitle => 'Perfil y Análisis';

  @override
  String get harikaGidiyorsun => '¡Lo estás haciendo genial!';

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
  String get googleHesabiBaglandi =>
      '¡Cuenta de Google vinculada con éxito! 🔗';

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
    return '¡Correo para restablecer contraseña enviado a $eposta! ✉️';
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
      '¡Caché de imágenes y archivos temporales borrados! ✨';

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
      'No se encontraron datos del armario para exportar. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      '¡Todos los datos del armario se copiaron al portapapeles en formato JSON! 📋';

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
      'Última actualización: 27 de agosto de 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Recopilación y uso de datos';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck procesa información para optimizar la gestión de tu armario y las recomendaciones de atuendos. Las fotos, el estilo y las preferencias de género se almacenan localmente en tu dispositivo.';

  @override
  String get gizlilikMadde2Baslik => '2. Permisos de ubicación';

  @override
  String get gizlilikMadde2Icerik =>
      'La ubicación en tiempo real se procesa de forma anónima a través de los servicios de Open-Meteo únicamente para consultar las condiciones meteorológicas. Los datos de ubicación nunca se almacenan en servidores ni se comparten con terceros.';

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
      'Introduce tu código de cupón a continuación para obtener créditos extra:';

  @override
  String get kuponKoduHint => 'Ej: VIP2026';

  @override
  String get kuponKullanButon => 'Canjear';

  @override
  String get kuponBasariliMesaji =>
      '🎉 ¡Cupón aplicado con éxito! Créditos cargados.';

  @override
  String get kuponKullanilmisUyari =>
      '⚠️ ¡Ya has canjeado este código de cupón!';

  @override
  String get kuponGecersizUyari =>
      '❌ ¡Código de cupón no válido! Inténtalo de nuevo.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Créditos ilimitados 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Créditos restantes: $hak ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      'Disfruta de generaciones de atuendos y análisis de estilo ilimitados con ventajas premium.';

  @override
  String get gunlukHakAciklama =>
      'Los créditos diarios se reinician todos los días a las 00:00. Puedes ver anuncios o usar cupones para ganar más créditos.';

  @override
  String get kuponKullan => 'Usar cupón';

  @override
  String get hakEklendiTebrikler => '¡Enhorabuena! +3 crédito añadido. ✨';

  @override
  String get gardirobunDolduTitle => '¡Armario lleno!';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return 'Has alcanzado el límite de $limit prendas. ¿Quieres ver un vídeo corto para ampliar la capacidad de tu armario en +3 prendas? 👕';
  }

  @override
  String get reklamIzleSlotEkle => 'Ver anuncio (+3 espacios)';

  @override
  String get yeniSlotEklendiTebrikler =>
      '¡Enhorabuena! +3 nuevos espacios añadidos al armario. 🎉';

  @override
  String get gunlukHakBittiTitle => '¡Límite diario alcanzado!';

  @override
  String get gunlukHakBittiIcerik =>
      'Has agotado tus operaciones diarias gratuitas. ¡Mira un vídeo corto o introduce un código de cupón para obtener nuevos créditos! 🛍️';

  @override
  String get kuponGir => 'Introducir cupón';

  @override
  String get anaSemsiyeBildirimBaslik => '¡No olvides tu paraguas! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Parece que hoy va a llover, no olvides elegir un atuendo adecuado para el tiempo húmedo.';

  @override
  String get anaCamasirGunuBildirimBaslik => '¡Día de colada! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Se ha acumulado ropa sucia en tu cesto. ¡Es hora de poner una lavadora!';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ ¿Qué puedo ponerme con esta prenda? ($parca)';
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
  String get rehberAnladimBasla => '¡Entendido, empezar!';

  @override
  String get rehberSonrakiAdim => 'Siguiente paso ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik => '📸 Digitaliza tu armario';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Toca este botón para tomar fotos o subirlas desde tu galería y crear tu armario digital.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ Asistente de estilo por voz';

  @override
  String get rehberSesliAsistanAciklama =>
      'Usa comandos de voz para preguntar qué ponerte o recibir recomendaciones instantáneas.';

  @override
  String get rehberAiStilistBaslik => '✨ Recomendaciones con IA';

  @override
  String get rehberAiStilistAciklama =>
      'Obtén recomendaciones a medida según el clima, tono de piel y preferencias con un solo toque.';

  @override
  String get rehberAyarlarBaslik => '⚙️ Personalización y Ajustes';

  @override
  String get rehberAyarlarAciklama =>
      'Personaliza género, tono de piel, color y tema o vuelve a ver la guía de inicio.';

  @override
  String get rehberNavGardirobumBaslik => '👔 Mi armario';

  @override
  String get rehberNavGardirobumAciklama =>
      'Consulta, filtra y gestiona toda tu ropa de forma clara por categorías.';

  @override
  String get rehberNavHaftalikBaslik => '📅 Planificador semanal';

  @override
  String get rehberNavHaftalikAciklama =>
      'Planifica tus atuendos diarios con antelación según el pronóstico para 7 días.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 Atuendos IA con tu ropa';

  @override
  String get rehberNavDolaptanAciklama =>
      'Deja que la IA genere combinaciones automáticas con tu ropa actual según las condiciones diarias.';

  @override
  String get rehberNavKendiBaslik => '🎨 Crear atuendo personalizado';

  @override
  String get rehberNavKendiAciklama =>
      'Mezcla y combina partes de arriba, de abajo y calzado manualmente para crear y guardar tu propio estilo.';

  @override
  String get rehberNavProfilBaslik => '📊 Estadísticas y Colada';

  @override
  String get rehberNavProfilAciklama =>
      'Revisa estadísticas de uso de tu ropa y controla prendas pendientes en el cesto.';

  @override
  String get bildirimIzinGerekliBaslik => 'Permiso de notificaciones requerido';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Recomendamos activar las notificaciones para recibir recordatorios de colada, alertas de lluvia y consejos diarios.';

  @override
  String get bildirimGunaydinBaslik => '¡Buenos días! ☀️';

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
  String get gardirobumBosBaslik => '¡Tu armario está muy vacío!';

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
      '¡Enhorabuena, nuevo crédito de conjunto obtenido!';

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
      'Aún no se han añadido prendas. ¡Añade ahora!';

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
    return '¡Analicemos juntos tu conjunto «$kombin»! Pregúntame lo que quieras sobre la armonía de colores, el clima o prendas alternativas. ✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 ¿Por qué combina bien este conjunto?';

  @override
  String get kombinSohbetOneriAlternatif => '👟 Sugiere una prenda alternativa';

  @override
  String get kombinSohbetOneriHava => '🌦️ ¿Y si cambia el clima?';

  @override
  String get kombinSohbetOneriAksesuar => '💍 Dame ideas de accesorios';

  @override
  String get kombinSohbetAltBaslikAnlik =>
      'Charla sobre tu conjunto del momento';

  @override
  String get chatKirliSepetiBos =>
      '🧺 ¡Tu cesto de colada está vacío! Todas tus prendas están listas para usar: puedo prepararte un conjunto cuando quieras. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 Tienes **$sayi** prendas esperando en el cesto de colada:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Estas prendas no se incluirán en tus conjuntos hasta que se laven. Si quieres, puedo prepararte ahora mismo un look con tus prendas limpias.';

  @override
  String get analitikVerileriPaylas => 'Compartir datos de análisis';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Se envían datos de uso anónimos para mejorar la experiencia de la app. Si lo desactivas, se eliminan los datos de análisis de este dispositivo.';

  @override
  String get chatKarsilamaHavaYok =>
      '¡Hola! 👋 ¿Creamos un conjunto genial que vaya con tu estilo? ✨';

  @override
  String get premiumBaslik => 'Uso mensual sin anuncios';

  @override
  String get premiumAciklama =>
      'Disfruta de FitCheck sin anuncios. Se eliminan todos los anuncios mientras tu suscripción esté activa.';

  @override
  String get premiumOzellikReklamsiz => 'Se eliminan todos los anuncios';

  @override
  String get premiumOzellikAylik => 'Se renueva automáticamente cada mes';

  @override
  String get premiumOzellikMagaza => 'Se gestiona a través de Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium está activo. Los anuncios están desactivados para tu cuenta.';

  @override
  String get premiumAboneOl => 'Suscríbete mensualmente';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Suscríbete mensualmente • $fiyat';
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
  String get premiumAylikBaslik => 'Premium mensual sin anuncios';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Elimina los anuncios por $fiyat al mes';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Hazte Premium • $fiyat/mes';
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
      'Taba / Turuncu tonları ile renk çarkında tam zıt konumda yer alan ve güçlü bir kontrast oluşturan renk hangisidir?';

  @override
  String get triviaQ1o1 => 'Saks Mavisi / Petrol Mavisi';

  @override
  String get triviaQ1o2 => 'Zümrüt Yeşili';

  @override
  String get triviaQ1o3 => 'Bordo';

  @override
  String get triviaQ1o4 => 'Hardal Sarısı';

  @override
  String get triviaQ2 =>
      'Modada \'Monokrom\' (Monochromatic) giyim tarzı ne anlama gelir?';

  @override
  String get triviaQ2o1 =>
      'Tek bir rengin farklı tonlarını bir arada kullanmak';

  @override
  String get triviaQ2o2 => 'Sadece siyah ve beyaz kıyafetler giyinmek';

  @override
  String get triviaQ2o3 => 'En az 3 zıt rengi aynı anda harmanlamak';

  @override
  String get triviaQ2o4 => 'Sadece desenli ve baskılı parçaları eşleştirmek';

  @override
  String get triviaQ3 =>
      'Altın (Gold) takıların, kiremit ve zeytin yeşili gibi tonların en çok yakıştığı cilt alt tonu hangisidir?';

  @override
  String get triviaQ3o1 => 'Soğuk (Cool) Alt Ton';

  @override
  String get triviaQ3o2 => 'Sıcak (Warm) Alt Ton';

  @override
  String get triviaQ3o3 => 'Mavi Alt Ton';

  @override
  String get triviaQ3o4 => 'Pembe Alt Ton';

  @override
  String get triviaQ4 =>
      'Kapsül gardırop oluştururken her renkle kolayca eşleşen \'Nötr Renkler\' grubunda hangisi YER ALMAZ?';

  @override
  String get triviaQ4o1 => 'Bej / Krem';

  @override
  String get triviaQ4o2 => 'Lacivert';

  @override
  String get triviaQ4o3 => 'Flaş (Neon) Sarı';

  @override
  String get triviaQ4o4 => 'Taba / Kahverengi';

  @override
  String get triviaQ5 =>
      'Renk çarkında yan yana duran ve yumuşak, göz yormayan bir geçiş sağlayan renk grubuna ne ad verilir?';

  @override
  String get triviaQ5o1 => 'Tamamlayıcı (Zıt) Renkler';

  @override
  String get triviaQ5o2 => 'Analog Renkler';

  @override
  String get triviaQ5o3 => 'Pastel Renkler';

  @override
  String get triviaQ5o4 => 'Triadik Renkler';

  @override
  String get triviaQ6 =>
      'Modada vücut oranını daha uzun ve dengeli göstermek için uygulanan \'Üçte Bir Kuralı\' (Rule of Thirds) hangisidir?';

  @override
  String get triviaQ6o1 => '1/2 Üst - 1/2 Alt (Gövde ve bacak eşit)';

  @override
  String get triviaQ6o2 => '1/3 Üst - 2/3 Alt (Yüksek bel / Kısa üst)';

  @override
  String get triviaQ6o3 => '2/3 Üst - 1/3 Alt (Uzun tunik / Kısa alt)';

  @override
  String get triviaQ6o4 => '3/3 Tam boy tek parça';

  @override
  String get triviaQ7 =>
      'Fransızca moda terimi olan \'Ton-sür-ton\' giyim tekniği neyi ifade eder?';

  @override
  String get triviaQ7o1 =>
      'Aynı rengin farklı doygunluk ve açık/koyu nüanslarını katmanlamak';

  @override
  String get triviaQ7o2 => 'Tamamen zıt iki rengi keskin hatlarla birleştirmek';

  @override
  String get triviaQ7o3 => 'Siyah ve beyaz desenleri karıştırmak';

  @override
  String get triviaQ7o4 => 'Farklı kumaş dokularını tek renkte toplamak';

  @override
  String get triviaQ8 =>
      'Klasik ve formal giyim kurallarına göre, deri kemer rengi hangisiyle birebir eşleşmelidir?';

  @override
  String get triviaQ8o1 => 'Kravat veya Şal';

  @override
  String get triviaQ8o2 => 'Gömlek';

  @override
  String get triviaQ8o3 => 'Ayakkabı';

  @override
  String get triviaQ8o4 => 'Ceket Astarı';

  @override
  String get triviaQ9 =>
      'Renk çarkında eşit uzaklıktaki 3 rengin (Ör: Kırmızı, Sarı, Mavi) oluşturduğu canlı kombin tarzına ne denir?';

  @override
  String get triviaQ9o1 => 'Triadik (Üçlü) Renk Uyumu';

  @override
  String get triviaQ9o2 => 'Nötr Uyum';

  @override
  String get triviaQ9o3 => 'Monokrom Uyum';

  @override
  String get triviaQ9o4 => 'Kapsül Geçiş';

  @override
  String get triviaQ10 =>
      'Ten rengine (Nude) veya giyilen pantolonun rengine tam uyan bir ayakkabı seçmek nasıl bir görsel etki yaratır?';

  @override
  String get triviaQ10o1 => 'Bacak boyunu kesintisiz ve daha uzun gösterir';

  @override
  String get triviaQ10o2 => 'Vücudu daha geniş gösterir';

  @override
  String get triviaQ10o3 => 'Omuz genişliğini öne çıkarır';

  @override
  String get triviaQ10o4 => 'Boyu olduğundan kısa gösterir';

  @override
  String get kombinOyunuBaslik => 'Juego de Combinaciones';

  @override
  String get kombinMevcutKombin => 'Mevcut Kombin';

  @override
  String get kombinParcaUst => 'Üst';

  @override
  String get kombinParcaAlt => 'Alt';

  @override
  String get kombinEksik_ayakkabi => 'Eksik: Ayakkabı';

  @override
  String get kombinEksik_ceket => 'Eksik: Ceket';

  @override
  String get kombinEksik_aksesuar => 'Eksik: Aksesuar';

  @override
  String get kombinSoru_ayakkabi => 'Hangi ayakkabı en uygun?';

  @override
  String get kombinSoru_ceket => 'Hangi ceket en uygun?';

  @override
  String get kombinSoru_aksesuar => 'Hangi aksesuar en uygun?';

  @override
  String get kombinKategoriAyakkabi => 'Ayakkabı';

  @override
  String get kombinKategoriCeket => 'Ceket';

  @override
  String get kombinKategoriAksesuar => 'Aksesuar';

  @override
  String get kombinOrtamOfis => 'Ofis';

  @override
  String get kombinOrtamCasual => 'Casual';

  @override
  String get kombinOrtamDavet => 'Davet';

  @override
  String get kombinOrtamSpor => 'Spor';

  @override
  String get kombinHavaGunesli => 'Güneşli';

  @override
  String get kombinHavaYagmurlu => 'Yağmurlu';

  @override
  String get kombinHavaSoguk => 'Soğuk';

  @override
  String get kombinHavaSicak => 'Sıcak';

  @override
  String get kombinRenkBeyaz => 'Beyaz';

  @override
  String get kombinRenkSiyah => 'Siyah';

  @override
  String get kombinRenkKahverengi => 'Kahverengi';

  @override
  String get kombinRenkLacivert => 'Lacivert';

  @override
  String get kombinRenkBej => 'Bej';

  @override
  String get kombinRenkKoyuYesil => 'Koyu Yeşil';

  @override
  String get kombinRenkNude => 'Nude';

  @override
  String get kombinRenkAltin => 'Altın';

  @override
  String get kombinRenkGri => 'Gri';

  @override
  String get kombinRenkPastelMavi => 'Pastel Mavi';

  @override
  String get kombinRenkKirmizi => 'Kırmızı';

  @override
  String get kombinRenkMavi => 'Mavi';

  @override
  String get kombinRenkGumus => 'Gümüş';

  @override
  String get kombinRenkKoyuMavi => 'Koyu Mavi';

  @override
  String get kombinRenkKamel => 'Kamel';

  @override
  String get kombinRenkYesil => 'Yeşil';

  @override
  String get kombinRenkAcikMavi => 'Açık Mavi';

  @override
  String get kombinRenkNavy => 'Navy';

  @override
  String get kombinSecenekKahverengiOxford => 'Kahverengi Deri Oxford';

  @override
  String get kombinSecenekSiyahDerby => 'Siyah Deri Derby';

  @override
  String get kombinSecenekBeyazSpor => 'Beyaz Spor Ayakkabı';

  @override
  String get kombinSecenekKahverengiCizme => 'Kahverengi Çizme';

  @override
  String get kombinSecenekSiyahSuGecirmezBot => 'Siyah Su Geçirmez Bot';

  @override
  String get kombinSecenekNudeBallerina => 'Nude Ballerina';

  @override
  String get kombinSecenekAltinSandalet => 'Altın Sandalet';

  @override
  String get kombinSecenekSiyahBlazer => 'Siyah Blazer';

  @override
  String get kombinSecenekKirmiziDeriCeket => 'Kırmızı Deri Ceket';

  @override
  String get kombinSecenekAltinDetayliCeket => 'Altın Detaylı Ceket';

  @override
  String get kombinSecenekBeyazPufy => 'Beyaz Pufy Ceket';

  @override
  String get kombinSecenekBeyazKosu => 'Beyaz Koşu Ayakkabısı';

  @override
  String get kombinSecenekSiyahBasketbol => 'Siyah Basketbol Ayakkabısı';

  @override
  String get kombinSecenekMaviTerlik => 'Mavi Terlik';

  @override
  String get kombinSecenekKahverengiLoafer => 'Kahverengi Loafer';

  @override
  String get kombinSecenekBeyazBespan => 'Beyaz Beşpan';

  @override
  String get kombinSecenekSiyahGunes => 'Siyah Güneş Gözlüğü';

  @override
  String get kombinSecenekSiyahSirtCantasi => 'Siyah Sırt Çantası';

  @override
  String get kombinSecenekGumusAkilliSaat => 'Gümüş Akıllı Saat';

  @override
  String get kombinSecenekKamelCifteYaka => 'Kamel Renkli Çifte Yaka';

  @override
  String get kombinSecenekSiyahBomber => 'Siyah Bomber';

  @override
  String get kombinSecenekKirmiziPufy => 'Kırmızı Pufy';

  @override
  String get kombinSecenekYesilDenim => 'Yeşil Denim Ceket';

  @override
  String get kombinSecenekKahverengiKemer => 'Kahverengi Kemer';

  @override
  String get kombinSecenekSiyahKemer => 'Siyah Kemer';

  @override
  String get kombinSecenekNavyBlokSal => 'Navy Blok Şal';

  @override
  String get kombinSecenekKahverengiGozluk => 'Kahverengi Gözlük';

  @override
  String get kombinSecenekGriSuGecirmez => 'Gri Su Geçirmez Koşu';

  @override
  String get kombinSecenekKahverengiTrekking => 'Kahverengi Trekking Botu';

  @override
  String get kombinSecenekSiyahTerlik => 'Siyah Terlik';

  @override
  String get kombinSecenekBeyazTenis => 'Beyaz Tenis Ayakkabısı';

  @override
  String get kombinOyunBitti => 'Oyun Bitti';

  @override
  String get kombinToplamPuan => 'Toplam Puan';

  @override
  String get kombinBasariOrani => 'Başarı Oranı';

  @override
  String get kombinTekrarOyna => 'Tekrar Oyna';

  @override
  String get kombinAnaSayfa => 'Ana Sayfa';

  @override
  String get kombinSonucUsta => 'Stil Ustası! 🏆';

  @override
  String get kombinSonucUstaMesaj => 'Renk ve uyum hissini ödüllemeye değer!';

  @override
  String get kombinSonucIyi => 'İyi Gidiyorsun! 👍';

  @override
  String get kombinSonucIyiMesaj => 'Az pratikle mükemmel olacaksın.';

  @override
  String get kombinSonucPratik => 'Pratik Lazım 📚';

  @override
  String get kombinSonucPratikMesaj =>
      'Renk teorisi ipuçları için \"Analiz\" sekmesine bak.';

  @override
  String get degerlendirmeBaslik => '¿Te gusta FitCheck?';

  @override
  String get degerlendirmeIcerik =>
      'Si te encanta la aplicación, ¿podrías dedicar 5 segundos a dejarnos una reseña? ¡Las reseñas pequeñas son una gran ayuda! ⭐ ¡Los revisores reciben +3 créditos gratis como regalo!';

  @override
  String get degerlendirmeEvet => 'Sí, lo evaluaré';

  @override
  String get degerlendirmeBelkiSonra => 'Quizás más tarde';

  @override
  String get yakinda => 'Próximamente';

  @override
  String get yakindaAciklama =>
      'Estamos trabajando en esta función, ¡muy pronto estará disponible!';

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
  String get dilSecimBaslik => '🌐 Seleccionar idioma';

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
}
