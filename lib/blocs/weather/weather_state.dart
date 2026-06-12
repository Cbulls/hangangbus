part of 'weather_bloc.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Map<String, WeatherData> weatherByPark;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weatherByPark = const {},
  });

  bool get isLoading => status == WeatherStatus.loading;

  /// 공원 이름으로 날씨 조회. 없으면 첫 번째 가용 데이터를 반환.
  WeatherData? weatherFor(String? parkAreaName) {
    if (parkAreaName != null && weatherByPark.containsKey(parkAreaName)) {
      return weatherByPark[parkAreaName];
    }
    return weatherByPark.isNotEmpty ? weatherByPark.values.first : null;
  }

  WeatherState copyWith({
    WeatherStatus? status,
    Map<String, WeatherData>? weatherByPark,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weatherByPark: weatherByPark ?? this.weatherByPark,
    );
  }

  @override
  List<Object?> get props => [status, weatherByPark];
}
