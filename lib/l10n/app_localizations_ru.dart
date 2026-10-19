// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get chatOrtamCasual => 'Повседневный';

  @override
  String get chatOrtamOfis => 'Офис';

  @override
  String get chatOrtamDavet => 'Вечеринка';

  @override
  String get chatOrtamSpor => 'Спорт';

  @override
  String get chatOrtamGece => 'Вечер';

  @override
  String get chatOrtamRomantik => 'Романтичный';

  @override
  String get chatOrtamHaftaSonu => 'Выходные';

  @override
  String get gardirobumAdimArkaplan => 'Удаление фона';

  @override
  String get gardirobumAdimArkaplanAlt => 'Анализ изображения с помощью ИИ';

  @override
  String get gardirobumAdimAnaliz => 'Анализ одежды';

  @override
  String get gardirobumAdimAnalizAlt => 'Определение цвета, стиля и категории';

  @override
  String get gardirobumAdimKaydet => 'Сохранение';

  @override
  String get gardirobumAdimKaydetAlt => 'Добавление в гардероб';

  @override
  String get gardirobumLutfenBekleyin => 'Пожалуйста, подождите...';

  @override
  String get authHataZayifSifre =>
      'Пароль слишком простой. Он должен содержать не менее 6 символов.';

  @override
  String get authHataEpostaKullanimda =>
      'Этот адрес электронной почты уже используется.';

  @override
  String get authHataGecersizEposta =>
      'Вы ввели неверный адрес электронной почты.';

  @override
  String get authHataKullaniciBulunamadi =>
      'Пользователь с таким адресом электронной почты не найден.';

  @override
  String get authHataYanlisSifre => 'Неверный пароль, попробуйте снова.';

  @override
  String get authHataGecersizKimlik =>
      'Неверная электронная почта или пароль. Проверьте данные.';

  @override
  String get authHataYontemIzinliDegil =>
      'Этот способ входа не включён в консоли Firebase.';

  @override
  String get authHataFarkliYontem =>
      'Эта почта уже зарегистрирована с другим способом входа.';

  @override
  String get authHataAgHatasi =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get authHataCokDeneme => 'Слишком много попыток. Попробуйте позже.';

  @override
  String get authHataHesapDevreDisi => 'Эта учётная запись отключена.';

  @override
  String get authHataYenidenGiris => 'Для этого действия нужно войти снова.';

  @override
  String get authHataGenel => 'Произошла ошибка. Попробуйте снова.';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'Не удалось отправить письмо для сброса пароля. Попробуйте снова.';

  @override
  String get authHataGoogleDogrulanamadi =>
      'Не удалось проверить вход через Google. Попробуйте снова.';

  @override
  String get authHataGoogleFarkliKullanici =>
      'Этот аккаунт Google привязан к другому пользователю.';

  @override
  String get authHataGoogleZatenBagli => 'Этот аккаунт Google уже привязан.';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'Вход через Google не настроен на этом устройстве. Сообщите в поддержку.';

  @override
  String get authHataGooglePencereAcik =>
      'Окно входа в Google всё ещё открыто. Подождите несколько секунд.';

  @override
  String get authHataGoogleTamamlanamadi =>
      'Не удалось завершить вход через Google. Попробуйте через несколько секунд.';

  @override
  String get authHataGoogleHesapSec => 'Чтобы войти, выберите аккаунт Google.';

  @override
  String get authHataGoogleOnayBekliyor =>
      'В вашем аккаунте Google есть незавершённое действие. Попробуйте снова.';

  @override
  String get authHataGoogleBeklenmeyen =>
      'При входе через Google произошла непредвиденная ошибка.';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => 'Внешний вид и тема';

  @override
  String get karanlikMod => 'Тёмная тема';

  @override
  String get koyuTemaAktif => 'Тёмная тема включена';

  @override
  String get acikTemaAktif => 'Светлая тема включена';

  @override
  String get dilAyarlari => 'Настройки языка и региона';

  @override
  String get uygulamaDili => 'Язык приложения';

  @override
  String get hakkinda => 'О приложении';

  @override
  String get surum => 'Версия';

  @override
  String get ayarOtomatikCihazDili => '🌐 Автоматически (язык устройства)';

  @override
  String get iptal => 'Отмена';

  @override
  String get tamam => 'ОК';

  @override
  String get gardirobumTitle => 'ВИРТУАЛЬНЫЙ ГАРДЕРОБ';

  @override
  String get gardirobumYukleniyor => 'ИИ анализирует...';

  @override
  String get gardirobumTopluEkle => 'Добавить несколько вещей';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return 'Анализ ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'Очистить гардероб';

  @override
  String get gardirobumTemizleOnay =>
      'Все вещи из вашего гардероба будут удалены. Вы уверены?';

  @override
  String get gardirobumEvet => 'Да, очистить всё';

  @override
  String get gardirobumHataMesaji => 'Произошла ошибка при добавлении вещей.';

  @override
  String get gardirobumKategoriTumu => 'Все';

  @override
  String get gardirobumKategoriUst => 'Верх';

  @override
  String get gardirobumKategoriAlt => 'Низ';

  @override
  String get gardirobumKategoriAyakkabi => 'Обувь';

  @override
  String get gardirobumKategoriAksesuar => 'Аксессуары';

  @override
  String get gardirobumBosKategori => 'В этой категории ничего не найдено.';

  @override
  String get gardirobumGiymeSayisi => 'Надето:';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'Стоимость: ₺$tutar / образ';
  }

  @override
  String get gardirobumDolabaAl => 'Вернуть в гардероб';

  @override
  String get gardirobumSepeteAt => 'Отправить в корзину для белья';

  @override
  String get gardirobumSepetteRozet => 'В СТИРКЕ';

  @override
  String get gardirobumGecersizParcaBaslik => 'Обнаружен неподходящий предмет';

  @override
  String get gardirobumGecersizParcaIcerik =>
      'Наша система не обнаружила одежду, обувь или аксессуары на этом изображении (обнаружена деревянная вещь, мебель или посторонний предмет). Пожалуйста, загружайте только элементы гардероба.';

  @override
  String get gardirobumTamam => 'ОК';

  @override
  String get stilistTitle => 'МГНОВЕННЫЙ ИИ-СТИЛИСТ';

  @override
  String get gunlukKombinTitle => 'DNEVNOY OBRAZ';

  @override
  String get gunlukKombinHazirBaslik => 'Готовы к образу?';

  @override
  String get gunlukKombinHazirIcerik =>
      'Бросьте кости или встряхните телефон, чтобы создать образ дня.';

  @override
  String get gunlukKombinKartBaslik => 'Образ дня';

  @override
  String get stilistAnlikHavaDurumu =>
      'Текущая погода (нажмите для обновления)';

  @override
  String get stilistKonumKontrol => 'Проверка геопозиции...';

  @override
  String get stilistNereyeGidiyorsun => 'Куда вы собираетесь?';

  @override
  String get stilistDusunuyor => 'Стилист думает...';

  @override
  String get stilistBugunNeGiymeliyim => 'Что мне надеть сегодня?';

  @override
  String get stilistKombiniTemizle => 'Сбросить образ';

  @override
  String stilistKombininTitle(Object ortam) {
    return 'Ваш образ: $ortam';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 Гармония: %$puan';
  }

  @override
  String get stilistUstGiyim => 'Верх';

  @override
  String get stilistAltGiyim => 'Низ';

  @override
  String get stilistAyakkabi => 'Обувь';

  @override
  String get stilistAksesuar => 'Аксессуары';

  @override
  String get stilistFavoriyeEkle => 'Добавить в избранное';

  @override
  String get stilistBugunGiydim => 'Надето сегодня';

  @override
  String get bugunGiydimOnayIcerik => 'Ты надевал(а) этот образ сегодня?';

  @override
  String get stilistTrendyolTamamla => 'Найти на Trendyol';

  @override
  String get stilistHata => 'Произошла ошибка при создании образа.';

  @override
  String get ortamCasual => 'Повседневный / Кэжуал';

  @override
  String get ortamOfis => 'Офис / Работа';

  @override
  String get ortamDavet => 'Свадьба / Мероприятие';

  @override
  String get ortamSpor => 'Спорт / Тренировка';

  @override
  String get ortamGece => 'Вечеринка / Ночной выход';

  @override
  String get ortamRomantik => 'Романтическое свидание';

  @override
  String get stilistUyariDolapBosBaslik =>
      'Ваш гардероб пуст или все вещи в стирке! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Чтобы получать персональные рекомендации, добавьте чистую одежду или аксессуары в ваш шкаф.';

  @override
  String get stilistUyariUstEksikBaslik => 'Не хватает верха! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'В вашем гардеробе нет чистой плечевой одежды. Добавьте хотя бы один верх, чтобы составить образ!';

  @override
  String get stilistUyariAltEksikBaslik => 'Не хватает низа! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'У вас нет чистых брюк или юбок. Добавьте низ для создания стильного лука!';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Не хватает обуви! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Образ отличный, но мы не нашли чистую обувь. Добавьте пару прямо сейчас!';

  @override
  String get stilistUyariButon => 'Понятно, добавлю!';

  @override
  String get anaHavaYukleniyor => 'Загрузка погоды...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK слушает... Говорите!';

  @override
  String get anaMikrofonHata =>
      'Доступ к микрофону или служба распознавания речи не готовы.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Ваши настройки обновлены: \"$cinsiyet\" ✨';
  }

  @override
  String get anaKonumKapaliBaslik => 'Служба геолокации отключена';

  @override
  String get anaKonumKapaliIcerik =>
      'Включите GPS, чтобы получать рекомендации с учётом текущей погоды.';

  @override
  String get anaKonumuAc => 'Включить геолокацию';

  @override
  String get anaIzinVer => 'Разрешить';

  @override
  String get anaIptal => 'Отмена';

  @override
  String get anaKonumIzinRedBaslik => 'В доступе к геолокации отказано';

  @override
  String get anaKonumIzinRedIcerik1 =>
      'Не удалось получить данные о погоде из-за отсутствия разрешения.';

  @override
  String get anaKonumIzinRedIcerik2 =>
      'Вам необходимо предоставить разрешение в системных настройках.';

  @override
  String get anaKonumIzinGerekliBaslik => 'Требуется доступ к геолокации';

  @override
  String get anaKonumIzinGerekliIcerik =>
      'Включите разрешение на геолокацию в настройках для загрузки прогноза погоды.';

  @override
  String get anaHavaDurumuAlinamadi => 'Данные о погоде недоступны';

  @override
  String get anaHavaTahminiYuklenemedi =>
      'Не удалось загрузить прогноз погоды.';

  @override
  String get anaFavoriEklendi => 'Образ добавлен в избранное! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ Внимание: Вы очень часто носили эти вещи в последнее время. Попробуйте другой стиль сегодня!';

  @override
  String get anaKombinMukemmel =>
      '✨ Отличный выбор! Ваш образ сегодня идеально сбалансирован.';

  @override
  String get anaYikamaUyariBaslik => 'Умное уведомление о стирке';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Так как вы надевали этот образ, часто используемые вещи \"$parcalar\" автоматически отправлены в корзину для белья! 🧺';
  }

  @override
  String get anaTamam => 'ОК';

  @override
  String get anaAyarlarTooltip => 'Настройки';

  @override
  String get anaKadin => 'Женский';

  @override
  String get anaErkek => 'Мужской';

  @override
  String get anaSesleKonus => 'Голосовая команда';

  @override
  String get anaStilistAsistani => 'Ассистент-стилист';

  @override
  String get anaSekmeGardirop => 'Гардероб';

  @override
  String get anaSekmeHaftalik => 'План на неделю';

  @override
  String get anaSekmeAnlik => 'Экспресс';

  @override
  String get anaSekmeYarismasi => 'Викторина';

  @override
  String get anaSekmeProfil => 'Профиль и аналитика';

  @override
  String get modaYarismasiBaslik => 'Мода и цвет';

  @override
  String get modaYarismasiGunlukTamamlandi => 'Викторина на сегодня завершена';

  @override
  String get modaYarismasiYeniYarin =>
      'Новый набор из 5 вопросов будет завтра.';

  @override
  String get modaYarismasiSonuc => 'Результат';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'Счёт: $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return 'Вопрос $index / 10';
  }

  @override
  String get modaYarismasiGeri => 'Назад';

  @override
  String get modaYarismasiAnaEkrana => 'Вернуться домой';

  @override
  String get havaParcaliBulutlu => 'Облачно с прояснениями';

  @override
  String get havaSicakGunesli => 'Жарко и солнечно';

  @override
  String get havaSogukKarli => 'Холодно, снег';

  @override
  String get havaYagmurlu => 'Дождь';

  @override
  String get havaGunesli => 'Солнечно';

  @override
  String get havaSoguk => 'Прохладно';

  @override
  String get gunPzt => 'Понедельник';

  @override
  String get gunSal => 'Вторник';

  @override
  String get gunCar => 'Среда';

  @override
  String get gunPer => 'Четверг';

  @override
  String get gunCum => 'Пятница';

  @override
  String get gunCmt => 'Суббота';

  @override
  String get gunPaz => 'Воскресенье';

  @override
  String get stilKahveBaslik => '☕ Кофе и повседневный стиль';

  @override
  String get stilKahveSoru =>
      'Предложи удобный и стильный образ для встречи с друзьями за кофе';

  @override
  String get stilOfisBaslik => '💼 Офис и деловой стиль';

  @override
  String get stilOfisSoru =>
      'Подбери элегантный и современный образ для работы в офисе';

  @override
  String get stilSporBaslik => '🏃 Спорт и комфорт';

  @override
  String get stilSporSoru =>
      'Составь максимально комфортный спортивный лук для прогулки на выходных';

  @override
  String get stilGeceBaslik => '🌙 Вечерний выход';

  @override
  String get stilGeceSoru =>
      'Предложи эффектный образ для романтического ужина или особых случаев';

  @override
  String get ilkGorevBaslik => '🎯 Первый шаг: Выберите ваш стиль!';

  @override
  String get ilkGorevAciklama =>
      'FitCheck ИИ моментально составит для вас образ. Куда вы отправляетесь сегодня?';

  @override
  String get haftalikUyariButon => 'Понятно';

  @override
  String get haftalikUyariDolapBosBaslik => 'Ваш гардероб пуст!';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Вам необходимо добавить одежду в шкаф, чтобы спланировать неделю.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Не хватает верха!';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'В вашем гардеробе нет чистой плечевой одежды.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Не хватает низа!';

  @override
  String get haftalikUyariAltEksikIcerik => 'У вас нет чистой поясной одежды.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Не хватает обуви!';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'В гардеробе отсутствует чистая обувь.';

  @override
  String get haftalikHata =>
      'Произошла ошибка при составлении недельного плана.';

  @override
  String get haftalikAjandaTitle => 'НЕДЕЛЬНЫЙ ПЛАНИРОВЩИК СТИЛЯ';

  @override
  String get haftalikAnlikHavaDurumu => 'Прогноз погоды на неделю';

  @override
  String get haftalikKonumKontrol => 'Загрузка погоды...';

  @override
  String get haftalikTemizParca => 'Чистые вещи';

  @override
  String get haftalikSepette => 'В стирке';

  @override
  String get haftalikPlanAciklama =>
      'Доверьте ИИ составление образов на 7 дней с учётом погоды.';

  @override
  String get haftalikProgramOlustur => 'Создать план на неделю';

  @override
  String get haftalikPlaniTemizle => 'Очистить план';

  @override
  String get haftalikAnalizEdiliyor => 'ИИ планирует...';

  @override
  String get haftalikUyum => 'Гармония';

  @override
  String get haftalikFavoriEkle => 'Добавить в избранное';

  @override
  String get haftalikGiyildiIsaretle => 'Надето сегодня';

  @override
  String get haftalikHava => 'Погода:';

  @override
  String get haftalikHavaUyarisi =>
      'Примечание: некоторые вещи этого образа изменены с учётом погоды этого дня.';

  @override
  String get haftalikUyumsuzParca => 'Нехватающий элемент';

  @override
  String get haftalikEksikParcaStilistNotu =>
      'Стилист учёл недостающую вещь и составил рекомендации из имеющейся чистой одежды.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'Недостаточно чистых вещей, чтобы заполнить этот день. Добавьте новую вещь или постирайте одежду — стилист предложит здесь новый образ.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'Идея образа от ИИ';

  @override
  String get haftalikEksikParcaOneriYok =>
      'Обнови план, чтобы увидеть сочетание верха, низа и обуви, дополняющее недостающую вещь.';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'Образ от ИИ-стилиста';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor =>
      'Стилист готовит предложение образа…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'Без верха и низа образ не собрать. Стилист подготовил предложение выше.';

  @override
  String get haftalikNot => 'Заметка';

  @override
  String get haftalikTrendyolAra => 'Искать на Trendyol';

  @override
  String get izinZorunluMesaj =>
      'Эти разрешения необходимы для полноценной работы приложения.';

  @override
  String get izinGerekliBaslik => 'Требуются разрешения';

  @override
  String get izinGerekliIcerik =>
      'Доступ к камере и геолокации был отклонён. Включите их в настройках.';

  @override
  String get ayarlaraGit => 'Перейти в настройки';

  @override
  String get izinAnaBaslik => 'Необходимые разрешения';

  @override
  String get izinAciklama =>
      'Для подбора лучших образов нам необходим доступ к геолокации (погода) и камере (фотографии).';

  @override
  String get konumIzni => 'Доступ к геолокации';

  @override
  String get kameraIzni => 'Доступ к камере';

  @override
  String get izinVerDevamEt => 'Разрешить и продолжить';

  @override
  String get gunlukHavaMevcutDegil => 'Данные о погоде недоступны';

  @override
  String get profilAnalizTitle => 'ПРОФИЛЬ И АНАЛИТИКА';

  @override
  String get anlikDurum => 'Текущий статус';

  @override
  String get toplamParca => 'Всего вещей';

  @override
  String get favoriKombin => 'Любимый образ';

  @override
  String get gardiropDegeri => 'Стоимость гардероба';

  @override
  String get ortalamaMaliyet => 'Средняя стоимость носки';

  @override
  String get kategoriDagilimi => 'Распределение по категориям';

  @override
  String get ustGiyim => 'Верх';

  @override
  String get altGiyim => 'Низ';

  @override
  String get ayakkabi => 'Обувь';

  @override
  String get disGiyim => 'Верхняя одежда';

  @override
  String get aksesuar => 'Аксессуары';

  @override
  String get sonGiyecekGecmisi => 'История последних образов';

  @override
  String get kayit => 'Запись';

  @override
  String get gecmisKombinYok => 'История образов пока пуста.';

  @override
  String get parca => 'предм.';

  @override
  String get onboardingHosGeldinBaslik => 'Добро пожаловать в FitCheck! ✨';

  @override
  String get onboardingDolabiniDijitallestir => 'Оцифруйте свой гардероб';

  @override
  String get onboardingDolapAciklama =>
      'Добавляйте вещи за пару секунд и создайте виртуальный шкаф.';

  @override
  String get onboardingHavaDurumu => 'Адаптация к погоде';

  @override
  String get onboardingHavaAciklama =>
      'Получайте рекомендации одежды, идеально подходящие под погоду за окном.';

  @override
  String get onboardingYikama => 'Умное отслеживание стирки';

  @override
  String get onboardingYikamaAciklama =>
      'Приложение автоматически определяет часто надеваемые вещи и отправляет их в бельевую корзину.';

  @override
  String get onboardingEksikParca => 'Советы по покупкам';

  @override
  String get onboardingEksikAciklama =>
      'Узнайте, каких базовых вещей не хватает для завершения идеального образа.';

  @override
  String get onboardingAnalitik => 'Продвинутая аналитика';

  @override
  String get onboardingAnalitikAciklama =>
      'Оценивайте общую стоимость шкафа, цену одного выхода и свои стилистические предпочтения.';

  @override
  String get onboardingStilist => 'ИИ-ассистент стилиста';

  @override
  String get onboardingStilistAciklama =>
      'Просто скажите, куда собираетесь, и ИИ подготовит идеальный лук за секунды.';

  @override
  String get onboardingAtla => 'Пропустить';

  @override
  String get onboardingModaProfiliniz => 'Ваш модный профиль';

  @override
  String get onboardingKadin => 'Женский';

  @override
  String get onboardingErkek => 'Мужской';

  @override
  String get onboardingBasla => 'Начать';

  @override
  String get onboardingDevamEt => 'Продолжить';

  @override
  String get cinsiyetBaslik => 'ПОЛ';

  @override
  String get tarzBaslik => 'ПОВСЕДНЕВНЫЙ СТИЛЬ (МОЖНО НЕСКОЛЬКО)';

  @override
  String get renkTercihiBaslik => 'ПРЕДПОЧТЕНИЯ ПО ЦВЕТУ';

  @override
  String get tenRengiBaslik => 'ЦВЕТОТИП И ТОН КОЖИ';

  @override
  String get kadin => 'Женский';

  @override
  String get erkek => 'Мужской';

  @override
  String get cinsiyetBelirtilmemis => 'Не указано';

  @override
  String get tarzSpor => 'Спортивный';

  @override
  String get tarzKlasik => 'Классический';

  @override
  String get tarzSokakModasi => 'Уличный стиль (Streetwear)';

  @override
  String get tarzMinimalist => 'Минимализм';

  @override
  String get renkKoyuTonlar => 'Тёмные тона';

  @override
  String get renkPastel => 'Пастельные цвета';

  @override
  String get renkCanli => 'Яркие цвета';

  @override
  String get renkNotr => 'Нейтральные тона';

  @override
  String get tenAcikBeyaz => 'Светлый / Очень светлый';

  @override
  String get tenBugday => 'Средний / Бежевый';

  @override
  String get tenEsmerKoyu => 'Смуглый / Тёмный';

  @override
  String get hesabinizaGirisYapin => 'Вход в аккаунт';

  @override
  String get yeniHesapOlusturun => 'Создать новый аккаунт';

  @override
  String get stilDunyanaTekrarHosGeldin => 'С возвращением в ваш модный мир ✨';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Присоединяйтесь, чтобы сохранять и синхронизировать образы 🚀';

  @override
  String get girisYap => 'Войти';

  @override
  String get girisYapGoogle => 'Войти через Google';

  @override
  String get girisBeniHatirla => 'Запомнить меня';

  @override
  String get girisVeya => 'или';

  @override
  String get kayitOl => 'Зарегистрироваться';

  @override
  String get adinizVeyaLakabiniz => 'Ваше имя или никнейм';

  @override
  String get epostaAdresiniz => 'Электронная почта';

  @override
  String get sifreniz => 'Пароль';

  @override
  String get girisYapVeBasla => 'Войти и начать';

  @override
  String get kayitOlVeBasla => 'Зарегистрироваться и начать';

  @override
  String get misafirOlarakDevamEt => 'Продолжить как гость';

  @override
  String get lutfenEpostaVeSifreGiriniz =>
      'Пожалуйста, введите email и пароль.';

  @override
  String get lutfenAdiniziGiriniz => 'Пожалуйста, введите ваше имя.';

  @override
  String get kullanimKosullariBaslik =>
      'Условия использования и пользовательское соглашение';

  @override
  String get onaylamakIcinKaydirin =>
      'Прокрутите до конца, чтобы принять условия';

  @override
  String get okudumAnladimKabulEdiyorum => 'Я прочитал(а), понял(а) и принимаю';

  @override
  String get kullanimKosullarini => 'условия использования';

  @override
  String get okudumVeOnayliyorum => '.';

  @override
  String get onaylamadanOnceKosullariOkuyun =>
      'Пожалуйста, ознакомьтесь с условиями перед принятием.';

  @override
  String get devamEtmekIcinKosullariKabulEdin =>
      'Вам необходимо принять условия для продолжения.';

  @override
  String get kullanimKosullariMetni =>
      'ПОЛЬЗОВАТЕЛЬСКОЕ СОГЛАШЕНИЕ И УСЛОВИЯ ИСПОЛЬЗОВАНИЯ FITCHECK\n\nПоследнее обновление: 27 августа 2026 г.\n\nПожалуйста, внимательно прочитайте настоящие условия («Соглашение») перед использованием мобильного приложения FitCheck («Приложение»). Загружая, открывая или используя Приложение, вы соглашаетесь соблюдать все условия данного Соглашения.\n\n1. СТОРОНЫ И ПРЕДМЕТ\nНастоящее Соглашение заключено между разработчиком FitCheck и индивидуальным пользователем («Пользователь»). Приложение предоставляет цифровое управление гардеробом, отслеживание вещей, подбор одежды по погоде и персональные рекомендации стилиста на базе ИИ.\n\n2. ОБЪЕМ УСЛУГ И УСЛОВИЯ ИСПОЛЬЗОВАНИЯ\n• Возрастное ограничение: Вам должно быть не менее 13 лет для использования Приложения.\n• Данные пользователя: Пользователь несет ответственность за точность имени, пола, стиля и предпочтений, указанных в профиле.\n• Рекомендательный характер: Оценки стиля, советы по покупкам и напоминания о стирке носят исключительно рекомендательный характер.\n• Погодные данные: Прогноз погоды определяется на основе геопозиции в реальном времени. Разработчик не несет ответственности за возможные расхождения.\n\n3. ИНТЕЛЛЕКТУАЛЬНАЯ СОБСТВЕННОСТЬ\nВы сохраняете права на загруженные фотографии одежды. Логотип FitCheck, дизайн, код и алгоритмы полностью принадлежат FitCheck.\n\n4. КОНФИДЕНЦИАЛЬНОСТЬ И БЕЗОПАСНОСТЬ\nЗагруженные фотографии и история образов по умолчанию хранятся локально на вашем устройстве.\n\n5. ОГРАНИЧЕНИЕ ОТВЕТСТВЕННОСТИ\nFitCheck не гарантирует бесперебойную работу и не несет ответственности за утерю данных при смене устройства.\n\n6. КОНТАКТЫ\nПо вопросам обращайтесь через раздел контактов в настройках или по адресу support@fitcheckapp.com.\n\n--- 📜 КОНЕЦ СОГЛАШЕНИЯ ---\nНажмите кнопку ниже, чтобы принять условия.';

  @override
  String chatKarsilama(Object hava) {
    return 'Привет! 👋 Сегодня на улице $hava. Соберём отличный образ в твоём стиле? ✨';
  }

  @override
  String get chatGorselGonderildi => 'Изображение отправлено.';

  @override
  String get chatAsistanSohbeti => 'Чат с ассистентом';

  @override
  String get chatModHavaDuyarli => 'Умные советы по стилю с учётом погоды';

  @override
  String get chatStilistHazirliyor => 'Стилист подбирает образ...';

  @override
  String get chatGorselEklendi => 'Изображение прикреплено';

  @override
  String get chatTekrarDene => 'Повторить';

  @override
  String get chatKamera => 'Камера';

  @override
  String get chatGaleri => 'Выбрать изображение из галереи';

  @override
  String get chatMikrofon => 'Микрофон';

  @override
  String get chatGonder => 'Отправить сообщение';

  @override
  String get chatOneriYagmur => '🌧️ Образ для дождливого дня';

  @override
  String get chatOneriOfis => '💼 Офис / Смарт-кэжуал';

  @override
  String get chatOneriHaftaSonu => '☕ Уютный выходной';

  @override
  String get chatOneriKirliSepeti => '🧺 Проверка корзины с бельём';

  @override
  String get chatDinleniyor => 'Слушаю...';

  @override
  String get chatBirSeylerYazin => 'Напишите сообщение ассистенту...';

  @override
  String get chatKombiniGiydim => 'Я надел(а) этот образ 👗';

  @override
  String get chatKombinIslendi => 'Образ сохранён на сегодня! 📅';

  @override
  String get chatGorselIncele => 'Посмотри на фото и предложи образ.';

  @override
  String get profilAyarlariBaslik => 'НАСТРОЙКИ ПРОФИЛЯ';

  @override
  String get cinsiyetTercihiBaslik => 'Предпочтение по полу';

  @override
  String get stilAramaHint =>
      'Например: \'Смарт-кэжуал с чёрным пиджаком\', \'Летнее платье\'...';

  @override
  String get stilFiltreTumu => 'Все вещи';

  @override
  String get stilFiltreSadeceTemizler => 'Только чистые';

  @override
  String get stilFiltreSadeceSepet => 'Только в стирке';

  @override
  String get profilFavoriKombinlerTitle => 'Мои любимые образы';

  @override
  String get profilFavoriKombinYok => 'Любимые образы пока не добавлены.';

  @override
  String get profilYikamaSepetimTitle => 'Корзина для белья';

  @override
  String get profilYikamaSepetimBos =>
      'Корзина пуста, вся ваша одежда чистая! ✨';

  @override
  String get profilSepetiBosalt => 'Очистить корзину';

  @override
  String get profilSepetiBosaltOnay =>
      'Все вещи будут отмечены как чистые. Подтверждаете?';

  @override
  String get profilSepetiBosaltButon => 'Да, всё постирано';

  @override
  String get profilTenRengi => 'Тон кожи / Цветотип';

  @override
  String get profilTarzTercihi => 'Предпочитаемый стиль';

  @override
  String get profilRenkPaleti => 'Любимая палитра цветов';

  @override
  String get rehberGardiropEkleTitle => 'Добавить фото';

  @override
  String get rehberGardiropEkleDesc =>
      'Делайте снимки или загружайте фото одежды поштучно или списком.';

  @override
  String get rehberAiStilistTitle => 'ИИ-ассистент стилиста';

  @override
  String get rehberAiStilistDesc =>
      'Запрашивайте у ИИ персональные луки и советы по стилю.';

  @override
  String get rehberSesliTitle => 'Голосовое управление';

  @override
  String get rehberSesliDesc =>
      'Просто скажите вслух, чтобы получить рекомендации без рук.';

  @override
  String get rehberAyarlarTitle => 'Настройки и профиль';

  @override
  String get rehberAyarlarDesc =>
      'Обновляйте ваши настройки пола, стиля и тона кожи.';

  @override
  String get rehberGardiropNavTitle => 'Мой гардероб';

  @override
  String get rehberGardiropNavDesc =>
      'Просматривайте всю вашу одежду, удобно отсортированную по категориям.';

  @override
  String get rehberHaftalikNavTitle => 'Планировщик на неделю';

  @override
  String get rehberHaftalikNavDesc =>
      'Планируйте образы на 7 дней вперед на основе прогноза погоды.';

  @override
  String get rehberDolaptanNavTitle => 'Генератор образов ИИ';

  @override
  String get rehberDolaptanNavDesc =>
      'Создавайте автоматические комбинации из ваших вещей с помощью ИИ.';

  @override
  String get rehberKendiNavTitle => 'Свой конструктор образов';

  @override
  String get rehberKendiNavDesc =>
      'Сочетайте верх, низ и обувь вручную для создания собственного стиля.';

  @override
  String get rehberProfilNavTitle => 'Профиль и аналитика';

  @override
  String get rehberProfilNavDesc =>
      'Отслеживайте окупаемость одежды и управляйте корзиной белья.';

  @override
  String get simdilikAtla => 'Пока пропустить';

  @override
  String get uygulamaIzinleri => 'Разрешения приложения';

  @override
  String get izinEkraniAciklama =>
      'FitCheck нужны эти разрешения для точного подбора одежды и уведомлений о погоде/стирке.';

  @override
  String get konumIzniAciklama =>
      'Для подбора вещей по погоде в режиме реального времени';

  @override
  String get kameraIzniAciklama =>
      'Чтобы фотографировать одежду и добавлять её в ваш шкаф';

  @override
  String get bildirimIzni => 'Разрешение на уведомления';

  @override
  String get bildirimIzniAciklama =>
      'Для напоминаний о стирке и погодных предупреждений';

  @override
  String get izinleriVerVeBasla => 'Предоставить доступ и начать';

  @override
  String get dahaSonraAyarla => 'Настроить позже';

  @override
  String get gunlukHakBittiBaslik => 'Дневной лимит исчерпан!';

  @override
  String get dahaSonra => 'Позже';

  @override
  String get reklamIzleHakKazan => 'Смотреть рекламу (+3 попытка)';

  @override
  String get tebriklerHakEklendi => 'Поздравляем! +3 попытка добавлена. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Отметка снята для образа \"$kombinAdi\".';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\" $kombinAdi\" отмечен как надето сегодня! 👕✨';
  }

  @override
  String get kiyafetDetayi => 'Детали одежды';

  @override
  String get parcaDetayiBaslik => 'ДЕТАЛИ ПРЕДМЕТА';

  @override
  String get farkliParcaSec => 'Выбрать другую вещь';

  @override
  String get farkliUstSec => 'Выбрать другой верх 👕';

  @override
  String get farkliAltSec => 'Выбрать другой низ 👖';

  @override
  String get farkliAyakkabiSec => 'Выбрать другую обувь 👟';

  @override
  String get farkliDisSec => 'Выбрать другую верхнюю одежду 🧥';

  @override
  String get baskaTemizKiyafetYok =>
      'В этой категории нет другой чистой одежды\nдля замены.';

  @override
  String get planiYenile => 'Обновить план';

  @override
  String get havaEtiketi => 'ПОГОДА';

  @override
  String get yukleniyor => 'Загрузка...';

  @override
  String get temizle => 'Очистить';

  @override
  String get yenidenDegerlendiriliyor => 'Переоценка...';

  @override
  String get kombinParcalariBaslik => 'ЭЛЕМЕНТЫ ОБРАЗА';

  @override
  String get parcalariKaydirIpucu =>
      'Смахните влево/вправо для просмотра других вещей 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ Я создал этот образ вокруг вещи: $parcaAdi!';
  }

  @override
  String get sihirliDokunus => 'Магический микс';

  @override
  String get dolabiKaristirEksikUyari =>
      'Чтобы перемешать гардероб, нужно иметь хотя бы 1 чистый Верх, 1 Низ и 1 пару Обуви! 👕👖👟';

  @override
  String get zarlarAtildiYorumu =>
      '🎲 Кубики брошены! Вы открыли неожиданное и стильное сочетание.';

  @override
  String get rastgeleKombinTuru => 'Случайный микс';

  @override
  String get temizAlternatifYok =>
      'В этой категории больше нет чистых альтернатив! 🧺';

  @override
  String get kisiselDokunus => 'Персональный штрих';

  @override
  String get aiYeniParcaAnalizEdiyor => 'ИИ анализирует новую вещь... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ Замена этих вещей создала прекрасную общую гармонию!';

  @override
  String get parcaDegisimHataYorum =>
      '✨ Замена элементов идеально адаптировала образ под ваш стиль!';

  @override
  String get bilgileriDuzenleBaslik => 'Редактировать данные';

  @override
  String get kiyafetAdiEtiketi => 'Название вещи';

  @override
  String get renkEtiketi => 'Цвет';

  @override
  String get kaydet => 'Сохранить';

  @override
  String get yenidenZarAt => 'Бросить кубики снова';

  @override
  String get zarAtKaristir => 'Бросить кубики (Перемешать)';

  @override
  String get zarPopupBaslik => 'Встряхни волшебные кубики!';

  @override
  String get zarPopupAciklama =>
      'Встряхни телефон или нажми кнопку ниже, чтобы бросить кубики и получить случайные образы из своего гардероба.';

  @override
  String get zarlariAt => 'Бросить кубики';

  @override
  String get zarSalla => 'Встряхнуть кубики';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Смахните или нажмите на вещь для замены 👈👉';

  @override
  String get favorilerdeEtiketi => 'В избранном';

  @override
  String get bugunGiydildiEtiketi => 'Надето сегодня ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Отличный выбор! Эти вещи замечательно сочетаются по тону и стилю.';

  @override
  String get kendiTasarimimBaslik => 'Мой собственный образ';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return 'Выбрать $kategori';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'Соберите свой образ';

  @override
  String get secimleriSifirla => 'Сбросить выбор';

  @override
  String get kombinHazirAiTavsiyesi =>
      'Образ выглядит потрясающе! Оцените с помощью ИИ и сохраните.';

  @override
  String get kombinBaslaIpucu =>
      'Что бы вы хотели надеть сегодня? Начните с выбора вещей.';

  @override
  String get ustAltModu => 'Верх + Низ';

  @override
  String get tekParcaElbiseModu => 'Цельный образ (Платье/Комбинезон)';

  @override
  String get tekParcaElbise => 'Цельный образ / Платье';

  @override
  String get aksesuarOpsiyonel => 'Аксессуары (Опционально)';

  @override
  String get stilistAnaliziBaslik => 'АНАЛИЗ СТИЛИСТА';

  @override
  String get stilistDegerlendiriyor => 'Стилист оценивает...';

  @override
  String get aiIleAnalizEtKaydet => 'Оценить ИИ и сохранить';

  @override
  String get bilinmiyor => 'Неизвестно';

  @override
  String get karmasikSiklik => 'Изысканная элегантность';

  @override
  String get gecmisiTemizleTitle => 'Очистить историю';

  @override
  String get gecmisiTemizleOnayIcerik =>
      'Вы уверены, что хотите удалить всю историю образов? Это действие необратимо.';

  @override
  String get gecmisBasariylaTemizlendi => 'История успешно очищена 🗑️';

  @override
  String get kayitGecmistenSilindi => 'Запись удалена из истории.';

  @override
  String get kombin => 'Образ';

  @override
  String get kombinDetayiUst => 'ДЕТАЛИ ОБРАЗА';

  @override
  String get giyilenParcalarUst => 'НАДЕТЫЕ ВЕЩИ';

  @override
  String get detayBulunamadi => 'Детали не найдены.';

  @override
  String get henuzFavoriEklemediniz =>
      'Вы ещё не добавляли образы в избранное.';

  @override
  String get camasirSepetiTitle => 'Корзина для белья';

  @override
  String get sepetBosTumKiyafetlerTemiz => 'Корзина пуста, вся одежда чистая!';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Вся одежда постирана и возвращена в гардероб 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'Отметить всё как чистые';

  @override
  String get profilVeAnalizTitle => 'Профиль и аналитика';

  @override
  String get harikaGidiyorsun => 'Вы отлично справляетесь!';

  @override
  String gundurSeridesin(Object gun) {
    return 'Серия $gun дней подряд';
  }

  @override
  String get tumuTemiz => 'Всё чистое';

  @override
  String kirliParcaSayisi(Object sayi) {
    return 'В стирке: $sayi предм.';
  }

  @override
  String get stilKimligin => 'Ваш стилистический профиль';

  @override
  String get dolapVerimliligi => 'Эффективность гардероба';

  @override
  String get renkPaletin => 'Ваша цветовая палитра';

  @override
  String get dolabinKahramanlari => 'Главные вещи гардероба';

  @override
  String get derinlerdeUnutulanlar => 'Забытые вещи';

  @override
  String get sonGiyilenler => 'Недавно надевавшиеся';

  @override
  String get tumunuTemizle => 'Очистить всё';

  @override
  String get henuzGecmisKaydiYok => 'Записей в истории пока нет.';

  @override
  String kezGiyildi(Object sayi) {
    return 'Надето $sayi раз(а)';
  }

  @override
  String get ayarlarTitle => 'Настройки';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'АККАУНТ И БЕЗОПАСНОСТЬ';

  @override
  String get kullaniciHesabi => 'Аккаунт пользователя';

  @override
  String get misafirKullanici => 'Гостевой пользователь';

  @override
  String get epostaDogrulanmis => 'Email подтверждён';

  @override
  String get esitlemekIcinGirisYapin =>
      'Войдите для синхронизации между устройствами.';

  @override
  String get cikisYapTitle => 'Выйти из аккаунта';

  @override
  String get cikisYapOnayIcerik => 'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get bagliHesaplarUst => 'ПРИВЯЗАННЫЕ АККАУНТЫ';

  @override
  String get googleHesabiBagli => 'Аккаунт Google привязан';

  @override
  String get googleHesabiniBagla => 'Привязать аккаунт Google';

  @override
  String get googleHesabiBaglandi => 'Успешно привязан аккаунт Google! 🔗';

  @override
  String get googleHesabiBaglantisiKesildi => 'Аккаунт Google отвязан.';

  @override
  String get sifreVeGuvenlik => 'Пароль и безопасность';

  @override
  String get sifreYenilemeBaglantisiIste => 'Запросить ссылку на сброс';

  @override
  String get sifremiUnuttum => 'Забыли пароль?';

  @override
  String get sifreDegistirTitle => 'Изменить пароль';

  @override
  String get sifreSifirlamaAciklama =>
      'Ссылка для сброса пароля будет отправлена на почту, привязанную к аккаунту:';

  @override
  String get epostaAdresi => 'Адрес электронной почты';

  @override
  String get gecerliBirEpostaGiriniz =>
      'Введите корректный адрес электронной почты';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return 'Письмо со ссылкой отправлено на $eposta! ✉️';
  }

  @override
  String get baglantiGonder => 'Отправить ссылку';

  @override
  String get hesabiKaliciSilTitle => 'Удалить аккаунт навсегда';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'Это действие необратимо. Все данные вашего гардероба и профиля будут удалены безвозвратно.';

  @override
  String get hesabiSilOnayKoduMetni =>
      'Введите \"fitcheck\" ниже для подтверждения:';

  @override
  String get vazgec => 'Отмена';

  @override
  String get hesabimiSil => 'Удалить мой аккаунт';

  @override
  String get hesabinizSilindi => 'Ваш аккаунт и данные были удалены.';

  @override
  String get kisiselStilVeProfilUst => 'ПЕРСОНАЛЬНЫЙ СТИЛЬ И ПРОФИЛЬ';

  @override
  String get stilVeTarzTercihleri => 'Предпочтения по стилю и крою';

  @override
  String get secili => 'Выбрано';

  @override
  String get tenRengiTercihinizUst => 'НАСТРОЙКА ТОНА КОЖИ';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'ИИ И ТОЧНОСТЬ СТИЛЯ';

  @override
  String get stilistKisiligiVeYantitTarziUst =>
      'ХАРАКТЕР СТИЛИСТА И СТИЛЬ ОТВЕТА';

  @override
  String get aiKisilikSamimiBaslik => 'Дружелюбный / Добрая подруга';

  @override
  String get aiKisilikSamimiAciklama =>
      'Теплый, поддерживающий тон, делающий моду простой и увлекательной';

  @override
  String get aiKisilikElestirmenBaslik => 'Профессиональный критик моды';

  @override
  String get aiKisilikElestirmenAciklama =>
      'Технические советы, сфокусированные на теории цвета и пропорциях';

  @override
  String get aiKisilikMinimalistBaslik => 'Минималистичный и прямой';

  @override
  String get aiKisilikMinimalistAciklama =>
      'Лаконичные и точные рекомендации без лишних слов';

  @override
  String get sikiRenkTeorisiUyumModu => 'Строгий режим теории цвета';

  @override
  String get sikiRenkTeorisiAciklama =>
      'При включении ИИ соблюдает исключительно классические правила сочетания цветов';

  @override
  String get bildirimlerVeHatirlaticiUst => 'УВЕДОМЛЕНИЯ И НАПОМИНАНИЯ';

  @override
  String get sabahKombinOnerisi => 'Утренний подбор лука';

  @override
  String herSabahBildirimAl(Object saat) {
    return 'Получать уведомление каждый день в $saat';
  }

  @override
  String get bildirimSaatiniOzellestir => 'Настроить время уведомления';

  @override
  String get gunlukKombinBildirimSaati => 'Время ежедневного уведомления';

  @override
  String get sabahBildirimSaatiSec => 'Выбрать время утреннего уведомления';

  @override
  String get saatKaydedildiAksama =>
      'Время сохранено, но служба уведомлений недоступна.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return 'Утреннее уведомление установлено на $saat. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari =>
      'Включите уведомления в настройках устройства, чтобы продолжить.';

  @override
  String get camasirSepetiUyarilari => 'Уведомления бельевой корзины';

  @override
  String get camasirSepetiUyarilariAciklama =>
      'Получать напоминания, когда накопилось много грязного белья';

  @override
  String get haftalikStilRaporu => 'Еженедельный отчет по стилю';

  @override
  String get haftalikStilRaporuAciklama =>
      'Получать сводку по использованию гардероба каждое воскресенье вечером';

  @override
  String get gorunumVeBolgeUst => 'ВНЕШНИЙ ВИД И РЕГИОН';

  @override
  String get lokasyonVeBirimlerUst => 'МЕСТОПОЛОЖЕНИЕ И ЕДИНИЦЫ';

  @override
  String get sicaklikBirimi => 'Единица температуры';

  @override
  String get varsayilanSehirBolge => 'Город / Регион по умолчанию';

  @override
  String get sehirOrnekHint => 'Например: Москва, Санкт-Петербург, Казань';

  @override
  String get gpsKullan => 'Использовать GPS';

  @override
  String get veriVeDepolamaYonetimiUst => 'УПРАВЛЕНИЕ ДАННЫМИ И ПАМЯТЬЮ';

  @override
  String get gorselOnbelleginiTemizle => 'Очистить кэш изображений';

  @override
  String get geciciFotografHafizasiAciklama =>
      'Освобождает временную память, выделенную под фотографии';

  @override
  String get onbellekTemizlendiBasari =>
      'Кэш изображений и временные файлы успешно очищены! ✨';

  @override
  String get onbellekTemizlerkenHata => 'Произошла ошибка при очистке кэша.';

  @override
  String get gardirobuDisaAktarYedekle => 'Экспорт гардероба (Резервная копия)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Экспортировать все данные о вещах и образах в формате JSON';

  @override
  String get disaAktarilacakVeriYok =>
      'Не найдено данных гардероба для экспорта. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      'Все данные гардероба скопированы в буфер обмена в формате JSON! 📋';

  @override
  String get destekVeDegerlendirmeUst => 'ПОДДЕРЖКА И ОЦЕНКА';

  @override
  String get uygulamayiDegerlendirin => 'Оценить приложение';

  @override
  String get googlePlay5YildizDestek =>
      'Поддержите нас 5 звёздами в Google Play ⭐';

  @override
  String get googlePlayAcilamadi => 'Не удалось открыть Google Play.';

  @override
  String get geriBildirimVeDestek => 'Обратная связь и поддержка';

  @override
  String get hataBildirVeyaOneri =>
      'Сообщить об ошибке или предложить новую функцию';

  @override
  String get islemTamamlanamadi =>
      'Не удалось завершить операцию. Попробуйте снова.';

  @override
  String get epostaUygulamasiAcilamadi =>
      'Не удалось открыть почтовый клиент. Напишите нам на ayberkzcn9@gmail.com.';

  @override
  String get gizlilikPolitikasiTitle => 'Политика конфиденциальности';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'Просмотр правил использования данных и прав конфиденциальности';

  @override
  String get sonGuncellemeTarihi => 'Последнее обновление: 27 августа 2026 г.';

  @override
  String get gizlilikMadde1Baslik => '1. Сбор и использование данных';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck обрабатывает информацию для оптимизации вашего гардероба и подбора образов. Ваши фото, стиль и пол хранятся локально на вашем устройстве.';

  @override
  String get gizlilikMadde2Baslik => '2. Доступ к геолокации';

  @override
  String get gizlilikMadde2Icerik =>
      'Геопозиция обрабатывается анонимно через сервисы Open-Meteo исключительно для получения текущей погоды. Данные не сохраняются и не передаются.';

  @override
  String get gizlilikMadde3Baslik => '3. Голосовой ассистент и микрофон';

  @override
  String get gizlilikMadde3Icerik =>
      'При использовании голосового управления ваши слова моментально преобразуются в текст. Аудиозаписи не сохраняются.';

  @override
  String get gizlilikMadde4Baslik => '4. Сторонние сервисы';

  @override
  String get gizlilikMadde4Icerik =>
      'Инфраструктура Firebase и Google AdMob используется для аналитики производительности и показа рекламы.';

  @override
  String get anladim => 'Понятно';

  @override
  String get stilVeModaTercihleriniz => 'Предпочтения стиля и моды';

  @override
  String get stilModalAciklama =>
      'ИИ будет отдавать приоритет этим параметрам стиля и кроя при подборе луков.';

  @override
  String get favoriTarzinizUst => 'ПРЕДПОЧТИТЕЛЬНЫЙ СТИЛЬ';

  @override
  String get giyimKesimiFitUst => 'КРОЙ И ПОСАДКА ОДЕЖДЫ';

  @override
  String get hesapSilmeUst => 'УДАЛЕНИЕ АККАУНТА';

  @override
  String get tumBulutVeYerelVeriTemizlenir =>
      'Удаляет все ваши локальные и облачные данные';

  @override
  String get hakkindaUst => 'О ПРИЛОЖЕНИИ';

  @override
  String get topluFotografEkleTooltip => 'Массовое добавление одежды';

  @override
  String get kuponKoduKullanTitle => 'Использовать промокод';

  @override
  String get kuponKoduAciklama =>
      'Введите промокод ниже, чтобы получить дополнительные попытки подбора образов:';

  @override
  String get kuponKoduHint => 'Например: VIP2026';

  @override
  String get kuponKullanButon => 'Применить';

  @override
  String get kuponBasariliMesaji =>
      '🎉 Промокод успешно применён! Попытки добавлены.';

  @override
  String get kuponKullanilmisUyari => '⚠️ Вы уже использовали этот промокод!';

  @override
  String get kuponGecersizUyari =>
      '❌ Недействительный промокод! Попробуйте ещё раз.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Безлимитный доступ 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Осталось попыток: $hak ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      'Пользуйтесь безлимитным генератором образов и анализом стиля с премиум-преимуществами.';

  @override
  String get gunlukHakAciklama =>
      'Ежедневные попытки обновляются каждые сутки в 00:00. Вы можете смотреть рекламу или вводить промокоды для получения дополнительных попыток.';

  @override
  String get kuponKullan => 'Ввести промокод';

  @override
  String get hakEklendiTebrikler => 'Поздравляем! +3 попытка добавлена. ✨';

  @override
  String get gardirobunDolduTitle => 'Гардероб полон!';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return 'Вы достигли лимита в $limit вещей. Посмотреть короткую рекламу, чтобы расширить гардероб ещё на +3 слотов? 👕';
  }

  @override
  String get reklamIzleSlotEkle => 'Смотреть рекламу (+3 слотов)';

  @override
  String get yeniSlotEklendiTebrikler =>
      'Поздравляем! В ваш гардероб добавлено +3 новых слотов. 🎉';

  @override
  String get gunlukHakBittiTitle => 'Дневной лимит исчерпан!';

  @override
  String get gunlukHakBittiIcerik =>
      'Вы использовали бесплатные попытки на сегодня. Посмотрите видео или введите промокод, чтобы получить новые! 🛍️';

  @override
  String get kuponGir => 'Ввести код';

  @override
  String get anaSemsiyeBildirimBaslik => 'Не забудьте зонт! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Сегодня ожидается дождь, не забудьте выбрать непромокаемую одежду.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'День стирки! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'В корзине накопилось много вещей. Самое время запустить стиральную машину!';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ Что мне надеть с этой вещью? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'Ваш образ готов ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'Посмотреть образ';

  @override
  String get chatStilistKombinTasarlayor => 'Стилист моделирует образ...';

  @override
  String get chatStilistYaziyor => 'Стилист пишет...';

  @override
  String get pazartesi => 'Понедельник';

  @override
  String get sali => 'Вторник';

  @override
  String get carsamba => 'Среда';

  @override
  String get persembe => 'Четверг';

  @override
  String get cuma => 'Пятница';

  @override
  String get cumartesi => 'Суббота';

  @override
  String get pazar => 'Воскресенье';

  @override
  String get rehberiAtla => 'ПРОПУСТИТЬ ОБУЧЕНИЕ';

  @override
  String get rehberAnladimBasla => 'Понятно, начнём!';

  @override
  String get rehberSonrakiAdim => 'Следующий шаг ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik => '📸 Оцифруйте свой гардероб';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Нажмите эту кнопку, чтобы сделать фото или загрузить их из галереи для создания виртуального шкафа.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ Голосовой ассистент стиля';

  @override
  String get rehberSesliAsistanAciklama =>
      'Используйте голосовые команды, чтобы узнать, что надеть, или получить мгновенный совет.';

  @override
  String get rehberAiStilistBaslik => '✨ Рекомендации ИИ-стилиста';

  @override
  String get rehberAiStilistAciklama =>
      'Получайте персональные образы под погоду, ваш цветотип и предпочтения в один клик.';

  @override
  String get rehberAyarlarBaslik => '⚙️ Персонализация и настройки';

  @override
  String get rehberAyarlarAciklama =>
      'Настраивайте пол, тон кожи, предпочитаемые цвета, тему или пересматривайте вступительное руководство.';

  @override
  String get rehberNavGardirobumBaslik => '👔 Мой гардероб';

  @override
  String get rehberNavGardirobumAciklama =>
      'Удобно просматривайте, фильтруйте и управляйте всеми вещами по категориям.';

  @override
  String get rehberNavHaftalikBaslik => '📅 Планировщик на неделю';

  @override
  String get rehberNavHaftalikAciklama =>
      'Планируйте повседневные луки на неделю вперед с учётом прогноза погоды на 7 дней.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 ИИ-генератор из гардероба';

  @override
  String get rehberNavDolaptanAciklama =>
      'Позвольте ИИ автоматически создавать образы из ваших существующих вещей на каждый день.';

  @override
  String get rehberNavKendiBaslik => '🎨 Конструктор своего стиля';

  @override
  String get rehberNavKendiAciklama =>
      'Комбинируйте верх, низ и обувь вручную для создания собственного неповторимого лука.';

  @override
  String get rehberNavProfilBaslik => '📊 Аналитика и стирка';

  @override
  String get rehberNavProfilAciklama =>
      'Следите за статистикой носки одежды и отслеживайте нестиранные вещи в корзине.';

  @override
  String get bildirimIzinGerekliBaslik => 'Требуется разрешение на уведомления';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Рекомендуем включить уведомления, чтобы получать напоминания о стирке, предупреждения о дожде и ежедневные советы по стилю.';

  @override
  String get bildirimGunaydinBaslik => 'Доброе утро! ☀️';

  @override
  String get bildirimGunaydinIcerik =>
      'Я подготовил отличный образ под сегодняшнюю погоду. Хотите взглянуть?';

  @override
  String get bildirimKanalGenelBaslik => 'Общие уведомления';

  @override
  String get bildirimKanalGenelAciklama =>
      'Общие обновления и уведомления FitCheck';

  @override
  String get bildirimKanalGunlukBaslik => 'Ежедневные подборы образов';

  @override
  String get bildirimKanalGunlukAciklama =>
      'Ежедневные уведомления с рекомендациями одежды';

  @override
  String get bildirimKanalYikamaBaslik => 'Напоминания о стирке';

  @override
  String get bildirimKanalYikamaAciklama =>
      'Отслеживание чистоты вещей и напоминания об уходе';

  @override
  String get bildirimKanalRaporBaslik => 'Еженедельные отчеты по стилю';

  @override
  String get bildirimKanalRaporAciklama => 'Итоги недели по гардеробу и стилю';

  @override
  String get tenRengiAcik => 'Светлый / Очень светлый';

  @override
  String get tenRengiBugday => 'Средний / Бежевый';

  @override
  String get tenRengiEsmer => 'Смуглый / Тёмный';

  @override
  String get stilStreetwear => 'Уличный стиль / Кэжуал';

  @override
  String get stilKlasik => 'Классика / Формальный';

  @override
  String get stilMinimalist => 'Минимализм';

  @override
  String get stilSpor => 'Спортивный / Аथлежер';

  @override
  String get stilVintage => 'Винтаж / Ретро';

  @override
  String get fitSlim => 'Приталенный (Slim Fit)';

  @override
  String get fitRegular => 'Прямой крой (Regular)';

  @override
  String get fitOversize => 'Свободный / Оверсайз';

  @override
  String get gardirobumBosBaslik => 'Ваш гардероб пуст!';

  @override
  String get gardirobumGizlendiBaslik => 'Гардероб скрыт';

  @override
  String get gardirobumGizlendiAciklama =>
      'Нажмите на иконку глаза вверху справа, чтобы отобразить содержимое';

  @override
  String get gardirobumGoster => 'Показать содержимое';

  @override
  String get gardirobumGizle => 'Скрыть содержимое';

  @override
  String get kategoriUst => 'ВЕРХ';

  @override
  String get kategoriAlt => 'НИЗ';

  @override
  String get kategoriAyakkabi => 'ОБУВЬ';

  @override
  String get kategoriAksesuar => 'АКСЕССУАРЫ';

  @override
  String get gardirobumBosAciklama =>
      'Добавьте свою первую вещь прямо сейчас и оцените магию ИИ.';

  @override
  String get gardirobumAiIslem1 => 'Анализ вашего гардероба...';

  @override
  String get gardirobumAiIslem2 => 'Проверка погодных условий...';

  @override
  String get gardirobumAiIslem3 => 'Расчёт цветовой гармонии...';

  @override
  String get gardirobumAiIslem4 => 'Подбор лучших вариантов...';

  @override
  String get gardirobumAiIslem5 => 'Завершение деталей...';

  @override
  String get gardirobumHakBittiBaslik => 'Дневной лимит исчерпан';

  @override
  String get gardirobumHakBittiAciklama =>
      'Вы исчерпали дневной лимит создания образов.';

  @override
  String get gardirobumHakEklendiMesaj =>
      'Поздравляем, получена новая попытка создания образа!';

  @override
  String get ayarlariAc => 'Открыть настройки';

  @override
  String get kiyafetEkle => 'Добавить одежду';

  @override
  String get kameraIleCek => 'Сделать фото';

  @override
  String get galeridenSecToplu => 'Выбрать из галереи';

  @override
  String get kameraIzniGerekliBaslik => 'Требуется доступ к камере';

  @override
  String get kameraIzniGerekliAciklama =>
      'Включите доступ к камере в настройках, чтобы делать снимки.';

  @override
  String get kiyafetDuzenleBaslik => 'Редактировать вещь';

  @override
  String get kategori => 'Категория';

  @override
  String get evetSil => 'Да, удалить';

  @override
  String get favorilerdenCikarildi => 'Удалено из избранного';

  @override
  String get gardirobumHenuzYokEkle =>
      'Вещи пока не добавлены. Добавьте первую вещь прямо сейчас!';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return 'Вы можете выбрать не более $max фото за один раз.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count предм.';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '%$oran гармонии';
  }

  @override
  String get kombinSohbetAc => 'Обсудить образ';

  @override
  String get kombinSohbetBaslik => 'Чат об образе';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return 'Обсуждение образа на $gun';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return 'Давайте вместе разберём ваш образ «$kombin»! Спрашивайте о сочетании цветов, погоде или альтернативных вещах. ✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 Почему этот образ удачен?';

  @override
  String get kombinSohbetOneriAlternatif => '👟 Предложи альтернативную вещь';

  @override
  String get kombinSohbetOneriHava => '🌦️ А если погода изменится?';

  @override
  String get kombinSohbetOneriAksesuar => '💍 Подбери аксессуары';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Чат о вашем образе на сейчас';

  @override
  String get chatKirliSepetiBos =>
      '🧺 Ваша корзина для белья пуста! Все вещи готовы к носке — я могу собрать образ в любой момент. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 В корзине для белья ждут стирки **$sayi** вещей:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Эти вещи не попадут в образы, пока их не постирают. Если хотите, я прямо сейчас соберу образ из чистых вещей.';

  @override
  String get analitikVerileriPaylas => 'Делиться данными аналитики';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Для улучшения приложения отправляются анонимные данные об использовании. При отключении данные аналитики на этом устройстве удаляются.';

  @override
  String get chatKarsilamaHavaYok =>
      'Привет! 👋 Соберём отличный образ в твоём стиле? ✨';

  @override
  String get premiumBaslik => 'Безлимитный стиль, без рекламы';

  @override
  String get premiumAciklama =>
      'Пользуйся образами и анализом стиля без ограничений и отключи всю рекламу одной подпиской.';

  @override
  String get premiumOzellikReklamsiz => 'Вся реклама отключена';

  @override
  String get premiumOzellikAylik => 'Продлевается автоматически каждый месяц';

  @override
  String get premiumOzellikMagaza => 'Управляется через Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium активен. Безлимитный доступ и без рекламы.';

  @override
  String get premiumAboneOl => 'Подписаться';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Подписаться • $fiyat';
  }

  @override
  String get premiumGeriYukle => 'Восстановить покупку';

  @override
  String get premiumMagazaHazirDegil =>
      'Google Play сейчас недоступен. Попробуй ещё раз.';

  @override
  String get premiumSatinAlmaBaslatilamadi => 'Не удалось начать покупку.';

  @override
  String get premiumSatinAlmaBasarisiz => 'Покупка не удалась.';

  @override
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Безлимитные образы • $fiyat/мес.';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Безлимит • $fiyat/мес.';
  }

  @override
  String get guncellemeBaslik => 'Требуется обновление';

  @override
  String get guncellemeAciklama =>
      'Доступна новая версия FitCheck. Чтобы продолжить, обновите приложение.';

  @override
  String get guncellemeButonu => 'Обновить сейчас';

  @override
  String guncellemeYeniSurum(String surum) {
    return 'Новая версия: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok =>
      'Не удалось открыть ссылку на магазин. Обновите приложение в магазине.';

  @override
  String get premiumUrunBulunamadi =>
      'Не удалось загрузить данные подписки. Попробуйте позже.';

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
  String get kombinOyunuBaslik => 'Игра в комбинации';

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
  String get degerlendirmeBaslik => 'Вам нравится FitCheck?';

  @override
  String get degerlendirmeIcerik =>
      'Если вам нравится приложение, уделите 5 секунд и оставьте нам отзыв! Небольшие отзывы — большая помощь! ⭐ Оценившим пользователям +3 бесплатных кредита в подарок!';

  @override
  String get degerlendirmeEvet => 'Да, оценю';

  @override
  String get degerlendirmeBelkiSonra => 'Может быть, позже';

  @override
  String get yakinda => 'Скоро';

  @override
  String get yakindaAciklama =>
      'Мы работаем над этой функцией, она скоро появится!';

  @override
  String get aiOneriHazirlaniyor => 'Подготовка рекомендации...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'Не удалось подготовить рекомендацию стилиста. Попробуйте снова.';

  @override
  String get haftalikAiServisHatasi =>
      'Не удалось подключиться к сервису ИИ. Проверьте интернет и попробуйте снова.';

  @override
  String get haftalikAiGecerliPlanYok =>
      'ИИ не вернул действительный план. Попробуйте снова.';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'При создании плана произошла непредвиденная ошибка. Попробуйте снова.';

  @override
  String get haftalikBugunGiyildi =>
      'Сегодняшний образ уже надет; новый образ не создан.';

  @override
  String get girisHataKullaniciAdiKisa => 'Введите не менее 3 символов';

  @override
  String get girisHataEpostaGecersiz =>
      'Введите корректный адрес электронной почты';

  @override
  String get girisHataSifreKisa => 'Введите не менее 6 символов';

  @override
  String get googleKullanicisi => 'Пользователь Google';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => '🌐 Выбор языка';

  @override
  String get dilSecenekOtomatik => 'Автоматически (язык устройства)';

  @override
  String get kapat => 'Закрыть';

  @override
  String get bildirimBaslik => 'Уведомление';

  @override
  String get ayarlarAltbilgi => 'Сделано со вкусом';

  @override
  String get geriBildirimKonu => 'FitCheck Отзыв';

  @override
  String get premiumOzelliklerBaslik => 'Что открывает Premium';

  @override
  String get premiumOzellikSinirsizKombin => 'Неограниченное создание образов';

  @override
  String get premiumOzellikSinirsizAnaliz => 'Неограниченный ИИ-анализ стиля';

  @override
  String get premiumOzellikSinirsizGardirob =>
      'Неограниченное место в гардеробе';

  @override
  String get premiumPlanAylik => 'Месяц';

  @override
  String get premiumPlanYillik => 'Год';

  @override
  String get premiumEnAvantajli => 'ЛУЧШИЙ ВЫБОР';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return 'Скидка $yuzde%';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun ДНЕЙ БЕСПЛАТНО';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'Затем $fiyat';
  }

  @override
  String get premiumYenilemeNotu =>
      'Подписка продлевается автоматически в конце каждого периода. Отменить можно в любое время.';

  @override
  String get kiyafetDondur => 'Повернуть';

  @override
  String get stilistHafizasiBaslik => 'Память стилиста';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return 'Помнит $sayi заметок';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'Пока ничего не помнит';

  @override
  String get stilistHafizasiAciklama =>
      'Стилист сохраняет то, что узнаёт из ваших чатов, как постоянные заметки и персонализирует советы. Заметки хранятся только на этом устройстве.';

  @override
  String get stilistHafizasiNelerBiliyor => 'Что он помнит?';

  @override
  String get stilistHafizasiOzetBaslik => 'Сводка последних чатов';

  @override
  String get stilistHafizasiBos =>
      'Я пока ничего не узнал. Чем больше мы общаемся, тем лучше я знаю ваш стиль.';

  @override
  String get stilistHafizasiTemizle => 'Очистить память';

  @override
  String get stilistHafizasiTemizleOnay =>
      'Всё, что стилист помнит о вас, будет удалено. Это действие нельзя отменить.';

  @override
  String get stilistHafizasiTemizlendi => 'Память очищена 🧠';
}
