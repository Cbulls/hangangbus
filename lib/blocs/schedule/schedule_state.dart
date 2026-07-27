part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final int selectedDockIndex;
  final ScheduleDirection selectedDirection;

  const ScheduleState({
    this.selectedDockIndex = 0,
    this.selectedDirection = ScheduleDirection.toYeouido,
  });

  ScheduleState copyWith({
    int? selectedDockIndex,
    ScheduleDirection? selectedDirection,
  }) {
    return ScheduleState(
      selectedDockIndex: selectedDockIndex ?? this.selectedDockIndex,
      selectedDirection: selectedDirection ?? this.selectedDirection,
    );
  }

  @override
  List<Object?> get props => [selectedDockIndex, selectedDirection];
}
