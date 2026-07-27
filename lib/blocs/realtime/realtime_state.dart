part of 'realtime_bloc.dart';

enum RealtimeStatus { initial, loading, success, failure }

class RealtimeState extends Equatable {
  final RealtimeStatus status;
  final Map<String, HangangRealtimeData> dataByPark;

  /// 마지막으로 데이터를 성공적으로 수신한 시각.
  final DateTime? lastUpdated;

  const RealtimeState({
    this.status = RealtimeStatus.initial,
    this.dataByPark = const {},
    this.lastUpdated,
  });

  HangangRealtimeData? dataFor(String? parkAreaName) {
    if (parkAreaName == null) return null;
    return dataByPark[parkAreaName];
  }

  RealtimeState copyWith({
    RealtimeStatus? status,
    Map<String, HangangRealtimeData>? dataByPark,
    DateTime? lastUpdated,
  }) {
    return RealtimeState(
      status: status ?? this.status,
      dataByPark: dataByPark ?? this.dataByPark,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [status, dataByPark, lastUpdated];
}
