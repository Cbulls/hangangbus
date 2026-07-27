import 'package:flutter/material.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/models/dock_info.dart';
import 'package:hangangbus/models/dock_type.dart';
import 'package:hangangbus/theme/app_colors.dart';
import 'package:hangangbus/utils/schedule_utils.dart';

class DockMeta {
  final String address;
  final String? parkAreaName;
  final int parkingSpaces;
  final String parkingName;
  final String nearestSubway;
  final int subwayWalkTime;
  final bool hasShuttle;
  final String? shuttleInfo;
  final List<String> facilities;
  final List<String> busRoutes;

  const DockMeta({
    required this.address,
    required this.parkAreaName,
    required this.parkingSpaces,
    required this.parkingName,
    required this.nearestSubway,
    required this.subwayWalkTime,
    required this.hasShuttle,
    this.shuttleInfo,
    required this.facilities,
    required this.busRoutes,
  });
}

/// 선착장 정적 메타 + 운항 상태를 조합해 [DockInfo] 목록을 만든다.
class DockCatalog {
  DockCatalog._();

  static Color brandColor(DockType dock) {
    switch (dock) {
      case DockType.magok:
        return AppColors.dockMagok;
      case DockType.mangwon:
        return AppColors.dockMangwon;
      case DockType.yeouido:
        return AppColors.dockYeouido;
      case DockType.apgujeong:
        return AppColors.dockApgujeong;
      case DockType.oksu:
        return AppColors.dockOksu;
      case DockType.ttukseom:
        return AppColors.dockTtukseom;
      case DockType.jamsil:
        return AppColors.dockJamsil;
      case DockType.seoulforest:
        return AppColors.dockSeoulForest;
    }
  }

  static List<DockInfo> all(AppLocalizations l10n) =>
      ScheduleUtils.docks.map((d) => build(d, l10n)).toList();

  static DockInfo build(DockType dock, AppLocalizations l10n) {
    final nextDeparture = ScheduleUtils.getNextDepartureForDock(dock);
    final minutesLeft = ScheduleUtils.getMinutesUntilNextForDock(dock) ?? 0;
    final isOperating = nextDeparture != null;
    final meta = metaFor(dock, l10n);
    final color = brandColor(dock);

    return DockInfo(
      name: dock.label(l10n),
      nameEn: ScheduleUtils.dockNameEn(dock),
      nextDeparture: nextDeparture ?? '--:--',
      minutesLeft: minutesLeft,
      gradientLight: [color, AppColors.tint(color, 0.35)],
      gradientDark: [AppColors.tint(color, 0.25), color],
      heroTag: 'dock-${dock.name}',
      operationStatus: isOperating
          ? OperationStatus.normal
          : OperationStatus.closed,
      statusMessage: isOperating ? l10n.statusNormal : l10n.statusClosed,
      address: meta.address,
      parkAreaName: meta.parkAreaName,
      parkingSpaces: meta.parkingSpaces,
      parkingName: meta.parkingName,
      nearestSubway: meta.nearestSubway,
      subwayWalkTime: meta.subwayWalkTime,
      hasShuttle: meta.hasShuttle,
      shuttleInfo: meta.shuttleInfo,
      facilities: meta.facilities,
      busRoutes: meta.busRoutes,
    );
  }

  static DockMeta metaFor(DockType dock, AppLocalizations l10n) {
    final defaultFacilities = [
      l10n.facilityConvenienceStore,
      l10n.facilityCafe,
    ];

    switch (dock) {
      case DockType.magok:
        return DockMeta(
          address: '서울특별시 강서구 가양동 441',
          // citydata: '마곡나루역' 단독은 ERROR-500. 공식 장소명은 합성명.
          parkAreaName: '서울식물원·마곡나루역',
          parkingSpaces: 38,
          parkingName: '가양라이품 공영주차장',
          nearestSubway: '양천향교역(9호선)',
          subwayWalkTime: 12,
          hasShuttle: true,
          shuttleInfo: '월~금 28회/일, 15분 간격\n가양나들목–양천향교역–발산역',
          facilities: [l10n.facilityConvenienceStore],
          busRoutes: const ['6611'],
        );
      case DockType.mangwon:
        return DockMeta(
          address: '서울특별시 마포구 망원동 205-8',
          parkAreaName: '망원한강공원',
          parkingSpaces: 138,
          parkingName: '망원 제3주차장',
          nearestSubway: '망원역(6호선)',
          subwayWalkTime: 27,
          hasShuttle: false,
          facilities: [
            l10n.facilityConvenienceStore,
            l10n.facilityCafe,
            l10n.facilityRamen,
            l10n.facilityFastFood,
          ],
          busRoutes: const ['마포16', '7716', '8775'],
        );
      case DockType.yeouido:
        return DockMeta(
          address: '서울특별시 영등포구 여의도동 85-1',
          parkAreaName: '여의도한강공원',
          parkingSpaces: 171,
          parkingName: '여의도한강공원 2주차장',
          nearestSubway: '여의나루역(5호선)',
          subwayWalkTime: 4,
          hasShuttle: false,
          facilities: [
            l10n.facilityConvenienceStore,
            l10n.facilityRamen,
            l10n.facilityFastFood,
            l10n.facilityCafe,
          ],
          busRoutes: const ['영등포10', '261', '753', '5615'],
        );
      case DockType.apgujeong:
        return DockMeta(
          address: '서울특별시 강남구 압구정동 일대',
          parkAreaName: null,
          parkingSpaces: 0,
          parkingName: '주차 정보 확인 필요',
          nearestSubway: '압구정로데오역(수인분당선)',
          subwayWalkTime: 15,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: const ['143', '240', '362'],
        );
      case DockType.oksu:
        return DockMeta(
          address: '서울특별시 성동구 옥수동 일대',
          parkAreaName: null,
          parkingSpaces: 0,
          parkingName: '주차 정보 확인 필요',
          nearestSubway: '옥수역(3호선/경의중앙선)',
          subwayWalkTime: 10,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: const ['110A', '2016', '241'],
        );
      case DockType.ttukseom:
        return DockMeta(
          address: '서울특별시 광진구 자양동 112',
          parkAreaName: '뚝섬한강공원',
          parkingSpaces: 0,
          parkingName: '뚝섬한강공원 주차장',
          nearestSubway: '자양역(7호선)',
          subwayWalkTime: 7,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: const ['2014', '2221', '2222'],
        );
      case DockType.jamsil:
        return DockMeta(
          address: '서울특별시 송파구 잠실동 1-2',
          parkAreaName: '잠실한강공원',
          parkingSpaces: 0,
          parkingName: '잠실한강공원 주차장',
          nearestSubway: '잠실새내역(2호선)',
          subwayWalkTime: 18,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: const ['302', '333', '341'],
        );
      case DockType.seoulforest:
        return DockMeta(
          address: '서울특별시 성동구 성수동1가 (서울숲 한강)',
          parkAreaName: null,
          parkingSpaces: 0,
          parkingName: '서울숲 공영주차장',
          nearestSubway: '서울숲역(수인분당선)',
          subwayWalkTime: 15,
          hasShuttle: false,
          facilities: defaultFacilities,
          busRoutes: const ['2014', '2224', '141'],
        );
    }
  }
}
