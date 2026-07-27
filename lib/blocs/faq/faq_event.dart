part of 'faq_bloc.dart';

sealed class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object?> get props => [];
}

/// 상단 탭 선택(0: FAQ, 1: 안전 수칙).
class FaqTabSelected extends FaqEvent {
  final int index;

  const FaqTabSelected(this.index);

  @override
  List<Object?> get props => [index];
}
