import 'package:flutter/material.dart';

enum OperationStatus { normal, partial, stopped, closed }

/// 홈/지도 화면에서 공유하는 선착장 카드 모델.
class DockInfo {
  final String name,
      nameEn,
      nextDeparture,
      heroTag,
      statusMessage,
      address,
      parkingName,
      nearestSubway;
  final String? shuttleInfo, parkAreaName;
  final int minutesLeft, parkingSpaces, subwayWalkTime;
  final bool hasShuttle;
  final List<Color> gradientLight, gradientDark;
  final OperationStatus operationStatus;
  final List<String> facilities, busRoutes;

  const DockInfo({
    required this.name,
    required this.nameEn,
    required this.nextDeparture,
    required this.minutesLeft,
    required this.gradientLight,
    required this.gradientDark,
    required this.heroTag,
    required this.operationStatus,
    required this.statusMessage,
    required this.address,
    required this.parkingSpaces,
    required this.parkingName,
    required this.nearestSubway,
    required this.subwayWalkTime,
    required this.hasShuttle,
    this.shuttleInfo,
    required this.facilities,
    required this.busRoutes,
    required this.parkAreaName,
  });
}
