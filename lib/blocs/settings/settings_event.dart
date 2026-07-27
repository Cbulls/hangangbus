part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// 저장된 설정 불러오기 (앱 시작 시 1회).
class SettingsLoaded extends SettingsEvent {
  const SettingsLoaded();
}

/// 글씨 크기 단계 변경.
class TextScaleChanged extends SettingsEvent {
  final TextScaleLevel level;
  const TextScaleChanged(this.level);

  @override
  List<Object?> get props => [level];
}
