import 'package:flutter/material.dart';

/// 앱 전역 디자인 토큰.
///
/// 색은 여기서만 정의하고, 화면에서는 이 토큰을 참조한다.
/// 선착장 색은 [dockColorOf]가 단일 소스.
class AppColors {
  AppColors._();

  // ── 브랜드 ──────────────────────────────────────────────
  static const Color primary = Color(0xFF0064B0); // 한강 블루
  static const Color primaryDark = Color(0xFF004C87);

  // ── 잉크 / 중립 ─────────────────────────────────────────
  static const Color ink = Color(0xFF1A1A1A);
  static const Color inkSecondary = Color(0xFF5C6470);
  static const Color inkTertiary = Color(0xFF9AA0A8);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;

  /// 카드 보더 등 헤어라인 (black 8%)
  static const Color hairline = Color(0x14000000);

  // ── 다크모드 표면 ───────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F1420);
  static const Color darkSurface = Color(0xFF1A2130);

  // ── 상태 ────────────────────────────────────────────────
  static const Color statusNormal = Color(0xFF00A05B); // 운항중
  static const Color statusPartial = Color(0xFFE8A000); // 부분 운항/지연
  static const Color statusStopped = Color(0xFFE0442E); // 운항 중단
  static const Color statusClosed = Color(0xFF78909C); // 운영 종료

  // ── 선착장 색 (채도/명도를 맞춘 8색, 흰 텍스트 대비 확보) ──
  static const Color dockMagok = Color(0xFF3A8464); // 그린
  static const Color dockMangwon = Color(0xFFE05C3A); // 코랄
  static const Color dockYeouido = Color(0xFF1B7FC4); // 블루
  static const Color dockApgujeong = Color(0xFF7B61C4); // 바이올렛
  static const Color dockOksu = Color(0xFF17998A); // 틸
  static const Color dockTtukseom = Color(0xFF3D8BD9); // 스카이
  static const Color dockJamsil = Color(0xFF0E96A8); // 시안
  static const Color dockSeoulForest = Color(0xFF5E9A3E); // 라임그린

  static const Map<String, Color> dockColors = {
    '마곡': dockMagok,
    '망원': dockMangwon,
    '여의도': dockYeouido,
    '압구정': dockApgujeong,
    '옥수': dockOksu,
    '뚝섬': dockTtukseom,
    '잠실': dockJamsil,
    '서울숲': dockSeoulForest,
  };

  /// 선착장 한글 키로 브랜드 색 조회. 미등록 키는 primary 폴백.
  static Color dockColorOf(String name) => dockColors[name] ?? primary;

  /// 흰색 방향으로 밝게 (0.0 = 원색, 1.0 = 흰색)
  static Color tint(Color color, double amount) =>
      Color.lerp(color, Colors.white, amount)!;

  /// 검정 방향으로 어둡게 (0.0 = 원색, 1.0 = 검정)
  static Color shade(Color color, double amount) =>
      Color.lerp(color, Colors.black, amount)!;
}
