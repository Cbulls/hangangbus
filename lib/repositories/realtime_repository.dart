import 'package:hangangbus/models/hangang_realtime_data.dart';
import 'package:hangangbus/services/seoul_api_service.dart';

/// 한강공원 실시간 도시데이터(인구/따릉이/주차) 접근 저장소.
/// 기존 정적 [SeoulApiService] 를 감싼다.
class RealtimeRepository {
  const RealtimeRepository();

  /// 단일 공원의 실시간 데이터 조회. 데이터가 없으면 null.
  Future<HangangRealtimeData?> fetch(String areaName) async {
    final result = await SeoulApiService.getCompleteData(areaName);
    return result['realtime'] as HangangRealtimeData?;
  }

  /// 여러 공원의 실시간 데이터를 순차 조회한다.
  /// 서울시 API 초당 호출 제한을 피하기 위해 호출 사이 200ms 지연을 둔다.
  Future<Map<String, HangangRealtimeData>> fetchMany(
    List<String> areaNames,
  ) async {
    final map = <String, HangangRealtimeData>{};
    for (var i = 0; i < areaNames.length; i++) {
      final data = await fetch(areaNames[i]);
      if (data != null) map[areaNames[i]] = data;
      if (i < areaNames.length - 1) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
    return map;
  }
}
