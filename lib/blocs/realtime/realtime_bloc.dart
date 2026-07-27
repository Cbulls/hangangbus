import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hangangbus/models/hangang_realtime_data.dart';
import 'package:hangangbus/repositories/realtime_repository.dart';

part 'realtime_event.dart';
part 'realtime_state.dart';

/// 한강공원별 실시간 도시데이터(인구/따릉이/주차)를 관리한다.
/// 기존 _Tab1HomeState._realtimeData / _realtimeDataTimer / _fetchRealtimeData 대체.
class RealtimeBloc extends Bloc<RealtimeEvent, RealtimeState> {
  RealtimeBloc(this._repo) : super(const RealtimeState()) {
    on<RealtimeSubscriptionRequested>(_onSubscription);
    on<RealtimeRefreshRequested>(_onRefresh);
  }

  final RealtimeRepository _repo;
  Timer? _timer;

  static const List<String> _parks = [
    '서울식물원·마곡나루역',
    '망원한강공원',
    '여의도한강공원',
    '뚝섬한강공원',
    '잠실한강공원',
  ];

  Future<void> _onSubscription(
    RealtimeSubscriptionRequested event,
    Emitter<RealtimeState> emit,
  ) async {
    _timer ??= Timer.periodic(
      const Duration(minutes: 5),
      (_) => add(const RealtimeRefreshRequested()),
    );
    await _load(emit);
  }

  Future<void> _onRefresh(
    RealtimeRefreshRequested event,
    Emitter<RealtimeState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<RealtimeState> emit) async {
    // 이미 캐시된 데이터가 있으면 loading 으로 깜빡이지 않게 하여
    // 새로고침당 불필요한 전체 리빌드를 줄인다.
    if (state.dataByPark.isEmpty) {
      emit(state.copyWith(status: RealtimeStatus.loading));
    }
    final map = await _repo.fetchMany(_parks);
    emit(
      state.copyWith(
        status: map.isNotEmpty
            ? RealtimeStatus.success
            : RealtimeStatus.failure,
        dataByPark: {...state.dataByPark, ...map},
        lastUpdated: map.isNotEmpty ? DateTime.now() : null,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
