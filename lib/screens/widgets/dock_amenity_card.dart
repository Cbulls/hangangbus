// screens/widgets/dock_amenity_card.dart
//
// 선착장 1곳 기준으로 "가장 가까운 따릉이 1곳 + 가장 가까운 주차장 1곳"을
// 거리와 함께 보여주는 카드 위젯.
//
// - 데이터 소스: RealtimeBloc.state.dataFor(apiAreaName)
// - 최근접 탐색 기준점: DockLocation.of(dockType) 의 좌표
// - apiAreaName 이 없는 선착장(압구정·옥수)은 "실시간 정보 없음" 표시

import 'package:flutter/material.dart';
import 'package:hangangbus/models/dock_location.dart';
import 'package:hangangbus/models/dock_type.dart';
import 'package:hangangbus/models/hangang_realtime_data.dart';

class DockAmenityCard extends StatelessWidget {
  final DockType dockType;
  final HangangRealtimeData? data;
  final List<Color> gradient;
  final bool isDarkMode;

  const DockAmenityCard({
    super.key,
    required this.dockType,
    required this.data,
    required this.gradient,
    required this.isDarkMode,
  });

  static const _seoulBlue = Color(0xFF0064B0);

  @override
  Widget build(BuildContext context) {
    final loc = DockLocation.of(dockType);

    // 실시간 미지원 선착장 → 안내만
    if (!loc.hasRealtime || data == null) {
      return Column(
        children: [
          _amenityTile(
            icon: Icons.pedal_bike_rounded,
            title: '가까운 따릉이',
            valueWidget: _unavailableText(),
            distanceText: null,
          ),
          const SizedBox(height: 10),
          _amenityTile(
            icon: Icons.local_parking_rounded,
            title: '가까운 주차장',
            valueWidget: _unavailableText(),
            distanceText: null,
          ),
        ],
      );
    }

    final bike = data!.nearestBikeStation(loc.lat, loc.lng);
    final parking = data!.nearestParkingLot(loc.lat, loc.lng);

    return Column(
      children: [
        _buildBikeTile(loc, bike),
        const SizedBox(height: 10),
        _buildParkingTile(loc, parking),
      ],
    );
  }

  // ── 따릉이 타일 ──────────────────────────────────────────────
  Widget _buildBikeTile(DockLocation loc, BikeStation? bike) {
    if (bike == null) {
      return _amenityTile(
        icon: Icons.pedal_bike_rounded,
        title: '가까운 따릉이',
        valueWidget: _unavailableText(),
        distanceText: null,
      );
    }
    final dist = HangangRealtimeData.distanceMeters(
      loc.lat,
      loc.lng,
      bike.lat,
      bike.lng,
    );
    return _amenityTile(
      icon: Icons.pedal_bike_rounded,
      title: '가까운 따릉이',
      subtitle: _cleanBikeName(bike.name),
      valueWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${bike.available}대',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isDarkMode ? Colors.white : gradient[0],
            ),
          ),
          Text(
            '거치율 ${bike.availabilityRate.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.6)
                  : _seoulBlue.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
      distanceText: _distanceLabel(dist),
    );
  }

  // ── 주차장 타일 ──────────────────────────────────────────────
  Widget _buildParkingTile(DockLocation loc, ParkingLot? parking) {
    if (parking == null) {
      return _amenityTile(
        icon: Icons.local_parking_rounded,
        title: '가까운 주차장',
        valueWidget: _unavailableText(),
        distanceText: null,
      );
    }
    final dist = HangangRealtimeData.distanceMeters(
      loc.lat,
      loc.lng,
      parking.lat,
      parking.lng,
    );

    final available = parking.availableCount; // null = 실시간 미제공
    final occ = parking.occupancyRate;

    Widget valueWidget;
    if (available == null) {
      // 실시간 잔여대수 없음 → 총 면수와 요금만
      valueWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '총 ${parking.capacity}면',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDarkMode ? Colors.white : gradient[0],
            ),
          ),
          Text(
            '실시간 정보 없음',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.4)
                  : _seoulBlue.withValues(alpha: 0.45),
            ),
          ),
        ],
      );
    } else {
      valueWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _occupancyColor(occ),
                ),
              ),
              Text(
                '가능 $available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDarkMode ? Colors.white : gradient[0],
                ),
              ),
            ],
          ),
          Text(
            '/ ${parking.capacity}면 · ${parking.baseRateText}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.6)
                  : _seoulBlue.withValues(alpha: 0.6),
            ),
          ),
        ],
      );
    }

    return _amenityTile(
      icon: Icons.local_parking_rounded,
      title: '가까운 주차장',
      subtitle: _cleanParkingName(parking.name),
      valueWidget: valueWidget,
      distanceText: _distanceLabel(dist),
    );
  }

  // ── 공통 타일 레이아웃 ───────────────────────────────────────
  Widget _amenityTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget valueWidget,
    required String? distanceText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: gradient[0].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: gradient[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.85)
                            : _seoulBlue.withValues(alpha: 0.8),
                      ),
                    ),
                    if (distanceText != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: gradient[0].withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          distanceText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: gradient[0],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.55)
                          : _seoulBlue.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          valueWidget,
        ],
      ),
    );
  }

  Widget _unavailableText() => Text(
        '정보 없음',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.4)
              : _seoulBlue.withValues(alpha: 0.45),
        ),
      );

  // ── 헬퍼 ─────────────────────────────────────────────────────
  String _distanceLabel(double meters) {
    if (meters < 1000) return '${meters.round()}m';
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  Color _occupancyColor(double? occ) {
    if (occ == null) return Colors.grey;
    if (occ >= 95) return const Color(0xFFE53935); // 만차
    if (occ >= 70) return const Color(0xFFFFC107); // 혼잡
    return const Color(0xFF00C853); // 여유
  }

  /// "260. 여의도 마리나선착장 앞" → "여의도 마리나선착장 앞" (앞 번호 제거)
  String _cleanBikeName(String raw) {
    final idx = raw.indexOf('. ');
    if (idx > 0 && idx <= 5) return raw.substring(idx + 2);
    return raw;
  }

  String _cleanParkingName(String raw) => raw;
}