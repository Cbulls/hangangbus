part of 'clock_bloc.dart';

sealed class ClockEvent extends Equatable {
  const ClockEvent();

  @override
  List<Object?> get props => [];
}

/// 시계 틱 구독을 시작한다.
class ClockStarted extends ClockEvent {
  const ClockStarted();
}
