// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'dart:ui';

// import 'package:hangangbus/hangang_realtime_data.dart';
// import 'package:hangangbus/dock_map_screen.dart';
// import 'package:hangangbus/weather_data.dart';
// import 'package:hangangbus/l10n/app_localizations.dart';

// // 서울색 팔레트
// class SeoulColors {
//   static const seoulBlue = Color(0xFF0064B0);
//   static const hanRiverBlue = Color(0xFF0099CC);
//   static const skyBlue = Color(0xFF87CEEB);
//   static const sunsetOrange = Color(0xFFFF6B35);
//   static const mountainGreen = Color(0xFF4A7C59);
//   static const warmWhite = Color(0xFFFFFBF5);
//   static const lightGray = Color(0xFFF5F5F5);

//   static const darkNavy = Color(0xFF0A0E27);
//   static const neonGreen = Color(0xFF00FF88);
//   static const neonCyan = Color(0xFF00D9FF);

//   static const statusNormal = Color(0xFF00C853);
//   static const statusPartial = Color(0xFFFFC107);
//   static const statusStopped = Color(0xFFE53935);
// }

// enum OperationStatus { normal, partial, stopped }

// class Tab1Home extends StatefulWidget {
//   const Tab1Home({super.key});

//   @override
//   State<Tab1Home> createState() => _Tab1HomeState();
// }

// class _Tab1HomeState extends State<Tab1Home> with TickerProviderStateMixin {
//   final PageController _dockController = PageController(viewportFraction: 0.88);
//   final ScrollController _scrollController = ScrollController();
//   int _currentDockIndex = 0;

//   late AnimationController _pulseController;
//   late Timer _timer;
//   late Timer _realtimeDataTimer;
//   DateTime _now = DateTime.now();

//   Map<String, WeatherData> _weatherData = {};
//   Map<String, HangangRealtimeData> _realtimeData = {};

//   // -------------------------------------------------------
//   // DockInfo는 언어와 무관한 내부 데이터만 보관.
//   // 표시용 이름(name)은 build()에서 l10n으로 채운다.
//   // -------------------------------------------------------
//   List<DockInfo> _getDocks(AppLocalizations l10n) => [
//     DockInfo(
//       name: l10n.dockYeouido,
//       nameEn: 'Yeouido',
//       nextDeparture: '11:30',
//       minutesLeft: 12,
//       gradientLight: [SeoulColors.hanRiverBlue, SeoulColors.skyBlue],
//       gradientDark: const [Color(0xFF667eea), Color(0xFF764ba2)],
//       heroTag: 'dock-yeouido',
//       operationStatus: OperationStatus.normal,
//       statusMessage: l10n.statusNormal,
//       address: '서울특별시 영등포구 여의도동 85-1',
//       parkAreaName: '여의도한강공원',
//       parkingSpaces: 171,
//       parkingName: '여의도한강공원 2주차장',
//       nearestSubway: '여의나루역(5호선)',
//       subwayWalkTime: 4,
//       hasShuttle: false,
//       facilities: [
//         l10n.facilityConvenienceStore,
//         l10n.facilityRamen,
//         l10n.facilityFastFood,
//         l10n.facilityCafe,
//       ],
//       busRoutes: ['영등포10', '261', '753', '5615'],
//     ),
//     DockInfo(
//       name: l10n.dockMangwon,
//       nameEn: 'Mangwon',
//       nextDeparture: '12:20',
//       minutesLeft: 62,
//       gradientLight: [SeoulColors.sunsetOrange, const Color(0xFFFFB85C)],
//       gradientDark: const [Color(0xFFf093fb), Color(0xFFF5576c)],
//       heroTag: 'dock-mangwon',
//       operationStatus: OperationStatus.normal,
//       statusMessage: l10n.statusNormal,
//       address: '서울특별시 마포구 망원동 205-8',
//       parkAreaName: '망원한강공원',
//       parkingSpaces: 138,
//       parkingName: '망원 제3주차장',
//       nearestSubway: '망원역(6호선)',
//       subwayWalkTime: 27,
//       hasShuttle: false,
//       facilities: [
//         l10n.facilityConvenienceStore,
//         l10n.facilityCafe,
//         l10n.facilityRamen,
//         l10n.facilityFastFood,
//       ],
//       busRoutes: ['마포16', '7716', '8775'],
//     ),
//     DockInfo(
//       name: l10n.dockMagok,
//       nameEn: 'Magok',
//       nextDeparture: '13:15',
//       minutesLeft: 97,
//       gradientLight: [SeoulColors.mountainGreen, const Color(0xFF6FA287)],
//       gradientDark: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
//       heroTag: 'dock-magok',
//       operationStatus: OperationStatus.normal,
//       statusMessage: l10n.statusNormal,
//       address: '서울특별시 강서구 가양동 441',
//       parkAreaName: null,
//       parkingSpaces: 38,
//       parkingName: '가양라이품 공영주차장',
//       nearestSubway: '양천향교역(9호선)',
//       subwayWalkTime: 12,
//       hasShuttle: true,
//       shuttleInfo: '월~금 28회/일, 15분 간격\n가양나들목–양천향교역–발산역',
//       facilities: [l10n.facilityConvenienceStore],
//       busRoutes: ['6611'],
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchWeather();
//     _weatherTimer = Timer.periodic(
//       const Duration(minutes: 10),
//       (_) => _fetchWeather(),
//     );
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) setState(() => _now = DateTime.now());
//     });

//     _dockController.addListener(() {
//       final page = _dockController.page ?? 0;
//       if (page.round() != _currentDockIndex) {
//         setState(() => _currentDockIndex = page.round());
//         HapticFeedback.lightImpact();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _dockController.dispose();
//     _scrollController.dispose();
//     _realtimeDataTimer.cancel();
//     _timer.cancel();
//     super.dispose();
//   }

//   // -------------------------------------------------------
//   // 시설 아이콘 — 영어/한국어 모두 포함 키워드로 매핑
//   // -------------------------------------------------------
//   String _getFacilityIcon(String facility) {
//     final f = facility.toLowerCase();
//     if (f.contains('편의점') || f.contains('convenience')) return '🏪';
//     if (f.contains('라면') || f.contains('ramen')) return '🍜';
//     if (f.contains('패스트푸드') || f.contains('fast food')) return '🍔';
//     if (f.contains('카페') ||
//         f.contains('까페') ||
//         f.contains('café') ||
//         f.contains('cafe'))
//       return '☕';
//     if (f.contains('화장실') || f.contains('restroom')) return '🚻';
//     if (f.contains('샤워') || f.contains('shower')) return '🚿';
//     if (f.contains('주차') || f.contains('parking')) return '🅿️';
//     if (f.contains('자전거') || f.contains('bike')) return '🚲';
//     return '🏢';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final l10n = AppLocalizations.of(context)!;
//     final docks = _getDocks(l10n);
//     final bgColor = isDarkMode ? SeoulColors.darkNavy : SeoulColors.warmWhite;

//     // 현재 선택된 선착장 날씨 (없으면 첫 번째 데이터 사용)
//     final currentDock = docks[_currentDockIndex];
//     final headerWeather = currentDock.parkAreaName != null
//         ? _weatherData[currentDock.parkAreaName]
//         : (_weatherData.isNotEmpty ? _weatherData.values.first : null);

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
//           // 배경 그라디언트
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 800),
//             curve: Curves.easeInOutCubic,
//             decoration: BoxDecoration(
//               gradient: RadialGradient(
//                 center: Alignment.topRight,
//                 radius: 1.5,
//                 colors: isDarkMode
//                     ? [
//                         _getCurrentGradient(
//                           isDarkMode,
//                           docks,
//                         )[0].withValues(alpha: 0.15),
//                         SeoulColors.darkNavy,
//                       ]
//                     : [
//                         _getCurrentGradient(
//                           isDarkMode,
//                           docks,
//                         )[0].withValues(alpha: 0.08),
//                         SeoulColors.warmWhite,
//                       ],
//               ),
//             ),
//           ),

//           CustomScrollView(
//             controller: _scrollController,
//             physics: const ClampingScrollPhysics(),
//             slivers: [
//               // ── 헤더 ──────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: SafeArea(
//                   bottom: false,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 12),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // 타이틀
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       colors: isDarkMode
//                                           ? [
//                                               Colors.white,
//                                               Colors.white.withValues(
//                                                 alpha: 0.8,
//                                               ),
//                                             ]
//                                           : [
//                                               SeoulColors.seoulBlue,
//                                               SeoulColors.hanRiverBlue,
//                                             ],
//                                     ).createShader(bounds),
//                                     child: Text(
//                                       "한강버스",
//                                       style: const TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.w900,
//                                         height: 1.1,
//                                         letterSpacing: -2,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     l10n.homeSubtitle,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: isDarkMode
//                                           ? Colors.white.withValues(alpha: 0.5)
//                                           : SeoulColors.seoulBlue.withValues(
//                                               alpha: 0.7,
//                                             ),
//                                       fontWeight: FontWeight.w500,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // ── 날씨 위젯 (항상 표시, 데이터 없으면 더미) ──
//                             const SizedBox(width: 16),
//                             _buildHeaderWeatherWidget(
//                               headerWeather,
//                               currentDock,
//                               isDarkMode,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SliverToBoxAdapter(child: SizedBox(height: 40)),

//               // ── 도크 카드 PageView ─────────────────────────
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.8,
//                   child: PageView.builder(
//                     controller: _dockController,
//                     itemCount: docks.length,
//                     clipBehavior: Clip.none,
//                     itemBuilder: (context, index) {
//                       final dock = docks[index];
//                       final isActive = _currentDockIndex == index;

//                       return AnimatedScale(
//                         scale: isActive ? 1.0 : 0.88,
//                         duration: const Duration(milliseconds: 400),
//                         curve: Curves.easeOutCubic,
//                         child: AnimatedOpacity(
//                           opacity: isActive ? 1.0 : 0.5,
//                           duration: const Duration(milliseconds: 400),
//                           child: Hero(
//                             tag: dock.heroTag,
//                             child: Material(
//                               color: Colors.transparent,
//                               child: _buildDockCard(
//                                 dock,
//                                 isActive,
//                                 isDarkMode,
//                                 l10n,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // ── 페이지 인디케이터 ──────────────────────────
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 24),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(docks.length, (index) {
//                       final isActive = _currentDockIndex == index;
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 400),
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         width: isActive ? 32 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           gradient: isActive
//                               ? LinearGradient(
//                                   colors: _getGradientForDock(
//                                     index,
//                                     isDarkMode,
//                                     docks,
//                                   ),
//                                 )
//                               : null,
//                           color: isActive
//                               ? null
//                               : isDarkMode
//                               ? Colors.white.withValues(alpha: 0.2)
//                               : SeoulColors.seoulBlue.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(4),
//                           boxShadow: isActive
//                               ? [
//                                   BoxShadow(
//                                     color: _getGradientForDock(
//                                       index,
//                                       isDarkMode,
//                                       docks,
//                                     )[0].withValues(alpha: 0.6),
//                                     blurRadius: 12,
//                                     spreadRadius: 2,
//                                   ),
//                                 ]
//                               : null,
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ),

//               // ── 빠른 이동 버튼 ─────────────────────────────
//               const SliverToBoxAdapter(child: SizedBox(height: 8)),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildGlassmorphicButton(
//                           icon: Icons.calendar_today_rounded,
//                           label: l10n.fullTimetable,
//                           isDarkMode: isDarkMode,
//                           onTap: () {
//                             HapticFeedback.mediumImpact();
//                             DefaultTabController.of(context).animateTo(1);
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildGlassmorphicButton(
//                           icon: Icons.explore_rounded,
//                           label: l10n.nearbyAttractions,
//                           isDarkMode: isDarkMode,
//                           onTap: () {
//                             HapticFeedback.mediumImpact();
//                             DefaultTabController.of(context).animateTo(2);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ── TODAY 통계 ─────────────────────────────────
//               const SliverToBoxAdapter(child: SizedBox(height: 32)),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ShaderMask(
//                         shaderCallback: (bounds) => LinearGradient(
//                           colors: isDarkMode
//                               ? [
//                                   Colors.white.withValues(alpha: 0.8),
//                                   Colors.white.withValues(alpha: 0.4),
//                                 ]
//                               : [
//                                   SeoulColors.seoulBlue.withValues(alpha: 0.8),
//                                   SeoulColors.hanRiverBlue.withValues(
//                                     alpha: 0.6,
//                                   ),
//                                 ],
//                         ).createShader(bounds),
//                         child: Text(
//                           l10n.todayLabel,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             letterSpacing: 3,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           _buildStat(
//                             l10n.statTrips,
//                             '18회',
//                             Icons.sailing,
//                             isDarkMode,
//                           ),
//                           const SizedBox(width: 12),
//                           _buildStat(
//                             l10n.statPassengers,
//                             '542명',
//                             Icons.people_rounded,
//                             isDarkMode,
//                           ),
//                           const SizedBox(width: 12),
//                           _buildStat(
//                             l10n.statOnTime,
//                             '100%',
//                             Icons.verified_rounded,
//                             isDarkMode,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SliverToBoxAdapter(child: SizedBox(height: 60)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════
//   // 헤더 날씨 위젯 — WeatherData가 없으면 DockInfo의 더미값 사용
//   // ═══════════════════════════════════════════════════════
//   Widget _buildHeaderWeatherWidget(
//     WeatherData? weather,
//     DockInfo dock,
//     bool isDarkMode,
//   ) {
//     // WeatherData가 있으면 실제 데이터, 없으면 DockInfo의 더미값
//     final pm10Color = weather?.current.pm10Color;
//     final pm10Level = weather?.current.pm10Level;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.black.withValues(alpha: 0.4)
//             : Colors.white.withValues(alpha: 0.9),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withValues(alpha: 0.1)
//               : SeoulColors.skyBlue.withValues(alpha: 0.3),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // 아이콘 + 기온
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(icon, style: const TextStyle(fontSize: 30)),
//               const SizedBox(width: 6),
//               ShaderMask(
//                 shaderCallback: (bounds) => const LinearGradient(
//                   colors: [SeoulColors.hanRiverBlue, SeoulColors.skyBlue],
//                 ).createShader(bounds),
//                 child: Text(
//                   temp,
//                   style: const TextStyle(
//                     fontSize: 34,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                     height: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           // 날씨 설명
//           Text(
//             desc,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: isDarkMode
//                   ? Colors.white.withValues(alpha: 0.7)
//                   : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//             ),
//           ),
//           // 미세먼지 — WeatherData 있을 때만 표시
//           if (pm10Color != null && pm10Level != null) ...[
//             const SizedBox(height: 5),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//               decoration: BoxDecoration(
//                 color: pm10Color.withValues(alpha: 0.15),
//                 borderRadius: BorderRadius.circular(7),
//                 border: Border.all(color: pm10Color.withValues(alpha: 0.3)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.masks_rounded, size: 11, color: pm10Color),
//                   const SizedBox(width: 3),
//                   Text(
//                     pm10Level,
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       color: pm10Color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════
//   // 도크 카드
//   // ═══════════════════════════════════════════════════════
//   Widget _buildDockCard(
//     DockInfo dock,
//     bool isActive,
//     bool isDarkMode,
//     AppLocalizations l10n,
//   ) {
//     final gradient = isDarkMode ? dock.gradientDark : dock.gradientLight;
//     final statusColor = _getStatusColor(dock.operationStatus);

//     final realtimeData = dock.parkAreaName != null
//         ? _realtimeData[dock.parkAreaName]
//         : null;
//     final weatherData = dock.parkAreaName != null
//         ? _weatherData[dock.parkAreaName]
//         : null;

//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.heavyImpact();
//         _showEnhancedDetailSheet(
//           context,
//           dock,
//           isDarkMode,
//           weatherData,
//           realtimeData,
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(32),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isDarkMode
//                       ? [
//                           gradient[0].withValues(alpha: 0.3),
//                           gradient[1].withValues(alpha: 0.15),
//                         ]
//                       : [
//                           Colors.white.withValues(alpha: 0.8),
//                           gradient[0].withValues(alpha: 0.1),
//                           Colors.white.withValues(alpha: 0.7),
//                         ],
//                 ),
//                 borderRadius: BorderRadius.circular(32),
//                 border: Border.all(
//                   color: isDarkMode
//                       ? Colors.white.withValues(alpha: 0.2)
//                       : Colors.white.withValues(alpha: 0.6),
//                   width: 1.5,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: gradient[0].withValues(alpha: 0.3),
//                     blurRadius: 30,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // 1. 선착장 이름 + 운항 상태
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             child: Stack(
//                               children: [
//                                 Text(
//                                   dock.name,
//                                   style: TextStyle(
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.w900,
//                                     letterSpacing: -1.5,
//                                     foreground: Paint()
//                                       ..style = PaintingStyle.stroke
//                                       ..strokeWidth = 3
//                                       ..color = isDarkMode
//                                           ? Colors.black.withValues(alpha: 0.5)
//                                           : Colors.white.withValues(alpha: 0.7),
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 ShaderMask(
//                                   shaderCallback: (bounds) => LinearGradient(
//                                     colors: isDarkMode
//                                         ? [
//                                             Colors.white,
//                                             Colors.white.withValues(alpha: 0.7),
//                                           ]
//                                         : gradient,
//                                   ).createShader(bounds),
//                                   child: Text(
//                                     dock.name,
//                                     style: const TextStyle(
//                                       fontSize: 40,
//                                       fontWeight: FontWeight.w900,
//                                       color: Colors.white,
//                                       letterSpacing: -1.5,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           AnimatedBuilder(
//                             animation: _pulseController,
//                             builder: (context, child) {
//                               return Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 5,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isDarkMode
//                                       ? Colors.grey[900]
//                                       : Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: statusColor.withValues(
//                                       alpha: isDarkMode ? 0.6 : 0.4,
//                                     ),
//                                     width: 1.2,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: isDarkMode
//                                           ? Colors.black.withValues(alpha: 0.3)
//                                           : Colors.black.withValues(
//                                               alpha: 0.05,
//                                             ),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       width: 10,
//                                       height: 10,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: statusColor,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       _getStatusText(
//                                         dock.operationStatus,
//                                         l10n,
//                                       ),
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w800,
//                                         color: statusColor,
//                                         letterSpacing: 0.5,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),

//                       // 2. 다음 출발 시간
//                       Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           color: isDarkMode
//                               ? Colors.black.withValues(alpha: 0.3)
//                               : Colors.white.withValues(alpha: 0.7),
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(
//                             color: isDarkMode
//                                 ? Colors.white.withValues(alpha: 0.1)
//                                 : gradient[0].withValues(alpha: 0.2),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               l10n.nextArrival,
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 letterSpacing: 2,
//                                 color: isDarkMode
//                                     ? Colors.white.withValues(alpha: 0.5)
//                                     : SeoulColors.seoulBlue.withValues(
//                                         alpha: 0.6,
//                                       ),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Flexible(
//                                   child: ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       colors:
//                                           dock.operationStatus ==
//                                               OperationStatus.stopped
//                                           ? [Colors.grey, Colors.grey]
//                                           : gradient,
//                                     ).createShader(bounds),
//                                     child: Text(
//                                       dock.operationStatus ==
//                                               OperationStatus.stopped
//                                           ? '--:--'
//                                           : dock.nextDeparture,
//                                       style: const TextStyle(
//                                         fontSize: 54,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                         height: 1,
//                                         letterSpacing: -2,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 if (dock.operationStatus !=
//                                     OperationStatus.stopped)
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 8),
//                                     child: AnimatedBuilder(
//                                       animation: _pulseController,
//                                       builder: (context, child) {
//                                         return Opacity(
//                                           opacity:
//                                               0.6 +
//                                               (_pulseController.value * 0.4),
//                                           child: Text(
//                                             l10n.minutesLeft(dock.minutesLeft),
//                                             style: TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.w700,
//                                               color: isDarkMode
//                                                   ? Colors.white
//                                                   : gradient[0],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // 3. 셔틀버스
//                       if (dock.hasShuttle && dock.shuttleInfo != null) ...[
//                         GestureDetector(
//                           onTap: () => HapticFeedback.mediumImpact(),
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: isDarkMode
//                                   ? Colors.white.withValues(alpha: 0.95)
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: gradient[0].withValues(alpha: 0.3),
//                                 width: 1.5,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: gradient[0].withValues(alpha: 0.15),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(colors: gradient),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Icon(
//                                     Icons.airport_shuttle_rounded,
//                                     size: 22,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 14),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         l10n.freeShuttle,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700,
//                                           color: gradient[0],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         dock.shuttleInfo!.split('\n')[0],
//                                         style: TextStyle(
//                                           fontSize: 11,
//                                           color: SeoulColors.seoulBlue
//                                               .withValues(alpha: 0.7),
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.arrow_forward_ios_rounded,
//                                   size: 16,
//                                   color: gradient[0].withValues(alpha: 0.5),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                       ],

//                       const SizedBox(height: 12),

//                       // 4. 주차 정보
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isDarkMode
//                               ? Colors.black.withValues(alpha: 0.3)
//                               : Colors.white.withValues(alpha: 0.7),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: isDarkMode
//                                 ? Colors.white.withValues(alpha: 0.1)
//                                 : gradient[0].withValues(alpha: 0.2),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.local_parking_rounded,
//                               size: 24,
//                               color: gradient[0],
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     l10n.parkingSpacesSuffix(
//                                       dock.parkingSpaces,
//                                     ),
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w900,
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : gradient[0],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     dock.parkingName,
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: isDarkMode
//                                           ? Colors.white.withValues(alpha: 0.6)
//                                           : SeoulColors.seoulBlue.withValues(
//                                               alpha: 0.7,
//                                             ),
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 12),

//                       // 5. 버스 노선
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isDarkMode
//                               ? Colors.black.withValues(alpha: 0.3)
//                               : Colors.white.withValues(alpha: 0.7),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: isDarkMode
//                                 ? Colors.white.withValues(alpha: 0.1)
//                                 : gradient[0].withValues(alpha: 0.2),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.directions_bus_rounded,
//                               size: 20,
//                               color: gradient[0],
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Wrap(
//                                 spacing: 6,
//                                 runSpacing: 6,
//                                 children: dock.busRoutes.map((route) {
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: gradient[0].withValues(
//                                         alpha: 0.15,
//                                       ),
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     child: Text(
//                                       route,
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w700,
//                                         color: gradient[0],
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 12),

//                       // 6. 부대시설
//                       if (dock.facilities.isNotEmpty)
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: isDarkMode
//                                 ? Colors.black.withValues(alpha: 0.3)
//                                 : Colors.white.withValues(alpha: 0.7),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: isDarkMode
//                                   ? Colors.white.withValues(alpha: 0.1)
//                                   : gradient[0].withValues(alpha: 0.2),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.store_rounded,
//                                     size: 20,
//                                     color: gradient[0],
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     l10n.facilities,
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w700,
//                                       color: isDarkMode
//                                           ? Colors.white.withValues(alpha: 0.8)
//                                           : gradient[0],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               Wrap(
//                                 spacing: 6,
//                                 runSpacing: 6,
//                                 children: dock.facilities.map((facility) {
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 10,
//                                       vertical: 6,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: isDarkMode
//                                           ? Colors.white.withValues(alpha: 0.1)
//                                           : Colors.white.withValues(alpha: 0.9),
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: gradient[0].withValues(
//                                           alpha: 0.2,
//                                         ),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           _getFacilityIcon(facility),
//                                           style: const TextStyle(fontSize: 12),
//                                         ),
//                                         const SizedBox(width: 4),
//                                         Text(
//                                           facility,
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             fontWeight: FontWeight.w600,
//                                             color: isDarkMode
//                                                 ? Colors.white.withValues(
//                                                     alpha: 0.9,
//                                                   )
//                                                 : SeoulColors.seoulBlue,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         ),

//                       const SizedBox(height: 20),

//                       // 7. 지도 버튼
//                       GestureDetector(
//                         onTap: () {
//                           HapticFeedback.mediumImpact();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   DockMapScreen(dockInfo: dock),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: gradient,
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(18),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: gradient[0].withValues(alpha: 0.4),
//                                 blurRadius: 16,
//                                 offset: const Offset(0, 6),
//                               ),
//                               BoxShadow(
//                                 color: gradient[0].withValues(alpha: 0.2),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withValues(alpha: 0.2),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(
//                                   Icons.map_rounded,
//                                   size: 20,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 l10n.scheduleAndMap,
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w800,
//                                   color: Colors.white,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               const Icon(
//                                 Icons.arrow_forward_rounded,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════
//   // 상세 바텀시트
//   // ═══════════════════════════════════════════════════════
//   void _showEnhancedDetailSheet(
//     BuildContext context,
//     DockInfo dock,
//     bool isDarkMode,
//     WeatherData? weatherData,
//     HangangRealtimeData? realtimeData,
//   ) {
//     final gradient = isDarkMode ? dock.gradientDark : dock.gradientLight;
//     final l10n = AppLocalizations.of(context)!;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.85,
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? SeoulColors.darkNavy.withValues(alpha: 0.95)
//                   : Colors.white.withValues(alpha: 0.95),
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(32),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 12),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? Colors.white.withValues(alpha: 0.3)
//                         : Colors.grey.withValues(alpha: 0.3),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Row(
//                     children: [
//                       ShaderMask(
//                         shaderCallback: (bounds) => LinearGradient(
//                           colors: gradient,
//                         ).createShader(bounds),
//                         child: Text(
//                           l10n.dockSheetTitle(dock.name),
//                           style: const TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white,
//                             letterSpacing: -1,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: Icon(
//                           Icons.close_rounded,
//                           color: isDarkMode
//                               ? Colors.white
//                               : SeoulColors.seoulBlue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       dock.address,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isDarkMode
//                             ? Colors.white.withValues(alpha: 0.6)
//                             : SeoulColors.seoulBlue.withValues(alpha: 0.6),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // 실시간 현황
//                         if (realtimeData != null) ...[
//                           _buildDetailSectionHeader(
//                             l10n.realtimeStatus,
//                             Icons.show_chart_rounded,
//                             gradient,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildRealtimeStatusSection(
//                             realtimeData,
//                             gradient,
//                             isDarkMode,
//                             l10n,
//                           ),
//                           const SizedBox(height: 24),
//                         ],

//                         // 날씨 정보
//                         if (weatherData != null) ...[
//                           _buildDetailSectionHeader(
//                             l10n.weatherInfo,
//                             Icons.wb_sunny_rounded,
//                             gradient,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildCurrentWeatherSection(
//                             weatherData,
//                             gradient,
//                             isDarkMode,
//                             l10n,
//                           ),
//                           const SizedBox(height: 16),
//                           _buildHourlyForecastSection(
//                             weatherData,
//                             gradient,
//                             isDarkMode,
//                             l10n,
//                           ),
//                           const SizedBox(height: 24),
//                         ],

//                         // 접근 수단
//                         _buildDetailSectionHeader(
//                           l10n.accessInfo,
//                           Icons.directions_rounded,
//                           gradient,
//                           isDarkMode,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildAccessInfo(
//                           icon: Icons.subway_rounded,
//                           title: dock.nearestSubway,
//                           subtitle: l10n.walkingMinutes(dock.subwayWalkTime),
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildAccessInfo(
//                           icon: Icons.local_parking_rounded,
//                           title: l10n.parkingSpacesSuffix(dock.parkingSpaces),
//                           subtitle: dock.parkingName,
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),
//                         const SizedBox(height: 24),

//                         // 부대시설
//                         _buildDetailSectionHeader(
//                           l10n.facilities,
//                           Icons.store_rounded,
//                           gradient,
//                           isDarkMode,
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: dock.facilities.map((facility) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: isDarkMode
//                                     ? Colors.white.withValues(alpha: 0.1)
//                                     : Colors.white.withValues(alpha: 0.7),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: gradient[0].withValues(alpha: 0.3),
//                                 ),
//                               ),
//                               child: Text(
//                                 facility,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: isDarkMode
//                                       ? Colors.white
//                                       : gradient[0],
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 40),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailSectionHeader(
//     String title,
//     IconData icon,
//     List<Color> gradient,
//     bool isDarkMode,
//   ) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: gradient),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, size: 20, color: Colors.white),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w800,
//             color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRealtimeStatusSection(
//     HangangRealtimeData data,
//     List<Color> gradient,
//     bool isDarkMode,
//     AppLocalizations l10n,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.black.withValues(alpha: 0.3)
//             : Colors.white.withValues(alpha: 0.7),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withValues(alpha: 0.1)
//               : gradient[0].withValues(alpha: 0.2),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: gradient[0].withValues(alpha: 0.15),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               l10n.updatedMinutesAgo,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: gradient[0],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           if (data.population != null)
//             _buildRealtimeItem(
//               icon: Icons.people_rounded,
//               label: l10n.currentPopulation,
//               value: '${data.population!.estimatedPopulation}명',
//               subValue: data.population!.congestLevel,
//               gradient: gradient,
//               isDarkMode: isDarkMode,
//             ),
//           const SizedBox(height: 12),
//           if (data.bikeStations.isNotEmpty)
//             _buildRealtimeItem(
//               icon: Icons.pedal_bike_rounded,
//               label: l10n.bikeShare,
//               value: l10n.bikeStationsCount(data.bikeStations.length),
//               subValue: l10n.bikesAvailable(
//                 data.bikeStations.fold<int>(0, (sum, b) => sum + b.available),
//               ),
//               gradient: gradient,
//               isDarkMode: isDarkMode,
//             ),
//           const SizedBox(height: 12),
//           if (data.parkingLots.isNotEmpty)
//             _buildRealtimeItem(
//               icon: Icons.local_parking_rounded,
//               label: l10n.parking,
//               value: l10n.parkingSpacesAvailable(
//                 data.parkingLots.fold<int>(0, (sum, p) => sum + p.available),
//               ),
//               subValue: l10n.parkingSpacesTotal(
//                 data.parkingLots.fold<int>(0, (sum, p) => sum + p.total),
//               ),
//               gradient: gradient,
//               isDarkMode: isDarkMode,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRealtimeItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required String subValue,
//     required List<Color> gradient,
//     required bool isDarkMode,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: isDarkMode
//                 ? Colors.white.withValues(alpha: 0.1)
//                 : Colors.white.withValues(alpha: 0.9),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, size: 20, color: gradient[0]),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isDarkMode
//                       ? Colors.white.withValues(alpha: 0.6)
//                       : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 subValue,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: isDarkMode
//                       ? Colors.white.withValues(alpha: 0.4)
//                       : SeoulColors.seoulBlue.withValues(alpha: 0.5),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w900,
//             color: isDarkMode ? Colors.white : gradient[0],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCurrentWeatherSection(
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
//     AppLocalizations l10n,
//   ) {
//     final current = weather.current;
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.black.withValues(alpha: 0.3)
//             : Colors.white.withValues(alpha: 0.7),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withValues(alpha: 0.1)
//               : gradient[0].withValues(alpha: 0.2),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(current.weatherIcon, style: const TextStyle(fontSize: 48)),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ShaderMask(
//                       shaderCallback: (bounds) =>
//                           LinearGradient(colors: gradient).createShader(bounds),
//                       child: Text(
//                         '${current.temperature.toInt()}°',
//                         style: const TextStyle(
//                           fontSize: 48,
//                           fontWeight: FontWeight.w900,
//                           color: Colors.white,
//                           height: 1,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             current.skyStatus,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: isDarkMode
//                                   ? Colors.white
//                                   : SeoulColors.seoulBlue,
//                             ),
//                           ),
//                           Text(
//                             l10n.feelsLike(current.sensoryTemp.toString()),
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: isDarkMode
//                                   ? Colors.white.withValues(alpha: 0.6)
//                                   : SeoulColors.seoulBlue.withValues(
//                                       alpha: 0.6,
//                                     ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildWeatherDetailItem(
//                   icon: Icons.water_drop_outlined,
//                   label: l10n.humidity,
//                   value: '${current.humidity.toInt()}%',
//                   gradient: gradient,
//                   isDarkMode: isDarkMode,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildWeatherDetailItem(
//                   icon: Icons.air_rounded,
//                   label: l10n.windSpeed,
//                   value: '${current.windSpeed}m/s',
//                   gradient: gradient,
//                   isDarkMode: isDarkMode,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: current.pm10Color.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: current.pm10Color.withValues(alpha: 0.3),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.masks_rounded, size: 20, color: current.pm10Color),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         l10n.fineDust,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: isDarkMode
//                               ? Colors.white.withValues(alpha: 0.6)
//                               : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         '${current.pm10Level} (${current.pm10}㎍/㎥)',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: current.pm10Color,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeatherDetailItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required List<Color> gradient,
//     required bool isDarkMode,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.white.withValues(alpha: 0.1)
//             : Colors.white.withValues(alpha: 0.9),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 18, color: gradient[0]),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: isDarkMode
//                   ? Colors.white.withValues(alpha: 0.5)
//                   : SeoulColors.seoulBlue.withValues(alpha: 0.6),
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w800,
//               color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHourlyForecastSection(
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
//     AppLocalizations l10n,
//   ) {
//     final displayForecasts = weather.hourlyForecasts.take(4).toList();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.black.withValues(alpha: 0.3)
//             : Colors.white.withValues(alpha: 0.7),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withValues(alpha: 0.1)
//               : gradient[0].withValues(alpha: 0.2),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.schedule_rounded, size: 18, color: gradient[0]),
//               const SizedBox(width: 8),
//               Text(
//                 l10n.hourlyForecast,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...displayForecasts.map(
//             (forecast) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 60,
//                     child: Text(
//                       forecast.timeString,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: isDarkMode
//                             ? Colors.white.withValues(alpha: 0.8)
//                             : SeoulColors.seoulBlue,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     forecast.weatherIcon,
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       '${forecast.temperature.toInt()}°',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                         color: isDarkMode ? Colors.white : gradient[0],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: forecast.precipitationProbability >= 70
//                           ? Colors.blue.withValues(alpha: 0.15)
//                           : Colors.grey.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.water_drop_outlined,
//                           size: 12,
//                           color: forecast.precipitationProbability >= 70
//                               ? Colors.blue
//                               : Colors.grey,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${forecast.precipitationProbability}%',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: forecast.precipitationProbability >= 70
//                                 ? Colors.blue
//                                 : Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (weather.hourlyForecasts.length > 4)
//             GestureDetector(
//               onTap: () => _showFullWeatherForecast(
//                 context,
//                 weather,
//                 gradient,
//                 isDarkMode,
//                 l10n,
//               ),
//               child: Container(
//                 margin: const EdgeInsets.only(top: 8),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: gradient[0].withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       l10n.fullForecast,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: gradient[0],
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Icon(
//                       Icons.arrow_forward_rounded,
//                       size: 16,
//                       color: gradient[0],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showFullWeatherForecast(
//     BuildContext context,
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
//     AppLocalizations l10n,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.7,
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? SeoulColors.darkNavy.withValues(alpha: 0.95)
//                   : Colors.white.withValues(alpha: 0.95),
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(32),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 12),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? Colors.white.withValues(alpha: 0.3)
//                         : Colors.grey.withValues(alpha: 0.3),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Row(
//                     children: [
//                       ShaderMask(
//                         shaderCallback: (bounds) => LinearGradient(
//                           colors: gradient,
//                         ).createShader(bounds),
//                         child: Text(
//                           l10n.weatherForecast24h,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.white,
//                             letterSpacing: -1,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: Icon(
//                           Icons.close_rounded,
//                           color: isDarkMode
//                               ? Colors.white
//                               : SeoulColors.seoulBlue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     itemCount: weather.hourlyForecasts.length,
//                     itemBuilder: (context, index) {
//                       final forecast = weather.hourlyForecasts[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isDarkMode
//                               ? Colors.white.withValues(alpha: 0.05)
//                               : SeoulColors.lightGray.withValues(alpha: 0.5),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: gradient[0].withValues(alpha: 0.2),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 70,
//                               child: Text(
//                                 forecast.timeString,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                   color: isDarkMode
//                                       ? Colors.white
//                                       : SeoulColors.seoulBlue,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               forecast.weatherIcon,
//                               style: const TextStyle(fontSize: 32),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '${forecast.temperature.toInt()}°C',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w900,
//                                       color: isDarkMode
//                                           ? Colors.white
//                                           : gradient[0],
//                                     ),
//                                   ),
//                                   Text(
//                                     forecast.skyStatus,
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: isDarkMode
//                                           ? Colors.white.withValues(alpha: 0.6)
//                                           : SeoulColors.seoulBlue.withValues(
//                                               alpha: 0.6,
//                                             ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors:
//                                       forecast.precipitationProbability >= 70
//                                       ? [
//                                           Colors.blue,
//                                           Colors.blue.withValues(alpha: 0.7),
//                                         ]
//                                       : [
//                                           Colors.grey.withValues(alpha: 0.3),
//                                           Colors.grey.withValues(alpha: 0.2),
//                                         ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.water_drop_rounded,
//                                     size: 14,
//                                     color:
//                                         forecast.precipitationProbability >= 70
//                                         ? Colors.white
//                                         : Colors.grey[600],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '${forecast.precipitationProbability}%',
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w700,
//                                       color:
//                                           forecast.precipitationProbability >=
//                                               70
//                                           ? Colors.white
//                                           : Colors.grey[600],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAccessInfo({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required List<Color> gradient,
//     required bool isDarkMode,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.black.withValues(alpha: 0.3)
//             : Colors.white.withValues(alpha: 0.7),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.white.withValues(alpha: 0.1)
//               : gradient[0].withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: gradient),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 20, color: Colors.white),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: isDarkMode
//                         ? Colors.white.withValues(alpha: 0.6)
//                         : SeoulColors.seoulBlue.withValues(alpha: 0.6),
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGlassmorphicButton({
//     required IconData icon,
//     required String label,
//     required bool isDarkMode,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? Colors.white.withValues(alpha: 0.08)
//                   : Colors.white.withValues(alpha: 0.8),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   icon,
//                   size: 20,
//                   color: isDarkMode
//                       ? Colors.white.withValues(alpha: 0.9)
//                       : SeoulColors.seoulBlue,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isDarkMode
//                         ? Colors.white.withValues(alpha: 0.9)
//                         : SeoulColors.seoulBlue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStat(
//     String label,
//     String value,
//     IconData icon,
//     bool isDarkMode,
//   ) {
//     return Expanded(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? Colors.white.withValues(alpha: 0.06)
//                   : Colors.white.withValues(alpha: 0.8),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   icon,
//                   size: 20,
//                   color: isDarkMode
//                       ? SeoulColors.neonGreen
//                       : SeoulColors.hanRiverBlue,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w900,
//                     color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: isDarkMode
//                         ? Colors.white.withValues(alpha: 0.5)
//                         : SeoulColors.seoulBlue.withValues(alpha: 0.6),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(OperationStatus status) {
//     switch (status) {
//       case OperationStatus.normal:
//         return SeoulColors.statusNormal;
//       case OperationStatus.partial:
//         return SeoulColors.statusPartial;
//       case OperationStatus.stopped:
//         return SeoulColors.statusStopped;
//     }
//   }

//   String _getStatusText(OperationStatus status, AppLocalizations l10n) {
//     switch (status) {
//       case OperationStatus.normal:
//         return l10n.statusNormal;
//       case OperationStatus.partial:
//         return l10n.statusPartial;
//       case OperationStatus.stopped:
//         return l10n.statusStopped;
//     }
//   }

//   List<Color> _getCurrentGradient(bool isDarkMode, List<DockInfo> docks) {
//     return isDarkMode
//         ? docks[_currentDockIndex].gradientDark
//         : docks[_currentDockIndex].gradientLight;
//   }

//   List<Color> _getGradientForDock(
//     int index,
//     bool isDarkMode,
//     List<DockInfo> docks,
//   ) {
//     return isDarkMode ? docks[index].gradientDark : docks[index].gradientLight;
//   }
// }

// // ═══════════════════════════════════════════════════════
// // 데이터 모델
// // ═══════════════════════════════════════════════════════
// class DockInfo {
//   final String name;
//   final String nameEn;
//   final String nextDeparture;
//   final int minutesLeft;
//   final List<Color> gradientLight;
//   final List<Color> gradientDark;
//   final String heroTag;
//   final OperationStatus operationStatus;
//   final String statusMessage;
//   final String address;
//   final int parkingSpaces;
//   final String parkingName;
//   final String nearestSubway;
//   final int subwayWalkTime;
//   final bool hasShuttle;
//   final String? shuttleInfo;
//   final List<String> facilities;
//   final List<String> busRoutes;
//   final String? parkAreaName;

//   DockInfo({
//     required this.name,
//     required this.nameEn,
//     required this.nextDeparture,
//     required this.minutesLeft,
//     required this.gradientLight,
//     required this.gradientDark,
//     required this.heroTag,
//     required this.operationStatus,
//     required this.statusMessage,
//     required this.address,
//     required this.parkingSpaces,
//     required this.parkingName,
//     required this.nearestSubway,
//     required this.subwayWalkTime,
//     required this.hasShuttle,
//     this.shuttleInfo,
//     required this.facilities,
//     required this.busRoutes,
//     required this.parkAreaName,
//   });
// }
