part of 'story_bloc.dart';

class StoryState extends Equatable {
  final int selectedDockIndex;
  final int selectedCategoryIndex;

  const StoryState({
    this.selectedDockIndex = 0,
    this.selectedCategoryIndex = 0,
  });

  StoryState copyWith({int? selectedDockIndex, int? selectedCategoryIndex}) {
    return StoryState(
      selectedDockIndex: selectedDockIndex ?? this.selectedDockIndex,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props => [selectedDockIndex, selectedCategoryIndex];
}
