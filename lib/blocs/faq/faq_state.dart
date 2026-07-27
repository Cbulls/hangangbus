part of 'faq_bloc.dart';

class FaqState extends Equatable {
  final int selectedTabIndex;

  const FaqState({this.selectedTabIndex = 0});

  FaqState copyWith({int? selectedTabIndex}) {
    return FaqState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex];
}
