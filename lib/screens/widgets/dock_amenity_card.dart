// screens/widgets/dock_amenity_card.dart
//
// 선착장 1곳 기준 "가장 가까운 따릉이 1곳 + 가장 가까운 주차장 1곳"을
// 거리와 함께 보여주는 카드 위젯.
//
// - 최근접 탐색 기준점: DockGeo.of(dockType) 의 좌표
// - apiAreaName 이 없는 선착장(압구정·옥수·서울숲)은 "정보 없음" 표시
// - 영어/한글은 AppLocalizations.localeName 으로 분기

import 'package:flutter/material.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/models/dock_geo.dart';
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

  bool _isEn(BuildContext context) {
    final name = AppLocalizations.of(context)?.localeName ?? 'ko';
    return !name.toLowerCase().startsWith('ko');
  }

  @override
  Widget build(BuildContext context) {
    final en = _isEn(context);
    final loc = DockGeo.of(dockType);

    final bikeTitle = en ? 'Nearby Bike' : '가까운 따릉이';
    final parkTitle = en ? 'Nearby Parking' : '가까운 주차장';

    // 실시간 미지원 선착장 → 안내만
    if (!loc.hasRealtime || data == null) {
      return Column(
        children: [
          _amenityTile(
            icon: Icons.pedal_bike_rounded,
            title: bikeTitle,
            valueWidget: _unavailableText(en),
            distanceText: null,
          ),
          const SizedBox(height: 10),
          _amenityTile(
            icon: Icons.local_parking_rounded,
            title: parkTitle,
            valueWidget: _unavailableText(en),
            distanceText: null,
          ),
        ],
      );
    }

    final bike = data!.nearestBikeStation(loc.lat, loc.lng);
    final parking = data!.nearestParkingLot(loc.lat, loc.lng);

    return Column(
      children: [
        _buildBikeTile(en, loc, bike, bikeTitle),
        const SizedBox(height: 10),
        _buildParkingTile(en, loc, parking, parkTitle),
      ],
    );
  }

  // ── 따릉이 타일 ──────────────────────────────────────────────
  Widget _buildBikeTile(bool en, DockGeo loc, BikeStation? bike, String title) {
    if (bike == null) {
      return _amenityTile(
        icon: Icons.pedal_bike_rounded,
        title: title,
        valueWidget: _unavailableText(en),
        distanceText: null,
      );
    }
    final dist = HangangRealtimeData.distanceMeters(
      loc.lat,
      loc.lng,
      bike.lat,
      bike.lng,
    );
    final countText = en ? '${bike.available}' : '${bike.available}대';
    final rateText = en
        ? 'Avail ${bike.availabilityRate.toStringAsFixed(0)}%'
        : '거치율 ${bike.availabilityRate.toStringAsFixed(0)}%';

    return _amenityTile(
      icon: Icons.pedal_bike_rounded,
      title: title,
      subtitle: _cleanBikeName(bike.name),
      valueWidget: _valueColumn(primary: countText, secondary: rateText),
      distanceText: _distanceLabel(dist),
    );
  }

  // ── 주차장 타일 ──────────────────────────────────────────────
  Widget _buildParkingTile(
    bool en,
    DockGeo loc,
    ParkingLot? parking,
    String title,
  ) {
    if (parking == null) {
      return _amenityTile(
        icon: Icons.local_parking_rounded,
        title: title,
        valueWidget: _unavailableText(en),
        distanceText: null,
      );
    }
    final dist = HangangRealtimeData.distanceMeters(
      loc.lat,
      loc.lng,
      parking.lat,
      parking.lng,
    );

    final available = parking.availableCount;
    final occ = parking.occupancyRate;

    Widget valueWidget;
    if (available == null) {
      valueWidget = _valueColumn(
        primary: en ? '${parking.capacity} total' : '총 ${parking.capacity}면',
        secondary: en ? 'No live data' : '실시간 정보 없음',
        primaryFontSize: 14,
      );
    } else {
      final primary = en ? 'Open $available' : '가능 $available';
      final secondary = en
          ? '/ ${parking.capacity} · ${parking.baseRateText}'
          : '/ ${parking.capacity}면 · ${parking.baseRateText}';
      valueWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _occupancyColor(occ),
                ),
              ),
              Text(
                primary,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: isDarkMode ? Colors.white : gradient[0],
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            secondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
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
      title: title,
      subtitle: parking.name,
      valueWidget: valueWidget,
      distanceText: _distanceLabel(dist),
    );
  }

  // ── 값 컬럼(따릉이/주차 공통) ────────────────────────────────
  Widget _valueColumn({
    required String primary,
    required String secondary,
    double primaryFontSize = 16,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primary,
          style: TextStyle(
            fontSize: primaryFontSize,
            fontWeight: FontWeight.w900,
            color: isDarkMode ? Colors.white : gradient[0],
          ),
        ),
        const SizedBox(height: 1),
        Text(
          secondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.6)
                : _seoulBlue.withValues(alpha: 0.6),
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(12),
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
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: gradient[0].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: gradient[0]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.85)
                              : _seoulBlue.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    if (distanceText != null) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: gradient[0].withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          distanceText,
                          style: TextStyle(
                            fontSize: 9,
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
                      fontSize: 10,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.55)
                          : _seoulBlue.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          valueWidget,
        ],
      ),
    );
  }

  Widget _unavailableText(bool en) => Text(
    en ? 'No data' : '정보 없음',
    style: TextStyle(
      fontSize: 12,
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
    if (occ >= 95) return const Color(0xFFE53935);
    if (occ >= 70) return const Color(0xFFFFC107);
    return const Color(0xFF00C853);
  }

  /// "260. 여의도 마리나선착장 앞" → "여의도 마리나선착장 앞"
  String _cleanBikeName(String raw) {
    final idx = raw.indexOf('. ');
    if (idx > 0 && idx <= 5) return raw.substring(idx + 2);
    return raw;
  }
}
