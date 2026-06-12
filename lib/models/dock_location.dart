// models/dock_location.dart
//
// 한강버스 7개 선착장의 공식 좌표와, 서울시 실시간 도시데이터(citydata) API
// 장소명(area name) 매핑을 정의한다.
//
// - apiAreaName 이 null 인 선착장(압구정·옥수)은 대응하는 citydata 장소가 없어
//   실시간 주차장/따릉이 데이터를 제공하지 않는다 → UI 에서 "정보 없음" 처리.
// - 좌표는 선착장 인근 따릉이/주차장 중 "가장 가까운" 1곳을 고르는 최근접 탐색의
//   기준점으로 사용한다.

import 'package:hangangbus/models/dock_type.dart';

class DockLocation {
  final DockType type;
  final double lat;
  final double lng;

  /// citydata API 호출에 사용하는 장소명. null 이면 실시간 데이터 없음.
  final String? apiAreaName;

  const DockLocation({
    required this.type,
    required this.lat,
    required this.lng,
    required this.apiAreaName,
  });

  bool get hasRealtime => apiAreaName != null;

  static const Map<DockType, DockLocation> _byType = {
    DockType.magok: DockLocation(
      type: DockType.magok,
      lat: 37.5746203,
      lng: 126.844138,
      apiAreaName: '마곡나루역',
    ),
    DockType.mangwon: DockLocation(
      type: DockType.mangwon,
      lat: 37.5546432,
      lng: 126.8943235,
      apiAreaName: '망원한강공원',
    ),
    DockType.yeouido: DockLocation(
      type: DockType.yeouido,
      lat: 37.5283613,
      lng: 126.9351477,
      apiAreaName: '여의도한강공원',
    ),
    DockType.apgujeong: DockLocation(
      type: DockType.apgujeong,
      lat: 37.5265383,
      lng: 127.0166979,
      apiAreaName: null, // 전용 citydata 장소 없음
    ),
    DockType.oksu: DockLocation(
      type: DockType.oksu,
      lat: 37.5389979,
      lng: 127.021159,
      apiAreaName: null, // 전용 citydata 장소 없음
    ),
    DockType.ttukseom: DockLocation(
      type: DockType.ttukseom,
      lat: 37.5286586,
      lng: 127.0666088,
      apiAreaName: '뚝섬한강공원',
    ),
    DockType.jamsil: DockLocation(
      type: DockType.jamsil,
      lat: 37.5186011,
      lng: 127.0846993,
      apiAreaName: '잠실한강공원',
    ),
    DockType.seoulforest: DockLocation(
      type: DockType.seoulforest,
      lat: 37.5365,
      lng: 127.0345,
      apiAreaName: null, // 전용 citydata 장소 없음 (임시 선착장)
    ),
  };

  static DockLocation of(DockType type) => _byType[type]!;

  static DockLocation? byApiAreaName(String areaName) {
    for (final loc in _byType.values) {
      if (loc.apiAreaName == areaName) return loc;
    }
    return null;
  }
}