import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hangangbus/repositories/schedule_repository.dart';
import 'package:hangangbus/utils/schedule_utils.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

/// 시간표 탭의 선착장/방향 선택 상태를 관리한다.
/// 기존 _Tab2ScheduleState._selectedDockIndex / _selectedDirection 대체.
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc(this._repo) : super(const ScheduleState()) {
    on<ScheduleDockSelected>(_onDockSelected);
    on<ScheduleDirectionSelected>(_onDirectionSelected);
  }

  final ScheduleRepository _repo;

  void _onDockSelected(
    ScheduleDockSelected event,
    Emitter<ScheduleState> emit,
  ) {
    final dock = _repo.docks[event.index];
    final directions = _repo.directionsForDock(dock);
    final direction = directions.contains(state.selectedDirection)
        ? state.selectedDirection
        : directions.first;
    emit(
      state.copyWith(
        selectedDockIndex: event.index,
        selectedDirection: direction,
      ),
    );
  }

  void _onDirectionSelected(
    ScheduleDirectionSelected event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(selectedDirection: event.direction));
  }
}
