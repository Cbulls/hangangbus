// live_tracking_map.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

class LiveTrackingMap extends StatefulWidget {
  final String? initialDock;

  const LiveTrackingMap({super.key, this.initialDock});

  @override
  State<LiveTrackingMap> createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<LiveTrackingMap> {
  int _selectedRouteIndex = 0;
  bool _isTrackingMode = true;
  Timer? _updateTimer;

  final List<RouteData> _routes = [
    RouteData(
      id: "6",
      name: "6노선",
      color: const Color(0xFF2196F3),
      stations: [
        StationPoint("여의도", 37.5285, 126.9340),
        StationPoint("망원", 37.5560, 126.8960),
        StationPoint("마곡", 37.5620, 126.8250),
      ],
    ),
    RouteData(
      id: "7",
      name: "7노선",
      color: const Color(0xFF4CAF50),
      stations: [
        StationPoint("옥수", 37.5400, 127.0180),
        StationPoint("뚝섬", 37.5304, 127.0661),
        StationPoint("잠실", 37.5145, 127.0820),
      ],
    ),
    RouteData(
      id: "8",
      name: "8노선",
      color: const Color(0xFFFF9800),
      stations: [
        StationPoint("압구정", 37.5270, 127.0280),
        StationPoint("뚝섬", 37.5304, 127.0661),
        StationPoint("잠실", 37.5145, 127.0820),
      ],
    ),
  ];

  double _boatLat = 37.5350;
  double _boatLng = 126.9600;
  int _animationIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialDock != null) {
      _selectRouteByDock(widget.initialDock!);
    }
    _startAnimation();
  }

  void _selectRouteByDock(String dockName) {
    for (int i = 0; i < _routes.length; i++) {
      if (_routes[i].stations.any((s) => s.name == dockName)) {
        _selectedRouteIndex = i;
        break;
      }
    }
  }

  void _startAnimation() {
    _updateTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final route = _routes[_selectedRouteIndex];
      final stations = route.stations;

      final currentStation = stations[_animationIndex % stations.length];
      final nextStation = stations[(_animationIndex + 1) % stations.length];

      setState(() {
        final progress = (_animationIndex % 10) / 10.0;
        _boatLat =
            currentStation.lat +
            (nextStation.lat - currentStation.lat) * progress;
        _boatLng =
            currentStation.lng +
            (nextStation.lng - currentStation.lng) * progress;
        _animationIndex++;
      });
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final route = _routes[_selectedRouteIndex];

    return Scaffold(
      body: Stack(
        children: [
          // 🔧 지도 배경 (KakaoMap 완전 제거)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [route.color.withOpacity(0.1), const Color(0xFFF5F5F5)],
              ),
            ),
            child: CustomPaint(
              size: Size.infinite,
              painter: SimpleMapPainter(
                stations: route.stations,
                boatLat: _boatLat,
                boatLng: _boatLng,
                routeColor: route.color,
              ),
            ),
          ),

          // 상단 앱바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildGlassButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    _buildGlassContainer(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          "실시간 위치",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildGlassButton(
                      icon: Icons.refresh_rounded,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _animationIndex = 0;
                          _boatLat = route.stations[0].lat;
                          _boatLng = route.stations[0].lng;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 노선 선택 탭
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            right: 16,
            child: _buildGlassContainer(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: List.generate(_routes.length, (index) {
                    final isSelected = _selectedRouteIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRouteIndex = index;
                            _animationIndex = 0;
                            _boatLat = _routes[index].stations[0].lat;
                            _boatLng = _routes[index].stations[0].lng;
                          });
                          HapticFeedback.lightImpact();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _routes[index].color
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _routes[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // 하단 컨트롤
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _isTrackingMode = !_isTrackingMode);
                      HapticFeedback.mediumImpact();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: _isTrackingMode
                            ? LinearGradient(
                                colors: [
                                  route.color,
                                  route.color.withOpacity(0.8),
                                ],
                              )
                            : null,
                        color: _isTrackingMode
                            ? null
                            : Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isTrackingMode
                                ? Icons.gps_fixed_rounded
                                : Icons.gps_not_fixed_rounded,
                            color: _isTrackingMode
                                ? Colors.white
                                : Colors.black87,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isTrackingMode ? "추적 중" : "추적 OFF",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _isTrackingMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 배 정보 카드
          Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: _buildGlassContainer(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [route.color, route.color.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_boat_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "한강버스",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "다음 정류장: ${route.stations[(_animationIndex + 1) % route.stations.length].name}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: route.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "약 8분",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: route.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.black87, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// 간단한 지도 페인터
class SimpleMapPainter extends CustomPainter {
  final List<StationPoint> stations;
  final double boatLat;
  final double boatLng;
  final Color routeColor;

  SimpleMapPainter({
    required this.stations,
    required this.boatLat,
    required this.boatLng,
    required this.routeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset latLngToOffset(double lat, double lng) {
      final minLat = stations.map((s) => s.lat).reduce(math.min) - 0.01;
      final maxLat = stations.map((s) => s.lat).reduce(math.max) + 0.01;
      final minLng = stations.map((s) => s.lng).reduce(math.min) - 0.01;
      final maxLng = stations.map((s) => s.lng).reduce(math.max) + 0.01;

      final x =
          ((lng - minLng) / (maxLng - minLng)) * size.width * 0.8 +
          size.width * 0.1;
      final y =
          size.height -
          (((lat - minLat) / (maxLat - minLat)) * size.height * 0.8 +
              size.height * 0.1);

      return Offset(x, y);
    }

    // 노선 경로
    final pathPaint = Paint()
      ..color = routeColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < stations.length; i++) {
      final offset = latLngToOffset(stations[i].lat, stations[i].lng);
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    canvas.drawPath(path, pathPaint);

    // 정류장 마커
    final stationPaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < stations.length; i++) {
      final offset = latLngToOffset(stations[i].lat, stations[i].lng);
      canvas.drawCircle(offset, 12, stationPaint);
      canvas.drawCircle(
        offset,
        12,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: stations[i].name,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(offset.dx - textPainter.width / 2, offset.dy + 20),
      );
    }

    // 배 마커
    final boatOffset = latLngToOffset(boatLat, boatLng);
    canvas.drawCircle(boatOffset, 16, Paint()..color = const Color(0xFFE53935));
    canvas.drawCircle(
      boatOffset,
      16,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );

    final boatPath = Path();
    boatPath.moveTo(boatOffset.dx, boatOffset.dy - 8);
    boatPath.lineTo(boatOffset.dx + 6, boatOffset.dy + 6);
    boatPath.lineTo(boatOffset.dx - 6, boatOffset.dy + 6);
    boatPath.close();
    canvas.drawPath(boatPath, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(SimpleMapPainter oldDelegate) => true;
}

class RouteData {
  final String id;
  final String name;
  final Color color;
  final List<StationPoint> stations;

  RouteData({
    required this.id,
    required this.name,
    required this.color,
    required this.stations,
  });
}

class StationPoint {
  final String name;
  final double lat;
  final double lng;

  StationPoint(this.name, this.lat, this.lng);
}
