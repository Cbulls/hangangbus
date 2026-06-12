// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get timetableTitle => '시간표';

  @override
  String get directionMagokToYeouido => '마곡 → 여의도';

  @override
  String get directionYeouidoToMagok => '여의도 → 마곡';

  @override
  String get dockMagok => '마곡';

  @override
  String get dockMangwon => '망원';

  @override
  String get dockYeouido => '여의도';

  @override
  String get dockApgujeong => '압구정';

  @override
  String get dockOksu => '옥수';

  @override
  String get dockTtukseom => '뚝섬';

  @override
  String get dockJamsil => '잠실';

  @override
  String get directionToYeouido => '여의도행';

  @override
  String get directionToMagok => '마곡행';

  @override
  String get directionToJamsil => '잠실행';

  @override
  String get nextBoat => '다음 배';

  @override
  String get firstBoat => '첫차';

  @override
  String get lastBoat => '막차';

  @override
  String departIn(String time) {
    return '$time 출발';
  }

  @override
  String get serviceClosedToday => '오늘 운행 종료';

  @override
  String tomorrowFirstBoat(String time) {
    return '내일 첫차 $time';
  }

  @override
  String get transferHub => '환승';

  @override
  String get yeouidoTransferTitle => '여의도 환승 안내';

  @override
  String get routeOverview => '노선도';

  @override
  String boundFor(String dock) {
    return '$dock행';
  }

  @override
  String minutesLeft(int minutes) {
    return '$minutes분 후';
  }

  @override
  String hoursMinutesLeft(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String get departed => '출발 완료';

  @override
  String get storyPageTitle => '한강 역사/맛집';

  @override
  String get storyPageSubtitle => '한강버스 선착장 별 역사/맛집 정보';

  @override
  String get categoryHistory => '역사';

  @override
  String get categoryFood => '맛집';

  @override
  String get comingSoon => '준비 중입니다';

  @override
  String get infoLabelLocation => '위치';

  @override
  String get infoLabelAccess => '이동';

  @override
  String get infoLabelPeriod => '시대';

  @override
  String get infoLabelHours => '영업';

  @override
  String get infoLabelPrice => '가격';

  @override
  String dockSuffix(String dockName) {
    return '$dockName 선착장';
  }

  @override
  String get homeTitle => '한강버스';

  @override
  String get homeSubtitle => '실시간 운항 현황';

  @override
  String get nextArrival => '다음 도착 예정';

  @override
  String get freeShuttle => '무료 셔틀버스';

  @override
  String get parking => '주차';

  @override
  String parkingSpacesAvailable(int count) {
    return '$count면 가능';
  }

  @override
  String parkingSpacesSuffix(int count) {
    return '$count면';
  }

  @override
  String parkingSpacesTotal(int count) {
    return '총 $count면 중 가능';
  }

  @override
  String get fullTimetable => '전체 시간표';

  @override
  String get nearbyAttractions => '주변 명소';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get statTrips => '운항';

  @override
  String get statPassengers => '탑승객';

  @override
  String get statOnTime => '정시율';

  @override
  String get statusNormal => '정상 운행';

  @override
  String get statusPartial => '일부 중단';

  @override
  String get statusStopped => '전면 중단';

  @override
  String get facilityConvenienceStore => '편의점';

  @override
  String get facilityRamen => '라면체험존';

  @override
  String get facilityFastFood => '패스트푸드';

  @override
  String get facilityCafe => '카페';

  @override
  String dockSheetTitle(String name) {
    return '$name 선착장';
  }

  @override
  String get realtimeStatus => '실시간 현황';

  @override
  String get weatherInfo => '날씨 정보';

  @override
  String get hourlyForecast => '시간별 예보';

  @override
  String get fullForecast => '24시간 예보 전체보기';

  @override
  String get weatherForecast24h => '24시간 날씨 예보';

  @override
  String get accessInfo => '접근 수단';

  @override
  String walkingMinutes(int minutes) {
    return '도보 $minutes분';
  }

  @override
  String get facilities => '부대시설';

  @override
  String get scheduleAndMap => '지도';

  @override
  String feelsLike(String temp) {
    return '체감 $temp°';
  }

  @override
  String get humidity => '습도';

  @override
  String get windSpeed => '풍속';

  @override
  String get fineDust => '미세먼지';

  @override
  String get updatedMinutesAgo => '5분 전 업데이트';

  @override
  String get currentPopulation => '현재 인구';

  @override
  String get bikeShare => '따릉이';

  @override
  String bikeStationsCount(int count) {
    return '$count개소';
  }

  @override
  String bikesAvailable(int count) {
    return '$count대 이용 가능';
  }

  @override
  String get weeklyForecast => '주간 예보 보기';

  @override
  String get dustGood => '좋음';

  @override
  String get dustNormal => '보통';

  @override
  String get dustBad => '나쁨';

  @override
  String get dustVeryBad => '매우 나쁨';

  @override
  String get statusClosed => '운행 종료';

  @override
  String get endOfService => '운행 종료';

  @override
  String get boardingDeclaration => '한강버스 승선신고';

  @override
  String statTripsValue(int count) {
    return '$count회';
  }

  @override
  String statPassengersValue(int count) {
    return '$count명';
  }

  @override
  String get navHome => '홈';

  @override
  String get navSchedule => '시간표';

  @override
  String get navGuide => '가이드';

  @override
  String get navFaq => 'FAQ';

  @override
  String get tabFaq => '자주 묻는 질문';

  @override
  String get tabSafety => '안전 수칙';

  @override
  String get safetyTitleLifeVest => '구명조끼 위치';

  @override
  String get safetyLifeVestAdult => '각 좌석 하단 보관함에 성인용 구명조끼가 1개씩 비치되어 있습니다.';

  @override
  String get safetyLifeVestChild =>
      '유아·어린이용 구명조끼는 선내 전용 캐비닛(보관함)에 별도 보관되어 있습니다. 승무원에게 문의하세요.';

  @override
  String get safetyLifeVestAccess =>
      '구명조끼 보관함은 비상 시 즉시 꺼낼 수 있도록 항상 개방 상태를 유지합니다.';

  @override
  String get safetyTitleHowToWear => '구명조끼 착용법';

  @override
  String get safetyWearStep1 => '좌석 하단 보관함을 열어 구명조끼를 꺼냅니다.';

  @override
  String get safetyWearStep2 => '구명조끼를 머리 위에서 아래로 내려 입습니다.';

  @override
  String get safetyWearStep3 => '앞쪽 버클을 \"딸깍\" 소리가 날 때까지 채웁니다.';

  @override
  String get safetyWearStep4 => '허리 끈을 몸에 밀착되도록 당겨 조입니다.';

  @override
  String get safetyWearStep5 =>
      '입수 후에는 구명조끼 앞쪽의 빨간 손잡이(이산화탄소 팽창장치)를 힘껏 당겨 팽창시킵니다.';

  @override
  String get safetyWearTip =>
      '자동 팽창이 안 될 경우 구명조끼의 구강 팽창 튜브(노란색)를 입으로 불어 팽창시킵니다.';

  @override
  String get safetyTitleEvacuation => '비상 탈출 안내';

  @override
  String get safetyEvacExit =>
      '비상 출구는 선실 전방(선수)과 후방(선미) 양쪽에 위치합니다. 탑승 후 위치를 미리 확인해 두세요.';

  @override
  String get safetyEvacCalm => '비상 상황 발생 시 승무원의 안내 방송에 따라 침착하게 지정된 출구로 대피합니다.';

  @override
  String get safetyEvacStay => '배가 완전히 멈추기 전에는 절대 자리에서 일어나지 마세요.';

  @override
  String get safetyEvacRescue =>
      '대피 후 선착장 또는 구조선으로 이동하며, 한강경찰대·소방구조대와 실시간 연결된 구조 시스템이 즉시 출동합니다.';

  @override
  String get safetyTitleReporting => '비상 신고 방법';

  @override
  String get safetyReportCall => '선내 승무원에게 즉시 알리거나, 한강버스 고객센터 또는 119에 신고하세요.';

  @override
  String get safetyReportTube =>
      '선내에 비치된 구명튜브(링 부표)는 물에 빠진 사람을 향해 던져 구조할 수 있습니다.';

  @override
  String get safetyReportQR =>
      '탑승 전 반드시 QR코드로 승선 신고를 완료해 주세요. 사고 발생 시 신속한 구조에 필수적입니다.';

  @override
  String get safetyTitleAttention => '탑승 주의사항';

  @override
  String get safetyAttentionWave =>
      '선박 특성상 물결에 따라 흔들림이 있을 수 있습니다. 특히 다른 선박이 지나갈 때 흔들림이 심해질 수 있으니 손잡이를 잡으세요.';

  @override
  String get safetyAttentionDeck =>
      '갑판(야외 데크)에 나가려면 반드시 선내 QR코드로 승선 신고를 먼저 완료해야 합니다.';

  @override
  String get safetyAttentionDanger => '전기장비실 등 위험 구역에는 절대 출입하지 마세요.';

  @override
  String get safetyAttentionBike =>
      '개인 자전거는 탑승 가능하나, 따릉이 및 전동 킥보드(전기자전거 포함)는 탑승이 불가합니다.';

  @override
  String get safetyAttentionChild =>
      '어린이 동반 시 승무원에게 미아 발생 방지를 위한 안내를 요청할 수 있습니다.';

  @override
  String get emergencyBannerTitle => '긴급 상황 발생 시';

  @override
  String get emergencyBannerContact => '승무원 즉시 신고  |  119';

  @override
  String get emergencyBannerRescue => '한강경찰대·소방구조대 실시간 연결';
}
