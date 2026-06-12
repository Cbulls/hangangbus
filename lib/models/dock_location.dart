import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DockLocation {
  final String name;
  final LatLng position;
  final Color color;
  final String address;

  const DockLocation({
    required this.name,
    required this.position,
    required this.color,
    required this.address,
  });
}

// 선착장 데이터
final List<DockLocation> docks = [
  DockLocation(
    name: '마곡',
    position: LatLng(37.575086622786905, 126.84405715556353),
    color: const Color(0xFF4A7C59),
    address: '서울특별시 강서구 가양동 441',
  ),
  DockLocation(
    name: '망원',
    position: LatLng(37.55454583761357, 126.89463688749166),
    color: const Color(0xFFFF6B35),
    address: '서울특별시 마포구 망원동 205-8',
  ),
  DockLocation(
    name: '여의도',
    position: LatLng(37.52890064458423, 126.93440535180632),
    color: const Color(0xFF0099CC),
    address: '서울특별시 영등포구 여의도동 85-1',
  ),
  DockLocation(
    name: '압구정',
    position: LatLng(37.5270, 127.0280),
    color: const Color(0xFF8E54E9),
    address: '서울특별시 강남구 압구정동 일대',
  ),
  DockLocation(
    name: '옥수',
    position: LatLng(37.5400, 127.0180),
    color: const Color(0xFF26A69A),
    address: '서울특별시 성동구 옥수동 일대',
  ),
  DockLocation(
    name: '뚝섬',
    position: LatLng(37.5304, 127.0661),
    color: const Color(0xFF42A5F5),
    address: '서울특별시 광진구 자양동 112',
  ),
  DockLocation(
    name: '잠실',
    position: LatLng(37.5145, 127.0820),
    color: const Color(0xFF00ACC1),
    address: '서울특별시 송파구 잠실동 1-2',
  ),
];
