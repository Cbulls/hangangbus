// screens/hangang_map_screen.dart
//
// 선착장 + 한강 관광지를 한 화면에 표시하는 통합 카카오맵.
// - 선착장 마커(⚓): docks (dock_location.dart)
// - 관광지 마커(카테고리 이모지): hangangAttractions (attraction_data.dart)
// - onMarkerTap 으로 markerId 접두사('dock_' / 'attr_')를 보고 분기

import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/models/attraction.dart';
import 'package:hangangbus/models/dock_location.dart';
import 'package:hangangbus/data/attraction_data.dart';
import 'package:hangangbus/screens/widgets/attraction_info_sheet.dart';

class HangangMapScreen extends StatefulWidget {
  /// 진입 시 지도 중심이 될 선착장 영문명(예: 'Yeouido'). null이면 한강 중심.
  final String? initialDockNameEn;

  const HangangMapScreen({super.key, this.initialDockNameEn});

  @override
  State<HangangMapScreen> createState() => _HangangMapScreenState();
}

class _HangangMapScreenState extends State<HangangMapScreen> {
  KakaoMapController? _mapController;

  // 기본 한강 중심 (대략 한강대교 부근) — 선택 선착장이 없을 때만 사용
  static final LatLng _hanRiverCenter = LatLng(37.5283, 126.9950);

  // 선착장 영문명 → 한국어명(docks의 name 키) 매핑
  static const Map<String, String> _enToKo = {
    'Magok': '마곡',
    'Mangwon': '망원',
    'Yeouido': '여의도',
    'Apgujeong': '압구정',
    'Oksu': '옥수',
    'Ttukseom': '뚝섬',
    'Jamsil': '잠실',
    'SeoulForest': '서울숲',
  };

  /// 현재 선착장의 한국어 이름(주변 명소 필터용). 없으면 null.
  String? get _currentDockKo {
    final en = widget.initialDockNameEn;
    if (en == null) return null;
    return _enToKo[en];
  }

  /// 진입 시 지도 중심. 선택 선착장이 있으면 그 좌표, 없으면 한강 중심.
  LatLng get _initialCenter {
    final en = widget.initialDockNameEn;
    if (en != null) {
      final ko = _enToKo[en];
      if (ko != null) {
        for (final d in docks) {
          if (d.name == ko) return d.position;
        }
      }
    }
    return _hanRiverCenter;
  }

  String _lang(BuildContext context) {
    final name = (AppLocalizations.of(context)?.localeName ?? 'ko')
        .toLowerCase();
    if (name.startsWith('ja')) return 'ja';
    if (name.startsWith('zh')) return 'zh';
    if (name.startsWith('en')) return 'en';
    return 'ko';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = _lang(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 카카오맵
          Positioned.fill(
            child: KakaoMap(
              onMapCreated: (controller) {
                _mapController = controller;
                // 초기 center 가 반영 안 되는 경우 대비해 명시적으로 이동
                controller.setCenter(_initialCenter);
                setState(() {});
              },
              center: _initialCenter,
              maxLevel: 12,
              markers: _buildMarkers(),
              onMarkerTap: (markerId, latLng, index) {
                _handleMarkerTap(markerId);
              },
            ),
          ),

          // 2. 상단 헤더 (화면 최상단 고정)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _circleButton(
                      icon: Icons.arrow_back_ios_new,
                      isDark: isDark,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _headerBox(isDark, lang)),
                  ],
                ),
              ),
            ),
          ),

          // 3. 하단 범례
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _legendBox(isDark, lang),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // 선착장 마커
    for (final dock in docks) {
      markers.add(
        Marker(
          markerId: 'dock_${dock.name}',
          latLng: dock.position,
          width: 33,
          height: 43,
          markerImageSrc: _dockMarkerImage,
        ),
      );
    }

    // 관광지 마커
    for (final a in hangangAttractions) {
      markers.add(
        Marker(
          markerId: a.id,
          latLng: a.position,
          width: 33,
          height: 43,
          markerImageSrc: _dockMarkerImage,
        ),
      );
    }

    return markers;
  }

  /// 범례 버튼 탭 → 현재 선착장 주변의 해당 종류(공원/명소) 명소를 시트로 표시.
  /// kind: 'park'(공원) | 'landmark'(공원 아닌 명소)
  void _showNearbySheet(String kind) {
    final dockKo = _currentDockKo;

    // 현재 선착장 주변 명소 중 종류에 맞는 것 추림
    final List<Attraction> nearby = hangangAttractions.where((a) {
      if (dockKo != null && a.nearestDock != dockKo) return false;
      if (kind == 'park') return a.category == AttractionCategory.park;
      return a.category != AttractionCategory.park; // landmark 묶음
    }).toList();

    // 선착장 정보가 없거나(전체 진입) 주변이 비면 전체에서 종류로 필터
    final List<Attraction> list = nearby.isNotEmpty
        ? nearby
        : hangangAttractions.where((a) {
            if (kind == 'park') return a.category == AttractionCategory.park;
            return a.category != AttractionCategory.park;
          }).toList();

    // 시트로 표시 + 해당 명소들이 다 보이게 줌
    final points = list.map((a) => a.position).toList();
    if (points.isNotEmpty) _mapController?.fitBounds(points);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NearbySheet(
        title: _nearbyTitle(kind, dockKo),
        attractions: list,
        lang: _lang(context),
        onTapCard: (a) {
          Navigator.pop(context); // 시트 닫기
          _mapController?.setCenter(a.position);
          _mapController?.setLevel(4);
          _showAttractionSheet(a); // 명소 정보 시트
        },
      ),
    );
  }

  String _nearbyTitle(String kind, String? dockKo) {
    final lang = _lang(context);
    final dockPart = dockKo ?? '';
    final kindLabel = kind == 'park'
        ? _legendPark(lang)
        : _legendLandmark(lang);
    switch (lang) {
      case 'en':
        return dockPart.isEmpty
            ? '$kindLabel near the Han River'
            : 'Near $dockPart Dock · $kindLabel';
      case 'ja':
        return dockPart.isEmpty
            ? '漢江周辺の$kindLabel'
            : '$dockPart乗り場周辺 · $kindLabel';
      case 'zh':
        return dockPart.isEmpty
            ? '汉江周边的$kindLabel'
            : '$dockPart码头周边 · $kindLabel';
      default:
        return dockPart.isEmpty
            ? '한강 주변 $kindLabel'
            : '$dockPart 선착장 주변 · $kindLabel';
    }
  }

  // 카카오 기본 마커 이미지. 선착장·관광지 공통 사용 (탭 이벤트가 확실히 동작).
  static const String _dockMarkerImage =
      'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';

  void _handleMarkerTap(String markerId) {
    if (markerId.startsWith('attr_')) {
      final attraction = hangangAttractions.firstWhere(
        (a) => a.id == markerId,
        orElse: () => hangangAttractions.first,
      );
      _showAttractionSheet(attraction);
    } else if (markerId.startsWith('dock_')) {
      final dockName = markerId.substring('dock_'.length);
      _showDockSheet(dockName);
    }
  }

  void _showAttractionSheet(Attraction attraction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AttractionInfoSheet(attraction: attraction),
    );
  }

  void _showDockSheet(String dockName) {
    DockLocation? dock;
    for (final d in docks) {
      if (d.name == dockName) {
        dock = d;
        break;
      }
    }
    if (dock == null) return;
    final found = dock;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DockMiniSheet(dock: found, lang: _lang(context)),
    );
  }

  // ── UI 보조 ──────────────────────────────────────────────────
  Widget _circleButton({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? Colors.black54 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white : const Color(0xFF0064B0),
        ),
      ),
    );
  }

  Widget _headerBox(bool isDark, String lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black54 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8),
        ],
      ),
      child: Text(
        _title(lang),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : const Color(0xFF0064B0),
        ),
      ),
    );
  }

  Widget _legendBox(bool isDark, String lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 선착장: 안내 표시만 (탭 없음)
          _legendLabel('⚓', _legendDock(lang), isDark),
          // 공원/명소: 탭하면 주변 탐색 시트
          _legendButton('🌳', _legendPark(lang), isDark, 'park'),
          _legendButton('🏙️', _legendLandmark(lang), isDark, 'landmark'),
        ],
      ),
    );
  }

  /// 비인터랙티브 범례 항목(선착장).
  Widget _legendLabel(String emoji, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    );
  }

  /// 탭 가능한 범례 버튼(공원/명소) → 주변 탐색 시트.
  Widget _legendButton(String emoji, String text, bool isDark, String kind) {
    return GestureDetector(
      onTap: () => _showNearbySheet(kind),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF0064B0).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF0064B0).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0064B0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 다국어 라벨 ──────────────────────────────────────────────
  String _title(String lang) {
    switch (lang) {
      case 'en':
        return 'Han River Map';
      case 'ja':
        return '漢江マップ';
      case 'zh':
        return '汉江地图';
      default:
        return '한강 지도';
    }
  }

  String _legendDock(String lang) {
    switch (lang) {
      case 'en':
        return 'Dock';
      case 'ja':
        return '乗り場';
      case 'zh':
        return '码头';
      default:
        return '선착장';
    }
  }

  String _legendPark(String lang) {
    switch (lang) {
      case 'en':
        return 'Park';
      case 'ja':
        return '公園';
      case 'zh':
        return '公园';
      default:
        return '공원';
    }
  }

  String _legendLandmark(String lang) {
    switch (lang) {
      case 'en':
        return 'Landmark';
      case 'ja':
        return '名所';
      case 'zh':
        return '地标';
      default:
        return '명소';
    }
  }
}

/// 지도에서 선착장 마커를 탭하면 올라오는 간단 정보 시트.
class _DockMiniSheet extends StatelessWidget {
  final DockLocation dock;
  final String lang;

  const _DockMiniSheet({required this.dock, required this.lang});

  static const _seoulBlue = Color(0xFF0064B0);

  String _dockLabel() {
    switch (lang) {
      case 'en':
        return 'Dock';
      case 'ja':
        return '乗り場';
      case 'zh':
        return '码头';
      default:
        return '선착장';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: dock.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_boat_rounded,
                    color: dock.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dock.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : _seoulBlue,
                        ),
                      ),
                      Text(
                        _dockLabel(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: dock.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.place_rounded,
                  size: 18,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dock.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 선착장 주변 명소를 가로 카드 리스트로 보여주는 하단 시트.
class _NearbySheet extends StatelessWidget {
  final String title;
  final List<Attraction> attractions;
  final String lang;
  final void Function(Attraction) onTapCard;

  const _NearbySheet({
    required this.title,
    required this.attractions,
    required this.lang,
    required this.onTapCard,
  });

  static const _seoulBlue = Color(0xFF0064B0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : _seoulBlue,
              ),
            ),
            const SizedBox(height: 14),
            if (attractions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  _emptyText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              )
            else
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: attractions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final a = attractions[i];
                    return _card(context, a, isDark);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, Attraction a, bool isDark) {
    final cat = _catStyle(a.category);
    return GestureDetector(
      onTap: () => onTapCard(a),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : cat.$2.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cat.$2.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cat.$2.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(cat.$1, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Text(
              a.localizedName(lang),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                a.localizedTagline(lang),
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  _detailText(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cat.$2,
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 16, color: cat.$2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _catStyle(AttractionCategory c) {
    switch (c) {
      case AttractionCategory.park:
        return ('🌳', const Color(0xFF2E7D32));
      case AttractionCategory.landmark:
        return ('🏙️', const Color(0xFF6A1B9A));
      case AttractionCategory.island:
        return ('🏝️', const Color(0xFF00838F));
      case AttractionCategory.fountain:
        return ('⛲', const Color(0xFF1565C0));
      case AttractionCategory.culture:
        return ('🎨', const Color(0xFFD84315));
    }
  }

  String _detailText() {
    switch (lang) {
      case 'en':
        return 'View';
      case 'ja':
        return '詳細';
      case 'zh':
        return '查看';
      default:
        return '보기';
    }
  }

  String _emptyText() {
    switch (lang) {
      case 'en':
        return 'No nearby spots found.';
      case 'ja':
        return '周辺のスポットがありません。';
      case 'zh':
        return '附近暂无景点。';
      default:
        return '주변 명소가 없습니다.';
    }
  }
}
