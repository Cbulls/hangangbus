// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get timetableTitle => '時刻表';

  @override
  String get directionMagokToYeouido => '麻谷 → 汝矣島';

  @override
  String get directionYeouidoToMagok => '汝矣島 → 麻谷';

  @override
  String get dockMagok => '麻谷';

  @override
  String get dockMangwon => '望遠';

  @override
  String get dockYeouido => '汝矣島';

  @override
  String get dockApgujeong => '狎鴎亭';

  @override
  String get dockOksu => '玉水';

  @override
  String get dockTtukseom => 'トゥクソム';

  @override
  String get dockJamsil => '蚕室';

  @override
  String get directionToYeouido => '汝矣島行き';

  @override
  String get directionToMagok => '麻谷行き';

  @override
  String get directionToJamsil => '蚕室行き';

  @override
  String get nextBoat => '次の便';

  @override
  String get firstBoat => '始発';

  @override
  String get lastBoat => '最終';

  @override
  String departIn(String time) {
    return '$time 出発';
  }

  @override
  String get serviceClosedToday => '本日の運航は終了しました';

  @override
  String tomorrowFirstBoat(String time) {
    return '明日の始発 $time';
  }

  @override
  String get transferHub => '乗換';

  @override
  String get yeouidoTransferTitle => '汝矣島 乗換案内';

  @override
  String get routeOverview => '路線図';

  @override
  String boundFor(String dock) {
    return '$dock行き';
  }

  @override
  String minutesLeft(int minutes) {
    return '$minutes分後';
  }

  @override
  String hoursMinutesLeft(int hours, int minutes) {
    return '$hours時間 $minutes分';
  }

  @override
  String get departed => '出発済み';

  @override
  String get storyPageTitle => '漢江の歴史/グルメ';

  @override
  String get storyPageSubtitle => '漢江バス乗り場ごとの歴史・グルメ情報';

  @override
  String get categoryHistory => '歴史';

  @override
  String get categoryFood => 'グルメ';

  @override
  String get comingSoon => '準備中です';

  @override
  String get infoLabelLocation => '位置';

  @override
  String get infoLabelAccess => 'アクセス';

  @override
  String get infoLabelPeriod => '時代';

  @override
  String get infoLabelHours => '営業';

  @override
  String get infoLabelPrice => '料金';

  @override
  String dockSuffix(String dockName) {
    return '$dockName 乗り場';
  }

  @override
  String get homeTitle => '漢江バス';

  @override
  String get homeSubtitle => 'リアルタイム運航状況';

  @override
  String get nextArrival => '次の到着予定';

  @override
  String get freeShuttle => '無料シャトルバス';

  @override
  String get parking => '駐車';

  @override
  String parkingSpacesAvailable(int count) {
    return '$count台 空き';
  }

  @override
  String parkingSpacesSuffix(int count) {
    return '$count台';
  }

  @override
  String parkingSpacesTotal(int count) {
    return '全$count台中 空き';
  }

  @override
  String get fullTimetable => '全時刻表';

  @override
  String get nearbyAttractions => '周辺の名所';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get statusNormal => '通常運航';

  @override
  String get statusPartial => '一部運休';

  @override
  String get statusStopped => '全面運休';

  @override
  String get facilityConvenienceStore => 'コンビニ';

  @override
  String get facilityRamen => 'ラーメン体験ゾーン';

  @override
  String get facilityFastFood => 'ファストフード';

  @override
  String get facilityCafe => 'カフェ';

  @override
  String dockSheetTitle(String name) {
    return '$name 乗り場';
  }

  @override
  String get realtimeStatus => 'リアルタイム状況';

  @override
  String get weatherInfo => '天気情報';

  @override
  String get hourlyForecast => '時間別予報';

  @override
  String get fullForecast => '24時間予報をすべて見る';

  @override
  String get weatherForecast24h => '24時間天気予報';

  @override
  String get accessInfo => 'アクセス手段';

  @override
  String walkingMinutes(int minutes) {
    return '徒歩$minutes分';
  }

  @override
  String get facilities => '付帯施設';

  @override
  String get scheduleAndMap => '地図';

  @override
  String feelsLike(String temp) {
    return '体感 $temp°';
  }

  @override
  String get humidity => '湿度';

  @override
  String get windSpeed => '風速';

  @override
  String get fineDust => '微小粒子状物質';

  @override
  String get updatedMinutesAgo => '5分前に更新';

  @override
  String get currentPopulation => '現在の人口';

  @override
  String get bikeShare => 'ソウル自転車';

  @override
  String bikeStationsCount(int count) {
    return '$countカ所';
  }

  @override
  String bikesAvailable(int count) {
    return '$count台 利用可能';
  }

  @override
  String get weeklyForecast => '週間予報を見る';

  @override
  String get dustGood => '良い';

  @override
  String get dustNormal => '普通';

  @override
  String get dustBad => '悪い';

  @override
  String get dustVeryBad => '非常に悪い';

  @override
  String get statusClosed => '運航終了';

  @override
  String get endOfService => '運航終了';

  @override
  String get boardingDeclaration => '漢江バス乗船申告';

  @override
  String get statTrips => '運航';

  @override
  String statTripsValue(int count) {
    return '$count回';
  }

  @override
  String get statPassengers => '乗客';

  @override
  String statPassengersValue(int count) {
    return '$count人';
  }

  @override
  String get statOnTime => '定時運行率';

  @override
  String get liveStatusLabel => 'リアルタイム';

  @override
  String get liveDataUnavailable => '情報なし';

  @override
  String get liveUpdatedJustNow => 'たった今更新';

  @override
  String liveUpdatedAgo(int minutes) {
    return '$minutes分前に更新';
  }

  @override
  String get statTodayTrips => '本日の運航';

  @override
  String get statCongestion => '混雑度';

  @override
  String get statBikesShort => 'ソウル自転車';

  @override
  String get statParkingShort => '駐車';

  @override
  String get congestionRelaxed => '空いている';

  @override
  String get congestionNormal => '普通';

  @override
  String get congestionSlightlyBusy => 'やや混雑';

  @override
  String get congestionBusy => '混雑';

  @override
  String get congestionUnknown => '情報なし';

  @override
  String get navHome => 'ホーム';

  @override
  String get navSchedule => '時刻表';

  @override
  String get navGuide => 'ガイド';

  @override
  String get navFaq => 'FAQ';

  @override
  String get tabFaq => 'よくある質問';

  @override
  String get tabSafety => '安全のしおり';

  @override
  String get safetyTitleLifeVest => 'ライフジャケットの位置';

  @override
  String get safetyLifeVestAdult => '各座席下の収納ボックスに大人用ライフジャケットが1つずつ備え付けられています。';

  @override
  String get safetyLifeVestChild => '乳幼児・子供用ライフジャケットは船内専用キャビネット(収納ボックス)に別途保管されています。乗務員にお尋ねください。';

  @override
  String get safetyLifeVestAccess => 'ライフジャケット収納ボックスは緊急時にすぐ取り出せるよう、常に開放状態を保っています。';

  @override
  String get safetyTitleHowToWear => 'ライフジャケットの着用方法';

  @override
  String get safetyWearStep1 => '座席下の収納ボックスを開けてライフジャケットを取り出します。';

  @override
  String get safetyWearStep2 => 'ライフジャケットを頭からかぶって着用します。';

  @override
  String get safetyWearStep3 => '前側のバックルを「カチッ」と音がするまで留めます。';

  @override
  String get safetyWearStep4 => '腰ひもを体に密着するよう引いて締めます。';

  @override
  String get safetyWearStep5 => '入水後はライフジャケット前側の赤いハンドル(二酸化炭素膨張装置)を力強く引いて膨張させます。';

  @override
  String get safetyWearTip => '自動膨張しない場合は、ライフジャケットの口での膨張チューブ(黄色)を口で吹いて膨張させます。';

  @override
  String get safetyTitleEvacuation => '緊急脱出案内';

  @override
  String get safetyEvacExit => '非常口は船室の前方(船首)と後方(船尾)の両側にあります。乗船後、位置を事前に確認しておいてください。';

  @override
  String get safetyEvacCalm => '緊急時は乗務員の案内放送に従い、落ち着いて指定された出口へ避難します。';

  @override
  String get safetyEvacStay => '船が完全に停止するまでは、絶対に席を立たないでください。';

  @override
  String get safetyEvacRescue => '避難後は乗り場または救助船へ移動し、漢江警察隊・消防救助隊とリアルタイムで連携した救助システムが直ちに出動します。';

  @override
  String get safetyTitleReporting => '緊急通報の方法';

  @override
  String get safetyReportCall => '船内の乗務員に直ちに知らせるか、漢江バスお客様センターまたは119に通報してください。';

  @override
  String get safetyReportTube => '船内に備え付けられた救命浮環(リング型ブイ)は、水に落ちた人に向かって投げて救助できます。';

  @override
  String get safetyReportQR => '乗船前に必ずQRコードで乗船申告を完了してください。事故発生時の迅速な救助に不可欠です。';

  @override
  String get safetyTitleAttention => '乗船時の注意事項';

  @override
  String get safetyAttentionWave => '船の特性上、波によって揺れることがあります。特に他の船が通過する際は揺れが大きくなることがあるので、手すりにおつかまりください。';

  @override
  String get safetyAttentionDeck => '甲板(屋外デッキ)に出るには、必ず船内のQRコードで乗船申告を先に完了する必要があります。';

  @override
  String get safetyAttentionDanger => '電気設備室など危険区域には絶対に立ち入らないでください。';

  @override
  String get safetyAttentionBike => '個人の自転車は乗船可能ですが、ソウル自転車および電動キックボード(電動アシスト自転車を含む)は乗船できません。';

  @override
  String get safetyAttentionChild => 'お子様連れの場合、迷子防止のための案内を乗務員にご依頼いただけます。';

  @override
  String get emergencyBannerTitle => '緊急事態発生時';

  @override
  String get emergencyBannerContact => '乗務員へ直ちに通報  |  119';

  @override
  String get emergencyBannerRescue => '漢江警察隊・消防救助隊とリアルタイム連携';

  @override
  String get routeInfo => '経路情報';

  @override
  String get departureDock => '出発乗り場';

  @override
  String get arrivalDock => '到着乗り場';

  @override
  String get estimatedInfo => '予想情報';

  @override
  String get distanceLabel => '距離';

  @override
  String get durationLabel => '所要時間';

  @override
  String get etaLabel => '到着予定';

  @override
  String get routeSpeedNote => '※ 平均速度11km/h基準\\n※ 実際の運航時間は状況により異なる場合があります';

  @override
  String get selectPrompt => '選択してください';

  @override
  String get departureTimetable => '出発時刻表';

  @override
  String get nextDeparture => '次の出発';

  @override
  String get weatherChangeNotice => '天候により運航が変更される場合があります';

  @override
  String approxMinutes(int minutes) {
    return '約$minutes分';
  }

  @override
  String approxHoursMinutes(int hours, int minutes) {
    return '約$hours時間$minutes分';
  }

  @override
  String approxHours(int hours) {
    return '約$hours時間';
  }
}
