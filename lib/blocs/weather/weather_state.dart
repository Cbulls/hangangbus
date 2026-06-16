part of 'weather_bloc.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;

  /// 서울 전역 대표 날씨. 모든 선착장이 이 값을 공유한다.
  final WeatherData? representative;

  /// (하위 호환) 공원별 날씨 맵. 현재는 대표값 단일 운영이라 비어 있을 수 있다.
  final Map<String, WeatherData> weatherByPark;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.representative,
    this.weatherByPark = const {},
  });

  bool get isLoading => status == WeatherStatus.loading;

  /// 날씨 조회. 모든 선착장이 동일한 대표값을 받는다.
  /// 대표값이 없을 때만 (구버전 호환) 공원별 맵을 참조한다.
  WeatherData? weatherFor(String? parkAreaName) {
    if (representative != null) return representative;
    if (parkAreaName != null && weatherByPark.containsKey(parkAreaName)) {
      return weatherByPark[parkAreaName];
    }
    return weatherByPark.isNotEmpty ? weatherByPark.values.first : null;
  }

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherData? representative,
    Map<String, WeatherData>? weatherByPark,
  }) {
    return WeatherState(
      status: status ?? this.status,
      representative: representative ?? this.representative,
      weatherByPark: weatherByPark ?? this.weatherByPark,
    );
  }

  @override
  List<Object?> get props => [status, representative, weatherByPark];
}
