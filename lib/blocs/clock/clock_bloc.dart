import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'clock_event.dart';
part 'clock_state.dart';

/// 1초 간격으로 현재 시각을 방출하는 공용 시계 Bloc.
/// tab1(카운트다운)과 tab2(다음 배 계산)에서 공유한다.
class ClockBloc extends Bloc<ClockEvent, ClockState> {
  ClockBloc() : super(ClockState(DateTime.now())) {
    on<ClockStarted>(_onStarted);
  }

  Future<void> _onStarted(ClockStarted event, Emitter<ClockState> emit) {
    return emit.forEach<DateTime>(
      Stream<DateTime>.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      onData: (now) => ClockState(now),
    );
  }
}
