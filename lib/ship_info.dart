import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ShipInfo {
  final String id;
  final String name;
  final LatLng currentPosition;
  final String fromDock;
  final String toDock;
  final DateTime departureTime;

  ShipInfo({
    required this.id,
    required this.name,
    required this.currentPosition,
    required this.fromDock,
    required this.toDock,
    required this.departureTime,
  });

  // Mock 데이터
  static ShipInfo getMockShip() {
    return ShipInfo(
      id: 'ship_001',
      name: '한강1호',
      currentPosition: LatLng(37.5350, 126.9150), // 여의도-망원 중간
      fromDock: '여의도',
      toDock: '망원',
      departureTime: DateTime.now().subtract(const Duration(minutes: 10)),
    );
  }
}
