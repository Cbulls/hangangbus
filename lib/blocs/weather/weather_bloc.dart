import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hangangbus/repositories/weather_repository.dart';
import 'package:hangangbus/models/weather_data.dart';

part 'weather_event.dart';
part 'weather_state.dart';

/// 한강공원별 날씨 데이터를 관리한다.
/// 기존 _Tab1HomeState._fetchWeather / _weatherTimer / _weatherLoading 대체.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this._repo) : super(const WeatherState()) {
    on<WeatherSubscriptionRequested>(_onSubscription);
    on<WeatherRefreshRequested>(_onRefresh);
  }

  final WeatherRepository _repo;
  Timer? _timer;

  static const String _primaryPark = '마곡나루역';
  static const List<String> _parks = [
    _primaryPark,
    '망원한강공원',
    '여의도한강공원',
    '뚝섬한강공원',
    '잠실한강공원',
  ];

  Future<void> _onSubscription(
    WeatherSubscriptionRequested event,
    Emitter<WeatherState> emit,
  ) async {
    _timer ??= Timer.periodic(
      const Duration(minutes: 10),
      (_) => add(const WeatherRefreshRequested()),
    );
    await _load(emit);
  }

  Future<void> _onRefresh(
    WeatherRefreshRequested event,
    Emitter<WeatherState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<WeatherState> emit) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    // 1) 키 없는 fallback 으로 즉시 기온 표시
    final quick = await _repo.fetchFallback();
    if (quick != null) {
      emit(
        state.copyWith(
          status: WeatherStatus.success,
          weatherByPark: {
            ...state.weatherByPark,
            _primaryPark: quick,
            '여의도한강공원': quick,
          },
        ),
      );
    }

    // 2) 주 공원(마곡) 정식 데이터
    final primary = await _repo.fetch(_primaryPark);
    if (primary != null) {
      emit(
        state.copyWith(
          status: WeatherStatus.success,
          weatherByPark: {
            ...state.weatherByPark,
            _primaryPark: primary,
            '여의도한강공원': primary,
          },
        ),
      );
    }

    // 3) 나머지 공원 순차 갱신
    for (final park in _parks.where((p) => p != _primaryPark)) {
      final weather = await _repo.fetch(park);
      if (weather != null) {
        emit(
          state.copyWith(
            weatherByPark: {...state.weatherByPark, park: weather},
          ),
        );
      }
    }

    if (state.status != WeatherStatus.success) {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
