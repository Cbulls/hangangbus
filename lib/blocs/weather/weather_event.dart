part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// 날씨 구독 시작(최초 로드 + 10분 주기 갱신 타이머 시작).
class WeatherSubscriptionRequested extends WeatherEvent {
  const WeatherSubscriptionRequested();
}

/// 수동/주기 갱신 요청.
class WeatherRefreshRequested extends WeatherEvent {
  const WeatherRefreshRequested();
}
