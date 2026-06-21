import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hangangbus/repositories/weather_repository.dart';
import 'package:hangangbus/models/weather_data.dart';
part 'weather_event.dart';
part 'weather_state.dart';

/// 서울 전역 대표 날씨 1건을 관리한다.
///
/// 기존에는 선착장(공원)별로 날씨를 각각 호출해 기온이 관측소마다 1~2도씩
/// 다르게 보였다(같은 서울인데 잠실만 30도 등). 모든 선착장은 같은 서울이므로
/// 대표 날씨 1건만 조회해 전 선착장이 공유한다.
///
/// - API 호출: 대표 장소 1회 (+ 최초 표시용 fallback 1회)
/// - 갱신 주기: 10분 (기온은 1초마다 받을 필요가 없음)
/// - 마지막 성공값 캐시: 갱신 실패해도 직전 값을 유지
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this._repo) : super(const WeatherState()) {
    on<WeatherSubscriptionRequested>(_onSubscription);
    on<WeatherRefreshRequested>(_onRefresh);
  }
  final WeatherRepository _repo;
  Timer? _timer;

  /// 서울 대표 날씨를 가져올 기준 장소.
  static const String _representativePark = '여의도한강공원';

  Future<void> _onSubscription(
    WeatherSubscriptionRequested event,
    Emitter<WeatherState> emit,
  ) async {
    debugPrint('🌦️ [WeatherBloc] 구독 시작됨 (WeatherSubscriptionRequested)');
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
    debugPrint(
      '🌦️ [WeatherBloc] _load 시작 (현재 representative='
      '${state.representative != null ? "있음" : "없음"})',
    );
    // 이미 성공 데이터가 있으면 로딩 표시로 깜빡이지 않게 둔다.
    if (state.representative == null) {
      emit(state.copyWith(status: WeatherStatus.loading));

      // 1) 키 없이 즉시 표시 가능한 fallback 기온 (빠른 첫 화면)
      debugPrint('🌦️ [WeatherBloc] fallback 호출 시도');
      final quick = await _repo.fetchFallback();
      debugPrint(
        '🌦️ [WeatherBloc] fallback 결과: '
        '${quick != null ? "성공 ${quick.current.temperature}°" : "null"}',
      );
      if (quick != null) {
        emit(
          state.copyWith(status: WeatherStatus.success, representative: quick),
        );
      }
    }

    // 2) 서울 대표 장소 정식 데이터로 갱신
    debugPrint('🌦️ [WeatherBloc] 정식 fetch 시도: $_representativePark');
    final primary = await _repo.fetch(_representativePark);
    debugPrint(
      '🌦️ [WeatherBloc] 정식 fetch 결과: '
      '${primary != null ? "성공 ${primary.current.temperature}°" : "null"}',
    );
    if (primary != null) {
      emit(
        state.copyWith(status: WeatherStatus.success, representative: primary),
      );
      return;
    }

    // 3) 정식 데이터 실패 + 캐시도 없으면 실패 처리 (캐시 있으면 유지)
    if (state.representative == null) {
      debugPrint('🌦️ [WeatherBloc] 최종 실패 → status=failure');
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
