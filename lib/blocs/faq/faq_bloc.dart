import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'faq_event.dart';
part 'faq_state.dart';

/// FAQ 탭의 상단 탭(자주 묻는 질문 / 안전 수칙) 선택 상태를 관리한다.
class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(const FaqState()) {
    on<FaqTabSelected>(_onTabSelected);
  }

  void _onTabSelected(FaqTabSelected event, Emitter<FaqState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }
}
