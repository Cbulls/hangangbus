part of 'story_bloc.dart';

sealed class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object?> get props => [];
}

/// 선착장 탭 선택.
class StoryDockSelected extends StoryEvent {
  final int index;

  const StoryDockSelected(this.index);

  @override
  List<Object?> get props => [index];
}

/// 카테고리(역사/맛집) 탭 선택.
class StoryCategorySelected extends StoryEvent {
  final int index;

  const StoryCategorySelected(this.index);

  @override
  List<Object?> get props => [index];
}
