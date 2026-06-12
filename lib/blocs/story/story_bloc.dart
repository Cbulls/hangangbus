import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'story_event.dart';
part 'story_state.dart';

/// 스토리 탭의 선착장/카테고리 선택 인덱스를 관리한다.
/// 기존 _Tab3StoryState._selectedDockIndex / _selectedCategoryIndex 대체.
class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(const StoryState()) {
    on<StoryDockSelected>(_onDockSelected);
    on<StoryCategorySelected>(_onCategorySelected);
  }

  void _onDockSelected(StoryDockSelected event, Emitter<StoryState> emit) {
    emit(state.copyWith(selectedDockIndex: event.index));
  }

  void _onCategorySelected(
    StoryCategorySelected event,
    Emitter<StoryState> emit,
  ) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
  }
}
