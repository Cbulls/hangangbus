part of 'settings_bloc.dart';

/// 글씨 크기 단계. 고령층 접근성을 위해 3단계 제공.
/// 너무 크면(2.0+) 레이아웃이 깨지므로 1.6을 상한으로 둔다.
enum TextScaleLevel {
  normal(1.0),
  large(1.3),
  extraLarge(1.6);

  final double scale;
  const TextScaleLevel(this.scale);

  /// 다음 단계로 순환 (normal → large → extraLarge → normal).
  TextScaleLevel get next {
    final values = TextScaleLevel.values;
    return values[(index + 1) % values.length];
  }
}

class SettingsState extends Equatable {
  final TextScaleLevel level;

  const SettingsState({this.level = TextScaleLevel.normal});

  /// MediaQuery.textScaler 에 적용할 배율.
  double get textScale => level.scale;

  /// 큰글씨가 켜진 상태인지(보통보다 큰지).
  bool get isLargeText => level != TextScaleLevel.normal;

  SettingsState copyWith({TextScaleLevel? level}) {
    return SettingsState(level: level ?? this.level);
  }

  @override
  List<Object?> get props => [level];
}
