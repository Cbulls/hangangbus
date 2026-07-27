import 'package:hangangbus/models/weather_data.dart';
import 'package:hangangbus/services/weather_service.dart';

/// 날씨 데이터 접근을 담당하는 저장소.
/// 기존 정적 [WeatherService] 를 감싸 Bloc 에 주입 가능한 형태로 제공한다.
class WeatherRepository {
  const WeatherRepository();

  /// 공원 이름으로 날씨 단독 조회 (실패 시 내부적으로 fallback 처리)
  Future<WeatherData?> fetch(String parkAreaName) {
    return WeatherService.fetch(parkAreaName);
  }

  /// 서울시 API 실패 시 사용하는 키 없는 공개 기온 fallback
  Future<WeatherData?> fetchFallback() {
    return WeatherService.fetchSeoulFallback();
  }
}
