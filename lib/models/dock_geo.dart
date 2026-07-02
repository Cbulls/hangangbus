// models/dock_geo.dart
//
// 선착장별 좌표 + 서울시 실시간 도시데이터(citydata) API 장소명 매핑.
// 인근 따릉이/주차장 "최근접 탐색"의 기준점으로 사용한다.
//
// 주의: 지도 표시용 DockLocation(name/position/color/address)과는 별개 클래스다.
//       (이름 충돌을 피하려고 DockGeo 로 분리)
//
// - apiAreaName 이 null 인 선착장(압구정·옥수·서울숲)은 대응 citydata 장소가
//   없어 실시간 데이터를 제공하지 않는다 → UI 에서 "정보 없음" 처리.

import 'package:hangangbus/models/dock_type.dart';

class DockGeo {
  final DockType type;
  final double lat;
  final double lng;

  /// citydata API 호출에 사용하는 장소명. null 이면 실시간 데이터 없음.
  final String? apiAreaName;

  const DockGeo({
    required this.type,
    required this.lat,
    required this.lng,
    required this.apiAreaName,
  });

  bool get hasRealtime => apiAreaName != null;

  static const Map<DockType, DockGeo> _byType = {
    DockType.magok: DockGeo(
      type: DockType.magok,
      lat: 37.5746203,
      lng: 126.844138,
      apiAreaName: '마곡나루역',
    ),
    DockType.mangwon: DockGeo(
      type: DockType.mangwon,
      lat: 37.5546432,
      lng: 126.8943235,
      apiAreaName: '망원한강공원',
    ),
    DockType.yeouido: DockGeo(
      type: DockType.yeouido,
      lat: 37.5283613,
      lng: 126.9351477,
      apiAreaName: '여의도한강공원',
    ),
    DockType.apgujeong: DockGeo(
      type: DockType.apgujeong,
      lat: 37.526686379656766,
      lng: 127.01647963172924,
      apiAreaName: '잠원한강공원',
    ),
    DockType.oksu: DockGeo(
      type: DockType.oksu,
      lat: 37.53887583066939,
      lng: 127.01780841215633,
      apiAreaName: null,
    ),
    DockType.ttukseom: DockGeo(
      type: DockType.ttukseom,
      lat: 37.5286586,
      lng: 127.0666088,
      apiAreaName: '뚝섬한강공원',
    ),
    DockType.jamsil: DockGeo(
      type: DockType.jamsil,
      lat: 37.5186011,
      lng: 127.0846993,
      apiAreaName: '잠실한강공원',
    ),
    DockType.seoulforest: DockGeo(
      type: DockType.seoulforest,
      lat: 37.53776088589692,
      lng: 127.04111182474081,
      apiAreaName: '서울숲공원', // 전용 citydata 장소 없음 (임시 선착장)
    ),
  };

  static DockGeo of(DockType type) => _byType[type]!;

  static DockGeo? byApiAreaName(String areaName) {
    for (final g in _byType.values) {
      if (g.apiAreaName == areaName) return g;
    }
    return null;
  }
}
