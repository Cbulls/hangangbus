// models/attraction.dart
//
// 한강 주요 관광지 정보 모델.
// 다국어(ko/en/ja/zh)는 Map 으로 담아 locale 에 맞는 값을 꺼낸다.
// (스토리/FAQ 와 동일한 콘텐츠 다국어 패턴)

import 'package:kakao_map_plugin/kakao_map_plugin.dart';

enum AttractionCategory { park, landmark, island, fountain, culture }

class Attraction {
  final String id; // 마커 식별자 (예: 'attr_nodeul')
  final LatLng position;
  final AttractionCategory category;

  /// 언어 코드 → 이름. {'ko':..,'en':..,'ja':..,'zh':..}
  final Map<String, String> name;

  /// 언어 코드 → 한 줄 소개.
  final Map<String, String> tagline;

  /// 언어 코드 → 상세 설명.
  final Map<String, String> description;

  /// 가까운 선착장(한국어 키 — DockInfo.name 과 매칭). null 가능.
  final String? nearestDock;

  final String? imageUrl;

  const Attraction({
    required this.id,
    required this.position,
    required this.category,
    required this.name,
    required this.tagline,
    required this.description,
    this.nearestDock,
    this.imageUrl,
  });

  String _pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? m['ko'] ?? '';

  String localizedName(String lang) => _pick(name, lang);
  String localizedTagline(String lang) => _pick(tagline, lang);
  String localizedDescription(String lang) => _pick(description, lang);
}
