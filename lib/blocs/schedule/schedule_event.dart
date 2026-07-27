part of 'schedule_bloc.dart';

sealed class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// 선착장 선택(인덱스는 ScheduleUtils.docks 순서 기준).
class ScheduleDockSelected extends ScheduleEvent {
  final int index;

  const ScheduleDockSelected(this.index);

  @override
  List<Object?> get props => [index];
}

/// 운항 방향 선택.
class ScheduleDirectionSelected extends ScheduleEvent {
  final ScheduleDirection direction;

  const ScheduleDirectionSelected(this.direction);

  @override
  List<Object?> get props => [direction];
}
