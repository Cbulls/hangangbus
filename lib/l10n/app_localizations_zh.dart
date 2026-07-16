// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get timetableTitle => '时刻表';

  @override
  String get directionMagokToYeouido => '麻谷 → 汝矣岛';

  @override
  String get directionYeouidoToMagok => '汝矣岛 → 麻谷';

  @override
  String get dockMagok => '麻谷';

  @override
  String get dockMangwon => '望远';

  @override
  String get dockYeouido => '汝矣岛';

  @override
  String get dockApgujeong => '狎鸥亭';

  @override
  String get dockOksu => '玉水';

  @override
  String get dockTtukseom => '纛岛';

  @override
  String get dockJamsil => '蚕室';

  @override
  String get dockSeoulForest => '首尔林';

  @override
  String get directionToYeouido => '开往汝矣岛';

  @override
  String get directionToMagok => '开往麻谷';

  @override
  String get directionToJamsil => '开往蚕室';

  @override
  String get nextBoat => '下一班';

  @override
  String get firstBoat => '首班';

  @override
  String get lastBoat => '末班';

  @override
  String departIn(String time) {
    return '$time 出发';
  }

  @override
  String get serviceClosedToday => '今日运营已结束';

  @override
  String tomorrowFirstBoat(String time) {
    return '明日首班 $time';
  }

  @override
  String get transferHub => '换乘';

  @override
  String get yeouidoTransferTitle => '汝矣岛换乘指南';

  @override
  String get routeOverview => '线路图';

  @override
  String boundFor(String dock) {
    return '开往$dock';
  }

  @override
  String minutesLeft(int minutes) {
    return '$minutes分钟后';
  }

  @override
  String hoursMinutesLeft(int hours, int minutes) {
    return '$hours小时 $minutes分钟';
  }

  @override
  String get departed => '已发船';

  @override
  String get storyPageTitle => '汉江历史/美食';

  @override
  String get storyPageSubtitle => '汉江巴士各码头的历史与美食信息';

  @override
  String get categoryHistory => '历史';

  @override
  String get categoryFood => '美食';

  @override
  String get comingSoon => '敬请期待';

  @override
  String get infoLabelLocation => '位置';

  @override
  String get infoLabelAccess => '交通';

  @override
  String get infoLabelPeriod => '年代';

  @override
  String get infoLabelHours => '营业';

  @override
  String get infoLabelPrice => '价格';

  @override
  String dockSuffix(String dockName) {
    return '$dockName 码头';
  }

  @override
  String get homeTitle => '汉江巴士';

  @override
  String get homeSubtitle => '实时运营状况';

  @override
  String get nextArrival => '下次到达预计';

  @override
  String get freeShuttle => '免费接驳巴士';

  @override
  String get parking => '停车';

  @override
  String parkingSpacesAvailable(int count) {
    return '剩余$count个车位';
  }

  @override
  String parkingSpacesSuffix(int count) {
    return '$count个车位';
  }

  @override
  String parkingSpacesTotal(int count) {
    return '共$count个车位中可用';
  }

  @override
  String get fullTimetable => '完整时刻表';

  @override
  String get nearbyAttractions => '周边景点';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get statusNormal => '正常运营';

  @override
  String get statusPartial => '部分停运';

  @override
  String get statusStopped => '全面停运';

  @override
  String get facilityConvenienceStore => '便利店';

  @override
  String get facilityRamen => '拉面体验区';

  @override
  String get facilityFastFood => '快餐';

  @override
  String get facilityCafe => '咖啡厅';

  @override
  String dockSheetTitle(String name) {
    return '$name 码头';
  }

  @override
  String get realtimeStatus => '实时状况';

  @override
  String get weatherInfo => '天气信息';

  @override
  String get hourlyForecast => '逐小时预报';

  @override
  String get fullForecast => '查看24小时预报全部';

  @override
  String get weatherForecast24h => '24小时天气预报';

  @override
  String get accessInfo => '交通方式';

  @override
  String walkingMinutes(int minutes) {
    return '步行$minutes分钟';
  }

  @override
  String get facilities => '配套设施';

  @override
  String get scheduleAndMap => '地图';

  @override
  String feelsLike(String temp) {
    return '体感 $temp°';
  }

  @override
  String get humidity => '湿度';

  @override
  String get windSpeed => '风速';

  @override
  String get fineDust => '细颗粒物';

  @override
  String get updatedMinutesAgo => '5分钟前更新';

  @override
  String get currentPopulation => '当前人流';

  @override
  String get bikeShare => '首尔单车';

  @override
  String bikeStationsCount(int count) {
    return '$count处';
  }

  @override
  String bikesAvailable(int count) {
    return '$count辆可用';
  }

  @override
  String get weeklyForecast => '查看一周预报';

  @override
  String get dustGood => '优';

  @override
  String get dustNormal => '良';

  @override
  String get dustBad => '差';

  @override
  String get dustVeryBad => '很差';

  @override
  String get statusClosed => '运营结束';

  @override
  String get endOfService => '运营结束';

  @override
  String get boardingDeclaration => '汉江巴士乘船申报';

  @override
  String get statTrips => '航次';

  @override
  String statTripsValue(int count) {
    return '$count次';
  }

  @override
  String get statPassengers => '乘客';

  @override
  String statPassengersValue(int count) {
    return '$count人';
  }

  @override
  String get statOnTime => '准点率';

  @override
  String get liveStatusLabel => '实时';

  @override
  String get liveDataUnavailable => '暂无信息';

  @override
  String get liveUpdatedJustNow => '刚刚更新';

  @override
  String liveUpdatedAgo(int minutes) {
    return '$minutes分钟前更新';
  }

  @override
  String get statTodayTrips => '今日航次';

  @override
  String get statCongestion => '拥挤度';

  @override
  String get statBikesShort => '首尔单车';

  @override
  String get statParkingShort => '停车';

  @override
  String get congestionRelaxed => '宽松';

  @override
  String get congestionNormal => '普通';

  @override
  String get congestionSlightlyBusy => '略拥挤';

  @override
  String get congestionBusy => '拥挤';

  @override
  String get congestionUnknown => '暂无信息';

  @override
  String get navHome => '首页';

  @override
  String get navSchedule => '时刻表';

  @override
  String get navGuide => '指南';

  @override
  String get navFaq => 'FAQ';

  @override
  String get tabFaq => '常见问题';

  @override
  String get tabSafety => '安全须知';

  @override
  String get safetyTitleLifeVest => '救生衣位置';

  @override
  String get safetyLifeVestAdult => '每个座位下方的储物箱内各配备一件成人救生衣。';

  @override
  String get safetyLifeVestChild => '婴幼儿及儿童救生衣另存放于船内专用柜（储物箱）。请向乘务员咨询。';

  @override
  String get safetyLifeVestAccess => '救生衣储物箱始终保持开启状态，以便紧急时立即取用。';

  @override
  String get safetyTitleHowToWear => '救生衣穿戴方法';

  @override
  String get safetyWearStep1 => '打开座位下方的储物箱，取出救生衣。';

  @override
  String get safetyWearStep2 => '将救生衣从头部向下套穿。';

  @override
  String get safetyWearStep3 => '扣紧前侧扣具，直到听到\"咔哒\"声。';

  @override
  String get safetyWearStep4 => '拉紧腰带使其紧贴身体。';

  @override
  String get safetyWearStep5 => '入水后用力拉动救生衣前侧的红色拉手（二氧化碳充气装置）使其充气。';

  @override
  String get safetyWearTip => '若无法自动充气，可用嘴吹救生衣的口吹充气管（黄色）使其充气。';

  @override
  String get safetyTitleEvacuation => '紧急疏散指南';

  @override
  String get safetyEvacExit => '紧急出口位于船舱前方（船头）和后方（船尾）两侧。登船后请提前确认位置。';

  @override
  String get safetyEvacCalm => '发生紧急情况时，请按照乘务员的广播指引，冷静地前往指定出口疏散。';

  @override
  String get safetyEvacStay => '船只完全停稳前，切勿离开座位。';

  @override
  String get safetyEvacRescue => '疏散后请前往码头或救援船，与汉江警察队·消防救援队实时联动的救援系统将立即出动。';

  @override
  String get safetyTitleReporting => '紧急报警方法';

  @override
  String get safetyReportCall => '请立即通知船内乘务员，或拨打汉江巴士客服中心或119报警。';

  @override
  String get safetyReportTube => '船内配备的救生圈（环形浮标）可投向落水者进行救援。';

  @override
  String get safetyReportQR => '登船前请务必通过二维码完成乘船申报。这对事故发生时的迅速救援至关重要。';

  @override
  String get safetyTitleAttention => '登船注意事项';

  @override
  String get safetyAttentionWave => '因船只特性，可能随波浪摇晃。尤其当其他船只经过时摇晃会加剧，请抓好扶手。';

  @override
  String get safetyAttentionDeck => '前往甲板（户外平台）须先通过船内二维码完成乘船申报。';

  @override
  String get safetyAttentionDanger => '切勿进入配电室等危险区域。';

  @override
  String get safetyAttentionBike => '个人自行车可携带登船，但首尔单车及电动滑板车（含电动自行车）不可登船。';

  @override
  String get safetyAttentionChild => '携带儿童时，可向乘务员申请防走失指引。';

  @override
  String get emergencyBannerTitle => '发生紧急情况时';

  @override
  String get emergencyBannerContact => '立即通知乘务员  |  119';

  @override
  String get emergencyBannerRescue => '与汉江警察队·消防救援队实时联动';

  @override
  String get routeInfo => '路线信息';

  @override
  String get departureDock => '出发码头';

  @override
  String get arrivalDock => '到达码头';

  @override
  String get estimatedInfo => '预计信息';

  @override
  String get distanceLabel => '距离';

  @override
  String get durationLabel => '所需时间';

  @override
  String get etaLabel => '预计到达';

  @override
  String get routeSpeedNote => '※ 以平均速度 11 km/h 为准\\n※ 实际运营时间可能因情况而异';

  @override
  String get selectPrompt => '请选择';

  @override
  String get departureTimetable => '出发时刻表';

  @override
  String get nextDeparture => '下次出发';

  @override
  String get weatherChangeNotice => '运营可能因天气状况而变更';

  @override
  String approxMinutes(int minutes) {
    return '约$minutes分钟';
  }

  @override
  String approxHoursMinutes(int hours, int minutes) {
    return '约$hours小时$minutes分钟';
  }

  @override
  String approxHours(int hours) {
    return '约$hours小时';
  }

  @override
  String get privacyPolicyTitle => '隐私政策';

  @override
  String get privacyPolicySubtitle => '数据使用说明与联系方式';
}
