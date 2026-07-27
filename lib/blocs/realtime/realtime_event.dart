part of 'realtime_bloc.dart';

sealed class RealtimeEvent extends Equatable {
  const RealtimeEvent();

  @override
  List<Object?> get props => [];
}

/// 실시간 데이터 구독 시작(최초 로드 + 5분 주기 갱신 타이머 시작).
class RealtimeSubscriptionRequested extends RealtimeEvent {
  const RealtimeSubscriptionRequested();
}

/// 수동/주기 갱신 요청.
class RealtimeRefreshRequested extends RealtimeEvent {
  const RealtimeRefreshRequested();
}
