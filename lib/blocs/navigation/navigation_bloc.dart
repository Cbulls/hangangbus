import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

/// 하단 네비게이션의 현재 탭 인덱스를 관리한다.
/// 기존 _MainBaseState._currentIndex 및 onNavigateTab 콜백을 대체한다.
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavTabSelected>(_onTabSelected);
  }

  void _onTabSelected(NavTabSelected event, Emitter<NavigationState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
