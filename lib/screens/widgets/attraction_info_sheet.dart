// widgets/attraction_info_sheet.dart
//
// 지도에서 관광지 마커를 탭하면 올라오는 정보 시트(BottomSheet).
// 다국어는 AppLocalizations.localeName 기준으로 Attraction 의 Map 에서 꺼낸다.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/models/attraction.dart';

class AttractionInfoSheet extends StatelessWidget {
  final Attraction attraction;

  const AttractionInfoSheet({super.key, required this.attraction});

  static const _seoulBlue = Color(0xFF0064B0);

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

    final name = attraction.localizedName(lang);
    final tagline = attraction.localizedTagline(lang);
    final desc = attraction.localizedDescription(lang);
    final cat = _categoryStyle(attraction.category, lang);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1A2E).withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                children: [
                  // 드래그 핸들
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
                  const SizedBox(height: 18),

                  // 이미지 (있을 때만)
                  if (attraction.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        attraction.imageUrl!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 카테고리 배지
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: cat.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cat.emoji,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              cat.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: cat.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 이름
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : _seoulBlue,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 한 줄 소개
                  Text(
                    tagline,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 상세 설명
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 가까운 선착장
                  if (attraction.nearestDock != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _seoulBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_boat_rounded,
                            size: 20,
                            color: _seoulBlue,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _nearestDockLabel(lang, attraction.nearestDock!),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _seoulBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // 카카오맵 길찾기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openKakaoMap(name),
                      icon: const Icon(Icons.map_rounded, size: 20),
                      label: Text(_directionsLabel(lang)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _seoulBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openKakaoMap(String name) async {
    final lat = attraction.position.latitude;
    final lng = attraction.position.longitude;
    final uri = Uri.parse(
      'https://map.kakao.com/link/map/${Uri.encodeComponent(name)},$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _nearestDockLabel(String lang, String dockKo) {
    switch (lang) {
      case 'en':
        return 'Nearest dock: $dockKo';
      case 'ja':
        return '最寄りの乗り場: $dockKo';
      case 'zh':
        return '最近的码头: $dockKo';
      default:
        return '가까운 선착장: $dockKo';
    }
  }

  String _directionsLabel(String lang) {
    switch (lang) {
      case 'en':
        return 'Directions on KakaoMap';
      case 'ja':
        return 'カカオマップで道順';
      case 'zh':
        return '在KakaoMap查看路线';
      default:
        return '카카오맵 길찾기';
    }
  }

  _CategoryStyle _categoryStyle(AttractionCategory c, String lang) {
    switch (c) {
      case AttractionCategory.park:
        return _CategoryStyle(
          '🌳',
          const Color(0xFF2E7D32),
          _catLabel(lang, '공원', 'Park', '公園', '公园'),
        );
      case AttractionCategory.landmark:
        return _CategoryStyle(
          '🏙️',
          const Color(0xFF6A1B9A),
          _catLabel(lang, '랜드마크', 'Landmark', 'ランドマーク', '地标'),
        );
      case AttractionCategory.island:
        return _CategoryStyle(
          '🏝️',
          const Color(0xFF00838F),
          _catLabel(lang, '섬', 'Island', '島', '岛'),
        );
      case AttractionCategory.fountain:
        return _CategoryStyle(
          '⛲',
          const Color(0xFF1565C0),
          _catLabel(lang, '분수', 'Fountain', '噴水', '喷泉'),
        );
      case AttractionCategory.culture:
        return _CategoryStyle(
          '🎨',
          const Color(0xFFD84315),
          _catLabel(lang, '문화', 'Culture', '文化', '文化'),
        );
    }
  }

  String _catLabel(String lang, String ko, String en, String ja, String zh) {
    switch (lang) {
      case 'en':
        return en;
      case 'ja':
        return ja;
      case 'zh':
        return zh;
      default:
        return ko;
    }
  }
}

class _CategoryStyle {
  final String emoji;
  final Color color;
  final String label;
  const _CategoryStyle(this.emoji, this.color, this.label);
}
