import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangangbus/blocs/clock/clock_bloc.dart';
import 'package:hangangbus/blocs/navigation/navigation_bloc.dart';
import 'package:hangangbus/blocs/realtime/realtime_bloc.dart';
import 'package:hangangbus/blocs/weather/weather_bloc.dart';
import 'package:hangangbus/blocs/settings/settings_bloc.dart';
import 'package:hangangbus/models/dock_type.dart';
import 'package:hangangbus/models/hangang_realtime_data.dart';
import 'package:hangangbus/screens/widgets/dock_amenity_card.dart';
import 'package:hangangbus/screens/dock_map_screen.dart';
import 'package:hangangbus/screens/hangang_map_screen.dart';
import 'package:hangangbus/utils/schedule_utils.dart';
import 'package:hangangbus/models/weather_data.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SeoulColors {
  static const seoulBlue = Color(0xFF0064B0);
  static const hanRiverBlue = Color(0xFF0099CC);
  static const skyBlue = Color(0xFF87CEEB);
  static const sunsetOrange = Color(0xFFFF6B35);
  static const mountainGreen = Color(0xFF4A7C59);
  static const warmWhite = Color(0xFFFFFBF5);
  static const lightGray = Color(0xFFF5F5F5);
  static const darkNavy = Color(0xFF0A0E27);
  static const neonGreen = Color(0xFF00FF88);
  static const neonCyan = Color(0xFF00D9FF);
  static const statusNormal = Color(0xFF00C853);
  static const statusPartial = Color(0xFFFFC107);
  static const statusStopped = Color(0xFFE53935);
  // 🆕 오늘 운행 종료를 알리는 세련된 잿빛 컬러
  static const statusClosed = Color(0xFF78909C);
}

enum OperationStatus { normal, partial, stopped, closed }

class Tab1Home extends StatefulWidget {
  const Tab1Home({super.key});

  @override
  State<Tab1Home> createState() => _Tab1HomeState();
}

class _Tab1HomeState extends State<Tab1Home> with TickerProviderStateMixin {
  final PageController _dockController = PageController(viewportFraction: 0.88);
  final ScrollController _scrollController = ScrollController();
  int _currentDockIndex = 0;

  /// 각 선착장 카드의 실측 높이(index → height). 내용량에 따라 카드마다 다르다.
  final Map<int, double> _cardHeights = {};

  /// PageView 컨테이너에 적용할 현재 페이지 높이. 측정 전 기본값(넉넉히).
  double _currentPageHeight = 720;

  late AnimationController _pulseController;

  /// 측정 위젯이 보고한 카드 높이를 저장하고, 현재 페이지면 컨테이너 높이를 갱신한다.
  /// 측정 지연/오차로 인한 미세 overflow를 막기 위해 약간의 여유를 더한다.
  void _reportCardHeight(int index, double height) {
    final adjusted = height + 4;
    if ((_cardHeights[index] ?? 0) == adjusted) return;
    _cardHeights[index] = adjusted;
    if (index == _currentDockIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentPageHeight != adjusted) {
          setState(() => _currentPageHeight = adjusted);
        }
      });
    }
  }

  /// 현재 페이지 인덱스에 맞는 카드 높이(측정값 없으면 직전 값 유지).
  double _heightForIndex(int index) =>
      _cardHeights[index] ?? _currentPageHeight;

  List<DockInfo> _getDocks(AppLocalizations l10n) {
    return ScheduleUtils.docks
        .map((dock) => _buildDockInfo(dock, l10n))
        .toList();
  }

  DockInfo _buildDockInfo(DockType dock, AppLocalizations l10n) {
    final nextDeparture = ScheduleUtils.getNextDepartureForDock(dock);
    final minutesLeft = ScheduleUtils.getMinutesUntilNextForDock(dock) ?? 0;
    final isOperating = nextDeparture != null;
    final meta = _dockMeta(dock, l10n);

    return DockInfo(
      name: dock.label(l10n),
      nameEn: ScheduleUtils.dockNameEn(dock),
      nextDeparture: nextDeparture ?? '--:--',
      minutesLeft: minutesLeft,
      gradientLight: meta.gradientLight,
      gradientDark: meta.gradientDark,
      heroTag: 'dock-${dock.name}',
      operationStatus: isOperating
          ? OperationStatus.normal
          : OperationStatus.closed,
      statusMessage: isOperating ? l10n.statusNormal : l10n.statusClosed,
      address: meta.address,
      parkAreaName: meta.parkAreaName,
      parkingSpaces: meta.parkingSpaces,
      parkingName: meta.parkingName,
      nearestSubway: meta.nearestSubway,
      subwayWalkTime: meta.subwayWalkTime,
      hasShuttle: meta.hasShuttle,
      shuttleInfo: meta.shuttleInfo,
      facilities: meta.facilities,
      busRoutes: meta.busRoutes,
    );
  }

  _DockMeta _dockMeta(DockType dock, AppLocalizations l10n) {
    final defaultFacilities = [
      l10n.facilityConvenienceStore,
      l10n.facilityCafe,
    ];

    switch (dock) {
      case DockType.magok:
        return _DockMeta(
          gradientLight: [SeoulColors.mountainGreen, const Color(0xFF6FA287)],
          gradientDark: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
          address: '서울특별시 강서구 가양동 441',
          parkAreaName: '마곡나루역',
          parkingSpaces: 38,
          parkingName: '가양라이품 공영주차장',
          nearestSubway: '양천향교역(9호선)',
          subwayWalkTime: 12,
          hasShuttle: true,
          shuttleInfo: '월~금 28회/일, 15분 간격\n가양나들목–양천향교역–발산역',
          facilities: [l10n.facilityConvenienceStore],
          busRoutes: ['6611'],
        );
      case DockType.mangwon:
        return _DockMeta(
          gradientLight: [SeoulColors.sunsetOrange, const Color(0xFFFFB85C)],
          gradientDark: const [Color(0xFFf093fb), Color(0xFFF5576c)],
          address: '서울특별시 마포구 망원동 205-8',
          parkAreaName: '망원한강공원',
          parkingSpaces: 138,
          parkingName: '망원 제3주차장',
          nearestSubway: '망원역(6호선)',
          subwayWalkTime: 27,
          hasShuttle: false,
          facilities: [
            l10n.facilityConvenienceStore,
            l10n.facilityCafe,
            l10n.facilityRamen,
            l10n.facilityFastFood,
          ],
          busRoutes: ['마포16', '7716', '8775'],
        );
      case DockType.yeouido:
        return _DockMeta(
          gradientLight: [SeoulColors.hanRiverBlue, SeoulColors.skyBlue],
          gradientDark: const [Color(0xFF667eea), Color(0xFF764ba2)],
          address: '서울특별시 영등포구 여의도동 85-1',
          parkAreaName: '여의도한강공원',
          parkingSpaces: 171,
          parkingName: '여의도한강공원 2주차장',
          nearestSubway: '여의나루역(5호선)',
          subwayWalkTime: 4,
          hasShuttle: false,
          facilities: [
            l10n.facilityConvenienceStore,
            l10n.facilityRamen,
            l10n.facilityFastFood,
            l10n.facilityCafe,
          ],
          busRoutes: ['영등포10', '261', '753', '5615'],
        );
      case DockType.apgujeong:
        return _DockMeta(
          gradientLight: const [Color(0xFF8E54E9), Color(0xFF4776E6)],
          gradientDark: const [Color(0xFF41295A), Color(0xFF2F0743)],
          address: '서울특별시 강남구 압구정동 일대',
          parkAreaName: null,
          parkingSpaces: 0,
          parkingName: '주차 정보 확인 필요',
          nearestSubway: '압구정로데오역(수인분당선)',
          subwayWalkTime: 15,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: ['143', '240', '362'],
        );
      case DockType.oksu:
        return _DockMeta(
          gradientLight: const [Color(0xFF26A69A), Color(0xFF80CBC4)],
          gradientDark: const [Color(0xFF136A8A), Color(0xFF267871)],
          address: '서울특별시 성동구 옥수동 일대',
          parkAreaName: null,
          parkingSpaces: 0,
          parkingName: '주차 정보 확인 필요',
          nearestSubway: '옥수역(3호선/경의중앙선)',
          subwayWalkTime: 10,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: ['110A', '2016', '241'],
        );
      case DockType.ttukseom:
        return _DockMeta(
          gradientLight: const [Color(0xFF42A5F5), Color(0xFF90CAF9)],
          gradientDark: const [Color(0xFF1A2980), Color(0xFF26D0CE)],
          address: '서울특별시 광진구 자양동 112',
          parkAreaName: '뚝섬한강공원',
          parkingSpaces: 0,
          parkingName: '뚝섬한강공원 주차장',
          nearestSubway: '자양역(7호선)',
          subwayWalkTime: 7,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: ['2014', '2221', '2222'],
        );
      case DockType.jamsil:
        return _DockMeta(
          gradientLight: const [Color(0xFF00ACC1), Color(0xFF4DD0E1)],
          gradientDark: const [Color(0xFF000428), Color(0xFF004E92)],
          address: '서울특별시 송파구 잠실동 1-2',
          parkAreaName: '잠실한강공원',
          parkingSpaces: 0,
          parkingName: '잠실한강공원 주차장',
          nearestSubway: '잠실새내역(2호선)',
          subwayWalkTime: 18,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: ['302', '333', '341'],
        );
      case DockType.seoulforest:
        return _DockMeta(
          gradientLight: const [Color(0xFF66BB6A), Color(0xFFAED581)],
          gradientDark: const [Color(0xFF134E5E), Color(0xFF71B280)],
          address: '서울특별시 성동구 성수동1가 (서울숲 한강)',
          parkAreaName: null, // 전용 실시간 API 장소 없음(임시 선착장)
          parkingSpaces: 0,
          parkingName: '서울숲 공영주차장',
          nearestSubway: '서울숲역(수인분당선)',
          subwayWalkTime: 15,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: ['2014', '2224', '141'],
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _dockController.addListener(() {
      final page = _dockController.page ?? 0;
      if (page.round() != _currentDockIndex) {
        setState(() {
          _currentDockIndex = page.round();
          _currentPageHeight = _heightForIndex(_currentDockIndex);
        });
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dockController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getFacilityIcon(String f) {
    final s = f.toLowerCase();
    if (s.contains('편의점') || s.contains('convenience')) return '🏪';
    if (s.contains('라면') || s.contains('ramen')) return '🍜';
    if (s.contains('패스트') || s.contains('fast food')) return '🍔';
    if (s.contains('카페') ||
        s.contains('café') ||
        s.contains('cafe') ||
        s.contains('까페'))
      return '☕';
    if (s.contains('화장실') || s.contains('restroom')) return '🚻';
    if (s.contains('샤워') || s.contains('shower')) return '🚿';
    if (s.contains('주차') || s.contains('parking')) return '🅿️';
    if (s.contains('자전거') || s.contains('bike')) return '🚲';
    return '🏢';
  }

  void _openWeatherWebView() async {
    final uri = Uri.parse(
      'https://www.weather.go.kr/w/weather/forecast/short-term.do',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('날씨 페이지를 열 수 없습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    // 분 단위 시계 변화에만 반응하여 "다음 배까지 N분" 카운트다운을 갱신한다.
    context.select((ClockBloc bloc) => bloc.state.minuteOfDay);
    final weatherState = context.watch<WeatherBloc>().state;
    context.watch<RealtimeBloc>();
    final docks = _getDocks(l10n);

    final currentDock = docks[_currentDockIndex];
    final headerWeather = weatherState.weatherFor(currentDock.parkAreaName);
    debugPrint(
      '🖥️ [tab1_home] weather 읽기: '
      'status=${weatherState.status}, '
      'representative=${weatherState.representative != null ? "있음" : "없음"}, '
      'parkAreaName=${currentDock.parkAreaName}, '
      'headerWeather=${headerWeather != null ? "있음 ${headerWeather.current.temperature}°" : "null"}',
    );

    return Scaffold(
      backgroundColor: isDarkMode
          ? SeoulColors.darkNavy
          : SeoulColors.warmWhite,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: isDarkMode
                    ? [
                        _getCurrentGradient(
                          isDarkMode,
                          docks,
                        )[0].withValues(alpha: 0.15),
                        SeoulColors.darkNavy,
                      ]
                    : [
                        _getCurrentGradient(
                          isDarkMode,
                          docks,
                        )[0].withValues(alpha: 0.08),
                        SeoulColors.warmWhite,
                      ],
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (b) => LinearGradient(
                                      colors: isDarkMode
                                          ? [
                                              Colors.white,
                                              Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                            ]
                                          : [
                                              SeoulColors.seoulBlue,
                                              SeoulColors.hanRiverBlue,
                                            ],
                                    ).createShader(b),
                                    child: Text(
                                      l10n.homeTitle,
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1,
                                        letterSpacing: -2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.homeSubtitle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                      color: isDarkMode
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : SeoulColors.seoulBlue.withValues(
                                              alpha: 0.7,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 날씨 위젯 — 탭하면 기상청 주간예보
                            _buildHeaderWeatherWidget(
                              headerWeather,
                              currentDock,
                              isDarkMode,
                              weatherState.isLoading,
                            ),
                            const SizedBox(width: 10),
                            // 큰글씨 토글 (고령층 접근성)
                            _buildTextScaleButton(isDarkMode),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              // 선착장 빠른 이동 칩 리스트 (탭하면 해당 카드로 스크롤)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: docks.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final d = docks[index];
                      final isActive = _currentDockIndex == index;
                      final activeColor = isDarkMode
                          ? d.gradientDark[0]
                          : d.gradientLight[0];
                      return GestureDetector(
                        onTap: () {
                          _dockController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isActive
                                ? activeColor
                                : (isDarkMode
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.white.withValues(alpha: 0.7)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? activeColor
                                  : activeColor.withValues(alpha: 0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            d.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isActive
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : (isDarkMode
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : activeColor),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  height: _heightForIndex(_currentDockIndex),
                  child: PageView.builder(
                    controller: _dockController,
                    itemCount: docks.length,
                    clipBehavior: Clip.none,
                    itemBuilder: (context, index) {
                      final dock = docks[index];
                      final isActive = _currentDockIndex == index;
                      return AnimatedScale(
                        scale: isActive ? 1.0 : 0.88,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: isActive ? 1.0 : 0.5,
                          duration: const Duration(milliseconds: 400),
                          child: Hero(
                            tag: dock.heroTag,
                            child: Material(
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: _MeasureSize(
                                  onChange: (size) =>
                                      _reportCardHeight(index, size.height),
                                  child: _buildDockCard(
                                    dock,
                                    isActive,
                                    isDarkMode,
                                    l10n,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(docks.length, (index) {
                      final isActive = _currentDockIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? LinearGradient(
                                  colors: _getGradientForDock(
                                    index,
                                    isDarkMode,
                                    docks,
                                  ),
                                )
                              : null,
                          color: isActive
                              ? null
                              : isDarkMode
                              ? Colors.white.withValues(alpha: 0.2)
                              : SeoulColors.seoulBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: _getGradientForDock(
                                      index,
                                      isDarkMode,
                                      docks,
                                    )[0].withValues(alpha: 0.6),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                  child: _buildBoardingButton(
                    isDarkMode,
                    _getGradientForDock(_currentDockIndex, isDarkMode, docks),
                    l10n,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildGlassmorphicButton(
                          icon: Icons.calendar_today_rounded,
                          label: l10n.fullTimetable,
                          isDarkMode: isDarkMode,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            context.read<NavigationBloc>().add(
                              const NavTabSelected(1),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGlassmorphicButton(
                          icon: Icons.explore_rounded,
                          label: l10n.nearbyAttractions,
                          isDarkMode: isDarkMode,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HangangMapScreen(
                                  initialDockNameEn: currentDock.nameEn,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: _buildLiveStatusSection(currentDock, isDarkMode, l10n),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoardingButton(
    bool isDarkMode,
    List<Color> gradient,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.mediumImpact();
        final Uri url = Uri.parse(
          'https://form.naver.com/response/ou4UyZcFdnB2YLEgeREpEw',
        );

        // 외부 브라우저에서 네이버 폼 열기
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch $url');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: gradient[0].withValues(alpha: 0.4),
            width: 2, // 승선신고의 중요도를 높이기 위해 선 두께 상향
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 텍스트 중앙 정렬
          children: [
            Icon(
              Icons.assignment_turned_in_rounded, // 신고/등록에 어울리는 아이콘
              color: gradient[0],
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.boardingDeclaration,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900, // 강조를 위해 굵게
                color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.open_in_new_rounded, // 외부 링크임을 알리는 아이콘
              size: 16,
              color: gradient[0].withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  /// 큰글씨 토글 버튼 (고령층 접근성).
  /// 탭하면 보통→크게→아주크게 순환. 현재 단계를 '가/가+/가++'로 표시.
  Widget _buildTextScaleButton(bool isDarkMode) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        final isLarge = settings.isLargeText;
        final label = switch (settings.level) {
          TextScaleLevel.normal => '가',
          TextScaleLevel.large => '가+',
          TextScaleLevel.extraLarge => '가++',
        };
        return GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            context.read<SettingsBloc>().add(
              TextScaleChanged(settings.level.next),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isLarge
                  ? SeoulColors.seoulBlue
                  : (isDarkMode
                        ? Colors.white.withValues(alpha: 0.12)
                        : SeoulColors.seoulBlue.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: SeoulColors.seoulBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  // 이 버튼 라벨은 글씨 배율의 영향을 받지 않게 고정
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    color: isLarge
                        ? Colors.white
                        : (isDarkMode ? Colors.white : SeoulColors.seoulBlue),
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  Icons.text_fields_rounded,
                  size: 13,
                  color: isLarge
                      ? Colors.white
                      : (isDarkMode ? Colors.white70 : SeoulColors.seoulBlue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderWeatherWidget(
    WeatherData? weather,
    DockInfo dock,
    bool isDarkMode,
    bool isLoading,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // 1. 아이콘 결정: 밤 아이콘(달)을 배제하고 날씨 상태 위주로 표시
    // weather_data.dart의 _skyIcon 로직을 우회하거나 날씨 텍스트 기반으로 이모지 매핑
    String weatherIcon = weather?.current.weatherIcon ?? '☀️';
    if (weatherIcon == '🌙') weatherIcon = '☀️'; // 달 아이콘 강제 변환 예시

    final hasWeather = weather != null;
    final temp = hasWeather ? '${weather.current.temperature.toInt()}°' : '--°';
    final pm10Color = weather?.current.pm10Color;
    final pm10LevelRaw = weather?.current.pm10Level; // '보통' 등 원본 데이터

    // 2. 다국어 맵핑 함수
    String getLocalizedDustLevel(String? level) {
      if (level == '좋음') return l10n.dustGood;
      if (level == '보통') return l10n.dustNormal;
      if (level == '나쁨') return l10n.dustBad;
      if (level == '매우나쁨') return l10n.dustVeryBad;
      return '--';
    }

    return InkWell(
      onTap: _openWeatherWebView,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : SeoulColors.skyBlue.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬로 레이아웃 안정화
          mainAxisSize: MainAxisSize.min,
          children: [
            // 온도 및 아이콘 섹션
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (weather == null && isLoading)
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode ? Colors.white70 : SeoulColors.hanRiverBlue,
                      ),
                    ),
                  )
                else
                  Text(weatherIcon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [SeoulColors.hanRiverBlue, SeoulColors.skyBlue],
                  ).createShader(b),
                  child: Text(
                    weather == null && isLoading ? '...' : temp,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 미세먼지 칩 (다국어 적용)
            if (pm10Color != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pm10Color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: pm10Color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.masks_rounded, size: 12, color: pm10Color),
                    const SizedBox(width: 4),
                    Text(
                      getLocalizedDustLevel(pm10LevelRaw),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: pm10Color,
                      ),
                    ),
                  ],
                ),
              )
            else if (weather == null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDarkMode ? Colors.white : SeoulColors.skyBlue)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (isDarkMode ? Colors.white : SeoulColors.skyBlue)
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  isLoading ? '불러오는 중' : '정보 없음',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.7)
                        : SeoulColors.hanRiverBlue,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // 주간 예보 안내 힌트 (유저가 클릭 가능함을 인지)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.weeklyForecast,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.4)
                        : SeoulColors.seoulBlue.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.3)
                      : SeoulColors.seoulBlue.withValues(alpha: 0.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDockCard(
    DockInfo dock,
    bool isActive,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    final gradient = isDarkMode ? dock.gradientDark : dock.gradientLight;
    final statusColor = _getStatusColor(dock.operationStatus);
    final realtimeData = dock.parkAreaName != null
        ? context.read<RealtimeBloc>().state.dataByPark[dock.parkAreaName]
        : null;
    final weatherData = context.read<WeatherBloc>().state.weatherFor(
      dock.parkAreaName,
    );

    final isServiceClosed =
        dock.operationStatus == OperationStatus.stopped ||
        dock.operationStatus == OperationStatus.closed;

    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        _showEnhancedDetailSheet(
          context,
          dock,
          isDarkMode,
          weatherData,
          realtimeData,
          l10n,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          gradient[0].withValues(alpha: 0.3),
                          gradient[1].withValues(alpha: 0.15),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.8),
                          gradient[0].withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.7),
                        ],
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. 선착장 이름 + 상태
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              children: [
                                Text(
                                  dock.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.5,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 3
                                      ..color = isDarkMode
                                          ? Colors.black.withValues(alpha: 0.5)
                                          : Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (b) => LinearGradient(
                                    colors: isDarkMode
                                        ? [
                                            Colors.white,
                                            Colors.white.withValues(alpha: 0.7),
                                          ]
                                        : gradient,
                                  ).createShader(b),
                                  child: Text(
                                    dock.name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (ctx, _) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[900]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withValues(
                                  alpha: isDarkMode ? 0.6 : 0.4,
                                ),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 74,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      _getStatusText(
                                        dock.operationStatus,
                                        l10n,
                                      ),
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: statusColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 2. 다음 출발
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : gradient[0].withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.nextArrival,
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : SeoulColors.seoulBlue.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: ShaderMask(
                                  shaderCallback: (b) => LinearGradient(
                                    colors: isServiceClosed
                                        ? [Colors.grey, Colors.grey]
                                        : gradient,
                                  ).createShader(b),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      isServiceClosed
                                          ? l10n.endOfService
                                          : dock.nextDeparture,
                                      style: TextStyle(
                                        fontSize:
                                            Localizations.localeOf(
                                                  context,
                                                ).languageCode ==
                                                'en'
                                            ? 46
                                            : 54,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1,
                                        letterSpacing: -2,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (!isServiceClosed)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (ctx, _) => Opacity(
                                      opacity:
                                          0.6 + _pulseController.value * 0.4,
                                      child: Text(
                                        l10n.minutesLeft(dock.minutesLeft + 1),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: isDarkMode
                                              ? Colors.white
                                              : gradient[0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 3. 셔틀버스
                    if (dock.hasShuttle && dock.shuttleInfo != null) ...[
                      GestureDetector(
                        onTap: () => HapticFeedback.mediumImpact(),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.95)
                                : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: gradient[0].withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradient[0].withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradient),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.airport_shuttle_rounded,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.freeShuttle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: gradient[0],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dock.shuttleInfo!.split('\n')[0],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: SeoulColors.seoulBlue.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                    // 4. 주차
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : gradient[0].withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_parking_rounded,
                            size: 24,
                            color: gradient[0],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.parkingSpacesSuffix(dock.parkingSpaces),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: isDarkMode
                                        ? Colors.white
                                        : gradient[0],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dock.parkingName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkMode
                                        ? Colors.white.withValues(alpha: 0.6)
                                        : SeoulColors.seoulBlue.withValues(
                                            alpha: 0.7,
                                          ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 4-1. 가까운 따릉이 / 주차장 (실시간 최근접)
                    Builder(
                      builder: (context) {
                        final dockType = ScheduleUtils.dockTypeFromName(
                          dock.nameEn,
                        );
                        if (dockType == null) {
                          return const SizedBox.shrink();
                        }
                        return DockAmenityCard(
                          dockType: dockType,
                          data: realtimeData,
                          gradient: gradient,
                          isDarkMode: isDarkMode,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // 5. 버스
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : gradient[0].withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_bus_rounded,
                            size: 20,
                            color: gradient[0],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: dock.busRoutes
                                  .map(
                                    (route) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: gradient[0].withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        route,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: gradient[0],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 6. 부대시설 — gradient 기반 칩 색상
                    if (dock.facilities.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.1)
                                : gradient[0].withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.store_rounded,
                                  size: 20,
                                  color: gradient[0],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.facilities,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDarkMode
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : gradient[0],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: dock.facilities
                                  .map(
                                    (facility) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        // ✅ 버스 번호와 동일한 스타일 (gradient 기반 파란색)
                                        color: gradient[0].withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: gradient[0].withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _getFacilityIcon(facility),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            facility,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: gradient[0],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    // 7. 지도 버튼
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DockMapScreen(dockInfo: dock),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: gradient[0].withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: gradient[0].withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.map_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.scheduleAndMap,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEnhancedDetailSheet(
    BuildContext context,
    DockInfo dock,
    bool isDarkMode,
    WeatherData? weatherData,
    HangangRealtimeData? realtimeData,
    AppLocalizations l10n,
  ) {
    final gradient = isDarkMode ? dock.gradientDark : dock.gradientLight;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? SeoulColors.darkNavy.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            LinearGradient(colors: gradient).createShader(b),
                        child: Text(
                          l10n.dockSheetTitle(dock.name),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDarkMode
                              ? Colors.white
                              : SeoulColors.seoulBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dock.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.6)
                            : SeoulColors.seoulBlue.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (realtimeData != null) ...[
                          _buildDetailSectionHeader(
                            l10n.realtimeStatus,
                            Icons.show_chart_rounded,
                            gradient,
                            isDarkMode,
                          ),
                          const SizedBox(height: 12),
                          _buildRealtimeStatusSection(
                            realtimeData,
                            gradient,
                            isDarkMode,
                            l10n,
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (weatherData != null) ...[
                          _buildDetailSectionHeader(
                            l10n.weatherInfo,
                            Icons.wb_sunny_rounded,
                            gradient,
                            isDarkMode,
                          ),
                          const SizedBox(height: 12),
                          _buildCurrentWeatherSection(
                            weatherData,
                            gradient,
                            isDarkMode,
                            l10n,
                          ),
                          const SizedBox(height: 16),
                          // _buildHourlyForecastSection(
                          //   weatherData,
                          //   gradient,
                          //   isDarkMode,
                          //   l10n,
                          // ),
                          const SizedBox(height: 24),
                        ],
                        _buildDetailSectionHeader(
                          l10n.accessInfo,
                          Icons.directions_rounded,
                          gradient,
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildAccessInfo(
                          icon: Icons.subway_rounded,
                          title: dock.nearestSubway,
                          subtitle: l10n.walkingMinutes(dock.subwayWalkTime),
                          gradient: gradient,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildAccessInfo(
                          icon: Icons.local_parking_rounded,
                          title: l10n.parkingSpacesSuffix(dock.parkingSpaces),
                          subtitle: dock.parkingName,
                          gradient: gradient,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 24),
                        _buildDetailSectionHeader(
                          l10n.facilities,
                          Icons.store_rounded,
                          gradient,
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: dock.facilities
                              .map(
                                (f) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: gradient[0].withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: gradient[0].withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    f,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: gradient[0],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSectionHeader(
    String title,
    IconData icon,
    List<Color> gradient,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildRealtimeStatusSection(
    HangangRealtimeData data,
    List<Color> gradient,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : gradient[0].withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: gradient[0].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.updatedMinutesAgo,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: gradient[0],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (data.population != null)
            _buildRealtimeItem(
              icon: Icons.people_rounded,
              label: l10n.currentPopulation,
              value: '${data.population!.estimatedPopulation}명',
              subValue: data.population!.congestLevel,
              gradient: gradient,
              isDarkMode: isDarkMode,
            ),
          const SizedBox(height: 12),
          if (data.bikeStations.isNotEmpty)
            _buildRealtimeItem(
              icon: Icons.pedal_bike_rounded,
              label: l10n.bikeShare,
              value: l10n.bikeStationsCount(data.bikeStations.length),
              subValue: l10n.bikesAvailable(
                data.bikeStations.fold<int>(0, (s, b) => s + b.available),
              ),
              gradient: gradient,
              isDarkMode: isDarkMode,
            ),
          const SizedBox(height: 12),
          if (data.parkingLots.isNotEmpty)
            _buildRealtimeItem(
              icon: Icons.local_parking_rounded,
              label: l10n.parking,
              value: l10n.parkingSpacesAvailable(
                data.parkingLots.fold<int>(
                  0,
                  (s, p) => s + (p.availableCount ?? 0),
                ),
              ),
              subValue: l10n.parkingSpacesTotal(
                data.parkingLots.fold<int>(0, (s, p) => s + p.capacity),
              ),
              gradient: gradient,
              isDarkMode: isDarkMode,
            ),
        ],
      ),
    );
  }

  Widget _buildRealtimeItem({
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
    required List<Color> gradient,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: gradient[0]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : SeoulColors.seoulBlue.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subValue,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.4)
                      : SeoulColors.seoulBlue.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: isDarkMode ? Colors.white : gradient[0],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeatherSection(
    WeatherData weather,
    List<Color> gradient,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    final current = weather.current;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : gradient[0].withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(current.weatherIcon, style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          LinearGradient(colors: gradient).createShader(b),
                      child: Text(
                        '${current.temperature.toInt()}°',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.skyStatus,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? Colors.white
                                  : SeoulColors.seoulBlue,
                            ),
                          ),
                          Text(
                            l10n.feelsLike(current.sensoryTemp.toString()),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : SeoulColors.seoulBlue.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWeatherDetailItem(
                  icon: Icons.water_drop_outlined,
                  label: l10n.humidity,
                  value: '${current.humidity.toInt()}%',
                  gradient: gradient,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherDetailItem(
                  icon: Icons.air_rounded,
                  label: l10n.windSpeed,
                  value: '${current.windSpeed}m/s',
                  gradient: gradient,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: current.pm10Color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: current.pm10Color.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.masks_rounded, size: 20, color: current.pm10Color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.fineDust,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.6)
                              : SeoulColors.seoulBlue.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${current.pm10Level} (${current.pm10}㎍/㎥)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: current.pm10Color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: gradient[0]),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.5)
                  : SeoulColors.seoulBlue.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHourlyForecastSection(
  //   WeatherData weather,
  //   List<Color> gradient,
  //   bool isDarkMode,
  //   AppLocalizations l10n,
  // ) {
  //   final displayForecasts = weather.hourlyForecasts.take(4).toList();
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: isDarkMode
  //           ? Colors.black.withValues(alpha: 0.3)
  //           : Colors.white.withValues(alpha: 0.7),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: isDarkMode
  //             ? Colors.white.withValues(alpha: 0.1)
  //             : gradient[0].withValues(alpha: 0.2),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.schedule_rounded, size: 18, color: gradient[0]),
  //             const SizedBox(width: 8),
  //             Text(
  //               l10n.hourlyForecast,
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w700,
  //                 color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         ...displayForecasts.map(
  //           (fc) => Padding(
  //             padding: const EdgeInsets.only(bottom: 12),
  //             child: Row(
  //               children: [
  //                 SizedBox(
  //                   width: 60,
  //                   child: Text(
  //                     fc.timeString,
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w600,
  //                       color: isDarkMode
  //                           ? Colors.white.withValues(alpha: 0.8)
  //                           : SeoulColors.seoulBlue,
  //                     ),
  //                   ),
  //                 ),
  //                 Text(fc.weatherIcon, style: const TextStyle(fontSize: 24)),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Text(
  //                     '${fc.temperature.toInt()}°',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w800,
  //                       color: isDarkMode ? Colors.white : gradient[0],
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 8,
  //                     vertical: 4,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: fc.precipitationProbability >= 70
  //                         ? Colors.blue.withValues(alpha: 0.15)
  //                         : Colors.grey.withValues(alpha: 0.1),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(
  //                         Icons.water_drop_outlined,
  //                         size: 12,
  //                         color: fc.precipitationProbability >= 70
  //                             ? Colors.blue
  //                             : Colors.grey,
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Text(
  //                         '${fc.precipitationProbability}%',
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           fontWeight: FontWeight.w600,
  //                           color: fc.precipitationProbability >= 70
  //                               ? Colors.blue
  //                               : Colors.grey,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         if (weather.hourlyForecasts.length > 4)
  //           GestureDetector(
  //             onTap: () => _showFullWeatherForecast(
  //               context,
  //               weather,
  //               gradient,
  //               isDarkMode,
  //               l10n,
  //             ),
  //             child: Container(
  //               margin: const EdgeInsets.only(top: 8),
  //               padding: const EdgeInsets.symmetric(vertical: 10),
  //               decoration: BoxDecoration(
  //                 color: gradient[0].withValues(alpha: 0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     l10n.fullForecast,
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w700,
  //                       color: gradient[0],
  //                     ),
  //                   ),
  //                   const SizedBox(width: 4),
  //                   Icon(
  //                     Icons.arrow_forward_rounded,
  //                     size: 16,
  //                     color: gradient[0],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAccessInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : gradient[0].withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.6)
                        : SeoulColors.seoulBlue.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicButton({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.9)
                      : SeoulColors.seoulBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.9)
                        : SeoulColors.seoulBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 혼잡도 원본(한글)을 현지화 라벨 + 색상으로 매핑
  ({String label, Color color}) _congestionStyle(
    String? raw,
    AppLocalizations l10n,
    bool isDarkMode,
  ) {
    switch (raw) {
      case '여유':
        return (label: l10n.congestionRelaxed, color: const Color(0xFF00C853));
      case '보통':
        return (label: l10n.congestionNormal, color: const Color(0xFF2196F3));
      case '약간 붐빔':
        return (
          label: l10n.congestionSlightlyBusy,
          color: const Color(0xFFFF9800),
        );
      case '붐빔':
        return (label: l10n.congestionBusy, color: const Color(0xFFE53935));
      default:
        return (
          label: l10n.congestionUnknown,
          color: isDarkMode ? Colors.white54 : SeoulColors.seoulBlue,
        );
    }
  }

  /// 메인 하단 LIVE 현황 섹션 — 현재 선택된 선착장 기준.
  /// 시간표 실측 운항 횟수 + 서울시 실시간 도시데이터(혼잡도/따릉이/주차).
  Widget _buildLiveStatusSection(
    DockInfo dock,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    final realtime = context.read<RealtimeBloc>().state;
    final data = realtime.dataFor(dock.parkAreaName);
    final isLoading = realtime.status == RealtimeStatus.loading && data == null;
    final hasData = data != null;

    // 시간표 기반 실측 운항 횟수(모든 방향 합)
    final tripCount = ScheduleUtils.getDockSchedule(dock.nameEn).length;

    // 혼잡도
    final congestRaw = data?.population?.congestLevel;
    final hasCongestion =
        hasData && congestRaw != null && congestRaw != '정보 없음';
    final congestion = _congestionStyle(congestRaw, l10n, isDarkMode);

    // 따릉이 / 주차 가용
    final hasBikes = hasData && data.bikeStations.isNotEmpty;
    final bikesAvailable = hasBikes
        ? data.bikeStations.fold<int>(0, (s, b) => s + b.available)
        : null;
    final hasParking = hasData && data.parkingLots.isNotEmpty;
    final parkingAvailable = hasParking
        ? data.parkingLots.fold<int>(0, (s, p) => s + (p.availableCount ?? 0))
        : null;

    // 마지막 업데이트 표기
    String updatedText = '';
    final lastUpdated = realtime.lastUpdated;
    if (lastUpdated != null) {
      final mins = DateTime.now().difference(lastUpdated).inMinutes;
      updatedText = mins <= 0
          ? l10n.liveUpdatedJustNow
          : l10n.liveUpdatedAgo(mins);
    }

    String liveValue(String? value) {
      if (isLoading) return '...';
      return value ?? l10n.liveDataUnavailable;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) => Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(
                    0xFFE53935,
                  ).withValues(alpha: 0.4 + _pulseController.value * 0.6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (b) => LinearGradient(
                colors: isDarkMode
                    ? [
                        Colors.white.withValues(alpha: 0.8),
                        Colors.white.withValues(alpha: 0.4),
                      ]
                    : [
                        SeoulColors.seoulBlue.withValues(alpha: 0.8),
                        SeoulColors.hanRiverBlue.withValues(alpha: 0.6),
                      ],
              ).createShader(b),
              child: Text(
                '${l10n.liveStatusLabel} · ${dock.name}',
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            if (updatedText.isNotEmpty)
              Text(
                updatedText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.4)
                      : SeoulColors.seoulBlue.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStat(
              l10n.statTodayTrips,
              l10n.statTripsValue(tripCount),
              Icons.sailing,
              isDarkMode,
            ),
            const SizedBox(width: 12),
            _buildStat(
              l10n.statCongestion,
              isLoading
                  ? '...'
                  : (hasCongestion
                        ? congestion.label
                        : l10n.liveDataUnavailable),
              Icons.groups_rounded,
              isDarkMode,
              valueColor: (!isLoading && hasCongestion)
                  ? congestion.color
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStat(
              l10n.statBikesShort,
              liveValue(bikesAvailable?.toString()),
              Icons.pedal_bike_rounded,
              isDarkMode,
            ),
            const SizedBox(width: 12),
            _buildStat(
              l10n.statParkingShort,
              liveValue(parkingAvailable?.toString()),
              Icons.local_parking_rounded,
              isDarkMode,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(
    String label,
    String value,
    IconData icon,
    bool isDarkMode, {
    Color? valueColor,
  }) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color:
                      valueColor ??
                      (isDarkMode
                          ? SeoulColors.neonGreen
                          : SeoulColors.hanRiverBlue),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color:
                        valueColor ??
                        (isDarkMode ? Colors.white : SeoulColors.seoulBlue),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.5)
                        : SeoulColors.seoulBlue.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(OperationStatus s) {
    switch (s) {
      case OperationStatus.normal:
        return SeoulColors.statusNormal;
      case OperationStatus.partial:
        return SeoulColors.statusPartial;
      case OperationStatus.stopped:
        return SeoulColors.statusStopped;
      case OperationStatus.closed:
        return SeoulColors.statusClosed;
    }
  }

  String _getStatusText(OperationStatus s, AppLocalizations l10n) {
    switch (s) {
      case OperationStatus.normal:
        return l10n.statusNormal;
      case OperationStatus.partial:
        return l10n.statusPartial;
      case OperationStatus.stopped:
        return l10n.statusStopped;
      case OperationStatus.closed:
        return l10n.statusClosed;
    }
  }

  List<Color> _getCurrentGradient(bool isDarkMode, List<DockInfo> docks) =>
      isDarkMode
      ? docks[_currentDockIndex].gradientDark
      : docks[_currentDockIndex].gradientLight;
  List<Color> _getGradientForDock(
    int index,
    bool isDarkMode,
    List<DockInfo> docks,
  ) => isDarkMode ? docks[index].gradientDark : docks[index].gradientLight;
}

class DockInfo {
  final String name,
      nameEn,
      nextDeparture,
      heroTag,
      statusMessage,
      address,
      parkingName,
      nearestSubway;
  final String? shuttleInfo, parkAreaName;
  final int minutesLeft, parkingSpaces, subwayWalkTime;
  final bool hasShuttle;
  final List<Color> gradientLight, gradientDark;
  final OperationStatus operationStatus;
  final List<String> facilities, busRoutes;

  DockInfo({
    required this.name,
    required this.nameEn,
    required this.nextDeparture,
    required this.minutesLeft,
    required this.gradientLight,
    required this.gradientDark,
    required this.heroTag,
    required this.operationStatus,
    required this.statusMessage,
    required this.address,
    required this.parkingSpaces,
    required this.parkingName,
    required this.nearestSubway,
    required this.subwayWalkTime,
    required this.hasShuttle,
    this.shuttleInfo,
    required this.facilities,
    required this.busRoutes,
    required this.parkAreaName,
  });
}

class _DockMeta {
  final List<Color> gradientLight;
  final List<Color> gradientDark;
  final String address;
  final String? parkAreaName;
  final int parkingSpaces;
  final String parkingName;
  final String nearestSubway;
  final int subwayWalkTime;
  final bool hasShuttle;
  final String? shuttleInfo;
  final List<String> facilities;
  final List<String> busRoutes;

  const _DockMeta({
    required this.gradientLight,
    required this.gradientDark,
    required this.address,
    required this.parkAreaName,
    required this.parkingSpaces,
    required this.parkingName,
    required this.nearestSubway,
    required this.subwayWalkTime,
    required this.hasShuttle,
    this.shuttleInfo,
    required this.facilities,
    required this.busRoutes,
  });
}

/// 자식 위젯의 렌더 크기를 측정해 콜백으로 전달하는 위젯.
/// PageView 안에서 각 카드의 실제 높이를 알아내 컨테이너 높이를 맞추는 데 사용한다.
class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  final GlobalKey _key = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_notify);
    return Container(key: _key, child: widget.child);
  }

  void _notify(_) {
    if (!mounted) return;
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final size = (ctx.findRenderObject() as RenderBox?)?.size;
    if (size == null || size == _oldSize) return;
    _oldSize = size;
    widget.onChange(size);
  }
}
