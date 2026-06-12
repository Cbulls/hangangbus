// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'dart:ui';

// import 'package:hangangbus/hangang_realtime_data.dart';
// import 'package:hangangbus/seoul_api_service.dart';
// import 'package:hangangbus/weather_data.dart';

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
//   final ScrollController _scrollController = ScrollController(); // 🔧 스크롤 제어
//   int _currentDockIndex = 0;

//   late AnimationController _pulseController;
//   late Timer _timer;
//   late Timer _realtimeDataTimer; // 🆕 실시간 데이터 갱신용
//   DateTime _now = DateTime.now();

//   Map<String, WeatherData> _weatherData = {};

//   Map<String, HangangRealtimeData> _realtimeData = {};
//   bool _isLoadingRealtimeData = false;

//   final List<DockInfo> _docks = [
//     DockInfo(
//       name: "여의도",
//       nameEn: "Yeouido",
//       nextDeparture: "11:30",
//       minutesLeft: 12,
//       weatherTemp: 24,
//       weatherIcon: "☀️",
//       weatherDesc: "맑음",
//       gradientLight: [SeoulColors.hanRiverBlue, SeoulColors.skyBlue],
//       gradientDark: [Color(0xFF667eea), Color(0xFF764ba2)],
//       heroTag: "dock-yeouido",
//       operationStatus: OperationStatus.normal,
//       statusMessage: "정상 운행",
//       address: "서울특별시 영등포구 여의도동 85-1",
//       parkAreaName: "여의도한강공원", // 🆕 API 조회용 공원 이름
//       parkingSpaces: 171,
//       parkingName: "여의도한강공원 2주차장",
//       nearestSubway: "여의나루역(5호선)",
//       subwayWalkTime: 4,
//       hasShuttle: false,
//       facilities: ["편의점", "라면체험존", "패스트푸드", "카페"],
//       busRoutes: ["영등포10", "10", "261", "753", "5615"],
//     ),
//     DockInfo(
//       name: "망원",
//       nameEn: "Mangwon",
//       nextDeparture: "12:20",
//       minutesLeft: 62,
//       weatherTemp: 22,
//       weatherIcon: "⛅",
//       weatherDesc: "구름 조금",
//       gradientLight: [SeoulColors.sunsetOrange, Color(0xFFFFB85C)],
//       gradientDark: [Color(0xFFf093fb), Color(0xFFF5576c)],
//       heroTag: "dock-mangwon",
//       operationStatus: OperationStatus.normal,
//       statusMessage: "정상 운행",
//       address: "서울특별시 마포구 망원동 205-8",
//       parkAreaName: "망원한강공원", // 🆕
//       parkingSpaces: 138,
//       parkingName: "망원 제3주차장",
//       nearestSubway: "망원역(6호선)",
//       subwayWalkTime: 27,
//       hasShuttle: false,
//       facilities: ["편의점", "카페", "라면체험존", "패스트푸드"],
//       busRoutes: ["마포16", "7716", "8775"],
//     ),
//     DockInfo(
//       name: "마곡",
//       nameEn: "Magok",
//       nextDeparture: "13:15",
//       minutesLeft: 97,
//       weatherTemp: 23,
//       weatherIcon: "🌤️",
//       weatherDesc: "화창함",
//       gradientLight: [SeoulColors.mountainGreen, Color(0xFF6FA287)],
//       gradientDark: [Color(0xFF4facfe), Color(0xFF00f2fe)],
//       heroTag: "dock-magok",
//       operationStatus: OperationStatus.normal,
//       statusMessage: "정상 운행",
//       address: "서울특별시 강서구 가양동 441",
//       parkAreaName: null, // 🆕 마곡은 데이터 없음
//       parkingSpaces: 38,
//       parkingName: "가양라이품 공영주차장",
//       nearestSubway: "양천향교역(9호선)",
//       subwayWalkTime: 12,
//       hasShuttle: true,
//       shuttleInfo: "월~금 28회/일, 15분 간격\n가양나들목–양천향교역–발산역",
//       facilities: ["편의점"],
//       busRoutes: ["6611"],
//     ),
//   ];

//   // 🆕 실시간 + 날씨 데이터 통합 로드
//   Future<void> _loadAllData() async {
//     setState(() => _isLoadingRealtimeData = true);

//     final areaNames = _docks
//         .where((dock) => dock.parkAreaName != null)
//         .map((dock) => dock.parkAreaName!)
//         .toList();

//     // 병렬 처리로 성능 최적화
//     final results = await Future.wait(
//       areaNames.map((areaName) => SeoulApiService.getCompleteData(areaName)),
//     );

//     if (mounted) {
//       setState(() {
//         for (int i = 0; i < areaNames.length; i++) {
//           final areaName = areaNames[i];
//           final result = results[i];

//           if (result['realtime'] != null) {
//             _realtimeData[areaName] = result['realtime'];
//           }
//           if (result['weather'] != null) {
//             _weatherData[areaName] = result['weather'];
//           }
//         }
//         _isLoadingRealtimeData = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // 1. 초기 데이터 통합 로드 (날씨 + 실시간 정보)
//     _loadAllData();

//     // 2. 5분마다 데이터 통합 갱신 (중복 타이머 제거)
//     _realtimeDataTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
//       _loadAllData();
//     });

//     // 3. 기존 애니메이션 및 스크롤 리스너 유지
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

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final bgColor = isDarkMode ? SeoulColors.darkNavy : SeoulColors.warmWhite;

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
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
//                         )[0].withValues(alpha: 0.15),
//                         SeoulColors.darkNavy,
//                       ]
//                     : [
//                         _getCurrentGradient(
//                           isDarkMode,
//                         )[0].withValues(alpha: 0.08),
//                         SeoulColors.warmWhite,
//                       ],
//               ),
//             ),
//           ),

//           // 🔧 스크롤 제어 추가
//           CustomScrollView(
//             controller: _scrollController,
//             physics: const ClampingScrollPhysics(), // 🔧 무한 스크롤 방지
//             slivers: [
//               SliverToBoxAdapter(
//                 child: SafeArea(
//                   bottom: false,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 12),

//                         ShaderMask(
//                           shaderCallback: (bounds) => LinearGradient(
//                             colors: isDarkMode
//                                 ? [
//                                     Colors.white,
//                                     Colors.white.withValues(alpha: 0.8),
//                                   ]
//                                 : [
//                                     SeoulColors.seoulBlue,
//                                     SeoulColors.hanRiverBlue,
//                                   ],
//                           ).createShader(bounds),
//                           child: const Text(
//                             "한강버스",
//                             style: TextStyle(
//                               fontSize: 48,
//                               fontWeight: FontWeight.w900,
//                               height: 1.1,
//                               letterSpacing: -2,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "실시간 운항 현황",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDarkMode
//                                 ? Colors.white.withValues(alpha: 0.5)
//                                 : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SliverToBoxAdapter(child: SizedBox(height: 40)),

//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 500,
//                   child: PageView.builder(
//                     controller: _dockController,
//                     itemCount: _docks.length,
//                     clipBehavior: Clip.none,
//                     itemBuilder: (context, index) {
//                       final dock = _docks[index];
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
//                               child: _buildDockCard(dock, isActive, isDarkMode),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 24),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(_docks.length, (index) {
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

//               const SliverToBoxAdapter(child: SizedBox(height: 8)),

//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildGlassmorphicButton(
//                           icon: Icons.calendar_today_rounded,
//                           label: "전체 시간표",
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
//                           label: "주변 명소",
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
//                         child: const Text(
//                           "TODAY",
//                           style: TextStyle(
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
//                           _buildStat("운항", "18회", Icons.sailing, isDarkMode),
//                           const SizedBox(width: 12),
//                           _buildStat(
//                             "탑승객",
//                             "842명",
//                             Icons.people_rounded,
//                             isDarkMode,
//                           ),
//                           const SizedBox(width: 12),
//                           _buildStat(
//                             "정시율",
//                             "100%",
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

//   Widget _buildDockCard(DockInfo dock, bool isActive, bool isDarkMode) {
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
//         _showDetailSheet(context, dock, isDarkMode);
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
//               child: Padding(
//                 padding: const EdgeInsets.all(28),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // 1. 선착장 이름 + 운항 상태
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: Stack(
//                             children: [
//                               Text(
//                                 dock.name,
//                                 style: TextStyle(
//                                   fontSize: 40,
//                                   fontWeight: FontWeight.w900,
//                                   letterSpacing: -1.5,
//                                   foreground: Paint()
//                                     ..style = PaintingStyle.stroke
//                                     ..strokeWidth = 3
//                                     ..color = isDarkMode
//                                         ? Colors.black.withValues(alpha: 0.5)
//                                         : Colors.white.withValues(alpha: 0.7),
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               ShaderMask(
//                                 shaderCallback: (bounds) => LinearGradient(
//                                   colors: isDarkMode
//                                       ? [
//                                           Colors.white,
//                                           Colors.white.withValues(alpha: 0.7),
//                                         ]
//                                       : gradient,
//                                 ).createShader(bounds),
//                                 child: Text(
//                                   dock.name,
//                                   style: const TextStyle(
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.w900,
//                                     color: Colors.white,
//                                     letterSpacing: -1.5,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         AnimatedBuilder(
//                           animation: _pulseController,
//                           builder: (context, child) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: isDarkMode
//                                     ? Colors.grey[900]
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: statusColor.withValues(
//                                     alpha: isDarkMode ? 0.6 : 0.4,
//                                   ),
//                                   width: 1.2,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: isDarkMode
//                                         ? Colors.black.withValues(alpha: 0.3)
//                                         : Colors.black.withValues(alpha: 0.05),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     width: 10,
//                                     height: 10,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: statusColor,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     _getStatusText(dock.operationStatus),
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w800,
//                                       color: statusColor,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // 2. 다음 출발 시간 (불투명 배경 - 가장 중요)
//                     Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: isDarkMode
//                             ? Colors.black.withValues(alpha: 0.3)
//                             : Colors.white.withValues(alpha: 0.7),
//                         borderRadius: BorderRadius.circular(24),
//                         border: Border.all(
//                           color: isDarkMode
//                               ? Colors.white.withValues(alpha: 0.1)
//                               : gradient[0].withValues(alpha: 0.2),
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "다음 도착 예정",
//                             style: TextStyle(
//                               fontSize: 11,
//                               letterSpacing: 2,
//                               color: isDarkMode
//                                   ? Colors.white.withValues(alpha: 0.5)
//                                   : SeoulColors.seoulBlue.withValues(
//                                       alpha: 0.6,
//                                     ),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Flexible(
//                                 child: ShaderMask(
//                                   shaderCallback: (bounds) => LinearGradient(
//                                     colors:
//                                         dock.operationStatus ==
//                                             OperationStatus.stopped
//                                         ? [Colors.grey, Colors.grey]
//                                         : gradient,
//                                   ).createShader(bounds),
//                                   child: Text(
//                                     dock.operationStatus ==
//                                             OperationStatus.stopped
//                                         ? "--:--"
//                                         : dock.nextDeparture,
//                                     style: const TextStyle(
//                                       fontSize: 54,
//                                       fontWeight: FontWeight.w900,
//                                       color: Colors.white,
//                                       height: 1,
//                                       letterSpacing: -2,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               if (dock.operationStatus !=
//                                   OperationStatus.stopped)
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 8),
//                                   child: AnimatedBuilder(
//                                     animation: _pulseController,
//                                     builder: (context, child) {
//                                       return Opacity(
//                                         opacity:
//                                             0.6 +
//                                             (_pulseController.value * 0.4),
//                                         child: Text(
//                                           "${dock.minutesLeft}분 후",
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w700,
//                                             color: isDarkMode
//                                                 ? Colors.white
//                                                 : gradient[0],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // 🆕 3. 간소화된 현재 날씨 (반투명 배경 - 한강버스 핵심)
//                     if (weatherData != null)
//                       _buildCompactWeatherSection(
//                         weatherData,
//                         gradient,
//                         isDarkMode,
//                       ),

//                     const SizedBox(height: 20),

//                     // 4. 버튼 (상세 정보로 이동)
//                     Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               HapticFeedback.lightImpact();
//                               _showEnhancedDetailSheet(
//                                 context,
//                                 dock,
//                                 isDarkMode,
//                                 weatherData,
//                                 realtimeData,
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               decoration: BoxDecoration(
//                                 color: isDarkMode
//                                     ? Colors.white.withValues(alpha: 0.1)
//                                     : Colors.white.withValues(alpha: 0.9),
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(
//                                   color: gradient[0].withValues(alpha: 0.3),
//                                 ),
//                               ),
//                               child: Text(
//                                 "상세 정보",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                   color: gradient[0],
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               HapticFeedback.mediumImpact();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: const Text('실시간 지도 기능은 준비 중입니다'),
//                                   behavior: SnackBarBehavior.floating,
//                                   backgroundColor: gradient[0],
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(colors: gradient),
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: gradient[0].withValues(alpha: 0.3),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.my_location_rounded,
//                                     size: 18,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Flexible(
//                                     child: Text(
//                                       "실시간",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.white,
//                                         letterSpacing: 0.5,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🆕 간소화된 날씨 섹션 (카드용 - 핵심만)
//   // Widget _buildCompactWeatherSection(
//   //   WeatherData weather,
//   //   List<Color> gradient,
//   //   bool isDarkMode,
//   // ) {
//   //   final current = weather.current;

//   //   return Container(
//   //     padding: const EdgeInsets.all(20),
//   //     decoration: BoxDecoration(
//   //       // 🎨 배경색 통일 (도착 시간과 동일)
//   //       color: isDarkMode
//   //           ? Colors.black.withValues(alpha: 0.3)
//   //           : Colors.white.withValues(alpha: 0.7),
//   //       borderRadius: BorderRadius.circular(20),
//   //       border: Border.all(
//   //         color: isDarkMode
//   //             ? Colors.white.withValues(alpha: 0.1)
//   //             : gradient[0].withValues(alpha: 0.2),
//   //       ),
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         // 헤더
//   //         Row(
//   //           children: [
//   //             Text(current.weatherIcon, style: const TextStyle(fontSize: 32)),
//   //             const SizedBox(width: 12),
//   //             Expanded(
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   ShaderMask(
//   //                     shaderCallback: (bounds) =>
//   //                         LinearGradient(colors: gradient).createShader(bounds),
//   //                     child: Text(
//   //                       "${current.temperature.toInt()}°C",
//   //                       style: const TextStyle(
//   //                         fontSize: 32,
//   //                         fontWeight: FontWeight.w900,
//   //                         color: Colors.white,
//   //                         height: 1,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   const SizedBox(height: 4),
//   //                   Text(
//   //                     "${current.skyStatus} · 체감 ${current.sensoryTemp}°",
//   //                     style: TextStyle(
//   //                       fontSize: 13,
//   //                       color: isDarkMode
//   //                           ? Colors.white.withValues(alpha: 0.6)
//   //                           : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//   //                       fontWeight: FontWeight.w600,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //             // 미세먼지 뱃지
//   //             Container(
//   //               padding: const EdgeInsets.symmetric(
//   //                 horizontal: 12,
//   //                 vertical: 6,
//   //               ),
//   //               decoration: BoxDecoration(
//   //                 color: current.pm10Color.withValues(alpha: 0.15),
//   //                 borderRadius: BorderRadius.circular(12),
//   //                 border: Border.all(
//   //                   color: current.pm10Color.withValues(alpha: 0.3),
//   //                 ),
//   //               ),
//   //               child: Row(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 children: [
//   //                   Icon(
//   //                     Icons.masks_rounded,
//   //                     size: 16,
//   //                     color: current.pm10Color,
//   //                   ),
//   //                   const SizedBox(width: 6),
//   //                   Text(
//   //                     current.pm10Level,
//   //                     style: TextStyle(
//   //                       fontSize: 12,
//   //                       fontWeight: FontWeight.w700,
//   //                       color: current.pm10Color,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   Widget _buildCompactWeatherSection(
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
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
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
//         children: [
//           // 왼쪽: 아이콘 + 기온
//           Row(
//             children: [
//               Text(current.weatherIcon, style: const TextStyle(fontSize: 32)),
//               const SizedBox(width: 12),
//               ShaderMask(
//                 shaderCallback: (bounds) =>
//                     LinearGradient(colors: gradient).createShader(bounds),
//                 child: Text(
//                   "${current.temperature.toInt()}°C",
//                   style: const TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // 오른쪽: 미세먼지 정보 (버튼이 아닌 정보성 위젯)
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               // 버튼처럼 보이지 않도록 배경을 더 투명하게 처리
//               color: current.pm10Color.withValues(alpha: 0.08),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.masks_rounded, size: 18, color: current.pm10Color),
//                 const SizedBox(width: 8),
//                 Text(
//                   "미세먼지 ${current.pm10Level}", // 예: 미세먼지 보통
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: current.pm10Color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🆕 개선된 상세 정보 바텀시트
//   void _showEnhancedDetailSheet(
//     BuildContext context,
//     DockInfo dock,
//     bool isDarkMode,
//     WeatherData? weatherData,
//     HangangRealtimeData? realtimeData,
//   ) {
//     final gradient = isDarkMode ? dock.gradientDark : dock.gradientLight;

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
//                 // 드래그 핸들
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

//                 // 헤더
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 28),
//                   child: Row(
//                     children: [
//                       ShaderMask(
//                         shaderCallback: (bounds) => LinearGradient(
//                           colors: gradient,
//                         ).createShader(bounds),
//                         child: Text(
//                           "${dock.name} 선착장",
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

//                 // 스크롤 가능한 콘텐츠
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // 📊 실시간 현황 (전체)
//                         if (realtimeData != null) ...[
//                           _buildDetailSectionHeader(
//                             "실시간 현황",
//                             Icons.show_chart_rounded,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildRealtimeStatusSection(
//                             realtimeData,
//                             gradient,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 24),
//                         ],

//                         // 🌤️ 날씨 (전체)
//                         if (weatherData != null) ...[
//                           _buildDetailSectionHeader(
//                             "날씨 정보",
//                             Icons.wb_sunny_rounded,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildCurrentWeatherSection(
//                             weatherData,
//                             gradient,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 16),
//                           _buildHourlyForecastSection(
//                             weatherData,
//                             gradient,
//                             isDarkMode,
//                           ),
//                           const SizedBox(height: 24),
//                         ],

//                         // 🚇 접근성
//                         _buildDetailSectionHeader(
//                           "접근 수단",
//                           Icons.directions_rounded,
//                           isDarkMode,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildAccessInfo(
//                           icon: Icons.subway_rounded,
//                           title: dock.nearestSubway,
//                           subtitle: "도보 ${dock.subwayWalkTime}분",
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildAccessInfo(
//                           icon: Icons.local_parking_rounded,
//                           title: "${dock.parkingSpaces}면",
//                           subtitle: dock.parkingName,
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),

//                         const SizedBox(height: 24),

//                         // 🏪 부대시설
//                         _buildDetailSectionHeader(
//                           "부대시설",
//                           Icons.store_rounded,
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

//   // 🆕 섹션 헤더 (아이콘 포함)
//   Widget _buildDetailSectionHeader(
//     String title,
//     IconData icon,
//     bool isDarkMode,
//   ) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//         ),
//         const SizedBox(width: 8),
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

//   // 나머지 위젯들은 기존 코드 유지...
//   // 🆕 실시간 현황 섹션
//   Widget _buildRealtimeStatusSection(
//     HangangRealtimeData data,
//     List<Color> gradient,
//     bool isDarkMode,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             gradient[0].withValues(alpha: 0.1),
//             gradient[1].withValues(alpha: 0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: gradient[0].withValues(alpha: 0.3),
//           width: 1.5,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: gradient),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.show_chart_rounded,
//                   size: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 "실시간 현황",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: gradient[0].withValues(alpha: 0.15),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "5분 전",
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: gradient[0],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // 인구
//           if (data.population != null)
//             _buildRealtimeItem(
//               icon: Icons.people_rounded,
//               label: "현재 인구",
//               value: "${data.population!.estimatedPopulation}명",
//               subValue: data.population!.congestLevel,
//               gradient: gradient,
//               isDarkMode: isDarkMode,
//             ),

//           const SizedBox(height: 12),

//           // 따릉이
//           if (data.bikeStations.isNotEmpty)
//             _buildRealtimeItem(
//               icon: Icons.pedal_bike_rounded,
//               label: "따릉이",
//               value: "${data.bikeStations.length}개소",
//               subValue:
//                   "${data.bikeStations.fold<int>(0, (sum, b) => sum + b.available)}대 이용 가능",
//               gradient: gradient,
//               isDarkMode: isDarkMode,
//             ),

//           const SizedBox(height: 12),

//           // 주차
//           if (data.parkingLots.isNotEmpty)
//             _buildRealtimeItem(
//               icon: Icons.local_parking_rounded,
//               label: "주차",
//               value:
//                   "${data.parkingLots.fold<int>(0, (sum, p) => sum + p.available)}면",
//               subValue:
//                   "총 ${data.parkingLots.fold<int>(0, (sum, p) => sum + p.total)}면 중 가능",
//               gradient: gradient,
//               isDarkMode: isDarkMode,
//             ),
//         ],
//       ),
//     );
//   }

//   // 🆕 실시간 항목 위젯
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
//                 : Colors.white.withValues(alpha: 0.7),
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

//   // 🆕 로딩 상태
//   Widget _buildLoadingStatus(List<Color> gradient, bool isDarkMode) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.white.withValues(alpha: 0.05)
//             : Colors.white.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 16,
//             height: 16,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               valueColor: AlwaysStoppedAnimation(gradient[0]),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             "실시간 정보 불러오는 중...",
//             style: TextStyle(
//               fontSize: 13,
//               color: isDarkMode
//                   ? Colors.white.withValues(alpha: 0.6)
//                   : SeoulColors.seoulBlue.withValues(alpha: 0.6),
//             ),
//           ),
//         ],
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
//             ? Colors.white.withValues(alpha: 0.05)
//             : SeoulColors.lightGray.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: gradient[0].withValues(alpha: 0.2)),
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

//   void _showDetailSheet(BuildContext context, DockInfo dock, bool isDarkMode) {
//     final gradient = isDarkMode ? dock.gradientDark : dock.gradientLight;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.8,
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
//                           "${dock.name} 선착장",
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
//                         _buildDetailSection(
//                           title: "접근 수단",
//                           isDarkMode: isDarkMode,
//                         ),
//                         _buildDetailItem(
//                           icon: Icons.subway_rounded,
//                           title: "지하철",
//                           content:
//                               "${dock.nearestSubway} 도보 ${dock.subwayWalkTime}분",
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),
//                         _buildDetailItem(
//                           icon: Icons.directions_bus_rounded,
//                           title: "버스",
//                           content: dock.busRoutes.join(", "),
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),

//                         const SizedBox(height: 24),

//                         _buildDetailSection(
//                           title: "주차 정보",
//                           isDarkMode: isDarkMode,
//                         ),
//                         _buildDetailItem(
//                           icon: Icons.local_parking_rounded,
//                           title: "주차장",
//                           content:
//                               "${dock.parkingName}\n${dock.parkingSpaces}면 · 5분당 400원",
//                           gradient: gradient,
//                           isDarkMode: isDarkMode,
//                         ),

//                         if (dock.hasShuttle) ...[
//                           const SizedBox(height: 24),
//                           _buildDetailSection(
//                             title: "무료 셔틀버스",
//                             isDarkMode: isDarkMode,
//                           ),
//                           _buildDetailItem(
//                             icon: Icons.airport_shuttle_rounded,
//                             title: "운행 정보",
//                             content: dock.shuttleInfo ?? "",
//                             gradient: gradient,
//                             isDarkMode: isDarkMode,
//                           ),
//                         ],

//                         const SizedBox(height: 24),

//                         _buildDetailSection(
//                           title: "부대시설",
//                           isDarkMode: isDarkMode,
//                         ),
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
//                                 gradient: LinearGradient(
//                                   colors: gradient
//                                       .map((c) => c.withValues(alpha: 0.15))
//                                       .toList(),
//                                 ),
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

//   Widget _buildDetailSection({
//     required String title,
//     required bool isDarkMode,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w800,
//           color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem({
//     required IconData icon,
//     required String title,
//     required String content,
//     required List<Color> gradient,
//     required bool isDarkMode,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.white.withValues(alpha: 0.05)
//             : SeoulColors.lightGray.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: gradient[0].withValues(alpha: 0.2)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: gradient),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 24, color: Colors.white),
//           ),
//           const SizedBox(width: 16),
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
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   content,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isDarkMode
//                         ? Colors.white.withValues(alpha: 0.7)
//                         : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//                     height: 1.5,
//                   ),
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

//   String _getStatusText(OperationStatus status) {
//     switch (status) {
//       case OperationStatus.normal:
//         return "정상 운행";
//       case OperationStatus.partial:
//         return "일부 중단";
//       case OperationStatus.stopped:
//         return "전면 중단";
//     }
//   }

//   List<Color> _getCurrentGradient(bool isDarkMode) {
//     return isDarkMode
//         ? _docks[_currentDockIndex].gradientDark
//         : _docks[_currentDockIndex].gradientLight;
//   }

//   List<Color> _getGradientForDock(int index, bool isDarkMode) {
//     return isDarkMode
//         ? _docks[index].gradientDark
//         : _docks[index].gradientLight;
//   }

//   // 🆕 날씨 상세 항목
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
//             ? Colors.white.withValues(alpha: 0.05)
//             : Colors.white.withValues(alpha: 0.5),
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

//   // 🆕 24시간 예보 섹션
//   Widget _buildHourlyForecastSection(
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
//   ) {
//     // 처음 4개만 표시 (12시간)
//     final displayForecasts = weather.hourlyForecasts.take(4).toList();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Colors.white.withValues(alpha: 0.05)
//             : Colors.white.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: gradient[0].withValues(alpha: 0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 헤더
//           Row(
//             children: [
//               Icon(Icons.schedule_rounded, size: 18, color: gradient[0]),
//               const SizedBox(width: 8),
//               Text(
//                 "시간별 예보",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // 시간별 예보 리스트
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
//                       "${forecast.temperature.toInt()}°",
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
//                           "${forecast.precipitationProbability}%",
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

//           // 더보기 버튼
//           if (weather.hourlyForecasts.length > 4)
//             GestureDetector(
//               onTap: () {
//                 _showFullWeatherForecast(
//                   context,
//                   weather,
//                   gradient,
//                   isDarkMode,
//                 );
//               },
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
//                       "24시간 예보 전체보기",
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

//   // 🆕 전체 날씨 예보 바텀시트
//   void _showFullWeatherForecast(
//     BuildContext context,
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
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
//                         child: const Text(
//                           "24시간 날씨 예보",
//                           style: TextStyle(
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
//                                     "${forecast.temperature.toInt()}°C",
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
//                                     "${forecast.precipitationProbability}%",
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

//   // 🆕 현재 날씨 섹션
//   Widget _buildCurrentWeatherSection(
//     WeatherData weather,
//     List<Color> gradient,
//     bool isDarkMode,
//   ) {
//     final current = weather.current;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             gradient[0].withValues(alpha: 0.08),
//             gradient[1].withValues(alpha: 0.04),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: gradient[0].withValues(alpha: 0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 헤더
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: gradient),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.wb_sunny_rounded,
//                   size: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 "현재 날씨",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   color: isDarkMode ? Colors.white : SeoulColors.seoulBlue,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // 메인 온도 + 날씨 아이콘
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(current.weatherIcon, style: const TextStyle(fontSize: 48)),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ShaderMask(
//                           shaderCallback: (bounds) => LinearGradient(
//                             colors: gradient,
//                           ).createShader(bounds),
//                           child: Text(
//                             "${current.temperature.toInt()}°",
//                             style: const TextStyle(
//                               fontSize: 48,
//                               fontWeight: FontWeight.w900,
//                               color: Colors.white,
//                               height: 1,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 current.skyStatus,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                   color: isDarkMode
//                                       ? Colors.white
//                                       : SeoulColors.seoulBlue,
//                                 ),
//                               ),
//                               Text(
//                                 "체감 ${current.sensoryTemp}°",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: isDarkMode
//                                       ? Colors.white.withValues(alpha: 0.6)
//                                       : SeoulColors.seoulBlue.withValues(
//                                           alpha: 0.6,
//                                         ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // 상세 정보 그리드
//           Row(
//             children: [
//               Expanded(
//                 child: _buildWeatherDetailItem(
//                   icon: Icons.water_drop_outlined,
//                   label: "습도",
//                   value: "${current.humidity.toInt()}%",
//                   gradient: gradient,
//                   isDarkMode: isDarkMode,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildWeatherDetailItem(
//                   icon: Icons.air_rounded,
//                   label: "풍속",
//                   value: "${current.windSpeed}m/s",
//                   gradient: gradient,
//                   isDarkMode: isDarkMode,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // 미세먼지
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
//                         "미세먼지",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: isDarkMode
//                               ? Colors.white.withValues(alpha: 0.6)
//                               : SeoulColors.seoulBlue.withValues(alpha: 0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         "${current.pm10Level} (${current.pm10}㎍/㎥)",
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
// }

// // 데이터 모델
// class DockInfo {
//   final String name;
//   final String nameEn;
//   final String nextDeparture;
//   final int minutesLeft;
//   final int weatherTemp;
//   final String weatherIcon;
//   final String weatherDesc;
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
//     required this.weatherTemp,
//     required this.weatherIcon,
//     required this.weatherDesc,
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
