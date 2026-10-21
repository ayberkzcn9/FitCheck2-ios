// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get chatOrtamCasual => 'カジュアル';

  @override
  String get chatOrtamOfis => 'オフィス';

  @override
  String get chatOrtamDavet => 'パーティー';

  @override
  String get chatOrtamSpor => 'スポーツ';

  @override
  String get chatOrtamGece => 'ナイト';

  @override
  String get chatOrtamRomantik => 'ロマンチック';

  @override
  String get chatOrtamHaftaSonu => '週末';

  @override
  String get gardirobumAdimArkaplan => '背景を削除中';

  @override
  String get gardirobumAdimArkaplanAlt => 'AIで画像を解析中';

  @override
  String get gardirobumAdimAnaliz => '衣類を解析中';

  @override
  String get gardirobumAdimAnalizAlt => '色・スタイル・カテゴリを判定中';

  @override
  String get gardirobumAdimKaydet => '保存中';

  @override
  String get gardirobumAdimKaydetAlt => 'ワードローブに追加中';

  @override
  String get gardirobumLutfenBekleyin => 'お待ちください...';

  @override
  String get authHataZayifSifre => 'パスワードが弱すぎます。6文字以上にしてください。';

  @override
  String get authHataEpostaKullanimda => 'このメールアドレスはすでに使用されています。';

  @override
  String get authHataGecersizEposta => '無効なメールアドレスを入力しました。';

  @override
  String get authHataKullaniciBulunamadi => 'このメールアドレスのユーザーが見つかりません。';

  @override
  String get authHataYanlisSifre => 'パスワードが正しくありません。もう一度お試しください。';

  @override
  String get authHataGecersizKimlik => 'メールアドレスまたはパスワードが正しくありません。ご確認ください。';

  @override
  String get authHataYontemIzinliDegil => 'このログイン方法はFirebaseコンソールで有効になっていません。';

  @override
  String get authHataFarkliYontem => 'このメールアドレスは別のログイン方法ですでに登録されています。';

  @override
  String get authHataAgHatasi => 'インターネット接続を確認してもう一度お試しください。';

  @override
  String get authHataCokDeneme => '試行回数が多すぎます。しばらくしてからお試しください。';

  @override
  String get authHataHesapDevreDisi => 'このアカウントは無効化されています。';

  @override
  String get authHataYenidenGiris => 'この操作を行うには再度ログインが必要です。';

  @override
  String get authHataGenel => 'エラーが発生しました。もう一度お試しください。';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'パスワード再設定メールを送信できませんでした。もう一度お試しください。';

  @override
  String get authHataGoogleDogrulanamadi =>
      'Googleログインを確認できませんでした。もう一度お試しください。';

  @override
  String get authHataGoogleFarkliKullanici => 'このGoogleアカウントは別のユーザーにリンクされています。';

  @override
  String get authHataGoogleZatenBagli => 'このGoogleアカウントはすでにリンクされています。';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'この端末ではGoogleログインが設定されていません。サポートにご連絡ください。';

  @override
  String get authHataGooglePencereAcik =>
      'Googleログイン画面がまだ開いています。数秒待って再試行してください。';

  @override
  String get authHataGoogleTamamlanamadi =>
      'Googleログインを完了できませんでした。数秒後にもう一度お試しください。';

  @override
  String get authHataGoogleHesapSec => 'ログインするにはGoogleアカウントを選択してください。';

  @override
  String get authHataGoogleOnayBekliyor =>
      'Googleアカウントに保留中の操作があります。もう一度お試しください。';

  @override
  String get authHataGoogleBeklenmeyen => 'Googleログイン中に予期しないエラーが発生しました。';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => '外観とテーマ';

  @override
  String get karanlikMod => 'ダークモード';

  @override
  String get koyuTemaAktif => 'ダークテーマ有効';

  @override
  String get acikTemaAktif => 'ライトテーマ有効';

  @override
  String get dilAyarlari => '言語と地域の設定';

  @override
  String get uygulamaDili => 'アプリの言語';

  @override
  String get hakkinda => 'アプリについて';

  @override
  String get surum => 'バージョン';

  @override
  String get ayarOtomatikCihazDili => '🌐 自動（端末の言語設定）';

  @override
  String get iptal => 'キャンセル';

  @override
  String get tamam => 'OK';

  @override
  String get gardirobumTitle => 'バーチャルワードローブ';

  @override
  String get gardirobumYukleniyor => 'AI解析中...';

  @override
  String get gardirobumTopluEkle => '複数のアイテムを追加';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return '解析中 ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'ワードローブを空にする';

  @override
  String get gardirobumTemizleOnay => 'ワードローブ内のすべてのアイテムが削除されます。よろしいですか？';

  @override
  String get gardirobumEvet => 'はい、すべて削除します';

  @override
  String get gardirobumHataMesaji => 'アイテムの追加中にエラーが発生しました。';

  @override
  String get gardirobumKategoriTumu => 'すべて';

  @override
  String get gardirobumKategoriUst => 'トップス';

  @override
  String get gardirobumKategoriAlt => 'ボトムス';

  @override
  String get gardirobumKategoriAyakkabi => 'シューズ';

  @override
  String get gardirobumKategoriAksesuar => 'アクセサリー';

  @override
  String get gardirobumBosKategori => 'このカテゴリーにアイテムは見つかりませんでした。';

  @override
  String get gardirobumGiymeSayisi => '着用回数：';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'コスト：₺$tutar / コーデ';
  }

  @override
  String get gardirobumDolabaAl => 'クローゼットに戻す';

  @override
  String get gardirobumSepeteAt => 'ランドリーかごに入れる';

  @override
  String get gardirobumSepetteRozet => '洗濯待ち';

  @override
  String get gardirobumGecersizParcaBaslik => '無効なアイテムが検出されました';

  @override
  String get gardirobumGecersizParcaIcerik =>
      '画像から衣類、靴、アクセサリーが検出されませんでした（木製品、家具、生活用品、または不適切なオブジェクトが検出されました）。衣類アイテムのみをアップロードしてください。';

  @override
  String get gardirobumTamam => 'OK';

  @override
  String get stilistTitle => 'インスタントAIスタイリスト';

  @override
  String get gunlukKombinTitle => 'DEIRI KOODE';

  @override
  String get gunlukKombinHazirBaslik => 'コーデを作りましょう';

  @override
  String get gunlukKombinHazirIcerik => 'サイコロを振ったり、スマホを振って今日のコーデを作りましょう。';

  @override
  String get gunlukKombinKartBaslik => '今日のコーデ';

  @override
  String get stilistAnlikHavaDurumu => '現在の天気（タップして更新）';

  @override
  String get stilistKonumKontrol => '位置情報を確認中...';

  @override
  String get stilistNereyeGidiyorsun => 'どこへ行きますか？';

  @override
  String get stilistDusunuyor => 'スタイリストが考え中...';

  @override
  String get stilistBugunNeGiymeliyim => '今日のおすすめコーデは？';

  @override
  String get stilistKombiniTemizle => 'コーデをクリア';

  @override
  String stilistKombininTitle(Object ortam) {
    return '$ortamスタイルのコーデ';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 マッチ度：%$puan';
  }

  @override
  String get stilistUstGiyim => 'トップス';

  @override
  String get stilistAltGiyim => 'ボトムス';

  @override
  String get stilistAyakkabi => 'シューズ';

  @override
  String get stilistAksesuar => 'アクセサリー';

  @override
  String get stilistFavoriyeEkle => 'お気に入りに追加';

  @override
  String get stilistBugunGiydim => '今日着用した';

  @override
  String get bugunGiydimOnayIcerik => '今日はこのコーディネートを着ましたか？';

  @override
  String get stilistTrendyolTamamla => 'Trendyolで検索';

  @override
  String get stilistHata => 'コーデの作成中にエラーが発生しました。';

  @override
  String get ortamCasual => 'カジュアル / 日常';

  @override
  String get ortamOfis => 'オフィス / ビジネス';

  @override
  String get ortamDavet => '結婚式 / イベント';

  @override
  String get ortamSpor => 'スポーツ / ワークアウト';

  @override
  String get ortamGece => 'ナイトアウト';

  @override
  String get ortamRomantik => 'デート';

  @override
  String get stilistUyariDolapBosBaslik => 'ワードローブが空か、服がすべて洗濯中です！ 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'パーソナライズされたコーデ提案を受けるには、クローゼットに清潔な衣類やアクセサリーを追加してください。';

  @override
  String get stilistUyariUstEksikBaslik => 'トップスが足りません！ 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'クローゼットに清潔なトップスがありません。コーデを完成させるために少なくとも1つのトップスを追加してください！';

  @override
  String get stilistUyariAltEksikBaslik => 'ボトムスが足りません！ 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'クローゼットに清潔なボトムスがありません。おしゃれなスタイルを作るためにボトムスを追加してください！';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'シューズが足りません！ 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      '素敵なコーデですが、合わせる清潔なシューズが見つかりません。今すぐシューズを追加しましょう！';

  @override
  String get stilistUyariButon => '了解、追加します！';

  @override
  String get anaHavaYukleniyor => '地域の天気を読み込み中...';

  @override
  String get anaDinliyor => '🎙️ FITCHECKが聞き取り中... 話しかけてください！';

  @override
  String get anaMikrofonHata => 'マイクの権限または音声認識サービスが準備できていません。';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return '設定が更新されました：「$cinsiyet」✨';
  }

  @override
  String get anaKonumKapaliBaslik => '位置情報サービスがオフです';

  @override
  String get anaKonumKapaliIcerik =>
      '天気に合わせたコーディネート提案を受けるには、GPS位置情報を有効にしてください。';

  @override
  String get anaKonumuAc => '位置情報を有効にする';

  @override
  String get anaIzinVer => '許可する';

  @override
  String get anaIptal => 'キャンセル';

  @override
  String get anaKonumIzinRedBaslik => '位置情報の権限が拒否されました';

  @override
  String get anaKonumIzinRedIcerik1 => '権限が与えられていないため、天気情報を取得できません。';

  @override
  String get anaKonumIzinRedIcerik2 => 'システム設定で権限を有効にする必要があります。';

  @override
  String get anaKonumIzinGerekliBaslik => '位置情報の権限が必要です';

  @override
  String get anaKonumIzinGerekliIcerik => '天気予報を読み込むには、設定で位置情報の権限を有効にしてください。';

  @override
  String get anaHavaDurumuAlinamadi => '天気情報を取得できませんでした';

  @override
  String get anaHavaTahminiYuklenemedi => '天気予報を読み込めませんでした。';

  @override
  String get anaFavoriEklendi => 'お気に入りに追加しました！ ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ 注意：最近この服または類似のアイテムを頻繁に着ています。今日は別のスタイルを試してみませんか？';

  @override
  String get anaKombinMukemmel => '✨ 素晴らしい選択です！今日のスタイルはとてもバランスが取れています。';

  @override
  String get anaYikamaUyariBaslik => 'スマートランドリー通知';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'このコーデを着用したため、使用頻度の高いアイテム「$parcalar」が自動的にランドリーかごに移動しました！ 🧺';
  }

  @override
  String get anaTamam => 'OK';

  @override
  String get anaAyarlarTooltip => '設定';

  @override
  String get anaKadin => '女性';

  @override
  String get anaErkek => '男性';

  @override
  String get anaSesleKonus => '音声コマンド';

  @override
  String get anaStilistAsistani => 'スタイリストアシスタント';

  @override
  String get anaSekmeGardirop => 'ワードローブ';

  @override
  String get anaSekmeHaftalik => '週間計画';

  @override
  String get anaSekmeAnlik => 'インスタント';

  @override
  String get anaSekmeYarismasi => 'クイズ';

  @override
  String get anaSekmeProfil => 'マイページ・分析';

  @override
  String get modaYarismasiBaslik => 'ファッション＆カラーマッチ';

  @override
  String get modaYarismasiGunlukTamamlandi => '本日のクイズは完了しました';

  @override
  String get modaYarismasiYeniYarin => '新しい5問セットは明日再開します。';

  @override
  String get modaYarismasiSonuc => '結果';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'スコア：$skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return '質問 $index / 10';
  }

  @override
  String get modaYarismasiGeri => '戻る';

  @override
  String get modaYarismasiAnaEkrana => 'ホームに戻る';

  @override
  String get havaParcaliBulutlu => '晴れ時々曇り';

  @override
  String get havaSicakGunesli => '快晴・暑い';

  @override
  String get havaSogukKarli => '極寒・雪';

  @override
  String get havaYagmurlu => '雨';

  @override
  String get havaGunesli => '晴れ';

  @override
  String get havaSoguk => '肌寒い';

  @override
  String get gunPzt => '月曜日';

  @override
  String get gunSal => '火曜日';

  @override
  String get gunCar => '水曜日';

  @override
  String get gunPer => '木曜日';

  @override
  String get gunCum => '金曜日';

  @override
  String get gunCmt => '土曜日';

  @override
  String get gunPaz => '日曜日';

  @override
  String get stilKahveBaslik => '☕ カフェ＆カジュアル';

  @override
  String get stilKahveSoru => '友達とカフェに行くためのカジュアルでおしゃれなコーデを提案して';

  @override
  String get stilOfisBaslik => '💼 オフィス＆スマートビジネス';

  @override
  String get stilOfisSoru => 'オフィスワークに適した洗練されたシックなコーデを提案して';

  @override
  String get stilSporBaslik => '🏃 アクティブ＆スポーツ';

  @override
  String get stilSporSoru => '週末のお出かけにぴったりな快適でスポーティなコーデを提案して';

  @override
  String get stilGeceBaslik => '🌙 ナイトアウト＆ドレスアップ';

  @override
  String get stilGeceSoru => 'ディナーや特別なイベントのための華やかなコーデを提案して';

  @override
  String get ilkGorevBaslik => '🎯 最初のステップ：スタイルを選びましょう！';

  @override
  String get ilkGorevAciklama =>
      'FitCheck AIが即座にコーディネートを作成します。今日のお出かけ先はどちらですか？';

  @override
  String get haftalikUyariButon => '了解';

  @override
  String get haftalikUyariDolapBosBaslik => 'ワードローブが空です！';

  @override
  String get haftalikUyariDolapBosIcerik =>
      '1週間の計画を立てるには、クローゼットに服を追加する必要があります。';

  @override
  String get haftalikUyariUstEksikBaslik => 'トップスが足りません！';

  @override
  String get haftalikUyariUstEksikIcerik => 'クローゼットに清潔なトップスがありません。';

  @override
  String get haftalikUyariAltEksikBaslik => 'ボトムスが足りません！';

  @override
  String get haftalikUyariAltEksikIcerik => 'クローゼットに清潔なボトムスがありません。';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'シューズが足りません！';

  @override
  String get haftalikUyariAyakkabiEksikIcerik => 'クローゼットに清潔なシューズがありません。';

  @override
  String get haftalikHata => '週間計画の作成中にエラーが発生しました。';

  @override
  String get haftalikAjandaTitle => 'ウィークリースタイルプランナー';

  @override
  String get haftalikAnlikHavaDurumu => '今週の天気予報';

  @override
  String get haftalikKonumKontrol => '天気情報を読み込み中...';

  @override
  String get haftalikTemizParca => '清潔なアイテム';

  @override
  String get haftalikSepette => '洗濯待ち';

  @override
  String get haftalikPlanAciklama => '天気に合わせてAIに7日間のコーディネートを計画させましょう。';

  @override
  String get haftalikProgramOlustur => '週間プランを作成';

  @override
  String get haftalikPlaniTemizle => 'プランをクリア';

  @override
  String get haftalikAnalizEdiliyor => 'AIが計画中...';

  @override
  String get haftalikUyum => 'マッチ度';

  @override
  String get haftalikFavoriEkle => 'お気に入りに追加';

  @override
  String get haftalikGiyildiIsaretle => '今日着用した';

  @override
  String get haftalikHava => '天気：';

  @override
  String get haftalikHavaUyarisi => 'メモ：その日の天気に合わせて、このコーデの一部アイテムを変更しました。';

  @override
  String get haftalikUyumsuzParca => '足りないアイテム';

  @override
  String get haftalikEksikParcaStilistNotu =>
      '足りないアイテムを踏まえて、手持ちの清潔なアイテムでスタイリストが提案を作成しました。';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'この日のコーデに必要な清潔なアイテムが足りません。新しいアイテムを追加するか洗濯をすると、スタイリストがここに新しいコーデを提案します。';

  @override
  String get haftalikEksikParcaAiOnerisi => 'AIコーデ提案';

  @override
  String get haftalikEksikParcaOneriYok =>
      'プランを更新すると、不足しているアイテムを補うトップス・ボトムス・シューズの組み合わせが表示されます。';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'AIスタイリストのコーデ提案';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor => 'スタイリストがコーデを提案しています…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'トップスとボトムスがないとコーデは作れません。スタイリストが上に提案を用意しました。';

  @override
  String get haftalikNot => 'メモ';

  @override
  String get haftalikTrendyolAra => 'Trendyolで検索';

  @override
  String get izinZorunluMesaj => 'アプリを使用するにはこれらの権限が必要です。';

  @override
  String get izinGerekliBaslik => '必要な権限';

  @override
  String get izinGerekliIcerik => 'カメラおよび位置情報へのアクセス権限が拒否されました。設定で有効にしてください。';

  @override
  String get ayarlaraGit => '設定を開く';

  @override
  String get izinAnaBaslik => 'アクセス権限の要求';

  @override
  String get izinAciklama => '最適なコーディネート提案を提供するために、位置情報（天気）とカメラ（写真撮影）の権限が必要です。';

  @override
  String get konumIzni => '位置情報の権限';

  @override
  String get kameraIzni => 'カメラの権限';

  @override
  String get izinVerDevamEt => '許可して続行';

  @override
  String get gunlukHavaMevcutDegil => '天気データを利用できません';

  @override
  String get profilAnalizTitle => 'マイページ・分析';

  @override
  String get anlikDurum => '現在のステータス';

  @override
  String get toplamParca => '総アイテム数';

  @override
  String get favoriKombin => 'お気に入りコーデ';

  @override
  String get gardiropDegeri => '総クローゼット価値';

  @override
  String get ortalamaMaliyet => '平均着用コスト';

  @override
  String get kategoriDagilimi => 'カテゴリー別割合';

  @override
  String get ustGiyim => 'トップス';

  @override
  String get altGiyim => 'ボトムス';

  @override
  String get ayakkabi => 'シューズ';

  @override
  String get disGiyim => 'アウター';

  @override
  String get aksesuar => 'アクセサリー';

  @override
  String get sonGiyecekGecmisi => '最近の着用履歴';

  @override
  String get kayit => '記録';

  @override
  String get gecmisKombinYok => '着用履歴はまだありません。';

  @override
  String get parca => '点';

  @override
  String get onboardingHosGeldinBaslik => 'FitCheckへようこそ！ ✨';

  @override
  String get onboardingDolabiniDijitallestir => 'ワードローブをデジタル化';

  @override
  String get onboardingDolapAciklama => '数秒で服を追加して、あなただけのバーチャルワードローブを作成しましょう。';

  @override
  String get onboardingHavaDurumu => '天候に応じた提案';

  @override
  String get onboardingHavaAciklama => 'お住まいの地域の毎日の天気に合わせたコーディネート提案を受け取れます。';

  @override
  String get onboardingYikama => 'スマートな洗濯管理';

  @override
  String get onboardingYikamaAciklama => '頻繁に着た服を自動的に検出し、洗濯待ちに移動させます。';

  @override
  String get onboardingEksikParca => '不足アイテムの提案';

  @override
  String get onboardingEksikAciklama => 'コーデを完成させるための足りない服を特定し、買い足しアイデアを提供します。';

  @override
  String get onboardingAnalitik => '詳細な分析';

  @override
  String get onboardingAnalitikAciklama =>
      'クローゼットの総価値、着用1回あたりのコスト、好みの傾向を分析します。';

  @override
  String get onboardingStilist => 'AIスタイリストアシスタント';

  @override
  String get onboardingStilistAciklama => '行き先を伝えるだけで、AIが数秒で完璧なコーディネートを用意します。';

  @override
  String get onboardingAtla => 'スキップ';

  @override
  String get onboardingModaProfiliniz => 'あなたのファッションプロファイル';

  @override
  String get onboardingKadin => '女性';

  @override
  String get onboardingErkek => '男性';

  @override
  String get onboardingBasla => '始める';

  @override
  String get onboardingDevamEt => '次へ';

  @override
  String get cinsiyetBaslik => '性別';

  @override
  String get tarzBaslik => 'デイリースタイル（複数選択可）';

  @override
  String get renkTercihiBaslik => '好みのカラーパレット';

  @override
  String get tenRengiBaslik => 'パーソナルカラー / 肌のトーン';

  @override
  String get kadin => '女性';

  @override
  String get erkek => '男性';

  @override
  String get cinsiyetBelirtilmemis => '指定しない';

  @override
  String get tarzSpor => 'スポーティ';

  @override
  String get tarzKlasik => 'クラシック';

  @override
  String get tarzSokakModasi => 'ストリートウェア';

  @override
  String get tarzMinimalist => 'ミニマル';

  @override
  String get renkKoyuTonlar => 'ダーク系';

  @override
  String get renkPastel => 'パステルカラー';

  @override
  String get renkCanli => 'ビビッドカラー';

  @override
  String get renkNotr => 'モノトーン・ニュートラル';

  @override
  String get tenAcikBeyaz => '色白 / 明るい肌';

  @override
  String get tenBugday => '標準的な肌 / 健康的な肌';

  @override
  String get tenEsmerKoyu => '小麦色 / 色黒';

  @override
  String get hesabinizaGirisYapin => 'アカウントにログイン';

  @override
  String get yeniHesapOlusturun => '新規アカウント作成';

  @override
  String get stilDunyanaTekrarHosGeldin => 'おかえりなさい！ファッションの世界へ ✨';

  @override
  String get kombinleriniSaklamakIcinKatil => 'コーデを保存・同期するために登録しましょう 🚀';

  @override
  String get girisYap => 'ログイン';

  @override
  String get girisYapGoogle => 'Google でログイン';

  @override
  String get girisBeniHatirla => 'ログイン情報を保存';

  @override
  String get girisVeya => 'または';

  @override
  String get kayitOl => '新規登録';

  @override
  String get adinizVeyaLakabiniz => 'お名前またはニックネーム';

  @override
  String get epostaAdresiniz => 'メールアドレス';

  @override
  String get sifreniz => 'パスワード';

  @override
  String get girisYapVeBasla => 'ログインして始める';

  @override
  String get kayitOlVeBasla => '登録して始める';

  @override
  String get misafirOlarakDevamEt => 'ゲストとして試す';

  @override
  String get lutfenEpostaVeSifreGiriniz => 'メールアドレスとパスワードを入力してください。';

  @override
  String get lutfenAdiniziGiriniz => 'お名前を入力してください。';

  @override
  String get kullanimKosullariBaslik => '利用規約およびサービス契約';

  @override
  String get onaylamakIcinKaydirin => '同意するには最後までスクロールしてください';

  @override
  String get okudumAnladimKabulEdiyorum => '内容を確認し、同意します';

  @override
  String get kullanimKosullarini => '利用規約';

  @override
  String get okudumVeOnayliyorum => 'に同意します。';

  @override
  String get onaylamadanOnceKosullariOkuyun => '同意する前に利用規約をお読みください。';

  @override
  String get devamEtmekIcinKosullariKabulEdin => '続行するには利用規約に同意する必要があります。';

  @override
  String get kullanimKosullariMetni =>
      'FITCHECK 利用規約およびサービス契約\n\n最終更新日：2026年8月27日\n\nFitCheckモバイルアプリケーション（以下「本アプリ」）をご利用になる前に、本利用規約（以下「本契約」）をよくお読みください。本アプリをダウンロード、アクセス、または使用することにより、本契約のすべての条件に拘束されることに同意したとみなされます。\n\n1. 当事者および目的\n本契約は、FitCheckアプリのデベロッパーと、本アプリをダウンロードして使用する個人ユーザー（以下「ユーザー」）との間で締結されます。本アプリは、デジタルワードローブ管理、衣類追跡、天候に応じたコーディネート提案、AIによるスタイルコンサルティングを提供します。\n\n2. サービス範囲および利用条件\n・年齢制限：本アプリを使用するには13歳以上である必要があります。\n・ユーザー情報：プロファイル設定時に入力された名前、性別、スタイル、色の好みの正確性についてはユーザー自身が責任を負います。\n・アドバイスの性質：AIによって提供されるスタイルスコア、購入提案、洗濯リマインダーは参考情報に過ぎません。\n・気象データ：天気予報はリアルタイムの位置情報に基づいて取得されます。社はその不一致に対して責任を負いません。\n\n3. 知的財産権およびコンテンツ権利\nアップロードした服の写真の知的財産権はユーザーに帰属します。FitCheckのロゴ、デザイン、ソフトウェアコード、アルゴリズムはすべてFitCheckに帰属します。\n\n4. プライバシーおよびデータセキュリティ\nアップロードされた写真およびコーデ履歴は、デフォルトでユーザーの端末内にローカル保存されます。位置情報はリアルタイムの天気リクエストにのみ使用されます。\n\n5. 責任の制限\nFitCheckは中断のないサービスを保証しません。機種変更やアプリ削除によるデータ損失について一切の責任を負いません。\n\n6. お問い合わせ\nご質問がある場合は、設定タブのお問い合わせセクションまたは support@fitcheckapp.com までご連絡ください。\n\n--- 📜 契約終了 ---\n下のボタンを押して利用規約に同意してください。';

  @override
  String chatKarsilama(Object hava) {
    return 'こんにちは！👋 今日の天気は$havaですね。あなたのスタイルに合う素敵なコーデを作りましょうか？✨';
  }

  @override
  String get chatGorselGonderildi => '画像を送信しました。';

  @override
  String get chatAsistanSohbeti => 'アシスタントとのチャット';

  @override
  String get chatModHavaDuyarli => '天気に合わせたスマートなスタイル提案';

  @override
  String get chatStilistHazirliyor => 'スタイリストがコーデを作成中...';

  @override
  String get chatGorselEklendi => '画像が添付されました';

  @override
  String get chatTekrarDene => '再試行';

  @override
  String get chatKamera => 'カメラ';

  @override
  String get chatGaleri => 'ギャラリーから画像を選択';

  @override
  String get chatMikrofon => 'マイク';

  @override
  String get chatGonder => 'メッセージを送信';

  @override
  String get chatOneriYagmur => '🌧️ 雨の日コーディネート';

  @override
  String get chatOneriOfis => '💼 オフィス / スマートカジュアル';

  @override
  String get chatOneriHaftaSonu => '☕ 週末リラックススタイル';

  @override
  String get chatOneriKirliSepeti => '🧺 洗濯かごチェック';

  @override
  String get chatDinleniyor => '聞き取り中...';

  @override
  String get chatBirSeylerYazin => 'アシスタントにメッセージを入力...';

  @override
  String get chatKombiniGiydim => 'このコーデを着ました 👗';

  @override
  String get chatKombinIslendi => '今日のコーデとして記録しました！ 📅';

  @override
  String get chatGorselIncele => 'この画像をチェックしてコーディネートを提案してください。';

  @override
  String get profilAyarlariBaslik => 'プロフィール設定';

  @override
  String get cinsiyetTercihiBaslik => '性別の設定';

  @override
  String get stilAramaHint => '例：「黒ジャケットのスマートカジュアル」「夏ワンピース」...';

  @override
  String get stilFiltreTumu => 'すべてのアイテム';

  @override
  String get stilFiltreSadeceTemizler => '清潔な服のみ';

  @override
  String get stilFiltreSadeceSepet => '洗濯待ちのみ';

  @override
  String get profilFavoriKombinlerTitle => 'お気に入りコーディネート';

  @override
  String get profilFavoriKombinYok => 'お気に入りのコーデはまだ追加されていません。';

  @override
  String get profilYikamaSepetimTitle => 'ランドリーかご';

  @override
  String get profilYikamaSepetimBos => '洗濯かごは空です。すべての服が清潔です！ ✨';

  @override
  String get profilSepetiBosalt => '洗濯かごを空にする';

  @override
  String get profilSepetiBosaltOnay => 'すべてのアイテムが「清潔」としてマークされます。よろしいですか？';

  @override
  String get profilSepetiBosaltButon => 'はい、すべて洗濯済みにする';

  @override
  String get profilTenRengi => '肌のトーン / パーソナルカラー';

  @override
  String get profilTarzTercihi => '好みのスタイル';

  @override
  String get profilRenkPaleti => 'お気に入りカラーパレット';

  @override
  String get rehberGardiropEkleTitle => '写真を追加';

  @override
  String get rehberGardiropEkleDesc => '服の写真を個別に、またはまとめて撮影・アップロードできます。';

  @override
  String get rehberAiStilistTitle => 'AIスタイリストアシスタント';

  @override
  String get rehberAiStilistDesc => 'AIにパーソナライズされたコーデやスタイルのアドバイスを求めましょう。';

  @override
  String get rehberSesliTitle => '音声コマンド';

  @override
  String get rehberSesliDesc => '声で話しかけるだけで、ハンズフリーでコーデ提案を受け取れます。';

  @override
  String get rehberAyarlarTitle => '設定とプロフィール';

  @override
  String get rehberAyarlarDesc => '性別、スタイル、肌のトーンの設定をいつでも更新できます。';

  @override
  String get rehberGardiropNavTitle => 'マイワードローブ';

  @override
  String get rehberGardiropNavDesc => '追加したすべての服をカテゴリー別に整理して閲覧できます。';

  @override
  String get rehberHaftalikNavTitle => 'ウィークリープランナー';

  @override
  String get rehberHaftalikNavDesc => '天気予報に基づいて、7日間のコーデを事前に計画できます。';

  @override
  String get rehberDolaptanNavTitle => 'AIワードローブ生成';

  @override
  String get rehberDolaptanNavDesc => '手持ちの服を使って、その日に合わせた自動コーデを作成します。';

  @override
  String get rehberKendiNavTitle => 'カスタムコーデ作成';

  @override
  String get rehberKendiNavDesc => '手動で服を組み合わせて、自分だけのオリジナルスタイルを作成できます。';

  @override
  String get rehberProfilNavTitle => 'マイページ・分析';

  @override
  String get rehberProfilNavDesc => 'ワードローブの活用度を追跡し、洗濯かごを管理できます。';

  @override
  String get simdilikAtla => '今はスキップ';

  @override
  String get uygulamaIzinleri => 'アプリの権限';

  @override
  String get izinEkraniAciklama =>
      'FitCheckでは、パーソナライズされたコーデ提案や天気・洗濯の通知を提供するために以下の権限が必要です。';

  @override
  String get konumIzniAciklama => 'リアルタイムの天候に応じたコーデ提案のため';

  @override
  String get kameraIzniAciklama => '服の写真を撮影してクローゼットに追加するため';

  @override
  String get bildirimIzni => '通知の権限';

  @override
  String get bildirimIzniAciklama => '洗濯のリマインダーや天気のアラートを受け取るため';

  @override
  String get izinleriVerVeBasla => '権限を許可して始める';

  @override
  String get dahaSonraAyarla => '後で設定する';

  @override
  String get gunlukHakBittiBaslik => '本日の上限に達しました！';

  @override
  String get dahaSonra => '後で';

  @override
  String get reklamIzleHakKazan => '広告を見る (+3クレジット)';

  @override
  String get tebriklerHakEklendi => 'おめでとうございます！+3クレジットが追加されました。 ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return '「$kombinAdi」のマークを解除しました。';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '「$kombinAdi」を今日のコーデとしてマークしました！ 👕✨';
  }

  @override
  String get kiyafetDetayi => '服の詳細';

  @override
  String get parcaDetayiBaslik => 'アイテム詳細';

  @override
  String get farkliParcaSec => '別のアイテムを選択';

  @override
  String get farkliUstSec => '別のトップスを選択 👕';

  @override
  String get farkliAltSec => '別のボトムスを選択 👖';

  @override
  String get farkliAyakkabiSec => '別のシューズを選択 👟';

  @override
  String get farkliDisSec => '別のアウターを選択 🧥';

  @override
  String get baskaTemizKiyafetYok => '変更できる清潔な服が\nこのカテゴリーにありません。';

  @override
  String get planiYenile => 'プランを更新';

  @override
  String get havaEtiketi => '天気';

  @override
  String get yukleniyor => '読み込み中...';

  @override
  String get temizle => 'クリア';

  @override
  String get yenidenDegerlendiriliyor => '再評価中...';

  @override
  String get kombinParcalariBaslik => 'コーデの構成アイテム';

  @override
  String get parcalariKaydirIpucu => '左右にスワイプして他のアイテムを表示 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ このアイテムを中心にコーディネートを作成しました：$parcaAdi！';
  }

  @override
  String get sihirliDokunus => 'マジックシャッフル';

  @override
  String get dolabiKaristirEksikUyari =>
      'シャッフルするには、清潔なトップス、ボトムス、シューズが少なくとも各1点必要です！ 👕👖👟';

  @override
  String get zarlarAtildiYorumu => '🎲 サイコロが振られました！思いがけない素敵な組み合わせが見つかりました。';

  @override
  String get rastgeleKombinTuru => 'ランダム';

  @override
  String get temizAlternatifYok => 'このカテゴリーには選択可能な清潔な服がありません！ 🧺';

  @override
  String get kisiselDokunus => 'カスタム調整';

  @override
  String get aiYeniParcaAnalizEdiyor => 'AIが新しいアイテムを分析中... ✨';

  @override
  String get parcaDegisimVarsayilanYorum => '✨ アイテムを変更したことで、全体の調和がさらに高まりました！';

  @override
  String get parcaDegisimHataYorum => '✨ アイテムの変更により、あなたのスタイルによりフィットしました！';

  @override
  String get bilgileriDuzenleBaslik => '情報を編集';

  @override
  String get kiyafetAdiEtiketi => 'アイテム名';

  @override
  String get renkEtiketi => 'カラー';

  @override
  String get kaydet => '保存';

  @override
  String get yenidenZarAt => 'もう一度サイコロを振る';

  @override
  String get zarAtKaristir => 'サイコロを振る (シャッフル)';

  @override
  String get zarPopupBaslik => '魔法のサイコロを振ろう！';

  @override
  String get zarPopupAciklama =>
      'スマホを振るか下のボタンを押してサイコロを振り、クローゼットからランダムなコーデを作成できます。';

  @override
  String get zarlariAt => 'サイコロを振る';

  @override
  String get zarSalla => 'サイコロを振る';

  @override
  String get degistirmekIcinKaydirIpucu => 'スワイプまたはタップしてアイテムを変更 👈👉';

  @override
  String get favorilerdeEtiketi => 'お気に入り登録済み';

  @override
  String get bugunGiydildiEtiketi => '今日着用 ✨';

  @override
  String get varsayilanKendiAnalizYorumu => '素晴らしいチョイスです！色合いとスタイルの相性が抜群です。';

  @override
  String get kendiTasarimimBaslik => 'マイオリジナルコーデ';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return '$kategoriを選択';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'コーデをデザイン';

  @override
  String get secimleriSifirla => '選択をリセット';

  @override
  String get kombinHazirAiTavsiyesi => '素敵なコーデです！AIで分析して保存しましょう。';

  @override
  String get kombinBaslaIpucu => '今日のおすすめは？まずはアイテムを選んでみましょう。';

  @override
  String get ustAltModu => 'トップス + ボトムス';

  @override
  String get tekParcaElbiseModu => '1ピース（ワンピース/セットアップ）';

  @override
  String get tekParcaElbise => '1ピース / ワンピース';

  @override
  String get aksesuarOpsiyonel => 'アクセサリー（オプション）';

  @override
  String get stilistAnaliziBaslik => 'スタイリスト分析';

  @override
  String get stilistDegerlendiriyor => 'スタイリストが評価中...';

  @override
  String get aiIleAnalizEtKaydet => 'AIで分析して保存';

  @override
  String get bilinmiyor => '不明';

  @override
  String get karmasikSiklik => '洗練されたスタイル';

  @override
  String get gecmisiTemizleTitle => '履歴を削除';

  @override
  String get gecmisiTemizleOnayIcerik => 'すべてのコーデ履歴を削除してもよろしいですか？この操作は取り消せません。';

  @override
  String get gecmisBasariylaTemizlendi => '履歴を正常に削除しました 🗑️';

  @override
  String get kayitGecmistenSilindi => '記録が履歴から削除されました。';

  @override
  String get kombin => 'コーディネート';

  @override
  String get kombinDetayiUst => 'コーデ詳細';

  @override
  String get giyilenParcalarUst => '着用アイテム';

  @override
  String get detayBulunamadi => '詳細が見つかりませんでした。';

  @override
  String get henuzFavoriEklemediniz => 'お気に入りのコーデはまだ追加されていません。';

  @override
  String get camasirSepetiTitle => 'ランドリーかご';

  @override
  String get sepetBosTumKiyafetlerTemiz => '洗濯かごは空です。すべての服が清潔です！';

  @override
  String get tumKiyafetlerTemizlendi => 'すべての服が洗濯され、クローゼットに戻りました 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'すべてを「清潔」にする';

  @override
  String get profilVeAnalizTitle => 'マイページと分析';

  @override
  String get harikaGidiyorsun => '調子よく管理できています！';

  @override
  String gundurSeridesin(Object gun) {
    return '$gun日連続記録中';
  }

  @override
  String get tumuTemiz => 'すべて清潔';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '洗濯待ち $sayi 点';
  }

  @override
  String get stilKimligin => 'あなたのスタイルアイデンティティ';

  @override
  String get dolapVerimliligi => 'ワードローブ活用効率';

  @override
  String get renkPaletin => 'あなたのカラーパレット';

  @override
  String get dolabinKahramanlari => 'ヘビロテアイテム';

  @override
  String get derinlerdeUnutulanlar => '出番の少ないアイテム';

  @override
  String get sonGiyilenler => '最近着用した服';

  @override
  String get tumunuTemizle => 'すべて削除';

  @override
  String get henuzGecmisKaydiYok => '記録はまだありません。';

  @override
  String kezGiyildi(Object sayi) {
    return '$sayi 回着用';
  }

  @override
  String get ayarlarTitle => '設定';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'アカウント＆セキュリティセンター';

  @override
  String get kullaniciHesabi => 'ユーザーアカウント';

  @override
  String get misafirKullanici => 'ゲストユーザー';

  @override
  String get epostaDogrulanmis => 'メールアドレス確認済み';

  @override
  String get esitlemekIcinGirisYapin => '端末間で同期するにはログインしてください。';

  @override
  String get cikisYapTitle => 'ログアウト';

  @override
  String get cikisYapOnayIcerik => 'アカウントからログアウトしてもよろしいですか？';

  @override
  String get bagliHesaplarUst => '連携済みアカウント';

  @override
  String get googleHesabiBagli => 'Googleアカウント連携済み';

  @override
  String get googleHesabiniBagla => 'Googleアカウントを連携';

  @override
  String get googleHesabiBaglandi => 'Googleアカウントが正常に連携されました！ 🔗';

  @override
  String get googleHesabiBaglantisiKesildi => 'Googleアカウントの連携を解除しました。';

  @override
  String get sifreVeGuvenlik => 'パスワードとセキュリティ';

  @override
  String get sifreYenilemeBaglantisiIste => '再設定リンクをリクエスト';

  @override
  String get sifremiUnuttum => 'パスワードをお忘れですか？';

  @override
  String get sifreDegistirTitle => 'パスワードを変更';

  @override
  String get sifreSifirlamaAciklama =>
      'アカウントに登録されているメールアドレスにパスワード再設定リンクが送信されます：';

  @override
  String get epostaAdresi => 'メールアドレス';

  @override
  String get gecerliBirEpostaGiriniz => '有効なメールアドレスを入力してください';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return '$eposta に再設定メールを送信しました！ ✉️';
  }

  @override
  String get baglantiGonder => 'リンクを送信';

  @override
  String get hesabiKaliciSilTitle => 'アカウントを永久に削除';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'この操作は取り消せません。ワードローブのデータおよびプロフィール情報は永久に削除されます。';

  @override
  String get hesabiSilOnayKoduMetni => '確認のため、以下に「fitcheck」と入力してください：';

  @override
  String get vazgec => 'キャンセル';

  @override
  String get hesabimiSil => 'アカウントを削除する';

  @override
  String get hesabinizSilindi => 'アカウントとデータが削除されました。';

  @override
  String get kisiselStilVeProfilUst => 'パーソナルスタイル＆プロファイル';

  @override
  String get stilVeTarzTercihleri => 'スタイル＆シルエットの好み';

  @override
  String get secili => '選択中';

  @override
  String get tenRengiTercihinizUst => '肌のトーン設定';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'AI＆スタイル精度設定';

  @override
  String get stilistKisiligiVeYantitTarziUst => 'スタイリストの性格＆トーン';

  @override
  String get aiKisilikSamimiBaslik => 'フレンドリー＆親しみやすい';

  @override
  String get aiKisilikSamimiAciklama => 'ファッションを楽しく身近にする、温かく励ますようなトーン';

  @override
  String get aiKisilikElestirmenBaslik => 'プロファッション批評家';

  @override
  String get aiKisilikElestirmenAciklama => '色彩理論とシルエット理論に基づいた専門的なアドバイス';

  @override
  String get aiKisilikMinimalistBaslik => 'ミニマリスト＆ストレート';

  @override
  String get aiKisilikMinimalistAciklama => '無駄のない簡潔で直接的な提案';

  @override
  String get sikiRenkTeorisiUyumModu => '厳格な色彩理論モード';

  @override
  String get sikiRenkTeorisiAciklama => '有効にすると、AIはクラシックなカラーマッチングのルールを厳格に順守します';

  @override
  String get bildirimlerVeHatirlaticiUst => '通知＆リマインダー';

  @override
  String get sabahKombinOnerisi => '朝のコーディネート提案';

  @override
  String herSabahBildirimAl(Object saat) {
    return '毎日 $saat に通知を受け取る';
  }

  @override
  String get bildirimSaatiniOzellestir => '通知時間をカスタマイズ';

  @override
  String get gunlukKombinBildirimSaati => '毎日のコーデ通知時間';

  @override
  String get sabahBildirimSaatiSec => '朝の通知時間を選択';

  @override
  String get saatKaydedildiAksama => '時間は保存されましたが、通知サービスを利用できません。';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return '朝の通知が $saat に設定されました。 ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari => '続行するには、端末の設定で通知を許可してください。';

  @override
  String get camasirSepetiUyarilari => 'ランドリーかご通知';

  @override
  String get camasirSepetiUyarilariAciklama => '洗濯物が溜まったときに通知を受け取ります';

  @override
  String get haftalikStilRaporu => 'ウィークリースタイルレポート';

  @override
  String get haftalikStilRaporuAciklama => '毎週日曜日の夜にワードローブの使用概要を受け取ります';

  @override
  String get gorunumVeBolgeUst => '外観＆地域';

  @override
  String get lokasyonVeBirimlerUst => '位置情報＆単位';

  @override
  String get sicaklikBirimi => '温度単位';

  @override
  String get varsayilanSehirBolge => 'デフォルトの都市/地域';

  @override
  String get sehirOrnekHint => '例：東京、大阪、京都';

  @override
  String get gpsKullan => 'GPSを使用';

  @override
  String get veriVeDepolamaYonetimiUst => 'データ＆ストレージ管理';

  @override
  String get gorselOnbelleginiTemizle => '画像キャッシュをクリア';

  @override
  String get geciciFotografHafizasiAciklama => '写真用の臨時キャッシュメモリを解放します';

  @override
  String get onbellekTemizlendiBasari => '画像キャッシュと一時ファイルが正常にクリアされました！ ✨';

  @override
  String get onbellekTemizlerkenHata => 'キャッシュのクリア中に問題が発生しました。';

  @override
  String get gardirobuDisaAktarYedekle => 'ワードローブを出力（バックアップ）';

  @override
  String get tumKiyafetVeKombinJsonAciklama => 'すべての服とコーデのデータをJSON形式でエクスポートします';

  @override
  String get disaAktarilacakVeriYok => 'エクスポートするデータが見つかりませんでした。 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      'すべてのワードローブデータがJSON形式でクリップボードにコピーされました！ 📋';

  @override
  String get destekVeDegerlendirmeUst => 'サポート＆評価';

  @override
  String get uygulamayiDegerlendirin => 'アプリを評価する';

  @override
  String get googlePlay5YildizDestek => 'Google Playで5つ星評価をつけて応援してください ⭐';

  @override
  String get googlePlayAcilamadi => 'Google Playを開けませんでした。';

  @override
  String get geriBildirimVeDestek => 'フィードバック＆サポート';

  @override
  String get hataBildirVeyaOneri => 'バグの報告や機能のご要望はこちらから';

  @override
  String get islemTamamlanamadi => '操作を完了できませんでした。もう一度お試しください。';

  @override
  String get epostaUygulamasiAcilamadi =>
      'メールアプリを開けませんでした。 ayberkzcn9@gmail.com まで直接ご連絡ください。';

  @override
  String get gizlilikPolitikasiTitle => 'プライバシーポリシー';

  @override
  String get veriKullanimiVeGizlilikHaklari => 'データの使用方法とプライバシー権を確認';

  @override
  String get sonGuncellemeTarihi => '最終更新日：2026年10月20日';

  @override
  String get gizlilikMadde1Baslik => '1. データの収集と利用';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheckは、ワードローブ管理とコーデ提案を最適化するために情報を処理します。写真、スタイル、性別の設定は端末内にローカル保存されます。';

  @override
  String get gizlilikMadde2Baslik => '2. 位置情報の権限';

  @override
  String get gizlilikMadde2Icerik =>
      'リアルタイムの位置情報は、気象条件を取得する目的でのみOpen-Meteoサービスを通じて匿名で処理されます。データが保存または共有されることはありません。';

  @override
  String get gizlilikMadde3Baslik => '3. 音声アシスタントとマイク';

  @override
  String get gizlilikMadde3Icerik =>
      '音声コマンドを使用すると、話した内容は即座にテキストに変換されます。音声録音が永久に保存されることはありません。';

  @override
  String get gizlilikMadde4Baslik => '4. サードパーティサービス';

  @override
  String get gizlilikMadde4Icerik =>
      'パフォーマンスの分析および広告の配信のために、FirebaseおよびGoogle AdMobインフラストラクチャが使用されています。';

  @override
  String get anladim => '理解しました';

  @override
  String get stilVeModaTercihleriniz => 'スタイル＆ファッションの好み';

  @override
  String get stilModalAciklama => 'AIは、コーディネートを作成する際にこれらのスタイルとフィット感の好みを優先します。';

  @override
  String get favoriTarzinizUst => 'お気に入りのスタイル';

  @override
  String get giyimKesimiFitUst => 'シルエット / フィット感';

  @override
  String get hesapSilmeUst => 'アカウントの削除';

  @override
  String get tumBulutVeYerelVeriTemizlenir => 'ローカルおよびクラウドのすべてのデータを消去します';

  @override
  String get hakkindaUst => '情報';

  @override
  String get topluFotografEkleTooltip => '複数の服をまとめて追加';

  @override
  String get kuponKoduKullanTitle => 'クーポンコードを使用';

  @override
  String get kuponKoduAciklama => '追加のコーデクレジットを獲得するには、以下にプロモコードを入力してください：';

  @override
  String get kuponKoduHint => '例：VIP2026';

  @override
  String get kuponKullanButon => '適用する';

  @override
  String get kuponBasariliMesaji => '🎉 クーポンコードが適用されました！クレジットが追加されました。';

  @override
  String get kuponKullanilmisUyari => '⚠️ このクーポンコードは既に使用されています！';

  @override
  String get kuponGecersizUyari => '❌ 无効なクーポンコードです！もう一度お試しください。';

  @override
  String get sinirsizIslemHakkiBaslik => '無制限アクセス 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return '残りのクレジット：$hak ⚡';
  }

  @override
  String get sinirsizHakAciklama => 'プレミアム特典で、無制限のコーデ作成とスタイル分析をお楽しみいただけます。';

  @override
  String get gunlukHakAciklama =>
      '毎日のクレジットは00:00にリセットされます。広告の視聴やプロモコードの使用で追加獲得できます。';

  @override
  String get kuponKullan => 'クーポンコードを使用';

  @override
  String get hakEklendiTebrikler => 'おめでとうございます！+3クレジットが追加されました。 ✨';

  @override
  String get gardirobunDolduTitle => 'クローゼットがいっぱいです！';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return '最大上限の $limit アイテムに達しました。短い動画を視聴して、クローゼットの容量を +3 アイテム増やしますか？ 👕';
  }

  @override
  String get reklamIzleSlotEkle => '広告を見る (+3枠追加)';

  @override
  String get yeniSlotEklendiTebrikler =>
      'おめでとうございます！クローゼットに新しいスロットが+3追加されました。 🎉';

  @override
  String get gunlukHakBittiTitle => '本日の上限に達しました！';

  @override
  String get gunlukHakBittiIcerik =>
      '本日の無料アクションを使い切りました。動画を視聴するかクーポンコードを入力して、新しいクレジットを獲得しましょう！ 🛍️';

  @override
  String get kuponGir => 'コードを入力';

  @override
  String get anaSemsiyeBildirimBaslik => '折りたたみ傘をお忘れなく！ ☔';

  @override
  String get anaSemsiyeBildirimIcerik => '今日は雨が降りそうです。雨に適したコーディネートを選びましょう。';

  @override
  String get anaCamasirGunuBildirimBaslik => 'お洗濯の日です！ 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      '洗濯かごに着用済みの服が溜まっています。洗濯機を回すタイミングです！';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ このアイテムには何を合わせればいいですか？ ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'コーデの準備ができました ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'コーデを見る';

  @override
  String get chatStilistKombinTasarlayor => 'スタイリストがコーデを考案中...';

  @override
  String get chatStilistYaziyor => 'スタイリストが入力中...';

  @override
  String get pazartesi => '月曜日';

  @override
  String get sali => '火曜日';

  @override
  String get carsamba => '水曜日';

  @override
  String get persembe => '木曜日';

  @override
  String get cuma => '金曜日';

  @override
  String get cumartesi => '土曜日';

  @override
  String get pazar => '日曜日';

  @override
  String get rehberiAtla => 'ガイドをスキップ';

  @override
  String get rehberAnladimBasla => '理解しました、始める！';

  @override
  String get rehberSonrakiAdim => '次のステップ ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik => '📸 ワードローブをデジタル化';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'このボタンをタップして写真を撮影するかライブラリからアップロードし、バーチャルクローゼットを作成しましょう。';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ 音声スタイルアシスタント';

  @override
  String get rehberSesliAsistanAciklama =>
      '音声コマンドを使って何を着るべきか質問したり、即座にコーデ提案を受け取ったりできます。';

  @override
  String get rehberAiStilistBaslik => '✨ AIスタイリストの提案';

  @override
  String get rehberAiStilistAciklama =>
      '天気、肌のトーン、好みのスタイルに合わせたオーダーメイドのコーデをワンタップで獲得できます。';

  @override
  String get rehberAyarlarBaslik => '⚙️ カスタマイズ＆設定';

  @override
  String get rehberAyarlarAciklama =>
      '性別、肌のトーン、カラー、テーマをカスタマイズしたり、チュートリアルを再確認したりできます。';

  @override
  String get rehberNavGardirobumBaslik => '👔 マイワードローブ';

  @override
  String get rehberNavGardirobumAciklama =>
      '追加したすべての服をカテゴリー別に簡単に閲覧・フィルター・管理できます。';

  @override
  String get rehberNavHaftalikBaslik => '📅 ウィークリープランナー';

  @override
  String get rehberNavHaftalikAciklama => '7日間の天気予報に合わせて、毎日のコーデを事前に計画しましょう。';

  @override
  String get rehberNavDolaptanBaslik => '🤖 クローゼットからAI生成';

  @override
  String get rehberNavDolaptanAciklama => '手持ちの服を使って、AIがその日に適したコーデを自動生成します。';

  @override
  String get rehberNavKendiBaslik => '🎨 カスタムコーデ作成';

  @override
  String get rehberNavKendiAciklama =>
      'トップス、ボトムス、シューズを手動で組み合わせて自分だけのスタイルを作成・保存できます。';

  @override
  String get rehberNavProfilBaslik => '📊 分析＆洗濯管理';

  @override
  String get rehberNavProfilAciklama => '服の着用統計を確認したり、洗濯かごに入っている服を管理したりできます。';

  @override
  String get bildirimIzinGerekliBaslik => '通知の許可が必要です';

  @override
  String get bildirimIzinGerekliIcerik =>
      '洗濯のリマインダー、雨アラート、毎日のスタイルヒントを受け取るために通知を有効にすることをお勧めします。';

  @override
  String get bildirimGunaydinBaslik => 'おはようございます！ ☀️';

  @override
  String get bildirimGunaydinIcerik => '今日の天気に合わせた素敵なコーデを用意しました。チェックしてみませんか？';

  @override
  String get bildirimKanalGenelBaslik => '一般的な通知';

  @override
  String get bildirimKanalGenelAciklama => 'FitCheckからの一般的な更新通知';

  @override
  String get bildirimKanalGunlukBaslik => '毎日のコーデ提案';

  @override
  String get bildirimKanalGunlukAciklama => '毎日のコーディネートおすすめアラート';

  @override
  String get bildirimKanalYikamaBaslik => '洗濯リマインダー';

  @override
  String get bildirimKanalYikamaAciklama => '洗濯物の追跡とお手入れのリマインダー';

  @override
  String get bildirimKanalRaporBaslik => 'ウィークリースタイルレポート';

  @override
  String get bildirimKanalRaporAciklama => '週ごとのワードローブ利用とスタイルのまとめ';

  @override
  String get tenRengiAcik => '色白 / 明るい肌';

  @override
  String get tenRengiBugday => '標準的な肌 / 健康的な肌';

  @override
  String get tenRengiEsmer => '小麦色 / 色黒';

  @override
  String get stilStreetwear => 'ストリートウェア / カジュアル';

  @override
  String get stilKlasik => 'クラシック / フォーマル';

  @override
  String get stilMinimalist => 'ミニマル';

  @override
  String get stilSpor => 'スポーティ / アスレジャー';

  @override
  String get stilVintage => 'ヴィンテージ / レトロ';

  @override
  String get fitSlim => 'スリムフィット';

  @override
  String get fitRegular => 'レギュラーフィット';

  @override
  String get fitOversize => 'オーバーサイズ / ルーズ';

  @override
  String get gardirobumBosBaslik => 'クローゼットが空っぽです！';

  @override
  String get gardirobumGizlendiBaslik => 'ワードローブ非表示';

  @override
  String get gardirobumGizlendiAciklama => '右上の中央にある目のアイコンをタップすると内容が表示されます';

  @override
  String get gardirobumGoster => '内容を表示';

  @override
  String get gardirobumGizle => '内容を非表示';

  @override
  String get kategoriUst => 'トップス';

  @override
  String get kategoriAlt => 'ボトムス';

  @override
  String get kategoriAyakkabi => 'シューズ';

  @override
  String get kategoriAksesuar => 'アクセサリー';

  @override
  String get gardirobumBosAciklama => '最初の服を今すぐ追加して、AIの魔法を体験しましょう。';

  @override
  String get gardirobumAiIslem1 => 'ワードローブを分析中...';

  @override
  String get gardirobumAiIslem2 => '気象条件を確認中...';

  @override
  String get gardirobumAiIslem3 => '色の調和を計算中...';

  @override
  String get gardirobumAiIslem4 => 'ベストなコーデを選出中...';

  @override
  String get gardirobumAiIslem5 => '詳細を仕上げ中...';

  @override
  String get gardirobumHakBittiBaslik => '本日の上限に達しました';

  @override
  String get gardirobumHakBittiAciklama => '本日のコーディネート作成の上限に達しました。';

  @override
  String get gardirobumHakEklendiMesaj => 'おめでとうございます、新しいコーディネート権を獲得しました！';

  @override
  String get ayarlariAc => '設定を開く';

  @override
  String get kiyafetEkle => '服を追加';

  @override
  String get kameraIleCek => '写真を撮影';

  @override
  String get galeridenSecToplu => 'ライブラリから選択';

  @override
  String get kameraIzniGerekliBaslik => 'カメラの権限が必要です';

  @override
  String get kameraIzniGerekliAciklama => '写真を撮影するには、カメラのアクセス権限を有効にしてください。';

  @override
  String get kiyafetDuzenleBaslik => '服を編集';

  @override
  String get kategori => 'カテゴリー';

  @override
  String get evetSil => 'はい、削除します';

  @override
  String get favorilerdenCikarildi => 'お気に入りから削除しました';

  @override
  String get gardirobumHenuzYokEkle => '服はまだ追加されていません。今すぐ追加してみましょう！';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return '一度に選択できる写真は最大 $max 枚までです。';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count 点のアイテム';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return 'マッチ度 %$oran';
  }

  @override
  String get kombinSohbetAc => 'このコーデについて相談';

  @override
  String get kombinSohbetBaslik => 'コーデ相談';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return '$gunのコーデについて相談';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return '「$kombin」のコーデを一緒に見ていきましょう！色の相性、天気、代わりのアイテムなど、何でも聞いてくださいね。✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 このコーデの相性は？';

  @override
  String get kombinSohbetOneriAlternatif => '👟 別のアイテムを提案して';

  @override
  String get kombinSohbetOneriHava => '🌦️ 天気が変わったら？';

  @override
  String get kombinSohbetOneriAksesuar => '💍 小物の提案をして';

  @override
  String get kombinSohbetAltBaslikAnlik => '今のコーデについてのチャット';

  @override
  String get chatKirliSepetiBos =>
      '🧺 洗濯かごは空です！すべてのアイテムがすぐに着られます。いつでもコーデを提案できますよ。✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 洗濯かごには **$sayi** 点のアイテムが入っています：';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'これらのアイテムは洗濯するまでコーデ提案には含まれません。ご希望なら、きれいなアイテムだけで今すぐコーデを作れますよ。';

  @override
  String get analitikVerileriPaylas => '分析データを共有';

  @override
  String get analitikVerileriPaylasAciklama =>
      'アプリの改善のため、匿名の利用データを送信します。オフにすると、この端末に保存された分析データは削除されます。';

  @override
  String get chatKarsilamaHavaYok => 'こんにちは！👋 あなたのスタイルに合う素敵なコーデを作りましょうか？✨';

  @override
  String get premiumBaslik => 'スタイル無制限、広告ゼロ';

  @override
  String get premiumAciklama => 'コーデとスタイル分析を無制限に使えて、1つのサブスクリプションで広告をすべて削除。';

  @override
  String get premiumOzellikReklamsiz => 'すべての広告が削除されます';

  @override
  String get premiumOzellikAylik => '毎月自動で更新されます';

  @override
  String get premiumOzellikMagaza => 'Google Playで管理されます';

  @override
  String get premiumAktifMesaji => 'Premiumが有効です。無制限で広告もありません。';

  @override
  String get premiumAboneOl => '登録する';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return '登録する • $fiyat';
  }

  @override
  String get premiumGeriYukle => '購入を復元';

  @override
  String get premiumMagazaHazirDegil => 'Google Playに接続できません。もう一度お試しください。';

  @override
  String get premiumSatinAlmaBaslatilamadi => '購入を開始できませんでした。';

  @override
  String get premiumSatinAlmaBasarisiz => '購入に失敗しました。';

  @override
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'コーデ無制限 • 月 $fiyat';
  }

  @override
  String premiumGec(String fiyat) {
    return '無制限で使う • $fiyat/月';
  }

  @override
  String get guncellemeBaslik => 'アップデートが必要です';

  @override
  String get guncellemeAciklama =>
      'FitCheckの新しいバージョンが公開されました。続けるにはアプリを更新してください。';

  @override
  String get guncellemeButonu => '今すぐ更新';

  @override
  String guncellemeYeniSurum(String surum) {
    return '新しいバージョン: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok => 'ストアのリンクを開けませんでした。ストアからアプリを更新してください。';

  @override
  String get premiumUrunBulunamadi =>
      'サブスクリプション情報を取得できませんでした。しばらくしてから再試行してください。';

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
  String get kombinOyunuBaslik => 'コンビネーションゲーム';

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
  String get degerlendirmeBaslik => 'FitCheckを気に入っていますか？';

  @override
  String get degerlendirmeIcerik =>
      'アプリを気に入っていただけたら、5秒だけレビューを書いていただけませんか？小さなレビューが大きな励みになります！⭐ レビューを書いた方に+3無料クレジットをプレゼント！';

  @override
  String get degerlendirmeEvet => 'はい、評価します';

  @override
  String get degerlendirmeBelkiSonra => '後で';

  @override
  String get yakinda => '近日公開';

  @override
  String get yakindaAciklama => 'この機能は準備中です、もうすぐお届けします！';

  @override
  String get aiOneriHazirlaniyor => '提案を準備中...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'スタイリストの提案を作成できませんでした。もう一度お試しください。';

  @override
  String get haftalikAiServisHatasi =>
      'AIサービスに接続できませんでした。インターネット接続を確認して再試行してください。';

  @override
  String get haftalikAiGecerliPlanYok => 'AIが有効なプランを返しませんでした。もう一度お試しください。';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'プランの作成中に予期しないエラーが発生しました。もう一度お試しください。';

  @override
  String get haftalikBugunGiyildi => '今日のコーデはすでに着用済みです。新しいコーデは作成されませんでした。';

  @override
  String get girisHataKullaniciAdiKisa => '3文字以上入力してください';

  @override
  String get girisHataEpostaGecersiz => '有効なメールアドレスを入力してください';

  @override
  String get girisHataSifreKisa => '6文字以上入力してください';

  @override
  String get googleKullanicisi => 'Google ユーザー';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => '🌐 言語を選択';

  @override
  String get dilSecenekOtomatik => '自動（端末の言語）';

  @override
  String get kapat => '閉じる';

  @override
  String get bildirimBaslik => '通知';

  @override
  String get ayarlarAltbilgi => 'スタイルを込めて';

  @override
  String get geriBildirimKonu => 'FitCheck フィードバック';

  @override
  String get premiumOzelliklerBaslik => 'Premiumで使えるもの';

  @override
  String get premiumOzellikSinirsizKombin => 'コーデ作成が無制限';

  @override
  String get premiumOzellikSinirsizAnaliz => 'AIスタイル分析が無制限';

  @override
  String get premiumOzellikSinirsizGardirob => 'クローゼット容量が無制限';

  @override
  String get premiumPlanAylik => '月払い';

  @override
  String get premiumPlanYillik => '年払い';

  @override
  String get premiumEnAvantajli => 'いちばんお得';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return '$yuzde% お得';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun日間無料';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'その後 $fiyat';
  }

  @override
  String get premiumYenilemeNotu => 'サブスクリプションは各期間の終了時に自動更新されます。いつでも解約できます。';

  @override
  String get kiyafetDondur => '回転';

  @override
  String get stilistHafizasiBaslik => 'スタイリストの記憶';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return '$sayi 件のメモを記憶';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'まだ何も覚えていません';

  @override
  String get stilistHafizasiAciklama =>
      'スタイリストはチャットから学んだ内容を長期メモとして保存し、提案をパーソナライズします。メモはこの端末にのみ保存されます。';

  @override
  String get stilistHafizasiNelerBiliyor => '何を覚えている？';

  @override
  String get stilistHafizasiOzetBaslik => '最近の会話の要約';

  @override
  String get stilistHafizasiBos => 'まだ何も学んでいません。会話するほどあなたのスタイルを理解します。';

  @override
  String get stilistHafizasiTemizle => '記憶を消去';

  @override
  String get stilistHafizasiTemizleOnay =>
      'スタイリストがあなたについて記憶した内容はすべて削除されます。元に戻せません。';

  @override
  String get stilistHafizasiTemizlendi => '記憶を消去しました 🧠';

  @override
  String get gardirobumArkaPlanSilinemediBaslik => '背景を削除できませんでした';

  @override
  String get gardirobumArkaPlanSilinemediAciklama =>
      '接続に問題がある可能性があります。再試行する、背景付きで保存する、この写真をスキップする、のいずれかを選んでください。';

  @override
  String get gardirobumArkaPlanliKaydet => '背景付きで保存';

  @override
  String get cekimIpucuBaslik => 'きれいに切り抜くために';

  @override
  String get cekimIpucu1 => '衣類は平らな無地の面に置いてください。';

  @override
  String get cekimIpucu2 => '衣類と違う色の面を使ってください。';

  @override
  String get cekimIpucu3 => '影や柄のある面は避けてください。';

  @override
  String get kesimUyarisiBaslik => '切り抜きが正しくない可能性があります';

  @override
  String get kesimUyarisiAciklama =>
      '衣類の色が背景と非常に近いため、背景の削除がうまくいかないことがあります。背景が残ったり、衣類の一部が切れたりする場合があります。別の色の面で撮り直すと解決することが多いです。';

  @override
  String get kesimUyarisiTekrarCek => '撮り直す';

  @override
  String get kesimUyarisiYineDeKaydet => 'このまま保存';

  @override
  String get gizlilikMadde5Baslik => '5. AI による画像分析';

  @override
  String get gizlilikMadde5Icerik =>
      '衣類の写真は背景を削除するために当社のサーバーで処理され、スタイル分析とコーディネート提案のために Google（Gemini）および Groq の AI サービスに送信されます。写真はご依頼への回答のみに使用され、当社が永続的に保存することはなく、広告には使用しません。写真自体は端末に保存され、いつでもワードローブから削除できます。';

  @override
  String get bugunSekmesi => '今日';

  @override
  String get bugunBaslik => '今日';

  @override
  String get bugunGunaydin => 'おはようございます';

  @override
  String get bugunIyiGunler => 'こんにちは';

  @override
  String get bugunIyiAksamlar => 'こんばんは';

  @override
  String get bugunBugununKombini => '今日のコーデ';

  @override
  String get bugunHizliFotograf => '写真を追加';

  @override
  String get bugunHizliKombin => 'コーデを作成';

  @override
  String get bugunHizliStilist => 'スタイリストに聞く';

  @override
  String get bugunHizliPlan => '1週間を計画';

  @override
  String get bugunHazirlaniyor => 'コーデを準備中…';

  @override
  String get bugunBosBaslik => 'ワードローブはまだ空です';

  @override
  String get bugunBosAciklama => '最初のアイテムを追加しましょう。毎朝ここに新しいコーデの提案が届きます。';

  @override
  String get bugunYenile => '更新';

  @override
  String get bugunGiydim => '着た';

  @override
  String get bugunKaydet => '保存';

  @override
  String get bugunSeninIcin => 'あなたへ';

  @override
  String get bugunGiyilmediRafi => '2週間着ていない';

  @override
  String get bugunYeniRafi => '最近追加';

  @override
  String get bugunHavaRafi => '今日に合う';

  @override
  String get bugunRafIpucu => 'タップ：着た記録・着合わせ作成・クローゼットで開く';

  @override
  String get duelloSekmesi => 'デュエル';

  @override
  String get duelloBaslik => 'コーデ対決';

  @override
  String get duelloAltBaslik => '2つのコーデから1つ選んで、スタイル眼を試そう。';

  @override
  String get duelloBaslat => '対決を始める';

  @override
  String get duelloNasilOynanir => '遊び方';

  @override
  String get duelloKural1 => '毎ラウンド2つのコーデが出ます。';

  @override
  String get duelloKural2 => '質問に合うほうを選びましょう。';

  @override
  String get duelloKural3 => '正解するとポイントと連勝が増えます。';

  @override
  String get duelloEnIyi => 'ベスト';

  @override
  String get duelloSeri => '連勝';

  @override
  String duelloGunSerisi(int gun) {
    return '$gun 日';
  }

  @override
  String get duelloSeviye => 'レベル';

  @override
  String duelloSeviyeDegeri(int seviye) {
    return 'レベル $seviye';
  }

  @override
  String duelloXp(int xp) {
    return '$xp XP';
  }

  @override
  String duelloTur(int tur, int toplam) {
    return '第 $tur/$toplam 問';
  }

  @override
  String get duelloOlcuRenk => '色のまとまりが良いのはどっち？';

  @override
  String get duelloOlcuHava => '今日の天気に合うのはどっち？';

  @override
  String get duelloDokun => 'コーデをタップ';

  @override
  String get duelloDogru => '正解！';

  @override
  String get duelloYanlis => 'おしい';

  @override
  String get duelloDevam => '次へ';

  @override
  String get duelloSonuc => '結果を見る';

  @override
  String get duelloBitti => '対決終了';

  @override
  String duelloSkor(int dogru, int toplam) {
    return '$dogru/$toplam 正解';
  }

  @override
  String get duelloYeniden => 'もう一度';

  @override
  String get duelloBugune => '今日に戻る';

  @override
  String duelloEnIyiSeri(int seri) {
    return '最高連勝：$seri';
  }

  @override
  String get duelloPaletNotu => 'このラウンドはカラーカードです。ワードローブに服を追加すると、自分の服で対決できます。';

  @override
  String get duelloDolapEkle => '服を追加';

  @override
  String get duelloBugunOynadi => '今日はプレイ済み。明日また続けて連勝を伸ばそう。';

  @override
  String get duelloSebepNotr => 'ニュートラルとアースカラーは互いに調和します。';

  @override
  String get duelloSebepMonokrom => '同じ色系でまとめると一体感が出ます。';

  @override
  String get duelloSebepAnalog => '近い色はやわらかなグラデーションになります。';

  @override
  String get duelloSebepVurgu => 'ニュートラルなベースにアクセントカラーが1色。';

  @override
  String get duelloSebepZit => '反対色がバランスよく使われています。';

  @override
  String get duelloSebepDagink => '遠い2色をつなぐ色がありません。';

  @override
  String get duelloSebepCokRenk => '鮮やかな3色がぶつかり合っています。';

  @override
  String get duelloSebepHavaUygun => '今日の気温に合った服です。';

  @override
  String get duelloSebepHavaAgir => 'この天気には厚すぎます。';

  @override
  String get duelloSebepHavaHafif => 'この天気には薄すぎます。';

  @override
  String bildirimSabahKombin(String kombin) {
    return '今日のコーデができました：$kombin。タップして見る。';
  }

  @override
  String get bildirimPlanBaslik => '明日のコーデができました';

  @override
  String bildirimPlanKombin(String kombin) {
    return '明日は：$kombin。今のうちにチェックして、朝はゆっくり。';
  }

  @override
  String get bildirimPlanBos => '明日のコーデはまだ未定です。2分で計画しましょう。';

  @override
  String get planHatirlatimiAyar => '夜のプラン通知';

  @override
  String get planHatirlatimiAyarAciklama => '明日のコーデを21:00にお知らせします';

  @override
  String get bugunPaylas => 'コーデをシェア';

  @override
  String get bugunPaylasMetni => '今日のコーデはFitCheckで組みました ✨';

  @override
  String get bugunPaylasHata => '共有を開けませんでした。もう一度お試しください。';

  @override
  String get bugunParcaGiydim => '今日着た';

  @override
  String get bugunParcaKombin => 'これでコーデを作る';

  @override
  String get bugunParcaDolapta => 'クローゼットで開く';

  @override
  String bugunParcaGiydimIsaretlendi(String parca) {
    return '「$parca」を今日着たものにしました。';
  }

  @override
  String get stilGunluguBaslik => 'マイスタイル日記';

  @override
  String get stilGunluguTakvim => 'カレンダー';

  @override
  String get stilGunluguGunluk => '日記';

  @override
  String get stilGunluguRapor => 'レポート';

  @override
  String get stilGunluguGiyildi => '着用';

  @override
  String get stilGunluguPlanli => '予定';

  @override
  String get stilGunluguGunBos => 'この日の記録はありません';

  @override
  String stilGunluguRaporOzet(String kombin) {
    return '今週は $kombin 通りの着合わせをしました';
  }

  @override
  String stilGunluguRaporGecenHafta(String fark) {
    return '先週との比較: $fark';
  }

  @override
  String get stilGunluguRaporKullanim => 'クローゼットの使用率';

  @override
  String get stilGunluguRaporEnCok => '一番着たアイテム';

  @override
  String get stilGunluguRaporSeri => '連続日数';

  @override
  String get stilGunluguRaporHicGiyilmemis => '一度も着ていない';

  @override
  String get stilGunluguRaporPaylas => 'レポートを共有';

  @override
  String stilGunluguRaporPaylasMetni(String ozet) {
    return '今週のスタイルレポート: $ozet';
  }

  @override
  String get stilGunluguRaporBos => '今週はまだ着用の記録がありません。ここに表示されます。';

  @override
  String get seyahatBaslik => 'トラベルモード';

  @override
  String get seyahatGunSayisi => '日数';

  @override
  String get seyahatHava => '天気';

  @override
  String get seyahatHavaSicak => '暑い';

  @override
  String get seyahatHavaIliman => '温暖';

  @override
  String get seyahatHavaSoguk => '寒い';

  @override
  String get seyahatAmac => '目的';

  @override
  String get seyahatAmacGunluk => '日常';

  @override
  String get seyahatAmacIs => '仕事';

  @override
  String get seyahatAmacOzel => '特別な予定';

  @override
  String get seyahatPlanBaslik => 'パッキングプラン';

  @override
  String seyahatKombine(String adet) {
    return '$adet 通りの着合わせ';
  }

  @override
  String get seyahatDiger => 'アウター';

  @override
  String get seyahatEksikUst => '清潔なトップスがありません';

  @override
  String get seyahatEksikAlt => '清潔なボトムスがありません';

  @override
  String get seyahatEksikAyakkabi => '靴がありません';

  @override
  String seyahatEksikKombin(String gun) {
    return '$gun 日分の着合わせが足りません';
  }

  @override
  String get seyahatPaylas => 'リストを共有';

  @override
  String get seyahatPaylasMetni => 'FitCheck のパッキングプラン ✨';

  @override
  String get geriAl => '元に戻す';

  @override
  String get stilGunluguRaporSayiEtiketi => '今週着たコーデ';

  @override
  String get stilGunluguRaporDortHafta => '過去4週間';

  @override
  String get stilGunluguRaporEnCokParcalar => 'よく着たアイテム';

  @override
  String get navKombin => 'コーデ';

  @override
  String get navProfil => 'マイページ';

  @override
  String get dolapAra => 'ワードローブを検索';

  @override
  String get dolapEslesmeYok => '一致するアイテムがありません。';

  @override
  String get dolapAramayiTemizle => '検索をクリア';

  @override
  String get planGuneKombinSec => 'この日のコーデを選ぶ';

  @override
  String get planKombinSec => 'コーデを選ぶ';

  @override
  String get planDegistir => '変更';

  @override
  String get planKaldir => '削除';

  @override
  String get planFavoriYok => 'お気に入りのコーデはまだありません。';

  @override
  String get planKombinOlustur => 'コーデを作る';

  @override
  String get planGuneEklendi => 'コーデをこの日に追加しました';

  @override
  String get planKaldirildi => '予定を削除しました';

  @override
  String get planHaftalikProgram => '週間スケジュール';

  @override
  String planParcaSayisi(int count) {
    return '$count 点';
  }

  @override
  String get planBugun => '今日のコーデ';

  @override
  String get planTakvimdenDegistir => 'カレンダーで変更';

  @override
  String get planFavorilerim => 'お気に入り';

  @override
  String get planSonGiyilenler => '最近着たもの';

  @override
  String get izinGerekceKameraBaslik => 'カメラで衣類を追加';

  @override
  String get izinGerekceKameraAciklama =>
      '衣類を写真として追加するためにカメラを使います。写真は端末から送信され、背景除去と色・スタイル解析はサーバー側で実行され、恒久的には保存されません。';

  @override
  String get izinGerekceSimdiDegil => '今は不要';

  @override
  String get planOneriler => 'おすすめ';

  @override
  String get bilgiVerimlilik =>
      'ワードローブ効率は、少なくとも一度でも着たアイテムの割合を示します。60%を超えると健全な状態とみなされ、下回ると着ていないアイテムや買いすぎの兆候があります。';

  @override
  String get bilgiStil =>
      'スタイル身元は、ワードローブに多い色・カテゴリ・スタイルタグから計算されます。单品の提案はこのプロファイルに合わせて並び替わります。';

  @override
  String get bilgiSeri => '連続記録は、続けて着た日数です。「今日着た」を押すたびに増え、1日飛ばすとリセットされます。';

  @override
  String get bilgiSepet => '洗濯かごは、着たが洗いたいアイテムの置き場です。かごにあるアイテムは次の单品提案には使われません。';

  @override
  String get bilgiRenkPaleti =>
      'カラーパレットは、ワードローブで最も多い4色の分布を示します。似た色味どうしは相性がよく見えます。';

  @override
  String get bilgiKategoriDagilimi =>
      'カテゴリ分布は、トップス・ボトムス・靴・アクセソリーのバランスを示します。1つのカテゴリに偏ると、单品が作りにくくなります。';

  @override
  String get bilgiAnlikDurum => 'インスタント状態は、お住まいの天気とワードローブにもとづく短い提案を出します。';

  @override
  String get bilgiSeriBaslik => '着た連続記録';

  @override
  String get bilgiKahramanlar =>
      'ワードローブのヒーローは、よく着ているアイテムです。着回しの多いアイテムは多くの提案に登場し、ワードローブを活着させます。';

  @override
  String get bilgiUnutulanlar =>
      '忘れたアイテムは、着たことがない、または長く着ていないものです。使っていないアイテムも新しいコーデで復活します。';

  @override
  String get bilgiBugunKombini =>
      '今日のコーデは、ワードローブと天気から選ばれます。1日につきAIへの問い合わせは最大1回で、結果は当日中保持されます。AIが使えない場合はルールベースの提案に切り替わります。';

  @override
  String get bilgiRaporHafta =>
      '過去7日に記録した着数。「今日着た」を押すたびに1着として数え、同じ日に何着でも記録できます。';

  @override
  String get bilgiRaporDortHafta => '直近4週間の週ごとの着用数。グラフは週のリズムと増減を示します。';

  @override
  String get bilgiRaporEnCokParcalar => '今週いちばん着たアイテム。着回しの多いアイテムはワードローブの背骨です。';

  @override
  String get bilgiRaporKullanim =>
      '直近7日に使ったワードローブの割合。低い場合は、まだ一度も着那した組み合わせに入っていないことを意味します。';

  @override
  String get bilgiRaporSeri => '続けて着た日数。着た組み合わせを記録するたびに増え、1日飛ばすとリセットされます。';

  @override
  String get bilgiRaporHicGiyilmemis =>
      '直近7日に一度も着ていないアイテムの数。新しいの組み合わせで 다시着られます。';

  @override
  String get bilgiDueloPuan =>
      '各ラウンドで2つのコーデから1つを選びます。正解なら得点と連続記録が増え、外すと連続記録はリセットされます。採点はルールベースで、色の調和・カテゴリのバランス・季節の整合性を測ります。ワードローブが4着未満の場合は過去のコーデからパレットを作ります。';

  @override
  String get bilgiDolapCalisma =>
      '写真を追加すると背景が自動で取り除かれ、色・カテゴリ・スタイル・季節をAIが読み取ります。衣類は端末に保存され、背景除去と分析はサーバー側で処理されます。';

  @override
  String get duzenleArkaPlanBaslik => '背景と配置';

  @override
  String get duzenleIpucu => 'ドラッグで配置し、ピンチでサイズを変更できます。';

  @override
  String get duzenleZeminBeyaz => '白';

  @override
  String get duzenleZeminKirik => 'オフホワイト';

  @override
  String get duzenleZeminGri => 'ライトグレー';

  @override
  String get duzenleZeminSaydam => '透明';

  @override
  String get duzenleKaydet => '保存';

  @override
  String get duzenleVarsayilan => 'そのまま';
}
