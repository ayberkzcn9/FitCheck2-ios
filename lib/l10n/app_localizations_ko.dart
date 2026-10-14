// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => '화면 및 테마';

  @override
  String get karanlikMod => '다크 모드';

  @override
  String get koyuTemaAktif => '다크 테마 활성화됨';

  @override
  String get acikTemaAktif => '라이트 테마 활성화됨';

  @override
  String get dilAyarlari => '언어 및 지역 설정';

  @override
  String get uygulamaDili => '앱 언어';

  @override
  String get hakkinda => '앱 정보';

  @override
  String get surum => '버전';

  @override
  String get ayarOtomatikCihazDili => '🌐 자동 (기기 언어)';

  @override
  String get iptal => '취소';

  @override
  String get tamam => '확인';

  @override
  String get gardirobumTitle => '가상 옷장';

  @override
  String get gardirobumYukleniyor => 'AI 분석 중...';

  @override
  String get gardirobumTopluEkle => '여러 의류 한 번에 추가';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return '분석 진행 중 ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => '옷장 비우기';

  @override
  String get gardirobumTemizleOnay => '옷장의 모든 의류가 삭제됩니다. 정말 삭제하시겠습니까?';

  @override
  String get gardirobumEvet => '예, 모두 비우기';

  @override
  String get gardirobumHataMesaji => '의류를 추가하는 동안 오류가 발생했습니다.';

  @override
  String get gardirobumKategoriTumu => '전체';

  @override
  String get gardirobumKategoriUst => '상의';

  @override
  String get gardirobumKategoriAlt => '하의';

  @override
  String get gardirobumKategoriAyakkabi => '신발';

  @override
  String get gardirobumKategoriAksesuar => '액세서리';

  @override
  String get gardirobumBosKategori => '이 카테고리에 등록된 아이템이 없습니다.';

  @override
  String get gardirobumGiymeSayisi => '착용 횟수:';

  @override
  String gardirobumMaliyet(Object tutar) {
    return '착용 당 비용: ₺$tutar';
  }

  @override
  String get gardirobumDolabaAl => '옷장으로 이동';

  @override
  String get gardirobumSepeteAt => '빨래 바구니에 넣기';

  @override
  String get gardirobumSepetteRozet => '세탁 필요';

  @override
  String get gardirobumGecersizParcaBaslik => '유효하지 않은 아이템 감지됨';

  @override
  String get gardirobumGecersizParcaIcerik =>
      '이미지에서 의류, 신발 또는 액세서리를 감지하지 못했습니다 (목재, 가구, 생활용품 등 부적절한 개체 감지). 의류 아이템만 업로드해 주세요.';

  @override
  String get gardirobumTamam => '확인';

  @override
  String get stilistTitle => '맞춤형 AI 스타일리스트';

  @override
  String get gunlukKombinTitle => 'DEILLI LUK';

  @override
  String get gunlukKombinHazirBaslik => '오늘의 룩을 준비하세요';

  @override
  String get gunlukKombinHazirIcerik => '주사위를 던지거나 휴대폰을 흔들어 오늘의 룩을 만들어보세요.';

  @override
  String get gunlukKombinKartBaslik => '오늘의 룩';

  @override
  String get stilistAnlikHavaDurumu => '현재 날씨 (탭하여 새로고침)';

  @override
  String get stilistKonumKontrol => '위치 확인 중...';

  @override
  String get stilistNereyeGidiyorsun => '오늘 어디에 가시나요?';

  @override
  String get stilistDusunuyor => '스타일리스트가 고민 중...';

  @override
  String get stilistBugunNeGiymeliyim => '오늘 뭐 입을까?';

  @override
  String get stilistKombiniTemizle => '코디 초기화';

  @override
  String stilistKombininTitle(Object ortam) {
    return '$ortam 추천 코디';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 스타일 조화: %$puan';
  }

  @override
  String get stilistUstGiyim => '상의';

  @override
  String get stilistAltGiyim => '하의';

  @override
  String get stilistAyakkabi => '신발';

  @override
  String get stilistAksesuar => '액세서리';

  @override
  String get stilistFavoriyeEkle => '즐겨찾기에 추가';

  @override
  String get stilistBugunGiydim => '오늘 입었어요';

  @override
  String get bugunGiydimOnayIcerik => '오늘 이 코디를 입었나요?';

  @override
  String get stilistTrendyolTamamla => 'Trendyol에서 검색';

  @override
  String get stilistHata => '코디를 생성하는 중 오류가 발생했습니다.';

  @override
  String get ortamCasual => '캐주얼 / 데일리';

  @override
  String get ortamOfis => '오피스 / 비즈니스';

  @override
  String get ortamDavet => '결혼식 / 하객룩';

  @override
  String get ortamSpor => '스포츠 / 운동';

  @override
  String get ortamGece => '나이트라이프 / 파티';

  @override
  String get ortamRomantik => '데이트';

  @override
  String get stilistUyariDolapBosBaslik => '옷장이 비어 있거나 모든 옷이 세탁 중입니다! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      '맞춤형 코디 추천을 받으려면 옷장에 깨끗한 의류나 액세서리를 추가해 주세요.';

  @override
  String get stilistUyariUstEksikBaslik => '상의가 부족해요! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      '옷장에 깨끗한 상의가 없습니다. 완벽한 코디를 위해 상의를 최소 하나 이상 추가해 주세요!';

  @override
  String get stilistUyariAltEksikBaslik => '하의가 부족해요! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      '옷장에 깨끗한 하의가 없습니다. 멋진 스타일 연출을 위해 하의를 추가해 주세요!';

  @override
  String get stilistUyariAyakkabiEksikBaslik => '신발이 부족해요! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      '멋진 스타일이지만 함께 신을 깨끗한 신발을 찾지 못했습니다. 지금 신발을 추가해 보세요!';

  @override
  String get stilistUyariButon => '알겠어요, 추가할게요!';

  @override
  String get anaHavaYukleniyor => '지역 날씨 정보를 불러오는 중...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK가 듣고 있습니다... 말씀하세요!';

  @override
  String get anaMikrofonHata => '마이크 권한 또는 음성 인식 서비스를 사용할 수 없습니다.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return '선택 사항이 업데이트되었습니다: \"$cinsiyet\" ✨';
  }

  @override
  String get anaKonumKapaliBaslik => '위치 서비스 비활성화됨';

  @override
  String get anaKonumKapaliIcerik => '날씨에 맞춘 코디 추천을 받으려면 GPS 위치 서비스를 활성화해 주세요.';

  @override
  String get anaKonumuAc => '위치 서비스 켜기';

  @override
  String get anaIzinVer => '허용';

  @override
  String get anaIptal => '취소';

  @override
  String get anaKonumIzinRedBaslik => '위치 권한 거부됨';

  @override
  String get anaKonumIzinRedIcerik1 => '권한이 승인되지 않아 날씨 정보를 불러올 수 없습니다.';

  @override
  String get anaKonumIzinRedIcerik2 => '시스템 설정에서 권한을 허용해야 합니다.';

  @override
  String get anaKonumIzinGerekliBaslik => '위치 권한 필요';

  @override
  String get anaKonumIzinGerekliIcerik => '일기 예보를 불러오려면 설정에서 위치 권한을 허용해 주세요.';

  @override
  String get anaHavaDurumuAlinamadi => '날씨 정보를 불러올 수 없음';

  @override
  String get anaHavaTahminiYuklenemedi => '일기 예보를 불러오지 못했습니다.';

  @override
  String get anaFavoriEklendi => '즐겨찾기에 추가되었습니다! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ 주의: 최근 이 의류나 유사한 조합을 자주 착용하셨습니다. 오늘은 다른 스타일을 연출해 보는 건 어떨까요?';

  @override
  String get anaKombinMukemmel => '✨ 탁월한 선택입니다! 오늘 스타일의 밸런스가 매우 훌륭합니다.';

  @override
  String get anaYikamaUyariBaslik => '스마트 세탁 알림';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return '이 코디를 착용함에 따라, 자주 입은 의류 \"$parcalar\" 아이템이 자동으로 빨래 바구니로 이동되었습니다! 🧺';
  }

  @override
  String get anaTamam => '확인';

  @override
  String get anaAyarlarTooltip => '설정';

  @override
  String get anaKadin => '여성';

  @override
  String get anaErkek => '남성';

  @override
  String get anaSesleKonus => '음성 명령';

  @override
  String get anaStilistAsistani => '스타일리스트 어시스턴트';

  @override
  String get anaSekmeGardirop => '옷장';

  @override
  String get anaSekmeHaftalik => '주간 플랜';

  @override
  String get anaSekmeAnlik => '실시간 코디';

  @override
  String get anaSekmeYarismasi => '퀴즈';

  @override
  String get anaSekmeProfil => '프로필 & 분석';

  @override
  String get modaYarismasiBaslik => '패션 & 컬러 매치';

  @override
  String get modaYarismasiGunlukTamamlandi => '오늘 퀴즈가 완료되었습니다';

  @override
  String get modaYarismasiYeniYarin => '새로운 5문제 세트는 내일 다시 이용 가능합니다.';

  @override
  String get modaYarismasiSonuc => '결과';

  @override
  String modaYarismasiSkor(Object skor) {
    return '점수: $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return '문제 $index / 10';
  }

  @override
  String get modaYarismasiGeri => '뒤로';

  @override
  String get modaYarismasiAnaEkrana => '홈으로 돌아가기';

  @override
  String get havaParcaliBulutlu => '구름 조금';

  @override
  String get havaSicakGunesli => '무덥고 화창함';

  @override
  String get havaSogukKarli => '매우 춥고 눈';

  @override
  String get havaYagmurlu => '비';

  @override
  String get havaGunesli => '화창함';

  @override
  String get havaSoguk => '쌀쌀함';

  @override
  String get gunPzt => '월요일';

  @override
  String get gunSal => '화요일';

  @override
  String get gunCar => '수요일';

  @override
  String get gunPer => '목요일';

  @override
  String get gunCum => '금요일';

  @override
  String get gunCmt => '토요일';

  @override
  String get gunPaz => '일요일';

  @override
  String get stilKahveBaslik => '☕ 카페 & 데일리 캐주얼';

  @override
  String get stilKahveSoru => '친구들과 카페 갈 때 입기 좋은 편안하고 스타일리시한 코디 추천해줘';

  @override
  String get stilOfisBaslik => '💼 세련된 오피스룩';

  @override
  String get stilOfisSoru => '사무실 출근용으로 어울리는 도시적이고 세련된 스타일 추천해줘';

  @override
  String get stilSporBaslik => '🏃 스포티 & 편안한 스타일';

  @override
  String get stilSporSoru => '주말 야외 활동에 딱 맞는 활동적이고 편안한 룩 추천해줘';

  @override
  String get stilGeceBaslik => '🌙 드레스업 & 나이트라이프';

  @override
  String get stilGeceSoru => '특별한 저녁 식사나 모임에 어울리는 근사한 코디 추천해줘';

  @override
  String get ilkGorevBaslik => '🎯 첫 걸음: 선호하는 스타일을 선택하세요!';

  @override
  String get ilkGorevAciklama => 'FitCheck AI가 즉시 맞춤형 코디를 제안합니다. 오늘 어디로 가시나요?';

  @override
  String get haftalikUyariButon => '확인';

  @override
  String get haftalikUyariDolapBosBaslik => '옷장이 비어 있습니다!';

  @override
  String get haftalikUyariDolapBosIcerik => '주간 코디를 계획하려면 먼저 옷장에 의류를 추가해야 합니다.';

  @override
  String get haftalikUyariUstEksikBaslik => '상의가 부족해요!';

  @override
  String get haftalikUyariUstEksikIcerik => '옷장에 깨끗한 상의가 없습니다.';

  @override
  String get haftalikUyariAltEksikBaslik => '하의가 부족해요!';

  @override
  String get haftalikUyariAltEksikIcerik => '옷장에 깨끗한 하의가 없습니다.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => '신발이 부족해요!';

  @override
  String get haftalikUyariAyakkabiEksikIcerik => '옷장에 깨끗한 신발이 없습니다.';

  @override
  String get haftalikHata => '주간 일정을 생성하는 중 오류가 발생했습니다.';

  @override
  String get haftalikAjandaTitle => '주간 스타일 플래너';

  @override
  String get haftalikAnlikHavaDurumu => '이번 주 날씨 예보';

  @override
  String get haftalikKonumKontrol => '날씨 정보 불러오는 중...';

  @override
  String get haftalikTemizParca => '깨끗한 의류';

  @override
  String get haftalikSepette => '세탁 필요';

  @override
  String get haftalikPlanAciklama => 'AI가 날씨 예보에 맞춰 7일간의 스타일링을 자동으로 준비해 드립니다.';

  @override
  String get haftalikProgramOlustur => '주간 계획 생성하기';

  @override
  String get haftalikPlaniTemizle => '계획 초기화';

  @override
  String get haftalikAnalizEdiliyor => 'AI 분석 및 계획 중...';

  @override
  String get haftalikUyum => '스타일 조화';

  @override
  String get haftalikFavoriEkle => '즐겨찾기에 추가';

  @override
  String get haftalikGiyildiIsaretle => '오늘 입었어요';

  @override
  String get haftalikHava => '날씨:';

  @override
  String get haftalikHavaUyarisi => '참고: 해당 날짜의 날씨에 맞게 이 코디의 일부 아이템을 변경했습니다.';

  @override
  String get haftalikUyumsuzParca => '부족한 아이템';

  @override
  String get haftalikEksikParcaStilistNotu =>
      '부족한 아이템을 고려해 보유한 깨끗한 아이템으로 스타일리스트가 추천을 만들었습니다.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      '이 날짜를 채울 만큼 깨끗한 아이템이 부족합니다. 새 아이템을 추가하거나 빨래를 하면 스타일리스트가 여기에 새로운 코디를 추천합니다.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'AI 코디 제안';

  @override
  String get haftalikEksikParcaOneriYok =>
      '계획을 새로 고치면 부족한 아이템을 채워 줄 상의·하의·신발 조합을 볼 수 있어요.';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'AI 스타일리스트 코디 제안';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor => '스타일리스트가 코디를 준비하고 있어요…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      '상의와 하의가 없으면 코디를 만들 수 없어요. 스타일리스트가 위에 제안을 준비했어요.';

  @override
  String get haftalikNot => '메모';

  @override
  String get haftalikTrendyolAra => 'Trendyol에서 검색';

  @override
  String get izinZorunluMesaj => '앱을 정상적으로 사용하려면 다음 권한이 필요합니다.';

  @override
  String get izinGerekliBaslik => '필수 권한 안내';

  @override
  String get izinGerekliIcerik => '카메라 및 위치 접근 권한이 거부되었습니다. 설정에서 승인해 주세요.';

  @override
  String get ayarlaraGit => '설정으로 이동';

  @override
  String get izinAnaBaslik => '권한 요청';

  @override
  String get izinAciklama =>
      '최적의 코디 추천을 제공하기 위해 위치(날씨) 및 카메라(사진 촬영) 권한이 필요합니다.';

  @override
  String get konumIzni => '위치 정보 접근 권한';

  @override
  String get kameraIzni => '카메라 접근 권한';

  @override
  String get izinVerDevamEt => '권한 허용 후 시작';

  @override
  String get gunlukHavaMevcutDegil => '날씨 데이터를 사용할 수 없음';

  @override
  String get profilAnalizTitle => '프로필 & 분석';

  @override
  String get anlikDurum => '현재 상태';

  @override
  String get toplamParca => '총 의류 수';

  @override
  String get favoriKombin => '최애 코디';

  @override
  String get gardiropDegeri => '총 옷장 가치';

  @override
  String get ortalamaMaliyet => '평균 착용 비용';

  @override
  String get kategoriDagilimi => '카테고리별 비중';

  @override
  String get ustGiyim => '상의';

  @override
  String get altGiyim => '하의';

  @override
  String get ayakkabi => '신발';

  @override
  String get disGiyim => '아우터';

  @override
  String get aksesuar => '액세서리';

  @override
  String get sonGiyecekGecmisi => '최근 착용 기록';

  @override
  String get kayit => '기록';

  @override
  String get gecmisKombinYok => '아직 저장된 착용 기록이 없습니다.';

  @override
  String get parca => '개';

  @override
  String get onboardingHosGeldinBaslik => 'FitCheck에 오신 것을 환영합니다! ✨';

  @override
  String get onboardingDolabiniDijitallestir => '나만의 옷장 디지털화';

  @override
  String get onboardingDolapAciklama => '몇 초 만에 옷을 등록하고 가상 옷장을 완성해 보세요.';

  @override
  String get onboardingHavaDurumu => '날씨 맞춤 스타일링';

  @override
  String get onboardingHavaAciklama => '현재 계신 지역의 실시간 날씨에 최적화된 코디를 제안받으세요.';

  @override
  String get onboardingYikama => '스마트한 세탁 관리';

  @override
  String get onboardingYikamaAciklama => '자주 입은 옷을 자동으로 감지하여 빨래 바구니로 이동시켜 줍니다.';

  @override
  String get onboardingEksikParca => '부족한 의류 추천';

  @override
  String get onboardingEksikAciklama =>
      '스타일을 완성하기 위해 부족한 아이템을 파악하고 쇼핑 아이디어를 얻으세요.';

  @override
  String get onboardingAnalitik => '상세한 옷장 분석';

  @override
  String get onboardingAnalitikAciklama =>
      '옷장의 총 가치, 1회 착용당 비용 및 스타일 취향을 분석해 드립니다.';

  @override
  String get onboardingStilist => 'AI 전담 스타일리스트';

  @override
  String get onboardingStilistAciklama =>
      '목적지만 알려주시면 AI가 단 몇 초 만에 완벽한 스타일을 연출해 드립니다.';

  @override
  String get onboardingAtla => '건너뛰기';

  @override
  String get onboardingModaProfiliniz => '패션 프로필';

  @override
  String get onboardingKadin => '여성';

  @override
  String get onboardingErkek => '남성';

  @override
  String get onboardingBasla => '시작하기';

  @override
  String get onboardingDevamEt => '다음';

  @override
  String get cinsiyetBaslik => '성별';

  @override
  String get tarzBaslik => '선호 스타일 (복수 선택 가능)';

  @override
  String get renkTercihiBaslik => '선호 컬러 팔레트';

  @override
  String get tenRengiBaslik => '퍼스널 컬러 / 피부 톤';

  @override
  String get kadin => '여성';

  @override
  String get erkek => '남성';

  @override
  String get cinsiyetBelirtilmemis => '선택 안 함';

  @override
  String get tarzSpor => '스포티';

  @override
  String get tarzKlasik => '클래식';

  @override
  String get tarzSokakModasi => '스트릿웨어';

  @override
  String get tarzMinimalist => '미니멀';

  @override
  String get renkKoyuTonlar => '다크 톤';

  @override
  String get renkPastel => '파스텔 톤';

  @override
  String get renkCanli => '비비드 컬러';

  @override
  String get renkNotr => '뉴트럴 톤';

  @override
  String get tenAcikBeyaz => '밝은 톤 / 쿨톤';

  @override
  String get tenBugday => '보통 톤 / 웜톤';

  @override
  String get tenEsmerKoyu => '어두운 톤 / 딥톤';

  @override
  String get hesabinizaGirisYapin => '계정 로그인';

  @override
  String get yeniHesapOlusturun => '새 계정 만들기';

  @override
  String get stilDunyanaTekrarHosGeldin => '다시 오신 것을 환영합니다! ✨';

  @override
  String get kombinleriniSaklamakIcinKatil => '나만의 스타일을 동기화하고 안전하게 저장하세요 🚀';

  @override
  String get girisYap => '로그인';

  @override
  String get girisYapGoogle => 'Google로 로그인';

  @override
  String get girisBeniHatirla => '기억하기';

  @override
  String get girisVeya => '또는';

  @override
  String get kayitOl => '회원가입';

  @override
  String get adinizVeyaLakabiniz => '이름 또는 닉네임';

  @override
  String get epostaAdresiniz => '이메일 주소';

  @override
  String get sifreniz => '비밀번호';

  @override
  String get girisYapVeBasla => '로그인하고 시작하기';

  @override
  String get kayitOlVeBasla => '가입하고 시작하기';

  @override
  String get misafirOlarakDevamEt => '게스트로 이용하기';

  @override
  String get lutfenEpostaVeSifreGiriniz => '이메일과 비밀번호를 입력해 주세요.';

  @override
  String get lutfenAdiniziGiriniz => '이름을 입력해 주세요.';

  @override
  String get kullanimKosullariBaslik => '이용약관 및 서비스 동의서';

  @override
  String get onaylamakIcinKaydirin => '동의하려면 끝까지 스크롤하세요';

  @override
  String get okudumAnladimKabulEdiyorum => '상기 이용약관을 숙지하였으며 이에 동의합니다.';

  @override
  String get kullanimKosullarini => '이용약관';

  @override
  String get okudumVeOnayliyorum => '에 동의합니다.';

  @override
  String get onaylamadanOnceKosullariOkuyun => '동의하기 전에 이용약관을 읽어주시기 바랍니다.';

  @override
  String get devamEtmekIcinKosullariKabulEdin => '계속 진행하려면 이용약관에 동의해야 합니다.';

  @override
  String get kullanimKosullariMetni =>
      'FITCHECK 서비스 이용약관\n\n최종 수정일: 2026년 8월 27일\n\nFitCheck 모바일 애플리케이션(이하 \"앱\")을 이용하시기 전에 본 이용약관(이하 \"약관\")을 주의 깊게 읽어주시기 바랍니다. 앱을 다운로드, 접속 또는 이용함으로써 귀하는 본 약관의 모든 조건에 동의하게 됩니다.\n\n1. 당사자 및 목적\n본 약관은 FitCheck 개발자와 앱을 다운로드하여 사용하는 개인 사용자(이하 \"사용자\") 간에 체결됩니다. 앱은 디지털 옷장 관리, 의류 추적, 날씨 기반 코디 제안 및 AI 스타일 컨설팅 서비스를 제공합니다.\n\n2. 서비스 범위 및 이용 조건\n• 연령 제한: 만 13세 이상만 본 앱을 이용할 수 있습니다.\n• 사용자 정보: 프로필 설정 시 입력한 이름, 성별, 스타일, 선호 색상의 정확성에 대한 책임은 사용자에게 있습니다.\n• 조언의 성격: AI가 제공하는 스타일 점수, 구매 제안, 세탁 알림은 참고용 제안에 불과합니다.\n• 기상 데이터: 일기 예보는 실시간 위치를 기반으로 수집됩니다. 개발자는 데이터의 불일치에 대해 책임을 지지 않습니다.\n\n3. 지적재산권 및 콘텐츠 권리\n사용자가 업로드한 의류 사진의 지적재산권은 사용자에게 귀속됩니다. FitCheck 로고, 디자인, 소프트웨어 코드 및 알고리즘의 모든 권리는 FitCheck에 있습니다.\n\n4. 개인정보 보호 및 데이터 보안\n업로드된 사진과 코디 기록은 기본적으로 사용자의 기기에 로컬로 저장됩니다. 위치 데이터는 실시간 날씨 요청 목적으로만 사용됩니다.\n\n5. 책임의 한계\nFitCheck는 중단 없는 서비스를 보장하지 않습니다. 기기 변경이나 앱 삭제로 인한 데이터 손실에 대해 책임을 지지 않습니다.\n\n6. 문의하기\n문의 사항은 설정 탭의 문의하기 섹션 또는 support@fitcheckapp.com으로 연락해주시기 바랍니다.\n\n--- 📜 약관 끝 ---\n아래 버튼을 눌러 이용약관에 동의해 주세요.';

  @override
  String chatKarsilama(Object hava) {
    return '안녕하세요! 👋 오늘 바깥 날씨는 $hava입니다. 당신의 스타일에 어울리는 근사한 코디를 만들어 볼까요? ✨';
  }

  @override
  String get chatGorselGonderildi => '이미지가 전송되었습니다.';

  @override
  String get chatAsistanSohbeti => 'AI 스타일리스트 대화';

  @override
  String get chatModHavaDuyarli => '날씨에 맞춘 스마트한 스타일 제안';

  @override
  String get chatStilistHazirliyor => '스타일리스트가 코디를 연출 중입니다...';

  @override
  String get chatGorselEklendi => '이미지가 첨부됨';

  @override
  String get chatTekrarDene => '다시 시도';

  @override
  String get chatKamera => '카메라';

  @override
  String get chatGaleri => '갤러리에서 이미지 선택';

  @override
  String get chatMikrofon => '마이크';

  @override
  String get chatGonder => '메시지 보내기';

  @override
  String get chatOneriYagmur => '🌧️ 비 오는 날 맞춤 코디';

  @override
  String get chatOneriOfis => '💼 오피스 / 스마트 캐주얼';

  @override
  String get chatOneriHaftaSonu => '☕ 주말 편안한 캐주얼룩';

  @override
  String get chatOneriKirliSepeti => '🧺 빨래 바구니 점검';

  @override
  String get chatDinleniyor => '음성 듣는 중...';

  @override
  String get chatBirSeylerYazin => '스타일리스트에게 메시지 입력...';

  @override
  String get chatKombiniGiydim => '오늘 이 코디 입었어요 👗';

  @override
  String get chatKombinIslendi => '오늘의 착용 코디로 기록되었습니다! 📅';

  @override
  String get chatGorselIncele => '이 이미지를 확인하고 스타일에 맞는 코디를 제안해 주세요.';

  @override
  String get profilAyarlariBaslik => '프로필 설정';

  @override
  String get cinsiyetTercihiBaslik => '성별 설정';

  @override
  String get stilAramaHint => '예: \'블랙 재킷이 포함된 스마트 캐주얼\', \'원피스\'...';

  @override
  String get stilFiltreTumu => '전체 아이템';

  @override
  String get stilFiltreSadeceTemizler => '깨끗한 옷만 보기';

  @override
  String get stilFiltreSadeceSepet => '세탁할 옷만 보기';

  @override
  String get profilFavoriKombinlerTitle => '즐겨찾는 코디';

  @override
  String get profilFavoriKombinYok => '아직 즐겨찾기에 추가된 코디가 없습니다.';

  @override
  String get profilYikamaSepetimTitle => '빨래 바구니';

  @override
  String get profilYikamaSepetimBos => '빨래 바구니가 비어 있습니다. 모든 옷이 깨끗해요! ✨';

  @override
  String get profilSepetiBosalt => '빨래 바구니 비우기';

  @override
  String get profilSepetiBosaltOnay =>
      '모든 의류가 \'세탁 완료(깨끗함)\' 상태로 변경됩니다. 진행하시겠습니까?';

  @override
  String get profilSepetiBosaltButon => '예, 모두 세탁 완료';

  @override
  String get profilTenRengi => '피부 톤 / 퍼스널 컬러';

  @override
  String get profilTarzTercihi => '선호 스타일';

  @override
  String get profilRenkPaleti => '선호 컬러 팔레트';

  @override
  String get rehberGardiropEkleTitle => '사진 추가하기';

  @override
  String get rehberGardiropEkleDesc => '의류 사진을 한 장씩 또는 여러 장 한 번에 등록해 보세요.';

  @override
  String get rehberAiStilistTitle => 'AI 스타일리스트';

  @override
  String get rehberAiStilistDesc => 'AI에게 개인 맞춤형 스타일 조화 및 코디 추천을 요청하세요.';

  @override
  String get rehberSesliTitle => '음성 명령 지원';

  @override
  String get rehberSesliDesc => '음성으로 편리하게 오늘 입을 옷을 추천받으세요.';

  @override
  String get rehberAyarlarTitle => '설정 & 프로필';

  @override
  String get rehberAyarlarDesc => '성별, 선호 스타일, 피부 톤 설정을 언제든지 변경할 수 있습니다.';

  @override
  String get rehberGardiropNavTitle => '나만의 옷장';

  @override
  String get rehberGardiropNavDesc => '등록한 모든 의류를 카테고리별로 깔끔하게 정리해 보세요.';

  @override
  String get rehberHaftalikNavTitle => '주간 플래너';

  @override
  String get rehberHaftalikNavDesc => '7일간의 일기 예보에 맞추어 일주일 코디를 미리 계획하세요.';

  @override
  String get rehberDolaptanNavTitle => 'AI 옷장 자동 코디';

  @override
  String get rehberDolaptanNavDesc =>
      '내 옷장에 있는 옷들로 AI가 당일 날씨에 맞는 최적의 조합을 만들어 줍니다.';

  @override
  String get rehberKendiNavTitle => 'DIY 커스텀 코디';

  @override
  String get rehberKendiNavDesc => '상의, 하의, 신발을 직접 매치하여 나만의 스타일을 디자인하세요.';

  @override
  String get rehberProfilNavTitle => '분석 & 세탁 관리';

  @override
  String get rehberProfilNavDesc => '의류 착용 통계를 확인하고 세탁이 필요한 옷들을 관리하세요.';

  @override
  String get simdilikAtla => '건너뛰기';

  @override
  String get uygulamaIzinleri => '앱 접근 권한';

  @override
  String get izinEkraniAciklama =>
      'FitCheck는 맞춤형 코디 제안과 날씨/세탁 알림을 제공하기 위해 다음 권한이 필요합니다.';

  @override
  String get konumIzniAciklama => '실시간 날씨 기반 맞춤 코디 제안 제공 목적';

  @override
  String get kameraIzniAciklama => '의류 사진을 촬영하여 옷장에 등록하기 위한 목적';

  @override
  String get bildirimIzni => '알림 권한';

  @override
  String get bildirimIzniAciklama => '세탁 알림 및 일기 예보 알림 수신 목적';

  @override
  String get izinleriVerVeBasla => '권한 승인하고 시작하기';

  @override
  String get dahaSonraAyarla => '나중에 설정';

  @override
  String get gunlukHakBittiBaslik => '일일 제공 횟수 초과!';

  @override
  String get dahaSonra => '나중에';

  @override
  String get reklamIzleHakKazan => '광고 시청하기 (+3회 추가)';

  @override
  String get tebriklerHakEklendi => '축하합니다! +3회 이용권이 추가되었습니다. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return '\"$kombinAdi\" 코디 착용 표시가 취소되었습니다.';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" 코디를 오늘 입은 옷으로 등록했습니다! 👕✨';
  }

  @override
  String get kiyafetDetayi => '의류 상세 정보';

  @override
  String get parcaDetayiBaslik => '아이템 상세 정보';

  @override
  String get farkliParcaSec => '다른 아이템 선택';

  @override
  String get farkliUstSec => '다른 상의 선택 👕';

  @override
  String get farkliAltSec => '다른 하의 선택 👖';

  @override
  String get farkliAyakkabiSec => '다른 신발 선택 👟';

  @override
  String get farkliDisSec => '다른 아우터 선택 🧥';

  @override
  String get baskaTemizKiyafetYok => '교체할 수 있는 깨끗한 옷이\n이 카테고리에 없습니다.';

  @override
  String get planiYenile => '플랜 새로고침';

  @override
  String get havaEtiketi => '날씨';

  @override
  String get yukleniyor => '불러오는 중...';

  @override
  String get temizle => '지우기';

  @override
  String get yenidenDegerlendiriliyor => '재분석 중...';

  @override
  String get kombinParcalariBaslik => '코디 구성 아이템';

  @override
  String get parcalariKaydirIpucu => '좌우로 스와이프하여 다른 아이템 보기 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ 이 아이템을 중심으로 완벽한 스타일을 완성했어요: $parcaAdi!';
  }

  @override
  String get sihirliDokunus => '랜덤 매치 셔플';

  @override
  String get dolabiKaristirEksikUyari =>
      '랜덤 셔플을 진행하려면 깨끗한 상의, 하의, 신발이 최소 1개 이상 필요합니다! 👕👖👟';

  @override
  String get zarlarAtildiYorumu => '🎲 주사위가 던져졌습니다! 색다른 멋진 조합을 발견해 보세요.';

  @override
  String get rastgeleKombinTuru => '랜덤 매치';

  @override
  String get temizAlternatifYok => '이 카테고리에 교체 가능한 깨끗한 옷이 더 이상 없습니다! 🧺';

  @override
  String get kisiselDokunus => '커스텀 조합';

  @override
  String get aiYeniParcaAnalizEdiyor => 'AI가 새로운 아이템을 분석하는 중입니다... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ 아이템을 변경하여 전반적인 룩의 밸런스가 더욱 좋아졌습니다!';

  @override
  String get parcaDegisimHataYorum => '✨ 아이템 변경으로 당신의 개성에 꼭 맞는 스타일이 완성되었습니다!';

  @override
  String get bilgileriDuzenleBaslik => '정보 수정';

  @override
  String get kiyafetAdiEtiketi => '의류 이름';

  @override
  String get renkEtiketi => '색상';

  @override
  String get kaydet => '저장';

  @override
  String get yenidenZarAt => '주사위 다시 던지기';

  @override
  String get zarAtKaristir => '주사위 던지기 (랜덤 셔플)';

  @override
  String get zarPopupBaslik => '마법의 주사위를 흔들어 보세요!';

  @override
  String get zarPopupAciklama =>
      '휴대폰을 흔들거나 아래 버튼을 눌러 주사위를 던지면 옷장에서 무작위 코디를 만들어 줍니다.';

  @override
  String get zarlariAt => '주사위 던지기';

  @override
  String get zarSalla => '주사위 흔들기';

  @override
  String get degistirmekIcinKaydirIpucu => '스와이프하거나 탭하여 아이템을 교체하세요 👈👉';

  @override
  String get favorilerdeEtiketi => '즐겨찾기 됨';

  @override
  String get bugunGiydildiEtiketi => '오늘 착용함 ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      '멋진 감각이네요! 톤과 스타일의 조화가 매끄럽게 어우러집니다.';

  @override
  String get kendiTasarimimBaslik => '나만의 스타일 연출';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return '$kategori 선택';
  }

  @override
  String get kendiKombininiTasarlaTitle => '코디 디자인하기';

  @override
  String get secimleriSifirla => '선택 초기화';

  @override
  String get kombinHazirAiTavsiyesi => '근사한 코디입니다! AI로 조화도를 분석하고 저장하세요.';

  @override
  String get kombinBaslaIpucu => '오늘 어떤 스타일을 연출하고 싶으신가요? 아이템을 선택해 보세요.';

  @override
  String get ustAltModu => '상의 + 하의';

  @override
  String get tekParcaElbiseModu => '원피스 / 한 벌 옷';

  @override
  String get tekParcaElbise => '원피스 / 한 벌 옷';

  @override
  String get aksesuarOpsiyonel => '액세서리 (선택)';

  @override
  String get stilistAnaliziBaslik => '스타일리스트 분석 결과';

  @override
  String get stilistDegerlendiriyor => '스타일리스트 평가 진행 중...';

  @override
  String get aiIleAnalizEtKaydet => 'AI로 분석 및 저장';

  @override
  String get bilinmiyor => '알 수 없음';

  @override
  String get karmasikSiklik => '세련되고 감각적인 스타일';

  @override
  String get gecmisiTemizleTitle => '기록 삭제';

  @override
  String get gecmisiTemizleOnayIcerik =>
      '모든 착용 기록을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get gecmisBasariylaTemizlendi => '기록이 성공적으로 삭제되었습니다 🗑️';

  @override
  String get kayitGecmistenSilindi => '해당 기록이 삭제되었습니다.';

  @override
  String get kombin => '코디';

  @override
  String get kombinDetayiUst => '코디 상세 정보';

  @override
  String get giyilenParcalarUst => '착용된 아이템';

  @override
  String get detayBulunamadi => '상세 정보를 찾을 수 없습니다.';

  @override
  String get henuzFavoriEklemediniz => '아직 즐겨찾기에 추가된 코디가 없습니다.';

  @override
  String get camasirSepetiTitle => '빨래 바구니';

  @override
  String get sepetBosTumKiyafetlerTemiz => '빨래 바구니가 비어 있습니다. 모든 옷이 깨끗해요!';

  @override
  String get tumKiyafetlerTemizlendi => '모든 의류가 세탁되어 옷장으로 복원되었습니다 🧺✨';

  @override
  String get tumunuTemizIsaretle => '모두 세탁 완료(깨끗함)로 표시';

  @override
  String get profilVeAnalizTitle => '프로필 및 옷장 분석';

  @override
  String get harikaGidiyorsun => '매우 잘 관리하고 계십니다!';

  @override
  String gundurSeridesin(Object gun) {
    return '$gun일 연속 기록 중';
  }

  @override
  String get tumuTemiz => '모두 깨끗함';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '세탁 필요: $sayi개';
  }

  @override
  String get stilKimligin => '나만의 스타일 정체성';

  @override
  String get dolapVerimliligi => '옷장 활용도';

  @override
  String get renkPaletin => '컬러 팔레트';

  @override
  String get dolabinKahramanlari => '자주 입는 효자 아이템';

  @override
  String get derinlerdeUnutulanlar => '방치된 아이템';

  @override
  String get sonGiyilenler => '최근 입은 옷';

  @override
  String get tumunuTemizle => '전체 삭제';

  @override
  String get henuzGecmisKaydiYok => '아직 기록이 없습니다.';

  @override
  String kezGiyildi(Object sayi) {
    return '$sayi회 착용';
  }

  @override
  String get ayarlarTitle => '설정';

  @override
  String get hesapVeGuvenlikMerkeziUst => '계정 및 보안 센터';

  @override
  String get kullaniciHesabi => '사용자 계정';

  @override
  String get misafirKullanici => '게스트 사용자';

  @override
  String get epostaDogrulanmis => '이메일 인증 완료';

  @override
  String get esitlemekIcinGirisYapin => '기기 간 데이터 동기화를 위해 로그인하세요.';

  @override
  String get cikisYapTitle => '로그아웃';

  @override
  String get cikisYapOnayIcerik => '계정에서 로그아웃하시겠습니까?';

  @override
  String get bagliHesaplarUst => '연결된 계정';

  @override
  String get googleHesabiBagli => 'Google 계정 연동됨';

  @override
  String get googleHesabiniBagla => 'Google 계정 연동하기';

  @override
  String get googleHesabiBaglandi => 'Google 계정이 успішно 연동되었습니다! 🔗';

  @override
  String get googleHesabiBaglantisiKesildi => 'Google 계정 연동이 해제되었습니다.';

  @override
  String get sifreVeGuvenlik => '비밀번호 및 보안';

  @override
  String get sifreYenilemeBaglantisiIste => '비밀번호 재설정 링크 요청';

  @override
  String get sifremiUnuttum => '비밀번호를 잊으셨나요?';

  @override
  String get sifreDegistirTitle => '비밀번호 변경';

  @override
  String get sifreSifirlamaAciklama => '등록된 이메일 주소로 비밀번호 재설정 링크가 발송됩니다:';

  @override
  String get epostaAdresi => '이메일 주소';

  @override
  String get gecerliBirEpostaGiriniz => '유효한 이메일 주소를 입력해 주세요';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return '$eposta 주소로 재설정 이메일을 보냈습니다! ✉️';
  }

  @override
  String get baglantiGonder => '재설정 링크 발송';

  @override
  String get hesabiKaliciSilTitle => '계정 영구 삭제';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      '이 작업은 되돌릴 수 없습니다. 등록된 옷장 데이터 및 프로필 정보가 영구적으로 삭제됩니다.';

  @override
  String get hesabiSilOnayKoduMetni => '확인을 위해 아래에 \"fitcheck\"를 입력해 주세요:';

  @override
  String get vazgec => '취소';

  @override
  String get hesabimiSil => '계정 삭제하기';

  @override
  String get hesabinizSilindi => '계정 및 관련 데이터가 삭제되었습니다.';

  @override
  String get kisiselStilVeProfilUst => '개인 스타일 & 프로필';

  @override
  String get stilVeTarzTercihleri => '스타일 및 핏 선호도';

  @override
  String get secili => '선택됨';

  @override
  String get tenRengiTercihinizUst => '피부 톤 설정';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'AI 스타일 설정';

  @override
  String get stilistKisiligiVeYantitTarziUst => '스타일리스트 페르소나 및 답변 스타일';

  @override
  String get aiKisilikSamimiBaslik => '친근함 & 다정함';

  @override
  String get aiKisilikSamimiAciklama => '패션을 재미있고 접근하기 쉽게 만들어 주는 따뜻하고 격려하는 어조';

  @override
  String get aiKisilikElestirmenBaslik => '전문 패션 비평가';

  @override
  String get aiKisilikElestirmenAciklama => '색채학 및 실루엣 이론에 기초한 전문적인 지적 중심';

  @override
  String get aiKisilikMinimalistBaslik => '미니멀 & 핵심 직언';

  @override
  String get aiKisilikMinimalistAciklama => '군더더기 없는 간결하고 명확한 스타일 추천';

  @override
  String get sikiRenkTeorisiUyumModu => '엄격한 색채 이론 모드';

  @override
  String get sikiRenkTeorisiAciklama => '활성화 시 AI가 정통 클래식 색상 조합 규칙을 엄격하게 적용합니다';

  @override
  String get bildirimlerVeHatirlaticiUst => '알림 & 리마인더';

  @override
  String get sabahKombinOnerisi => '아침 코디 추천 알림';

  @override
  String herSabahBildirimAl(Object saat) {
    return '매일 $saat에 알림 받기';
  }

  @override
  String get bildirimSaatiniOzellestir => '알림 시간 설정';

  @override
  String get gunlukKombinBildirimSaati => '일일 코디 알림 시간';

  @override
  String get sabahBildirimSaatiSec => '아침 알림 시간 선택';

  @override
  String get saatKaydedildiAksama => '시간이 저장되었으나 알림 서비스를 이용할 수 없습니다.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return '아침 알림이 $saat로 설정되었습니다. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari => '계속 진행하려면 기기 설정에서 알림 권한을 승인해 주세요.';

  @override
  String get camasirSepetiUyarilari => '빨래 바구니 알림';

  @override
  String get camasirSepetiUyarilariAciklama => '세탁할 옷이 쌓이면 알림을 보냅니다';

  @override
  String get haftalikStilRaporu => '주간 스타일 리포트';

  @override
  String get haftalikStilRaporuAciklama => '매주 일요일 저녁 한 주간의 옷장 활용 요약을 제공합니다';

  @override
  String get gorunumVeBolgeUst => '화면 설정 및 지역';

  @override
  String get lokasyonVeBirimlerUst => '위치 및 단위';

  @override
  String get sicaklikBirimi => '온도 단위';

  @override
  String get varsayilanSehirBolge => '기본 도시 / 지역';

  @override
  String get sehirOrnekHint => '예: 서울, 부산, 인천';

  @override
  String get gpsKullan => 'GPS 사용';

  @override
  String get veriVeDepolamaYonetimiUst => '데이터 및 저장공간 관리';

  @override
  String get gorselOnbelleginiTemizle => '이미지 캐시 비우기';

  @override
  String get geciciFotografHafizasiAciklama => '사진 처리를 위해 사용된 임시 저장공간을 확보합니다';

  @override
  String get onbellekTemizlendiBasari => '이미지 캐시 및 임시 파일이 삭제되었습니다! ✨';

  @override
  String get onbellekTemizlerkenHata => '캐시를 비우는 동안 문제가 발생했습니다.';

  @override
  String get gardirobuDisaAktarYedekle => '옷장 데이터 내보내기 (백업)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      '등록된 모든 의류 및 코디 데이터를 JSON 형식으로 내보냅니다';

  @override
  String get disaAktarilacakVeriYok => '내보낼 옷장 데이터가 없습니다. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      '모든 옷장 데이터가 클립보드에 JSON 형식으로 복사되었습니다! 📋';

  @override
  String get destekVeDegerlendirmeUst => '지원 및 평가';

  @override
  String get uygulamayiDegerlendirin => '앱 평가하기';

  @override
  String get googlePlay5YildizDestek => 'Google Play에서 별점 5점으로 개발자를 응원해 주세요 ⭐';

  @override
  String get googlePlayAcilamadi => 'Google Play를 열 수 없습니다.';

  @override
  String get geriBildirimVeDestek => '피드백 및 고객 지원';

  @override
  String get hataBildirVeyaOneri => '버그 제보 및 기능 제안';

  @override
  String get islemTamamlanamadi => '작업을 완료할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get epostaUygulamasiAcilamadi =>
      '이메일 앱을 열 수 없습니다. ayberkzcn9@gmail.com 으로 직접 보내주세요.';

  @override
  String get gizlilikPolitikasiTitle => '개인정보 처리방침';

  @override
  String get veriKullanimiVeGizlilikHaklari => '데이터 사용 방식 및 개인정보 보호 권리 확인';

  @override
  String get sonGuncellemeTarihi => '최종 수정일: 2026년 8월 27일';

  @override
  String get gizlilikMadde1Baslik => '1. 데이터 수집 및 이용';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck는 옷장 관리 및 코디 제안을 최적화하기 위해 정보를 처리합니다. 사진, 스타일 및 성별 설정은 사용자의 기기에 로컬로 저장됩니다.';

  @override
  String get gizlilikMadde2Baslik => '2. 위치 정보 권한';

  @override
  String get gizlilikMadde2Icerik =>
      '실시간 위치 정보는 일기 예보를 받아오기 위한 목적으로만 Open-Meteo 서비스를 통해 익명으로 처리됩니다. 데이터는 저장되거나 공유되지 않습니다.';

  @override
  String get gizlilikMadde3Baslik => '3. 음성 어시스턴트 및 마이크';

  @override
  String get gizlilikMadde3Icerik =>
      '음성 명령 사용 시 말소리는 즉시 텍스트로 변환됩니다. 음성 녹음 데이터는 영구 저장되지 않습니다.';

  @override
  String get gizlilikMadde4Baslik => '4. 제3자 서비스';

  @override
  String get gizlilikMadde4Icerik =>
      '앱의 성능 분석 및 광고 제공을 위해 Firebase 및 Google AdMob 인프라가 사용됩니다.';

  @override
  String get anladim => '확인했습니다';

  @override
  String get stilVeModaTercihleriniz => '스타일 & 패션 선호도';

  @override
  String get stilModalAciklama =>
      'AI는 코디를 구성할 때 사용자가 설정한 스타일과 핏 선호도를 최우선으로 반영합니다.';

  @override
  String get favoriTarzinizUst => '선호 스타일';

  @override
  String get giyimKesimiFitUst => '실루엣 / 핏';

  @override
  String get hesapSilmeUst => '계정 삭제';

  @override
  String get tumBulutVeYerelVeriTemizlenir => '기기 및 클라우드에 저장된 모든 데이터가 삭제됩니다';

  @override
  String get hakkindaUst => '정보';

  @override
  String get topluFotografEkleTooltip => '의류 한 번에 대량 추가';

  @override
  String get kuponKoduKullanTitle => '프로모션 코드 사용';

  @override
  String get kuponKoduAciklama => '추가 코디 생성권을 받으려면 아래에 프로모션 코드를 입력하세요:';

  @override
  String get kuponKoduHint => '예: VIP2026';

  @override
  String get kuponKullanButon => '사용하기';

  @override
  String get kuponBasariliMesaji => '🎉 프로모션 코드가 적용되었습니다! 코디 생성권이 추가되었습니다.';

  @override
  String get kuponKullanilmisUyari => '⚠️ 이미 사용된 프로모션 코드입니다!';

  @override
  String get kuponGecersizUyari => '❌ 유효하지 않은 코드입니다! 다시 확인해 주세요.';

  @override
  String get sinirsizIslemHakkiBaslik => '무제한 이용권 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return '남은 생성권: $hak회 ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      '프리미엄 혜택으로 제한 없이 무제한 코디 생성 및 스타일 분석을 이용하실 수 있습니다.';

  @override
  String get gunlukHakAciklama =>
      '일일 이용권은 매일 00:00에 리셋됩니다. 광고를 시청하거나 코드를 입력하여 추가로 획득할 수 있습니다.';

  @override
  String get kuponKullan => '프로모션 코드 입력';

  @override
  String get hakEklendiTebrikler => '축하합니다! +3회 이용권이 추가되었습니다. ✨';

  @override
  String get gardirobunDolduTitle => '옷장이 가득 찼습니다!';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return '최대 용량인 $limit개에 도달했습니다. 짧은 영상 광고를 시청하고 옷장 용량을 +3개 늘리시겠습니까? 👕';
  }

  @override
  String get reklamIzleSlotEkle => '광고 시청 (+3슬롯 추가)';

  @override
  String get yeniSlotEklendiTebrikler => '축하합니다! 옷장에 새로운 슬롯 +3개가 추가되었습니다. 🎉';

  @override
  String get gunlukHakBittiTitle => '일일 무료 횟수 소진!';

  @override
  String get gunlukHakBittiIcerik =>
      '오늘의 무료 횟수를 모두 사용하셨습니다. 영상 광고를 시청하거나 코드를 입력하여 새로운 생성권을 받아보세요! 🛍️';

  @override
  String get kuponGir => '코드 입력';

  @override
  String get anaSemsiyeBildirimBaslik => '우산을 잊지 마세요! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      '오늘 비가 올 예정입니다. 비에 젖지 않는 적절한 의류를 선택해 보세요.';

  @override
  String get anaCamasirGunuBildirimBaslik => '즐거운 세탁 날! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      '빨래 바구니에 옷이 많이 쌓였습니다. 세탁기를 돌릴 시간이에요!';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ 이 아이템과 함께 입으려면 어떤 옷이 어울릴까요? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return '코디 연출이 완료되었습니다 ($ortam)';
  }

  @override
  String get chatKombiniGorButon => '코디 확인하기';

  @override
  String get chatStilistKombinTasarlayor => '스타일리스트가 스타일을 디자인 중입니다...';

  @override
  String get chatStilistYaziyor => '스타일리스트가 작성 중입니다...';

  @override
  String get pazartesi => '월요일';

  @override
  String get sali => '화요일';

  @override
  String get carsamba => '수요일';

  @override
  String get persembe => '목요일';

  @override
  String get cuma => '금요일';

  @override
  String get cumartesi => '토요일';

  @override
  String get pazar => '일요일';

  @override
  String get rehberiAtla => '가이드 건너뛰기';

  @override
  String get rehberAnladimBasla => '확인했어요, 시작하기!';

  @override
  String get rehberSonrakiAdim => '다음 단계 ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik => '📸 나만의 옷장 디지털화';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      '이 버튼을 눌러 사진을 촬영하거나 갤러리에서 불러와 가상 옷장을 구축하세요.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ 음성 스타일 어시스턴트';

  @override
  String get rehberSesliAsistanAciklama =>
      '음성 명령으로 입을 옷을 물어보거나 실시간 코디 제안을 받을 수 있습니다.';

  @override
  String get rehberAiStilistBaslik => '✨ AI 스타일리스트 추천';

  @override
  String get rehberAiStilistAciklama =>
      '날씨, 피부 톤, 선호 스타일에 맞춘 나만의 맞춤 코디를 터치 한 번으로 확인하세요.';

  @override
  String get rehberAyarlarBaslik => '⚙️ 개인화 & 설정';

  @override
  String get rehberAyarlarAciklama =>
      '성별, 퍼스널 컬러, 선호 색상 및 테마를 설정하거나 앱 안내 가이드를 다시 볼 수 있습니다.';

  @override
  String get rehberNavGardirobumBaslik => '👔 나만의 옷장';

  @override
  String get rehberNavGardirobumAciklama => '등록된 모든 옷을 카테고리별로 쉽게 조회하고 관리하세요.';

  @override
  String get rehberNavHaftalikBaslik => '📅 주간 스타일 플래너';

  @override
  String get rehberNavHaftalikAciklama =>
      '7일간의 날씨 예보를 기반으로 일주일 데일리룩을 미리 계획해 보세요.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 AI 옷장 자동 코디';

  @override
  String get rehberNavDolaptanAciklama =>
      '가지고 계신 옷들을 활용해 AI가 매일 최적의 스타일을 추천합니다.';

  @override
  String get rehberNavKendiBaslik => '🎨 커스텀 코디 디자이너';

  @override
  String get rehberNavKendiAciklama => '상의, 하의, 신발을 직접 매치하여 자신만의 스타일을 저장하세요.';

  @override
  String get rehberNavProfilBaslik => '📊 분석 & 세탁 관리';

  @override
  String get rehberNavProfilAciklama =>
      '의류별 착용 통계를 확인하고 세탁이 필요한 옷들을 체계적으로 관리하세요.';

  @override
  String get bildirimIzinGerekliBaslik => '알림 권한 필요';

  @override
  String get bildirimIzinGerekliIcerik =>
      '세탁 알림, 비 예보 알림 및 일일 스타일 팁을 수신하려면 알림 권한을 허용해 주시기 바랍니다.';

  @override
  String get bildirimGunaydinBaslik => '좋은 아침입니다! ☀️';

  @override
  String get bildirimGunaydinIcerik =>
      '오늘 날씨에 딱 어울리는 멋진 코디를 준비했습니다. 지금 확인해 보시겠어요?';

  @override
  String get bildirimKanalGenelBaslik => '일반 알림';

  @override
  String get bildirimKanalGenelAciklama => 'FitCheck 앱의 일반 업데이트 알림';

  @override
  String get bildirimKanalGunlukBaslik => '일일 코디 제안';

  @override
  String get bildirimKanalGunlukAciklama => '매일 제공되는 맞춤 코디 알림';

  @override
  String get bildirimKanalYikamaBaslik => '세탁 리마인더';

  @override
  String get bildirimKanalYikamaAciklama => '세탁 관리 및 의류케어 리마인더';

  @override
  String get bildirimKanalRaporBaslik => '주간 스타일 리포트';

  @override
  String get bildirimKanalRaporAciklama => '한 주간의 옷장 활용도 및 스타일 요약 알림';

  @override
  String get tenRengiAcik => '밝은 톤 / 쿨톤';

  @override
  String get tenRengiBugday => '보통 톤 / 웜톤';

  @override
  String get tenRengiEsmer => '어두운 톤 / 딥톤';

  @override
  String get stilStreetwear => '스트릿 / 데일리 캐주얼';

  @override
  String get stilKlasik => '클래식 / 포멀';

  @override
  String get stilMinimalist => '미니멀';

  @override
  String get stilSpor => '스포티 / 애슬레저';

  @override
  String get stilVintage => '빈티지 / 레트로';

  @override
  String get fitSlim => '슬림 핏 (Slim Fit)';

  @override
  String get fitRegular => '레귤러 핏 (Regular)';

  @override
  String get fitOversize => '오버사이즈 / 루즈 핏';

  @override
  String get gardirobumBosBaslik => '옷장이 비어 있습니다!';

  @override
  String get gardirobumGizlendiBaslik => '옷장 숨김 상태';

  @override
  String get gardirobumGizlendiAciklama =>
      '상단 중앙의 눈 모양 아이콘을 누르면 내용을 다시 볼 수 있습니다.';

  @override
  String get gardirobumGoster => '내용 표시하기';

  @override
  String get gardirobumGizle => '내용 숨기기';

  @override
  String get kategoriUst => '상의';

  @override
  String get kategoriAlt => '하의';

  @override
  String get kategoriAyakkabi => '신발';

  @override
  String get kategoriAksesuar => '액세서리';

  @override
  String get gardirobumBosAciklama => '지금 첫 번째 옷을 등록하고 AI의 놀라운 추천을 경험해 보세요.';

  @override
  String get gardirobumAiIslem1 => '옷장 데이터 분석 중...';

  @override
  String get gardirobumAiIslem2 => '기상 조건 확인 중...';

  @override
  String get gardirobumAiIslem3 => '색상 데이터 매칭 중...';

  @override
  String get gardirobumAiIslem4 => '최적의 조합 선택 중...';

  @override
  String get gardirobumAiIslem5 => '스타일 디테일 마무리 중...';

  @override
  String get gardirobumHakBittiBaslik => '일일 등록 제한 도달';

  @override
  String get gardirobumHakBittiAciklama => '오늘 생성할 수 있는 코디 횟수를 모두 소진하셨습니다.';

  @override
  String get gardirobumHakEklendiMesaj => '축하합니다! 새로운 코디 권한이 추가되었습니다.';

  @override
  String get ayarlariAc => '설정 열기';

  @override
  String get kiyafetEkle => '의류 추가';

  @override
  String get kameraIleCek => '카메라로 촬영';

  @override
  String get galeridenSecToplu => '갤러리에서 여러 개 선택';

  @override
  String get kameraIzniGerekliBaslik => '카메라 권한 필요';

  @override
  String get kameraIzniGerekliAciklama => '사진을 촬영하려면 카메라 접근 권한을 승인해 주세요.';

  @override
  String get kiyafetDuzenleBaslik => '의류 정보 수정';

  @override
  String get kategori => '카테고리';

  @override
  String get evetSil => '예, 삭제합니다';

  @override
  String get favorilerdenCikarildi => '즐겨찾기에서 삭제되었습니다.';

  @override
  String get gardirobumHenuzYokEkle => '아직 등록된 옷이 없습니다. 지금 추가해 보세요!';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return '한 번에 최대 $max장까지만 사진을 선택할 수 있습니다.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '총 $count개의 아이템';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '스타일 조화도 %$oran';
  }

  @override
  String get kombinSohbetAc => '이 코디에 대해 대화하기';

  @override
  String get kombinSohbetBaslik => '코디 채팅';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return '$gun 코디에 대한 대화';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return '\'$kombin\' 코디를 함께 살펴봐요! 색상 조화, 날씨, 대체 아이템 등 무엇이든 물어보세요. ✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 이 코디가 잘 어울리는 이유는?';

  @override
  String get kombinSohbetOneriAlternatif => '👟 다른 아이템을 추천해줘';

  @override
  String get kombinSohbetOneriHava => '🌦️ 날씨가 바뀌면 어떻게 입지?';

  @override
  String get kombinSohbetOneriAksesuar => '💍 액세서리를 추천해줘';

  @override
  String get kombinSohbetAltBaslikAnlik => '지금 코디에 대한 채팅';

  @override
  String get chatKirliSepetiBos =>
      '🧺 빨래 바구니가 비어 있어요! 모든 아이템을 바로 입을 수 있으니, 언제든 코디를 추천해 드릴게요. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 빨래 바구니에 **$sayi**개의 아이템이 기다리고 있어요:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      '이 아이템들은 세탁 전까지 코디 추천에 포함되지 않아요. 원하시면 깨끗한 아이템으로 지금 바로 코디를 만들어 드릴게요.';

  @override
  String get analitikVerileriPaylas => '분석 데이터 공유';

  @override
  String get analitikVerileriPaylasAciklama =>
      '앱 개선을 위해 익명 사용 데이터가 전송됩니다. 끄면 이 기기에 저장된 분석 데이터가 삭제됩니다.';

  @override
  String get chatKarsilamaHavaYok =>
      '안녕하세요! 👋 당신의 스타일에 어울리는 근사한 코디를 만들어 볼까요? ✨';

  @override
  String get premiumBaslik => '월간 광고 없는 이용';

  @override
  String get premiumAciklama =>
      '광고 없이 FitCheck를 이용하세요. 구독이 활성 상태인 동안 모든 광고가 제거됩니다.';

  @override
  String get premiumOzellikReklamsiz => '모든 광고가 제거됩니다';

  @override
  String get premiumOzellikAylik => '매월 자동으로 갱신됩니다';

  @override
  String get premiumOzellikMagaza => 'Google Play에서 관리됩니다';

  @override
  String get premiumAktifMesaji => '프리미엄이 활성화되었습니다. 이 계정에서는 광고가 꺼져 있습니다.';

  @override
  String get premiumAboneOl => '월간 구독하기';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return '월간 구독하기 • $fiyat';
  }

  @override
  String get premiumGeriYukle => '구매 복원';

  @override
  String get premiumMagazaHazirDegil =>
      '지금은 Google Play에 연결할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get premiumSatinAlmaBaslatilamadi => '구매를 시작할 수 없습니다.';

  @override
  String get premiumSatinAlmaBasarisiz => '구매에 실패했습니다.';

  @override
  String get premiumAylikBaslik => '월간 광고 없는 프리미엄';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return '월 $fiyat로 광고 제거';
  }

  @override
  String premiumGec(String fiyat) {
    return '프리미엄으로 전환 • 월 $fiyat';
  }

  @override
  String get guncellemeBaslik => '업데이트가 필요합니다';

  @override
  String get guncellemeAciklama =>
      'FitCheck의 새 버전이 출시되었습니다. 계속하려면 앱을 업데이트해 주세요.';

  @override
  String get guncellemeButonu => '지금 업데이트';

  @override
  String guncellemeYeniSurum(String surum) {
    return '새 버전: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok => '스토어 링크를 열 수 없습니다. 스토어에서 앱을 업데이트해 주세요.';

  @override
  String get premiumUrunBulunamadi => '구독 정보를 불러오지 못했습니다. 나중에 다시 시도해 주세요.';

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
  String get kombinOyunuBaslik => '콤비네이션 게임';

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
  String get degerlendirmeBaslik => 'FitCheck이 마음에 드시나요?';

  @override
  String get degerlendirmeIcerik =>
      '앱이 마음에 드신다면 5초만 투자해서 리뷰를 남겨주시겠어요? 작은 리뷰가 큰 힘이 됩니다! ⭐ 리뷰를 남긴 분께 +3 무료 크레딧을 선물로 드립니다!';

  @override
  String get degerlendirmeEvet => '네, 평가할게요';

  @override
  String get degerlendirmeBelkiSonra => '나중에';

  @override
  String get yakinda => '곧 공개';

  @override
  String get yakindaAciklama => '이 기능을 준비하고 있어요, 곧 만나요!';
}
