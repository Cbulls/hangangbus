import 'package:hangangbus/models/dock_type.dart';

/// 한강버스 시간표 유틸리티
/// 2026.3.1 적용 운항 시간표 기반
enum ScheduleDirection { toYeouido, toMagok, toJamsil }

class ScheduleUtils {
  static const List<DockType> docks = [
    DockType.magok,
    DockType.mangwon,
    DockType.yeouido,
    DockType.apgujeong,
    DockType.oksu,
    DockType.seoulforest,
    DockType.ttukseom,
    DockType.jamsil,
  ];

  static const Map<ScheduleDirection, Map<DockType, List<String>>>
  _departureTimes = {
    ScheduleDirection.toYeouido: {
      DockType.magok: [
        '10:20',
        '11:20',
        '12:20',
        '13:20',
        '14:40',
        '15:40',
        '16:40',
        '17:40',
      ],
      DockType.mangwon: [
        '10:44',
        '11:44',
        '12:44',
        '13:44',
        '15:04',
        '16:04',
        '17:04',
        '18:04',
      ],
      DockType.jamsil: [
        '10:00',
        '11:00',
        '12:00',
        '13:00',
        '14:30',
        '15:30',
        '16:30',
        '17:30',
      ],
      // 서울숲 → 여의도행 (2026.6.8~10.30, 선착장 출발 기준)
      DockType.seoulforest: [
        '11:35',
        '12:35',
        '13:35',
        '14:35',
        '16:05',
        '17:05',
        '18:05',
        '19:05',
      ],
      DockType.ttukseom: [
        '10:18',
        '11:18',
        '12:18',
        '13:18',
        '14:48',
        '15:48',
        '16:48',
        '17:48',
      ],
      DockType.oksu: [
        '10:41',
        '11:41',
        '12:41',
        '13:41',
        '15:11',
        '16:11',
        '17:11',
        '18:11',
      ],
      DockType.apgujeong: [
        '10:53',
        '11:53',
        '12:53',
        '13:53',
        '15:23',
        '16:23',
        '17:23',
        '18:23',
      ],
    },
    ScheduleDirection.toMagok: {
      DockType.yeouido: [
        '11:13',
        '12:13',
        '13:13',
        '14:13',
        '15:48',
        '16:48',
        '17:48',
        '18:48',
      ],
      DockType.mangwon: [
        '11:36',
        '12:36',
        '13:36',
        '14:36',
        '16:11',
        '17:11',
        '18:11',
        '19:11',
      ],
    },
    ScheduleDirection.toJamsil: {
      DockType.yeouido: [
        '11:35',
        '12:35',
        '13:35',
        '14:35',
        '16:05',
        '17:05',
        '18:05',
        '19:05',
      ],
      DockType.apgujeong: [
        '12:07',
        '13:07',
        '14:07',
        '15:07',
        '16:37',
        '17:37',
        '18:37',
        '19:37',
      ],
      DockType.oksu: [
        '12:19',
        '13:19',
        '14:19',
        '15:19',
        '16:49',
        '17:49',
        '18:49',
        '19:49',
      ],
      // 서울숲 → 잠실행 (2026.6.8~10.30, 선착장 출발 기준)
      DockType.seoulforest: [
        '13:27',
        '14:27',
        '15:27',
        '16:27',
        '17:57',
        '18:57',
        '19:57',
        '20:57',
      ],
      DockType.ttukseom: [
        '12:42',
        '13:42',
        '14:42',
        '15:42',
        '17:12',
        '18:12',
        '19:12',
        '20:12',
      ],
    },
  };

  /// 선착장별 출발 시간표 가져오기
  static List<String> getDockSchedule(String dockName) {
    final dock = dockTypeFromName(dockName);
    if (dock == null) return [];

    final List<String> times = [];

    for (final direction in getDirectionsForDock(dock)) {
      times.addAll(getDockScheduleByDirection(dock, direction));
    }

    // 시간순 정렬
    times.sort((a, b) => _parseTime(a).compareTo(_parseTime(b)));

    return times;
  }

  static List<ScheduleDirection> getDirectionsForDock(DockType dock) {
    return ScheduleDirection.values
        .where(
          (direction) => _departureTimes[direction]?.containsKey(dock) ?? false,
        )
        .toList();
  }

  static List<String> getDockScheduleByDirection(
    DockType dock,
    ScheduleDirection direction,
  ) {
    return List.unmodifiable(_departureTimes[direction]?[dock] ?? const []);
  }

  static String? getFirstDeparture(DockType dock, ScheduleDirection direction) {
    final times = getDockScheduleByDirection(dock, direction);
    return times.isEmpty ? null : times.first;
  }

  static String? getLastDeparture(DockType dock, ScheduleDirection direction) {
    final times = getDockScheduleByDirection(dock, direction);
    return times.isEmpty ? null : times.last;
  }

  static String? getNextDepartureByDirection(
    DockType dock,
    ScheduleDirection direction,
  ) {
    final times = getDockScheduleByDirection(dock, direction);
    final now = DateTime.now();

    for (final timeStr in times) {
      final departureTime = _parseTime(timeStr);
      if (departureTime.isAfter(now)) {
        return timeStr;
      }
    }

    return null;
  }

  static int? getMinutesUntilNextByDirection(
    DockType dock,
    ScheduleDirection direction,
  ) {
    final nextTime = getNextDepartureByDirection(dock, direction);
    if (nextTime == null) return null;

    final now = DateTime.now();
    return _parseTime(nextTime).difference(now).inMinutes;
  }

  static String? getNextDepartureForDock(DockType dock) {
    final times = <String>[];
    for (final direction in getDirectionsForDock(dock)) {
      times.addAll(getDockScheduleByDirection(dock, direction));
    }

    times.sort((a, b) => _parseTime(a).compareTo(_parseTime(b)));
    final now = DateTime.now();

    for (final timeStr in times) {
      final departureTime = _parseTime(timeStr);
      if (departureTime.isAfter(now)) {
        return timeStr;
      }
    }

    return null;
  }

  static int? getMinutesUntilNextForDock(DockType dock) {
    final nextTime = getNextDepartureForDock(dock);
    if (nextTime == null) return null;

    final now = DateTime.now();
    final departureTime = _parseTime(nextTime);
    return departureTime.difference(now).inMinutes;
  }

  /// 다음 출발 시간 찾기
  static String? getNextDeparture(String dockName) {
    final dock = dockTypeFromName(dockName);
    if (dock == null) return null;
    return getNextDepartureForDock(dock);
  }

  /// 다음 출발까지 남은 시간 (분)
  static int? getMinutesUntilNext(String dockName) {
    final dock = dockTypeFromName(dockName);
    if (dock == null) return null;
    return getMinutesUntilNextForDock(dock);
  }

  /// 시간 문자열을 DateTime으로 변환
  static DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static int timeToMinutes(String timeStr) {
    final parts = timeStr.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static DockType? dockTypeFromName(String dockName) {
    switch (dockName) {
      case '여의도':
      case 'Yeouido':
        return DockType.yeouido;
      case '망원':
      case 'Mangwon':
        return DockType.mangwon;
      case '마곡':
      case 'Magok':
        return DockType.magok;
      case '압구정':
      case 'Apgujeong':
        return DockType.apgujeong;
      case '옥수':
      case 'Oksu':
        return DockType.oksu;
      case '뚝섬':
      case 'Ttukseom':
        return DockType.ttukseom;
      case '잠실':
      case 'Jamsil':
        return DockType.jamsil;
      case '서울숲':
      case 'Seoul Forest':
      case 'SeoulForest':
        return DockType.seoulforest;
      default:
        return null;
    }
  }

  static String dockNameEn(DockType dock) {
    switch (dock) {
      case DockType.magok:
        return 'Magok';
      case DockType.mangwon:
        return 'Mangwon';
      case DockType.yeouido:
        return 'Yeouido';
      case DockType.apgujeong:
        return 'Apgujeong';
      case DockType.oksu:
        return 'Oksu';
      case DockType.ttukseom:
        return 'Ttukseom';
      case DockType.jamsil:
        return 'Jamsil';
      case DockType.seoulforest:
        return 'SeoulForest';
    }
  }

  /// 시간이 지났는지 확인
  static bool isPastTime(String timeStr) {
    final now = DateTime.now();
    final time = _parseTime(timeStr);
    return time.isBefore(now);
  }

  /// 다음 출발 시간인지 확인
  static bool isNextDeparture(String dockName, String timeStr) {
    final nextTime = getNextDeparture(dockName);
    return nextTime == timeStr;
  }
}