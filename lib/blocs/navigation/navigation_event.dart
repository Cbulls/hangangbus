part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

/// 특정 인덱스의 탭으로 전환한다.
class NavTabSelected extends NavigationEvent {
  final int index;

  const NavTabSelected(this.index);

  @override
  List<Object?> get props => [index];
}
