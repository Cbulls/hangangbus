// models/hangang_realtime_data.dart
//
// 서울시 실시간 도시데이터 API: CITYDATA 노드 기준
// 실측 응답(2025) 기반 필드 매핑:
//   - 따릉이 : SBIKE_STTS[*]  (SBIKE_SPOT_NM, SBIKE_PARKING_CNT, SBIKE_RACK_CNT, SBIKE_SHARED ...)
//   - 주차장 : PRK_STTS[*]    (PRK_NM, CPCTY, CUR_PRK_CNT, CUR_PRK_YN, RATES ...)

import 'dart:math' as math;

class HangangRealtimeData {
  final String areaName;
  final PopulationData? population;
  final List<BikeStation> bikeStations;
  final List<ParkingLot> parkingLots;

  HangangRealtimeData({
    required this.areaName,
    this.population,
    this.bikeStations = const [],
    this.parkingLots = const [],
  });

  factory HangangRealtimeData.fromJson(
    Map<String, dynamic> json,
    String areaName,
  ) {
    // 실시간 인구
    final populationList = json['LIVE_PPLTN_STTS'] as List?;
    final populationData = populationList != null && populationList.isNotEmpty
        ? PopulationData.fromJson(populationList.first as Map<String, dynamic>)
        : null;

    // 따릉이
    final bikeList = json['SBIKE_STTS'] as List?;
    final bikes = bikeList
            ?.whereType<Map<String, dynamic>>()
            .map(BikeStation.fromJson)
            .toList() ??
        const [];

    // 주차장
    final parkingList = json['PRK_STTS'] as List?;
    final parkings = parkingList
            ?.whereType<Map<String, dynamic>>()
            .map(ParkingLot.fromJson)
            .toList() ??
        const [];

    return HangangRealtimeData(
      areaName: areaName,
      population: populationData,
      bikeStations: bikes,
      parkingLots: parkings,
    );
  }

  /// 부분 문자열로 따릉이 대여소를 찾는다. (예: '여의도 마리나선착장')
  BikeStation? bikeStationContaining(String keyword) {
    for (final s in bikeStations) {
      if (s.name.contains(keyword)) return s;
    }
    return null;
  }

  /// 부분 문자열로 주차장을 찾는다. (예: '여의도한강2주차장')
  ParkingLot? parkingLotContaining(String keyword) {
    for (final p in parkingLots) {
      if (p.name.contains(keyword)) return p;
    }
    return null;
  }

  /// 기준 좌표에서 가장 가까운 따릉이 대여소. 좌표가 유효한 것만 후보로 삼는다.
  BikeStation? nearestBikeStation(double lat, double lng) {
    BikeStation? best;
    double bestDist = double.infinity;
    for (final s in bikeStations) {
      if (s.lat == 0 || s.lng == 0) continue;
      final d = _haversine(lat, lng, s.lat, s.lng);
      if (d < bestDist) {
        bestDist = d;
        best = s;
      }
    }
    return best;
  }

  /// 기준 좌표에서 가장 가까운 주차장.
  ///
  /// 서울시 API 는 같은 주차장을 정적(CUR_PRK_YN='N')·실시간(CUR_PRK_YN='Y')
  /// 두 레코드로 중복 제공한다. 거의 같은 위치(30m 이내)면 동일 주차장으로 보고
  /// 실시간 레코드를 우선 선택한다.
  ParkingLot? nearestParkingLot(double lat, double lng) {
    ParkingLot? best;
    double bestDist = double.infinity;
    for (final p in parkingLots) {
      if (p.lat == 0 || p.lng == 0) continue;
      final d = _haversine(lat, lng, p.lat, p.lng);
      final nearlySame = (d - bestDist).abs() < 30;
      final preferRealtime =
          nearlySame && p.realtimeAvailable && !(best?.realtimeAvailable ?? false);
      if (d < bestDist - 1 || preferRealtime) {
        if (d < bestDist) bestDist = d;
        best = p;
      }
    }
    return best;
  }

  /// 거리(미터) 헬퍼 — 위젯에서 "120m" 표기에 사용.
  static double distanceMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) =>
      _haversine(lat1, lng1, lat2, lng2);
}

/// 두 좌표 사이 거리(미터) — Haversine.
double _haversine(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371000.0; // m
  final dLat = _deg2rad(lat2 - lat1);
  final dLng = _deg2rad(lng2 - lng1);
  final a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
      math.cos(_deg2rad(lat1)) *
          math.cos(_deg2rad(lat2)) *
          (math.sin(dLng / 2) * math.sin(dLng / 2));
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadius * c;
}

double _deg2rad(double deg) => deg * (math.pi / 180.0);

class PopulationData {
  final String currentMin;
  final String currentMax;
  final String congestLevel;
  final String maleRate;
  final String femaleRate;

  PopulationData({
    required this.currentMin,
    required this.currentMax,
    required this.congestLevel,
    required this.maleRate,
    required this.femaleRate,
  });

  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      currentMin: json['AREA_PPLTN_MIN']?.toString() ?? '0',
      currentMax: json['AREA_PPLTN_MAX']?.toString() ?? '0',
      congestLevel: json['AREA_CONGEST_LVL']?.toString() ?? '정보 없음',
      maleRate: json['MALE_PPLTN_RATE']?.toString() ?? '0',
      femaleRate: json['FEMALE_PPLTN_RATE']?.toString() ?? '0',
    );
  }

  String get estimatedPopulation {
    final min = int.tryParse(currentMin) ?? 0;
    final max = int.tryParse(currentMax) ?? 0;
    final avg = ((min + max) / 2).round();
    return avg.toString();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 따릉이 대여소 (SBIKE_STTS)
// ─────────────────────────────────────────────────────────────────────────────
class BikeStation {
  final String id; // SBIKE_SPOT_ID  (예: ST-414)
  final String name; // SBIKE_SPOT_NM  (예: 260. 여의도 마리나선착장 앞)
  final int available; // SBIKE_PARKING_CNT (현재 거치된 따릉이 대수)
  final int rackCount; // SBIKE_RACK_CNT    (거치대 수)
  final double sharePercent; // SBIKE_SHARED      (거치율 %, 원본 값)
  final double lng; // SBIKE_X
  final double lat; // SBIKE_Y

  const BikeStation({
    required this.id,
    required this.name,
    required this.available,
    required this.rackCount,
    required this.sharePercent,
    this.lng = 0,
    this.lat = 0,
  });

  factory BikeStation.fromJson(Map<String, dynamic> json) {
    return BikeStation(
      id: json['SBIKE_SPOT_ID']?.toString() ?? '',
      name: json['SBIKE_SPOT_NM']?.toString() ?? '정보 없음',
      available: _toInt(json['SBIKE_PARKING_CNT']),
      rackCount: _toInt(json['SBIKE_RACK_CNT']),
      sharePercent: _toDouble(json['SBIKE_SHARED']),
      lng: _toDouble(json['SBIKE_X']),
      lat: _toDouble(json['SBIKE_Y']),
    );
  }

  /// 거치율(%). API의 SBIKE_SHARED 를 우선 사용하되,
  /// 값이 없으면 거치 대수/거치대 수로 계산한다.
  double get availabilityRate {
    if (sharePercent > 0) return sharePercent;
    if (rackCount == 0) return 0;
    return (available / rackCount) * 100;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 주차장 (PRK_STTS)
// ─────────────────────────────────────────────────────────────────────────────
class ParkingLot {
  final String code; // PRK_CD
  final String name; // PRK_NM
  final String type; // PRK_TYPE (BP 등)
  final int capacity; // CPCTY        (총 주차면)
  final int? currentCount; // CUR_PRK_CNT  (현재 주차대수, 빈 문자열이면 null)
  final bool realtimeAvailable; // CUR_PRK_YN == 'Y' (실시간 정보 제공 여부)
  final String updatedAt; // CUR_PRK_TIME
  final bool isPaid; // PAY_YN == 'Y'
  final int baseRate; // RATES          (기본요금 원)
  final int baseTimeMinutes; // TIME_RATES     (기본요금 시간 분)
  final int addRate; // ADD_RATES      (추가요금 원)
  final int addTimeMinutes; // ADD_TIME_RATES (추가요금 단위 분)
  final String address; // ADDRESS
  final String roadAddress; // ROAD_ADDR
  final double lng; // LNG
  final double lat; // LAT

  const ParkingLot({
    required this.code,
    required this.name,
    required this.type,
    required this.capacity,
    required this.currentCount,
    required this.realtimeAvailable,
    required this.updatedAt,
    required this.isPaid,
    required this.baseRate,
    required this.baseTimeMinutes,
    required this.addRate,
    required this.addTimeMinutes,
    required this.address,
    required this.roadAddress,
    this.lng = 0,
    this.lat = 0,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    final raw = json['CUR_PRK_CNT']?.toString().trim() ?? '';
    return ParkingLot(
      code: json['PRK_CD']?.toString() ?? '',
      name: json['PRK_NM']?.toString() ?? '정보 없음',
      type: json['PRK_TYPE']?.toString() ?? '',
      capacity: _toInt(json['CPCTY']),
      currentCount: raw.isEmpty ? null : int.tryParse(raw),
      realtimeAvailable: (json['CUR_PRK_YN']?.toString() ?? 'N') == 'Y',
      updatedAt: json['CUR_PRK_TIME']?.toString() ?? '',
      isPaid: (json['PAY_YN']?.toString() ?? 'N') == 'Y',
      baseRate: _toInt(json['RATES']),
      baseTimeMinutes: _toInt(json['TIME_RATES']),
      addRate: _toInt(json['ADD_RATES']),
      addTimeMinutes: _toInt(json['ADD_TIME_RATES']),
      address: json['ADDRESS']?.toString() ?? '',
      roadAddress: json['ROAD_ADDR']?.toString() ?? '',
      lng: _toDouble(json['LNG']),
      lat: _toDouble(json['LAT']),
    );
  }

  /// 표시용 주소 (도로명 우선, 없으면 지번)
  String get displayAddress =>
      roadAddress.isNotEmpty ? roadAddress : address;

  /// 잔여 주차 가능 면수. 실시간 정보가 없으면 null.
  int? get availableCount {
    if (!realtimeAvailable || currentCount == null) return null;
    final remain = capacity - currentCount!;
    return remain < 0 ? 0 : remain;
  }

  /// 점유율(%). 실시간 정보가 없으면 null.
  double? get occupancyRate {
    if (!realtimeAvailable || currentCount == null || capacity == 0) {
      return null;
    }
    return (currentCount! / capacity) * 100;
  }

  /// 요금 안내 문자열 (예: "2,000원 / 30분")
  String get baseRateText =>
      isPaid ? '${_comma(baseRate)}원 / $baseTimeMinutes분' : '무료';

  /// 추가요금 문자열 (예: "300원 / 10분")
  String get addRateText => '${_comma(addRate)}원 / $addTimeMinutes분';
}

// ── 파싱 헬퍼 ────────────────────────────────────────────────────────────────
int _toInt(Object? v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString().trim()) ?? 0;
}

double _toDouble(Object? v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString().trim()) ?? 0;
}

String _comma(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}