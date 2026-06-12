import 'dart:math';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DistanceCalculator {
  // 평균 속도 (km/h)
  static const double avgSpeed = 11.0;

  // Haversine 공식으로 두 지점 간 거리 계산 (km)
  static double calculateDistance(LatLng start, LatLng end) {
    const R = 6371.0; // 지구 반지름 (km)

    final dLat = _toRadians(end.latitude - start.latitude);
    final dLon = _toRadians(end.longitude - start.longitude);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(start.latitude)) *
            cos(_toRadians(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  // 소요 시간 계산 (분)
  static int calculateDuration(double distanceKm) {
    final hours = distanceKm / avgSpeed;
    return (hours * 60).round();
  }

  // 도착 예정 시간 계산
  static DateTime calculateETA(double distanceKm, DateTime departureTime) {
    final minutes = calculateDuration(distanceKm);
    return departureTime.add(Duration(minutes: minutes));
  }

  // 라디안 변환
  static double _toRadians(double degree) {
    return degree * pi / 180.0;
  }

  // 거리를 읽기 쉬운 형식으로 변환
  static String formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()}m';
    }
    return '${km.toStringAsFixed(1)}km';
  }

  // 시간을 읽기 쉬운 형식으로 변환
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '약 $minutes분';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '약 ${hours}시간 ${mins}분' : '약 ${hours}시간';
  }
}
