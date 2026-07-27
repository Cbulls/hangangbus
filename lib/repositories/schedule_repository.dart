import 'package:hangangbus/models/dock_type.dart';
import 'package:hangangbus/utils/schedule_utils.dart';

/// 운항 시간표 계산 저장소. 순수 정적 [ScheduleUtils] 를 감싼다.
class ScheduleRepository {
  const ScheduleRepository();

  List<DockType> get docks => ScheduleUtils.docks;

  List<ScheduleDirection> directionsForDock(DockType dock) =>
      ScheduleUtils.getDirectionsForDock(dock);

  List<String> scheduleByDirection(
    DockType dock,
    ScheduleDirection direction,
  ) => ScheduleUtils.getDockScheduleByDirection(dock, direction);

  String? nextDepartureByDirection(
    DockType dock,
    ScheduleDirection direction,
  ) => ScheduleUtils.getNextDepartureByDirection(dock, direction);

  String? firstDeparture(DockType dock, ScheduleDirection direction) =>
      ScheduleUtils.getFirstDeparture(dock, direction);

  String? lastDeparture(DockType dock, ScheduleDirection direction) =>
      ScheduleUtils.getLastDeparture(dock, direction);

  /// 선택 선착장의 오늘 총 운항 횟수(모든 방향 합). 시간표 기반 실측값.
  int todayTripCount(DockType dock) {
    var count = 0;
    for (final direction in ScheduleUtils.getDirectionsForDock(dock)) {
      count += ScheduleUtils.getDockScheduleByDirection(dock, direction).length;
    }
    return count;
  }

  String? nextDepartureForDock(DockType dock) =>
      ScheduleUtils.getNextDepartureForDock(dock);

  int? minutesUntilNextForDock(DockType dock) =>
      ScheduleUtils.getMinutesUntilNextForDock(dock);

  String dockNameEn(DockType dock) => ScheduleUtils.dockNameEn(dock);
}
