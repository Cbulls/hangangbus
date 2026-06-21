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

// 선착장 데이터 (좌표: 한강버스 공식 선착장 위치 실측 기준)
final List<DockLocation> docks = [
  DockLocation(
    name: '마곡',
    position: LatLng(37.575048, 126.84399),
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
    position: LatLng(37.5265383, 127.0166979),
    color: const Color(0xFF8E54E9),
    address: '서울특별시 강남구 압구정동 380-1',
  ),
  DockLocation(
    name: '옥수',
    position: LatLng(37.5389979, 127.0211590),
    color: const Color(0xFF26A69A),
    address: '서울특별시 성동구 옥수동 86',
  ),
  DockLocation(
    name: '뚝섬',
    position: LatLng(37.5286586, 127.0666088),
    color: const Color(0xFF42A5F5),
    address: '서울특별시 광진구 자양동 2216',
  ),
  DockLocation(
    name: '잠실',
    position: LatLng(37.5186011, 127.0846993),
    color: const Color(0xFF00ACC1),
    address: '서울특별시 송파구 잠실동 1-2',
  ),
  DockLocation(
    name: '서울숲',
    position: LatLng(37.5365, 127.0345),
    color: const Color(0xFF66BB6A),
    address: '서울특별시 성동구 성수동1가 (서울숲 한강)',
  ),
];
