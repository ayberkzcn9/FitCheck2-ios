// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get chatOrtamCasual => '休闲';

  @override
  String get chatOrtamOfis => '办公';

  @override
  String get chatOrtamDavet => '聚会';

  @override
  String get chatOrtamSpor => '运动';

  @override
  String get chatOrtamGece => '夜间';

  @override
  String get chatOrtamRomantik => '浪漫';

  @override
  String get chatOrtamHaftaSonu => '周末';

  @override
  String get gardirobumAdimArkaplan => '正在移除背景';

  @override
  String get gardirobumAdimArkaplanAlt => '正在用 AI 分析图片';

  @override
  String get gardirobumAdimAnaliz => '正在分析衣物';

  @override
  String get gardirobumAdimAnalizAlt => '正在识别颜色、风格和类别';

  @override
  String get gardirobumAdimKaydet => '正在保存';

  @override
  String get gardirobumAdimKaydetAlt => '正在添加到衣橱';

  @override
  String get gardirobumLutfenBekleyin => '请稍候...';

  @override
  String get authHataZayifSifre => '密码太弱，至少需要 6 个字符。';

  @override
  String get authHataEpostaKullanimda => '该邮箱地址已被使用。';

  @override
  String get authHataGecersizEposta => '你输入的邮箱地址无效。';

  @override
  String get authHataKullaniciBulunamadi => '未找到该邮箱对应的用户。';

  @override
  String get authHataYanlisSifre => '密码错误，请重试。';

  @override
  String get authHataGecersizKimlik => '邮箱或密码错误，请检查你的信息。';

  @override
  String get authHataYontemIzinliDegil => '该登录方式未在 Firebase 控制台中启用。';

  @override
  String get authHataFarkliYontem => '该邮箱已使用其他登录方式注册。';

  @override
  String get authHataAgHatasi => '请检查网络连接后重试。';

  @override
  String get authHataCokDeneme => '尝试次数过多，请稍后再试。';

  @override
  String get authHataHesapDevreDisi => '该账户已被停用。';

  @override
  String get authHataYenidenGiris => '你需要重新登录才能完成此操作。';

  @override
  String get authHataGenel => '出错了，请重试。';

  @override
  String get authHataSifreEpostasiGonderilemedi => '无法发送密码重置邮件，请重试。';

  @override
  String get authHataGoogleDogrulanamadi => '无法验证 Google 登录，请重试。';

  @override
  String get authHataGoogleFarkliKullanici => '该 Google 账户已关联到其他用户。';

  @override
  String get authHataGoogleZatenBagli => '该 Google 账户已关联。';

  @override
  String get authHataGoogleYapilandirilmamis => '此设备未配置 Google 登录，请向支持团队反馈。';

  @override
  String get authHataGooglePencereAcik => 'Google 登录窗口仍处于打开状态，请稍等几秒后重试。';

  @override
  String get authHataGoogleTamamlanamadi => '无法完成 Google 登录，请几秒后重试。';

  @override
  String get authHataGoogleHesapSec => '你需要选择 Google 账户才能登录。';

  @override
  String get authHataGoogleOnayBekliyor => '你的 Google 账户有待处理的操，请重试。';

  @override
  String get authHataGoogleBeklenmeyen => 'Google 登录时发生意外错误，请重试。';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => '外观与主题';

  @override
  String get karanlikMod => '深色模式';

  @override
  String get koyuTemaAktif => '已启用深色主题';

  @override
  String get acikTemaAktif => '已启用浅色主题';

  @override
  String get dilAyarlari => '语言与地区设置';

  @override
  String get uygulamaDili => '应用语言';

  @override
  String get hakkinda => '关于应用';

  @override
  String get surum => '版本';

  @override
  String get ayarOtomatikCihazDili => '🌐 自动（跟随系统语言）';

  @override
  String get iptal => '取消';

  @override
  String get tamam => '确定';

  @override
  String get gardirobumTitle => '虚拟衣橱';

  @override
  String get gardirobumYukleniyor => 'AI 分析中...';

  @override
  String get gardirobumTopluEkle => '批量添加衣物';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return '正在分析 ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => '清空衣橱';

  @override
  String get gardirobumTemizleOnay => '您的衣橱中的所有物品都将被删除。确定要继续吗？';

  @override
  String get gardirobumEvet => '是的，全部清空';

  @override
  String get gardirobumHataMesaji => '添加物品时发生错误。';

  @override
  String get gardirobumKategoriTumu => '全部';

  @override
  String get gardirobumKategoriUst => '上衣';

  @override
  String get gardirobumKategoriAlt => '下装';

  @override
  String get gardirobumKategoriAyakkabi => '鞋履';

  @override
  String get gardirobumKategoriAksesuar => '配饰';

  @override
  String get gardirobumBosKategori => '该分类下暂无物品。';

  @override
  String get gardirobumGiymeSayisi => '穿搭次数：';

  @override
  String gardirobumMaliyet(Object tutar) {
    return '单次穿搭成本：₺$tutar';
  }

  @override
  String get gardirobumDolabaAl => '放回衣橱';

  @override
  String get gardirobumSepeteAt => '放入脏衣篮';

  @override
  String get gardirobumSepetteRozet => '待清洗';

  @override
  String get gardirobumGecersizParcaBaslik => '检测到无效物品';

  @override
  String get gardirobumGecersizParcaIcerik =>
      '系统中未在此图片中检测到服装、鞋履或配饰（检测到木制物品、家具、家居用品或不符物品）。请仅上传衣橱相关物品。';

  @override
  String get gardirobumTamam => '确定';

  @override
  String get stilistTitle => '即时 AI 造型师';

  @override
  String get gunlukKombinTitle => 'MEIRI CHUAN DA';

  @override
  String get gunlukKombinHazirBaslik => '准备好你的穿搭了吗？';

  @override
  String get gunlukKombinHazirIcerik => '摇骰子或晃动手机来创建今天的穿搭。';

  @override
  String get gunlukKombinKartBaslik => '今日穿搭';

  @override
  String get stilistAnlikHavaDurumu => '当前天气（点击刷新）';

  @override
  String get stilistKonumKontrol => '正在获取位置...';

  @override
  String get stilistNereyeGidiyorsun => '您今天打算去哪里？';

  @override
  String get stilistDusunuyor => '造型师思考中...';

  @override
  String get stilistBugunNeGiymeliyim => '我今天应该穿什么？';

  @override
  String get stilistKombiniTemizle => '清除搭配';

  @override
  String stilistKombininTitle(Object ortam) {
    return '您的 $ortam 穿搭';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 契合度：%$puan';
  }

  @override
  String get stilistUstGiyim => '上衣';

  @override
  String get stilistAltGiyim => '下装';

  @override
  String get stilistAyakkabi => '鞋履';

  @override
  String get stilistAksesuar => '配饰';

  @override
  String get stilistFavoriyeEkle => '添加至收藏';

  @override
  String get stilistBugunGiydim => '今天已穿';

  @override
  String get bugunGiydimOnayIcerik => '你今天穿了这套搭配吗？';

  @override
  String get stilistTrendyolTamamla => '在 Trendyol 上搜索';

  @override
  String get stilistHata => '生成穿搭时发生错误。';

  @override
  String get ortamCasual => '休闲 / 日常';

  @override
  String get ortamOfis => '职场 / 办公';

  @override
  String get ortamDavet => '婚礼 / 宴会活动';

  @override
  String get ortamSpor => '运动 / 健身';

  @override
  String get ortamGece => '夜生活 / 聚会';

  @override
  String get ortamRomantik => '浪漫约会';

  @override
  String get stilistUyariDolapBosBaslik => '您的衣橱是空的，或者所有衣服都在脏衣篮里！ 🧺';

  @override
  String get stilistUyariDolapBosIcerik => '为了获取个性化的穿搭推荐，请在衣橱中添加干净的衣物或配饰。';

  @override
  String get stilistUyariUstEksikBaslik => '缺少上衣！ 👕';

  @override
  String get stilistUyariUstEksikIcerik => '您的衣橱里没有干净的上衣。请至少添加一件上衣来完成搭配！';

  @override
  String get stilistUyariAltEksikBaslik => '缺少下装！ 👖';

  @override
  String get stilistUyariAltEksikIcerik => '您的衣橱里没有干净的下装。添加一件下装来打造时尚造型吧！';

  @override
  String get stilistUyariAyakkabiEksikBaslik => '缺少鞋履！ 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      '搭配很棒，但我们没找到干净的鞋子来匹配。现在就添加一双鞋吧！';

  @override
  String get stilistUyariButon => '知道了，这就去添加！';

  @override
  String get anaHavaYukleniyor => '正在加载当地天气...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK 正在倾听... 请说话！';

  @override
  String get anaMikrofonHata => '麦克风权限或语音识别服务未就绪。';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return '您的偏好已更新：\"$cinsiyet\" ✨';
  }

  @override
  String get anaKonumKapaliBaslik => '定位服务已关闭';

  @override
  String get anaKonumKapaliIcerik => '您需要开启 GPS 定位服务，以便接收符合天气的穿搭推荐。';

  @override
  String get anaKonumuAc => '开启定位服务';

  @override
  String get anaIzinVer => '允许';

  @override
  String get anaIptal => '取消';

  @override
  String get anaKonumIzinRedBaslik => '定位权限已被拒绝';

  @override
  String get anaKonumIzinRedIcerik1 => '由于未授予权限，无法获取天气信息。';

  @override
  String get anaKonumIzinRedIcerik2 => '您需要在系统设置中开启权限。';

  @override
  String get anaKonumIzinGerekliBaslik => '需要定位权限';

  @override
  String get anaKonumIzinGerekliIcerik => '请在设置中开启定位权限以加载天气预报。';

  @override
  String get anaHavaDurumuAlinamadi => '无法获取天气信息';

  @override
  String get anaHavaTahminiYuklenemedi => '无法加载天气预报。';

  @override
  String get anaFavoriEklendi => '穿搭已添加至收藏！ ⭐';

  @override
  String get anaKombinTekrarUyari => '⚠️ 注意：您最近经常穿这套或类似的衣服。今天不妨尝试一下其他风格！';

  @override
  String get anaKombinMukemmel => '✨ 绝佳的选择！您今天的整体搭配非常均衡时尚。';

  @override
  String get anaYikamaUyariBaslik => '智能洗衣提醒';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return '由于您穿了这套搭配，高频使用的物品 \"$parcalar\" 已自动移至脏衣篮！ 🧺';
  }

  @override
  String get anaTamam => '确定';

  @override
  String get anaAyarlarTooltip => '设置';

  @override
  String get anaKadin => '女性';

  @override
  String get anaErkek => '男性';

  @override
  String get anaSesleKonus => '语音指令';

  @override
  String get anaStilistAsistani => '造型师助手';

  @override
  String get anaSekmeGardirop => '衣橱';

  @override
  String get anaSekmeHaftalik => '一周计划';

  @override
  String get anaSekmeAnlik => '即时推荐';

  @override
  String get anaSekmeYarismasi => '测验';

  @override
  String get anaSekmeProfil => '个人与分析';

  @override
  String get modaYarismasiBaslik => '时尚与色彩搭配';

  @override
  String get modaYarismasiGunlukTamamlandi => '今日的测验已完成';

  @override
  String get modaYarismasiYeniYarin => '新的5题套会在明天恢复。';

  @override
  String get modaYarismasiSonuc => '结果';

  @override
  String modaYarismasiSkor(Object skor) {
    return '得分：$skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return '问题 $index / 10';
  }

  @override
  String get modaYarismasiGeri => '返回';

  @override
  String get modaYarismasiAnaEkrana => '返回首页';

  @override
  String get havaParcaliBulutlu => '多云';

  @override
  String get havaSicakGunesli => '炎热晴朗';

  @override
  String get havaSogukKarli => '严寒有雪';

  @override
  String get havaYagmurlu => '有雨';

  @override
  String get havaGunesli => '晴朗';

  @override
  String get havaSoguk => '寒冷';

  @override
  String get gunPzt => '星期一';

  @override
  String get gunSal => '星期二';

  @override
  String get gunCar => '星期三';

  @override
  String get gunPer => '星期四';

  @override
  String get gunCum => '星期五';

  @override
  String get gunCmt => '星期六';

  @override
  String get gunPaz => '星期日';

  @override
  String get stilKahveBaslik => '☕ 咖啡聚会 & 休闲';

  @override
  String get stilKahveSoru => '请推荐一套适合和朋友喝咖啡的时尚舒适休闲装';

  @override
  String get stilOfisBaslik => '💼 干练通勤 / 职场';

  @override
  String get stilOfisSoru => '请推荐一套适合办公室工作的精致现代职场穿搭';

  @override
  String get stilSporBaslik => '🏃 活力运动 / 舒适';

  @override
  String get stilSporSoru => '请推荐一套非常舒适运动、适合周末郊游的搭配';

  @override
  String get stilGeceBaslik => '🌙 晚宴 / 派对夜生活';

  @override
  String get stilGeceSoru => '请推荐一套适合浪漫晚餐或特别活动的出彩穿搭';

  @override
  String get ilkGorevBaslik => '🎯 第一步：选择您的风格！';

  @override
  String get ilkGorevAciklama => 'FitCheck AI 将即刻为您生成穿搭。您今天打算去哪里？';

  @override
  String get haftalikUyariButon => '知道了';

  @override
  String get haftalikUyariDolapBosBaslik => '您的衣橱是空的！';

  @override
  String get haftalikUyariDolapBosIcerik => '您需要先向衣橱添加衣物才能规划一周穿搭。';

  @override
  String get haftalikUyariUstEksikBaslik => '缺少上衣！';

  @override
  String get haftalikUyariUstEksikIcerik => '您的衣橱里没有干净的上衣。';

  @override
  String get haftalikUyariAltEksikBaslik => '缺少下装！';

  @override
  String get haftalikUyariAltEksikIcerik => '您的衣橱里没有干净的下装。';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => '缺少鞋履！';

  @override
  String get haftalikUyariAyakkabiEksikIcerik => '您的衣橱里没有干净的鞋子。';

  @override
  String get haftalikHata => '生成一周计划时发生错误。';

  @override
  String get haftalikAjandaTitle => '每周风格规划师';

  @override
  String get haftalikAnlikHavaDurumu => '本周天气预报';

  @override
  String get haftalikKonumKontrol => '正在加载天气...';

  @override
  String get haftalikTemizParca => '干净衣物';

  @override
  String get haftalikSepette => '待清洗';

  @override
  String get haftalikPlanAciklama => '让 AI 根据天气预报为您准备 7 天穿搭计划。';

  @override
  String get haftalikProgramOlustur => '生成每周穿搭计划';

  @override
  String get haftalikPlaniTemizle => '清除计划';

  @override
  String get haftalikAnalizEdiliyor => 'AI 规划中...';

  @override
  String get haftalikUyum => '契合度';

  @override
  String get haftalikFavoriEkle => '添加至收藏';

  @override
  String get haftalikGiyildiIsaretle => '今天已穿';

  @override
  String get haftalikHava => '天气：';

  @override
  String get haftalikHavaUyarisi => '提示：为了适应当天的天气，这套搭配中的部分单品已作调整。';

  @override
  String get haftalikUyumsuzParca => '缺失物品';

  @override
  String get haftalikEksikParcaStilistNotu => '造型师已考虑到缺少的单品，并用你现有的干净单品做出了搭配建议。';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      '没有足够的干净单品来填满这一天。添加一件新单品或清洗衣物，造型师就会在这里推荐新搭配。';

  @override
  String get haftalikEksikParcaAiOnerisi => 'AI 穿搭建议';

  @override
  String get haftalikEksikParcaOneriYok => '刷新计划即可看到补齐缺失单品上衣、下装与鞋子的搭配建议。';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'AI 造型师穿搭建议';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor => '造型师正在准备穿搭建议…';

  @override
  String get haftalikEksikParcaPlanKurulamadi => '缺少上衣和下装无法搭配。造型师已在上面准备好建议。';

  @override
  String get haftalikNot => '备注';

  @override
  String get haftalikTrendyolAra => '在 Trendyol 上搜索';

  @override
  String get izinZorunluMesaj => '使用此应用需要提供这些权限。';

  @override
  String get izinGerekliBaslik => '需要相关权限';

  @override
  String get izinGerekliIcerik => '相机和定位权限已被拒绝，请在设置中开启它们。';

  @override
  String get ayarlaraGit => '前往设置';

  @override
  String get izinAnaBaslik => '所需权限';

  @override
  String get izinAciklama => '为了向您提供最佳穿搭推荐，我们需要定位权限（获取天气）和相机权限（拍照）。';

  @override
  String get konumIzni => '定位权限';

  @override
  String get kameraIzni => '相机权限';

  @override
  String get izinVerDevamEt => '授权并继续';

  @override
  String get gunlukHavaMevcutDegil => '天气数据不可用';

  @override
  String get profilAnalizTitle => '个人与分析';

  @override
  String get anlikDurum => '当前状态';

  @override
  String get toplamParca => '物品总数';

  @override
  String get favoriKombin => '最爱搭配';

  @override
  String get gardiropDegeri => '衣橱总价值';

  @override
  String get ortalamaMaliyet => '平均穿搭成本';

  @override
  String get kategoriDagilimi => '分类占比';

  @override
  String get ustGiyim => '上衣';

  @override
  String get altGiyim => '下装';

  @override
  String get ayakkabi => '鞋履';

  @override
  String get disGiyim => '外套';

  @override
  String get aksesuar => '配饰';

  @override
  String get sonGiyecekGecmisi => '最近穿搭历史';

  @override
  String get kayit => '记录';

  @override
  String get gecmisKombinYok => '暂无保存的穿搭历史记录。';

  @override
  String get parca => '件';

  @override
  String get onboardingHosGeldinBaslik => '欢迎使用 FitCheck！ ✨';

  @override
  String get onboardingDolabiniDijitallestir => '数字衣橱管理';

  @override
  String get onboardingDolapAciklama => '只需几秒即可添加衣物，打造您的专属虚拟衣橱。';

  @override
  String get onboardingHavaDurumu => '天气实时匹配';

  @override
  String get onboardingHavaAciklama => '根据您所在地区的每日天气获取最合适的穿搭建议。';

  @override
  String get onboardingYikama => '智能洗衣追踪';

  @override
  String get onboardingYikamaAciklama => '应用会自动检测常穿衣物并将其移动至脏衣篮。';

  @override
  String get onboardingEksikParca => '缺失单品建议';

  @override
  String get onboardingEksikAciklama => '识别完善穿搭所需的缺失单品，获取即时选购灵感。';

  @override
  String get onboardingAnalitik => '深度穿搭分析';

  @override
  String get onboardingAnalitikAciklama => '分析衣橱总价值、单次穿搭成本以及您的偏好风格趋势。';

  @override
  String get onboardingStilist => 'AI 专属造型师';

  @override
  String get onboardingStilistAciklama => '只需说明您的去向，AI 将在几秒内为您搭配完美造型。';

  @override
  String get onboardingAtla => '跳过';

  @override
  String get onboardingModaProfiliniz => '您的时尚档案';

  @override
  String get onboardingKadin => '女性';

  @override
  String get onboardingErkek => '男性';

  @override
  String get onboardingBasla => '开始使用';

  @override
  String get onboardingDevamEt => '继续';

  @override
  String get cinsiyetBaslik => '性别';

  @override
  String get tarzBaslik => '日常风格（可多选）';

  @override
  String get renkTercihiBaslik => '偏好色系';

  @override
  String get tenRengiBaslik => '肤色 / 个人色彩';

  @override
  String get kadin => '女性';

  @override
  String get erkek => '男性';

  @override
  String get cinsiyetBelirtilmemis => '未指定';

  @override
  String get tarzSpor => '运动';

  @override
  String get tarzKlasik => '经典';

  @override
  String get tarzSokakModasi => '街头潮牌';

  @override
  String get tarzMinimalist => '极简';

  @override
  String get renkKoyuTonlar => '深色系';

  @override
  String get renkPastel => '柔和马卡龙色';

  @override
  String get renkCanli => '鲜艳明亮色';

  @override
  String get renkNotr => '中性色 / 黑白灰';

  @override
  String get tenAcikBeyaz => '白皙 / 偏白';

  @override
  String get tenBugday => '自然肤色 / 暖小麦';

  @override
  String get tenEsmerKoyu => '健康小麦 / 深色';

  @override
  String get hesabinizaGirisYapin => '登录您的账户';

  @override
  String get yeniHesapOlusturun => '注册新账户';

  @override
  String get stilDunyanaTekrarHosGeldin => '欢迎回到您的时尚世界 ✨';

  @override
  String get kombinleriniSaklamakIcinKatil => '加入我们以保存和同步您的穿搭 🚀';

  @override
  String get girisYap => '登录';

  @override
  String get girisYapGoogle => '使用 Google 登录';

  @override
  String get girisBeniHatirla => '记住我';

  @override
  String get girisVeya => '或';

  @override
  String get kayitOl => '注册';

  @override
  String get adinizVeyaLakabiniz => '您的姓名或昵称';

  @override
  String get epostaAdresiniz => '电子邮箱';

  @override
  String get sifreniz => '密码';

  @override
  String get girisYapVeBasla => '登录并开始';

  @override
  String get kayitOlVeBasla => '注册并开始';

  @override
  String get misafirOlarakDevamEt => '以游客身份继续';

  @override
  String get lutfenEpostaVeSifreGiriniz => '请输入您的邮箱和密码。';

  @override
  String get lutfenAdiniziGiriniz => '请输入您的姓名。';

  @override
  String get kullanimKosullariBaslik => '使用条款与服务协议';

  @override
  String get onaylamakIcinKaydirin => '请滑动至底部以接受条款';

  @override
  String get okudumAnladimKabulEdiyorum => '我已阅读、理解并同意';

  @override
  String get kullanimKosullarini => '使用条款';

  @override
  String get okudumVeOnayliyorum => '。';

  @override
  String get onaylamadanOnceKosullariOkuyun => '请在接受前仔细阅读使用条款。';

  @override
  String get devamEtmekIcinKosullariKabulEdin => '您需要同意使用条款才能继续。';

  @override
  String get kullanimKosullariMetni =>
      'FITCHECK 服务条款与使用协议\n\n最后更新日期：2026年8月27日\n\n在使用 FitCheck 移动应用（“本应用”）之前，请仔细阅读本使用条款（“本协议”）。通过下载、访问或使用本应用，即表示您同意受本协议所有条款的约束。\n\n1. 协议主体与目的\n本协议由 FitCheck 应用开发者与下载并使用本应用的高级个人用户（“用户”）签订。本应用提供数字衣橱管理、衣物追踪、基于天气的穿搭推荐以及 AI 驱动的造型咨询服务。\n\n2. 服务范围与使用条件\n• 年龄限制：您必须年满 13 岁方可使用本应用。\n• 用户信息：用户需对在个人资料设置中提供的姓名、性别、风格和色彩偏好的准确性负责。\n• 咨询性质：AI 提供的风格评分、购买建议和洗衣提醒仅供参考。\n• 天气数据：天气预报基于实时定位获取。本公司对任何偏差不承担责任。\n\n3. 知识产权与内容权利\n您保留对所上传衣物照片的知识产权。FitCheck 标志、设计、软件代码和算法完全归 FitCheck 所有。\n\n4. 隐私与数据安全\n您上传的照片和穿搭历史记录默认保存在您的本地设备上。位置数据仅用于实时天气查询。\n\n5. 责任限制\nFitCheck 不保证服务不间断。对于因更换设备或删除应用导致的数据丢失，我们概不负责。\n\n6. 联系方式\n如有疑问，请通过“设置”选项卡中的联系部分或发送邮件至 support@fitcheckapp.com 联系我们。\n\n--- 📜 协议结束 ---\n请点击下方按钮接受条款。';

  @override
  String chatKarsilama(Object hava) {
    return '您好！👋 今天外面天气$hava。要不要来搭配一套适合您风格的穿搭？✨';
  }

  @override
  String get chatGorselGonderildi => '图片已发送。';

  @override
  String get chatAsistanSohbeti => '与助手对话';

  @override
  String get chatModHavaDuyarli => '根据天气智能推荐穿搭';

  @override
  String get chatStilistHazirliyor => '造型师正在设计搭配...';

  @override
  String get chatGorselEklendi => '已添加图片附件';

  @override
  String get chatTekrarDene => '重试';

  @override
  String get chatKamera => '相机';

  @override
  String get chatGaleri => '从图库选择图片';

  @override
  String get chatMikrofon => '麦克风';

  @override
  String get chatGonder => '发送消息';

  @override
  String get chatOneriYagmur => '🌧️ 雨天穿搭推荐';

  @override
  String get chatOneriOfis => '💼 职场 / 精致休闲';

  @override
  String get chatOneriHaftaSonu => '☕ 轻松周末风';

  @override
  String get chatOneriKirliSepeti => '🧺 查看脏衣篮';

  @override
  String get chatDinleniyor => '正在倾听...';

  @override
  String get chatBirSeylerYazin => '给助手发送消息...';

  @override
  String get chatKombiniGiydim => '我穿了这套搭配 👗';

  @override
  String get chatKombinIslendi => '已记录为今天的穿搭！ 📅';

  @override
  String get chatGorselIncele => '请分析这张图片并推荐搭配。';

  @override
  String get profilAyarlariBaslik => '个人资料设置';

  @override
  String get cinsiyetTercihiBaslik => '性别偏好';

  @override
  String get stilAramaHint => '例如：“黑色西装精致休闲风”、“夏季连衣裙”...';

  @override
  String get stilFiltreTumu => '所有物品';

  @override
  String get stilFiltreSadeceTemizler => '仅看干净衣物';

  @override
  String get stilFiltreSadeceSepet => '仅看待清洗衣物';

  @override
  String get profilFavoriKombinlerTitle => '我收藏的搭配';

  @override
  String get profilFavoriKombinYok => '暂未添加收藏的搭配。';

  @override
  String get profilYikamaSepetimTitle => '脏衣篮';

  @override
  String get profilYikamaSepetimBos => '您的脏衣篮是空的，所有衣物都是干净的！ ✨';

  @override
  String get profilSepetiBosalt => '清空脏衣篮';

  @override
  String get profilSepetiBosaltOnay => '所有物品将被标记为已清洗。确认操作？';

  @override
  String get profilSepetiBosaltButon => '是的，全部洗干净';

  @override
  String get profilTenRengi => '肤色 / 色彩季型';

  @override
  String get profilTarzTercihi => '偏好风格';

  @override
  String get profilRenkPaleti => '偏好调色盘';

  @override
  String get rehberGardiropEkleTitle => '添加照片';

  @override
  String get rehberGardiropEkleDesc => '您可以单张或批量拍摄/上传您的衣物照片。';

  @override
  String get rehberAiStilistTitle => 'AI 造型助手';

  @override
  String get rehberAiStilistDesc => '向 AI 获取定制穿搭或时尚穿搭建议。';

  @override
  String get rehberSesliTitle => '语音指令';

  @override
  String get rehberSesliDesc => '只需说话即可解放双手，快速获取穿搭建议。';

  @override
  String get rehberAyarlarTitle => '设置与个人资料';

  @override
  String get rehberAyarlarDesc => '随时更新您的性别、风格和肤色偏好。';

  @override
  String get rehberGardiropNavTitle => '我的衣橱';

  @override
  String get rehberGardiropNavDesc => '按分类轻松查看和管理您添加的所有衣物。';

  @override
  String get rehberHaftalikNavTitle => '每周规划师';

  @override
  String get rehberHaftalikNavDesc => '根据 7 天天气预报提前规划您的每日穿搭。';

  @override
  String get rehberDolaptanNavTitle => '衣橱 AI 搭配生成';

  @override
  String get rehberDolaptanNavDesc => '让 AI 用您现有的衣物根据当天天气自动生成组合。';

  @override
  String get rehberKendiNavTitle => '自定义搭配创作';

  @override
  String get rehberKendiNavDesc => '手动组合上衣、下装和鞋子，打造属于您自己的造型。';

  @override
  String get rehberProfilNavTitle => '分析与洗衣';

  @override
  String get rehberProfilNavDesc => '追踪衣物穿搭率并管理脏衣篮中的待洗物品。';

  @override
  String get simdilikAtla => '暂时跳过';

  @override
  String get uygulamaIzinleri => '应用权限';

  @override
  String get izinEkraniAciklama => 'FitCheck 需要这些权限以推荐个性化穿搭并发送天气/洗衣提醒。';

  @override
  String get konumIzniAciklama => '用于基于实时天气的穿搭推荐';

  @override
  String get kameraIzniAciklama => '用于拍摄衣物照片并添加至衣橱';

  @override
  String get bildirimIzni => '通知权限';

  @override
  String get bildirimIzniAciklama => '用于洗衣提醒和天气预警';

  @override
  String get izinleriVerVeBasla => '授予权限并开始';

  @override
  String get dahaSonraAyarla => '稍后设置';

  @override
  String get gunlukHakBittiBaslik => '已达今日上限！';

  @override
  String get dahaSonra => '稍后再说';

  @override
  String get reklamIzleHakKazan => '观看广告（+3 次额度）';

  @override
  String get tebriklerHakEklendi => '恭喜！已增加 +3 次额度。 ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return '已取消搭配 \"$kombinAdi\" 的标记。';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" 已标记为今天穿搭！ 👕✨';
  }

  @override
  String get kiyafetDetayi => '衣物详情';

  @override
  String get parcaDetayiBaslik => '单品详情';

  @override
  String get farkliParcaSec => '选择其他单品';

  @override
  String get farkliUstSec => '选择其他上衣 👕';

  @override
  String get farkliAltSec => '选择其他下装 👖';

  @override
  String get farkliAyakkabiSec => '选择其他鞋履 👟';

  @override
  String get farkliDisSec => '选择其他外套 🧥';

  @override
  String get baskaTemizKiyafetYok => '在该分类中您没有其他干净的衣物\n可供替换。';

  @override
  String get planiYenile => '刷新计划';

  @override
  String get havaEtiketi => '天气';

  @override
  String get yukleniyor => '加载中...';

  @override
  String get temizle => '清除';

  @override
  String get yenidenDegerlendiriliyor => '重新评估中...';

  @override
  String get kombinParcalariBaslik => '搭配构成';

  @override
  String get parcalariKaydirIpucu => '左右滑动以查看更多单品 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ 我围绕这件单品精心设计了这套搭配：$parcaAdi！';
  }

  @override
  String get sihirliDokunus => '灵感组合';

  @override
  String get dolabiKaristirEksikUyari => '混搭衣橱需要至少有 1 件上衣、1 件下装和 1 双鞋子！ 👕👖👟';

  @override
  String get zarlarAtildiYorumu => '🎲 摇出新惊喜！您发现了一个意想不到的出彩组合。';

  @override
  String get rastgeleKombinTuru => '随机搭配';

  @override
  String get temizAlternatifYok => '该分类下没有更多干净的可替代衣物！ 🧺';

  @override
  String get kisiselDokunus => '个性调整';

  @override
  String get aiYeniParcaAnalizEdiyor => 'AI 正在分析新单品... ✨';

  @override
  String get parcaDegisimVarsayilanYorum => '✨ 替换这些单品后，整体协调度变得更加出色了！';

  @override
  String get parcaDegisimHataYorum => '✨ 单品调整使这套搭配更契合您的风格！';

  @override
  String get bilgileriDuzenleBaslik => '编辑信息';

  @override
  String get kiyafetAdiEtiketi => '单品名称';

  @override
  String get renkEtiketi => '颜色';

  @override
  String get kaydet => '保存';

  @override
  String get yenidenZarAt => '重新摇色子';

  @override
  String get zarAtKaristir => '摇色子（随机混搭）';

  @override
  String get zarPopupBaslik => '摇动魔法色子！';

  @override
  String get zarPopupAciklama => '摇动手机或点击下方按钮来掷色子，即可从你的衣橱中随机搭配造型。';

  @override
  String get zarlariAt => '掷色子';

  @override
  String get zarSalla => '摇色子';

  @override
  String get degistirmekIcinKaydirIpucu => '滑动或点击单品进行替换 👈👉';

  @override
  String get favorilerdeEtiketi => '已收藏';

  @override
  String get bugunGiydildiEtiketi => '今天已穿 ✨';

  @override
  String get varsayilanKendiAnalizYorumu => '太棒了！这些单品在色彩和风格上都非常搭。';

  @override
  String get kendiTasarimimBaslik => '我的原创搭配';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return '选择 $kategori';
  }

  @override
  String get kendiKombininiTasarlaTitle => '设计您的搭配';

  @override
  String get secimleriSifirla => '重置选择';

  @override
  String get kombinHazirAiTavsiyesi => '搭配非常好看！使用 AI 分析并保存吧。';

  @override
  String get kombinBaslaIpucu => '今天想穿什么？先挑选单品吧。';

  @override
  String get ustAltModu => '上衣 + 下装';

  @override
  String get tekParcaElbiseModu => '连体装（连衣裙/套装）';

  @override
  String get tekParcaElbise => '连体装 / 连衣裙';

  @override
  String get aksesuarOpsiyonel => '配饰（可选）';

  @override
  String get stilistAnaliziBaslik => '造型师分析';

  @override
  String get stilistDegerlendiriyor => '造型师评估中...';

  @override
  String get aiIleAnalizEtKaydet => 'AI 分析并保存';

  @override
  String get bilinmiyor => '未知';

  @override
  String get karmasikSiklik => '精致雅致风格';

  @override
  String get gecmisiTemizleTitle => '清空历史记录';

  @override
  String get gecmisiTemizleOnayIcerik => '确定要删除所有穿搭历史记录吗？此操作无法撤销。';

  @override
  String get gecmisBasariylaTemizlendi => '历史记录已成功删除 🗑️';

  @override
  String get kayitGecmistenSilindi => '该记录已从历史记录中删除。';

  @override
  String get kombin => '穿搭';

  @override
  String get kombinDetayiUst => '穿搭详情';

  @override
  String get giyilenParcalarUst => '已穿单品';

  @override
  String get detayBulunamadi => '未找到详情。';

  @override
  String get henuzFavoriEklemediniz => '您还没有添加收藏的搭配。';

  @override
  String get camasirSepetiTitle => '脏衣篮';

  @override
  String get sepetBosTumKiyafetlerTemiz => '脏衣篮是空的，所有衣物都很干净！';

  @override
  String get tumKiyafetlerTemizlendi => '所有衣物均已洗净放回衣橱 🧺✨';

  @override
  String get tumunuTemizIsaretle => '全部标记为已清洗';

  @override
  String get profilVeAnalizTitle => '个人与衣橱分析';

  @override
  String get harikaGidiyorsun => '您管理得太棒了！';

  @override
  String gundurSeridesin(Object gun) {
    return '已连续打卡 $gun 天';
  }

  @override
  String get tumuTemiz => '全部干净';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '$sayi 件待清洗';
  }

  @override
  String get stilKimligin => '您的风格名片';

  @override
  String get dolapVerimliligi => '衣橱利用率';

  @override
  String get renkPaletin => '您的专属色盘';

  @override
  String get dolabinKahramanlari => '衣橱百搭王';

  @override
  String get derinlerdeUnutulanlar => '被遗忘的单品';

  @override
  String get sonGiyilenler => '最近穿过';

  @override
  String get tumunuTemizle => '全部清除';

  @override
  String get henuzGecmisKaydiYok => '暂无历史记录。';

  @override
  String kezGiyildi(Object sayi) {
    return '已穿 $sayi 次';
  }

  @override
  String get ayarlarTitle => '设置';

  @override
  String get hesapVeGuvenlikMerkeziUst => '账户与安全中心';

  @override
  String get kullaniciHesabi => '用户账户';

  @override
  String get misafirKullanici => '游客用户';

  @override
  String get epostaDogrulanmis => '邮箱已验证';

  @override
  String get esitlemekIcinGirisYapin => '登录以跨设备同步数据。';

  @override
  String get cikisYapTitle => '退出登录';

  @override
  String get cikisYapOnayIcerik => '确定要退出当前账户吗？';

  @override
  String get bagliHesaplarUst => '已绑定账户';

  @override
  String get googleHesabiBagli => '已绑定 Google 账户';

  @override
  String get googleHesabiniBagla => '绑定 Google 账户';

  @override
  String get googleHesabiBaglandi => 'Google 账户绑定成功！ 🔗';

  @override
  String get googleHesabiBaglantisiKesildi => '已解绑 Google 账户。';

  @override
  String get sifreVeGuvenlik => '密码与安全';

  @override
  String get sifreYenilemeBaglantisiIste => '请求重置密码链接';

  @override
  String get sifremiUnuttum => '忘记密码？';

  @override
  String get sifreDegistirTitle => '修改密码';

  @override
  String get sifreSifirlamaAciklama => '密码重置链接将发送至您账户绑定的邮箱：';

  @override
  String get epostaAdresi => '电子邮箱';

  @override
  String get gecerliBirEpostaGiriniz => '请输入有效的电子邮箱地址';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return '重置邮件已发送至 $eposta！ ✉️';
  }

  @override
  String get baglantiGonder => '发送链接';

  @override
  String get hesabiKaliciSilTitle => '永久注销账户';

  @override
  String get hesabiSilGeriAlinamazUyari => '此操作不可逆。您的衣橱数据和个人资料将被永久删除。';

  @override
  String get hesabiSilOnayKoduMetni => '请在下方输入 \"fitcheck\" 以确认：';

  @override
  String get vazgec => '取消';

  @override
  String get hesabimiSil => '注销我的账户';

  @override
  String get hesabinizSilindi => '您的账户及相关数据已被删除。';

  @override
  String get kisiselStilVeProfilUst => '个人风格与档案';

  @override
  String get stilVeTarzTercihleri => '风格与剪裁偏好';

  @override
  String get secili => '已选择';

  @override
  String get tenRengiTercihinizUst => '肤色偏好设置';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'AI 与风格精度';

  @override
  String get stilistKisiligiVeYantitTarziUst => '造型师性格与回复风格';

  @override
  String get aiKisilikSamimiBaslik => '热情友善 / 闺蜜模式';

  @override
  String get aiKisilikSamimiAciklama => '温暖且充满鼓励的语气，让时尚搭配变得轻松有趣';

  @override
  String get aiKisilikElestirmenBaslik => '专业时尚评论家';

  @override
  String get aiKisilikElestirmenAciklama => '聚焦于色彩理论和版型比例的技术性专业建议';

  @override
  String get aiKisilikMinimalistBaslik => '极简直奔主题';

  @override
  String get aiKisilikMinimalistAciklama => '精炼直接的搭配建议，绝无冗余话术';

  @override
  String get sikiRenkTeorisiUyumModu => '严格色彩理论模式';

  @override
  String get sikiRenkTeorisiAciklama => '开启后，AI 将严格遵循经典色彩搭配法则';

  @override
  String get bildirimlerVeHatirlaticiUst => '通知与提醒';

  @override
  String get sabahKombinOnerisi => '早间搭配推荐';

  @override
  String herSabahBildirimAl(Object saat) {
    return '每天在 $saat 接收通知';
  }

  @override
  String get bildirimSaatiniOzellestir => '自定义通知时间';

  @override
  String get gunlukKombinBildirimSaati => '每日穿搭通知时间';

  @override
  String get sabahBildirimSaatiSec => '选择早间通知时间';

  @override
  String get saatKaydedildiAksama => '时间已保存，但通知服务暂时无法访问。';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return '早间提醒已设置为 $saat。 ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari => '请在设备设置中开启通知权限以继续。';

  @override
  String get camasirSepetiUyarilari => '脏衣篮提醒';

  @override
  String get camasirSepetiUyarilariAciklama => '当堆积的脏衣物较多时接收提醒';

  @override
  String get haftalikStilRaporu => '每周风格报告';

  @override
  String get haftalikStilRaporuAciklama => '每周日晚上获取您本周的衣橱使用总结';

  @override
  String get gorunumVeBolgeUst => '外观与地区';

  @override
  String get lokasyonVeBirimlerUst => '位置与单位';

  @override
  String get sicaklikBirimi => '温度单位';

  @override
  String get varsayilanSehirBolge => '默认城市/地区';

  @override
  String get sehirOrnekHint => '例如：北京、上海、广州';

  @override
  String get gpsKullan => '使用 GPS 定位';

  @override
  String get veriVeDepolamaYonetimiUst => '数据与存储管理';

  @override
  String get gorselOnbelleginiTemizle => '清理图片缓存';

  @override
  String get geciciFotografHafizasiAciklama => '释放预留给照片的临时内存空间';

  @override
  String get onbellekTemizlendiBasari => '图片缓存和临时文件已成功清理！ ✨';

  @override
  String get onbellekTemizlerkenHata => '清理缓存时发生错误。';

  @override
  String get gardirobuDisaAktarYedekle => '导出衣橱（备份）';

  @override
  String get tumKiyafetVeKombinJsonAciklama => '以 JSON 格式导出所有衣物和搭配数据';

  @override
  String get disaAktarilacakVeriYok => '未找到可导出的衣橱数据。 📭';

  @override
  String get gardiropVerisiKopyalandi => '所有衣橱数据已以 JSON 格式复制到剪贴板！ 📋';

  @override
  String get destekVeDegerlendirmeUst => '支持与评价';

  @override
  String get uygulamayiDegerlendirin => '评价此应用';

  @override
  String get googlePlay5YildizDestek => '在 Google Play 给我们 5 星好评以表支持 ⭐';

  @override
  String get googlePlayAcilamadi => '无法打开 Google Play。';

  @override
  String get geriBildirimVeDestek => '反馈与支持';

  @override
  String get hataBildirVeyaOneri => '提交 Bug 或提出新功能建议';

  @override
  String get islemTamamlanamadi => '无法完成操作。请重试。';

  @override
  String get epostaUygulamasiAcilamadi =>
      '无法打开邮件应用。请直接发送邮件至 ayberkzcn9@gmail.com。';

  @override
  String get gizlilikPolitikasiTitle => '隐私政策';

  @override
  String get veriKullanimiVeGizlilikHaklari => '查看数据使用规则和隐私权利';

  @override
  String get sonGuncellemeTarihi => '最后更新日期：2026年8月27日';

  @override
  String get gizlilikMadde1Baslik => '1. 数据收集与使用';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck 处理信息以优化您的衣橱管理和搭配推荐。您的照片、风格和性别偏好均本地存储于您的设备上。';

  @override
  String get gizlilikMadde2Baslik => '2. 位置权限';

  @override
  String get gizlilikMadde2Icerik =>
      '实时位置信息仅通过 Open-Meteo 服务以匿名方式处理，纯粹用于获取天气状况。数据绝不会被存储或共享。';

  @override
  String get gizlilikMadde3Baslik => '3. 语音助手与麦克风';

  @override
  String get gizlilikMadde3Icerik => '使用语音指令时，您的语音将即时转换为文本。音频录音不会被永久存储。';

  @override
  String get gizlilikMadde4Baslik => '4. 第三方服务';

  @override
  String get gizlilikMadde4Icerik => 'Firebase 和 Google AdMob 基础架构用于性能分析和广告展示。';

  @override
  String get anladim => '我知道了';

  @override
  String get stilVeModaTercihleriniz => '风格与时尚偏好';

  @override
  String get stilModalAciklama => 'AI 在生成穿搭时将优先考虑这些风格和剪裁偏好。';

  @override
  String get favoriTarzinizUst => '偏好风格';

  @override
  String get giyimKesimiFitUst => '服装版型 / 剪裁';

  @override
  String get hesapSilmeUst => '注销账户';

  @override
  String get tumBulutVeYerelVeriTemizlenir => '清除您所有的本地和云端数据';

  @override
  String get hakkindaUst => '关于';

  @override
  String get topluFotografEkleTooltip => '批量添加衣物';

  @override
  String get kuponKoduKullanTitle => '使用兑换码';

  @override
  String get kuponKoduAciklama => '在下方输入您的兑换码以获取额外的穿搭额度：';

  @override
  String get kuponKoduHint => '例如：VIP2026';

  @override
  String get kuponKullanButon => '兑换';

  @override
  String get kuponBasariliMesaji => '🎉 兑换码使用成功！穿搭额度已增加。';

  @override
  String get kuponKullanilmisUyari => '⚠️ 您已经使用过该兑换码了！';

  @override
  String get kuponGecersizUyari => '❌ 兑换码无效！请重试。';

  @override
  String get sinirsizIslemHakkiBaslik => '无限额度 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return '剩余额度：$hak ⚡';
  }

  @override
  String get sinirsizHakAciklama => '享受会员特权的无限穿搭生成与风格分析。';

  @override
  String get gunlukHakAciklama => '每日免费额度会在每天 00:00 重置。您可以观看广告或使用兑换码获取更多额度。';

  @override
  String get kuponKullan => '输入兑换码';

  @override
  String get hakEklendiTebrikler => '恭喜！已增加 +3 次额度。 ✨';

  @override
  String get gardirobunDolduTitle => '衣橱已满！';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return '您已达到 $limit 件衣物的上限。观看一段短视频即可将衣橱容量扩大 +3 件？ 👕';
  }

  @override
  String get reklamIzleSlotEkle => '观看广告（+3 个容量）';

  @override
  String get yeniSlotEklendiTebrikler => '恭喜！您的衣橱已成功扩展 +3 个新位置。 🎉';

  @override
  String get gunlukHakBittiTitle => '已达今日上限！';

  @override
  String get gunlukHakBittiIcerik => '您已用完今天的免费操作额度。观看视频或输入兑换码即可获取新额度！ 🛍️';

  @override
  String get kuponGir => '输入兑换码';

  @override
  String get anaSemsiyeBildirimBaslik => '别忘了带伞！ ☔';

  @override
  String get anaSemsiyeBildirimIcerik => '今天看起来有雨，记得选择适合雨天的穿搭哦。';

  @override
  String get anaCamasirGunuBildirimBaslik => '洗衣日到了！ 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik => '脏衣篮里的衣服堆积不少了，是时候开动洗衣机啦！';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ 这件单品应该怎么搭配？ ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return '您的搭配已生成 ($ortam)';
  }

  @override
  String get chatKombiniGorButon => '查看搭配';

  @override
  String get chatStilistKombinTasarlayor => '造型师正在设计搭配...';

  @override
  String get chatStilistYaziyor => '造型师正在输入...';

  @override
  String get pazartesi => '星期一';

  @override
  String get sali => '星期二';

  @override
  String get carsamba => '星期三';

  @override
  String get persembe => '星期四';

  @override
  String get cuma => '星期五';

  @override
  String get cumartesi => '星期六';

  @override
  String get pazar => '星期日';

  @override
  String get rehberiAtla => '跳过指南';

  @override
  String get rehberAnladimBasla => '明白了，开始吧！';

  @override
  String get rehberSonrakiAdim => '下一步 ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik => '📸 数字衣橱管理';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      '点击此按钮拍照或从相册上传，构建您的专属虚拟衣橱。';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ 语音穿搭助手';

  @override
  String get rehberSesliAsistanAciklama => '使用语音指令询问穿搭建议或即时获取推荐。';

  @override
  String get rehberAiStilistBaslik => '✨ AI 造型师推荐';

  @override
  String get rehberAiStilistAciklama => '一键根据天气、肤色和风格偏好获取量身定制的穿搭方案。';

  @override
  String get rehberAyarlarBaslik => '⚙️ 个性化与设置';

  @override
  String get rehberAyarlarAciklama => '自定义性别、肤色、偏好色彩与主题，或重新查看新手引导。';

  @override
  String get rehberNavGardirobumBaslik => '👔 我的衣橱';

  @override
  String get rehberNavGardirobumAciklama => '按分类轻松查看、筛选和管理您的所有衣物。';

  @override
  String get rehberNavHaftalikBaslik => '📅 每周规划师';

  @override
  String get rehberNavHaftalikAciklama => '根据 7 天天气预报提前规划每日穿搭。';

  @override
  String get rehberNavDolaptanBaslik => '🤖 衣橱 AI 智能生成';

  @override
  String get rehberNavDolaptanAciklama => '让 AI 用您现有的衣物自动生成契合当天的穿搭。';

  @override
  String get rehberNavKendiBaslik => '🎨 自由组合 DIY';

  @override
  String get rehberNavKendiAciklama => '手动搭配上衣、下装和鞋履，打造并保存您独特的造型。';

  @override
  String get rehberNavProfilBaslik => '📊 分析与洗衣';

  @override
  String get rehberNavProfilAciklama => '查看衣物穿搭频率统计，管理脏衣篮中的待洗物品。';

  @override
  String get bildirimIzinGerekliBaslik => '需要通知权限';

  @override
  String get bildirimIzinGerekliIcerik => '我们建议开启通知权限，以便接收洗衣提醒、降雨预警和每日穿搭灵感。';

  @override
  String get bildirimGunaydinBaslik => '早上好！ ☀️';

  @override
  String get bildirimGunaydinIcerik => '我为您准备了非常适合今天天气的穿搭，要来看看吗？';

  @override
  String get bildirimKanalGenelBaslik => '常规通知';

  @override
  String get bildirimKanalGenelAciklama => 'FitCheck 常规更新与通知';

  @override
  String get bildirimKanalGunlukBaslik => '每日穿搭推荐';

  @override
  String get bildirimKanalGunlukAciklama => '每日穿搭推荐提醒';

  @override
  String get bildirimKanalYikamaBaslik => '洗衣提醒';

  @override
  String get bildirimKanalYikamaAciklama => '衣物洗涤追踪与保养提醒';

  @override
  String get bildirimKanalRaporBaslik => '每周风格报告';

  @override
  String get bildirimKanalRaporAciklama => '每周衣橱使用与风格总结';

  @override
  String get tenRengiAcik => '白皙 / 偏白';

  @override
  String get tenRengiBugday => '自然肤色 / 暖小麦';

  @override
  String get tenRengiEsmer => '健康小麦 / 深色';

  @override
  String get stilStreetwear => '街头潮牌 / 休闲';

  @override
  String get stilKlasik => '经典 / 正装';

  @override
  String get stilMinimalist => '极简';

  @override
  String get stilSpor => '运动 / 运动休闲风';

  @override
  String get stilVintage => '复古 / 怀旧';

  @override
  String get fitSlim => '修身 (Slim Fit)';

  @override
  String get fitRegular => '合身 / 标准 (Regular)';

  @override
  String get fitOversize => '宽松 / 廓形 (Oversize)';

  @override
  String get gardirobumBosBaslik => '您的衣橱空空如也！';

  @override
  String get gardirobumGizlendiBaslik => '衣橱内容已隐藏';

  @override
  String get gardirobumGizlendiAciklama => '点击右上角的眼睛图标即可显示内容';

  @override
  String get gardirobumGoster => '显示内容';

  @override
  String get gardirobumGizle => '隐藏内容';

  @override
  String get kategoriUst => '上衣';

  @override
  String get kategoriAlt => '下装';

  @override
  String get kategoriAyakkabi => '鞋履';

  @override
  String get kategoriAksesuar => '配饰';

  @override
  String get gardirobumBosAciklama => '现在就添加您的第一件衣物，感受 AI 的魔法吧。';

  @override
  String get gardirobumAiIslem1 => '正在分析您的衣橱...';

  @override
  String get gardirobumAiIslem2 => '正在检查天气状况...';

  @override
  String get gardirobumAiIslem3 => '正在计算色彩搭配度...';

  @override
  String get gardirobumAiIslem4 => '正在挑选最佳穿搭...';

  @override
  String get gardirobumAiIslem5 => '正在完成细节...';

  @override
  String get gardirobumHakBittiBaslik => '已达今日上限';

  @override
  String get gardirobumHakBittiAciklama => '您已达到今天的穿搭创建上限。';

  @override
  String get gardirobumHakEklendiMesaj => '恭喜，获得新的穿搭额度！';

  @override
  String get ayarlariAc => '打开设置';

  @override
  String get kiyafetEkle => '添加衣物';

  @override
  String get kameraIleCek => '拍照添加';

  @override
  String get galeridenSecToplu => '从相册批量选择';

  @override
  String get kameraIzniGerekliBaslik => '需要相机权限';

  @override
  String get kameraIzniGerekliAciklama => '请开启相机权限以拍照添加衣物。';

  @override
  String get kiyafetDuzenleBaslik => '编辑衣物';

  @override
  String get kategori => '分类';

  @override
  String get evetSil => '是的，删除';

  @override
  String get favorilerdenCikarildi => '已从收藏中移除';

  @override
  String get gardirobumHenuzYokEkle => '暂未添加任何衣物，现在就添加一件吧！';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return '单次最多可选择 $max 张照片。';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '共 $count 件物品';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '契合度 %$oran';
  }

  @override
  String get kombinSohbetAc => '聊聊这套搭配';

  @override
  String get kombinSohbetBaslik => '搭配对话';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return '关于$gun搭配的对话';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return '我们一起来看看你的「$kombin」搭配吧！配色、天气或替换单品，想问什么都可以。✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 这套搭配为什么协调？';

  @override
  String get kombinSohbetOneriAlternatif => '👟 推荐一件替换单品';

  @override
  String get kombinSohbetOneriHava => '🌦️ 天气变了怎么穿？';

  @override
  String get kombinSohbetOneriAksesuar => '💍 给我配饰建议';

  @override
  String get kombinSohbetAltBaslikAnlik => '关于即时穿搭的对话';

  @override
  String get chatKirliSepetiBos => '🧺 脏衣篮是空的！所有单品都可以随时穿，我随时可以帮你搭配。✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 脏衣篮里有 **$sayi** 件待洗单品：';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      '这些单品在洗净之前不会出现在搭配建议中。需要的话，我现在就可以用干净的单品为你搭配一套。';

  @override
  String get analitikVerileriPaylas => '共享分析数据';

  @override
  String get analitikVerileriPaylasAciklama =>
      '为改进应用体验会发送匿名使用数据。关闭后，本机存储的分析数据将被删除。';

  @override
  String get chatKarsilamaHavaYok => '您好！👋 要不要来搭配一套适合您风格的穿搭？✨';

  @override
  String get premiumBaslik => '风格无限制，零广告';

  @override
  String get premiumAciklama => '无限制使用搭配和风格分析，并通过一次订阅移除所有广告。';

  @override
  String get premiumOzellikReklamsiz => '移除所有广告';

  @override
  String get premiumOzellikAylik => '每月自动续订';

  @override
  String get premiumOzellikMagaza => '通过 Google Play 管理';

  @override
  String get premiumAktifMesaji => 'Premium 已生效。无限使用且无广告。';

  @override
  String get premiumAboneOl => '订阅';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return '订阅 • $fiyat';
  }

  @override
  String get premiumGeriYukle => '恢复购买';

  @override
  String get premiumMagazaHazirDegil => 'Google Play 目前不可用，请重试。';

  @override
  String get premiumSatinAlmaBaslatilamadi => '无法启动购买。';

  @override
  String get premiumSatinAlmaBasarisiz => '购买失败。';

  @override
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return '无限制搭配 • 每月 $fiyat';
  }

  @override
  String premiumGec(String fiyat) {
    return '无限使用 • $fiyat/月';
  }

  @override
  String get guncellemeBaslik => '需要更新';

  @override
  String get guncellemeAciklama => 'FitCheck 有新版本可用。请更新应用以继续。';

  @override
  String get guncellemeButonu => '立即更新';

  @override
  String guncellemeYeniSurum(String surum) {
    return '新版本：$surum';
  }

  @override
  String get guncellemeMagazaUrlYok => '无法打开商店链接。请从商店更新应用。';

  @override
  String get premiumUrunBulunamadi => '无法加载订阅信息，请稍后重试。';

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
  String get kombinOyunuBaslik => '搭配游戏';

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
  String get degerlendirmeBaslik => '你喜欢FitCheck吗？';

  @override
  String get degerlendirmeIcerik =>
      '如果你喜欢这个应用，能花5秒给我们留个评价吗？小小的评价是很大的支持！⭐ 评价的用户可获得+3免费积分作为礼物！';

  @override
  String get degerlendirmeEvet => '好的，我来评价';

  @override
  String get degerlendirmeBelkiSonra => '以后再说';

  @override
  String get yakinda => '即将推出';

  @override
  String get yakindaAciklama => '我们正在开发这个功能，很快就会与大家见面！';

  @override
  String get aiOneriHazirlaniyor => '正在准备建议...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi => '无法准备造型师建议，请重试。';

  @override
  String get haftalikAiServisHatasi => '无法连接 AI 服务，请检查网络后重试。';

  @override
  String get haftalikAiGecerliPlanYok => 'AI 未返回有效的计划，请重试。';

  @override
  String get haftalikPlanBeklenmeyenHata => '创建计划时发生意外错误，请重试。';

  @override
  String get haftalikBugunGiyildi => '今天的穿搭已经穿过，未创建新的穿搭。';

  @override
  String get girisHataKullaniciAdiKisa => '请输入至少 3 个字符';

  @override
  String get girisHataEpostaGecersiz => '请输入有效的邮箱';

  @override
  String get girisHataSifreKisa => '请输入至少 6 个字符';

  @override
  String get googleKullanicisi => 'Google 用户';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => '🌐 选择语言';

  @override
  String get dilSecenekOtomatik => '自动（设备语言）';

  @override
  String get kapat => '关闭';

  @override
  String get bildirimBaslik => '通知';

  @override
  String get ayarlarAltbilgi => '用心打造';

  @override
  String get geriBildirimKonu => 'FitCheck 反馈';

  @override
  String get premiumOzelliklerBaslik => 'Premium 解锁的内容';

  @override
  String get premiumOzellikSinirsizKombin => '无限制搭配生成';

  @override
  String get premiumOzellikSinirsizAnaliz => '无限制 AI 风格分析';

  @override
  String get premiumOzellikSinirsizGardirob => '无限制衣橱空间';

  @override
  String get premiumPlanAylik => '按月';

  @override
  String get premiumPlanYillik => '按年';

  @override
  String get premiumEnAvantajli => '最超值';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return '省 $yuzde%';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun 天免费';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return '之后 $fiyat';
  }

  @override
  String get premiumYenilemeNotu => '订阅将在每个周期结束时自动续订。可随时取消。';

  @override
  String get kiyafetDondur => '旋转';
}
