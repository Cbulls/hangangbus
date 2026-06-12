part of 'clock_bloc.dart';

class ClockState extends Equatable {
  final DateTime now;

  const ClockState(this.now);

  /// 분 단위(시*60+분)로 환산한 값. 리빌드 최소화용 셀렉터에 사용.
  int get minuteOfDay => now.hour * 60 + now.minute;

  @override
  List<Object?> get props => [now];
}
