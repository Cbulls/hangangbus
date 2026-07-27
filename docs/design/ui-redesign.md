# UI 리디자인 (토스형 플랫)

## 배경

하단 탭·역사/맛집(Tab3)·홈 화면에 스톡 그라데이션·ShaderMask·유리효과(BackdropFilter)가 많아 AI 생성 UI 느낌이 강했다. 선착장 색도 화면마다 복붙되어 있었다.

## 변경 요약

- 디자인 토큰 [`lib/theme/app_colors.dart`](../../lib/theme/app_colors.dart): 브랜드/상태/선착장 8색 + `dockColorOf` / `tint` / `shade`
- [`lib/models/dock_location.dart`](../../lib/models/dock_location.dart)가 `AppColors`를 단일 소스로 참조
- 하단 탭바([`lib/main.dart`](../../lib/main.dart)): 불투명 흰 바 + hairline, 선택색 primary, 200ms + 햅틱, 이야기 탭 `auto_stories`
- Tab3: ShaderMask/유리 TabBar 제거 → 선착장 색 칩 + 세그먼트 컨트롤 + 플랫 카드 + InkWell
- 홈: 제목 단색, tonal CTA, 선착장 카드 InkWell, 스톡 다크 그라데이션 제거
- FAQ: 브랜드 블루 탭 인디케이터 + 카드 hairline

## 주요 파일

- `lib/theme/app_colors.dart`
- `lib/main.dart` (`MainBase` NavigationBar)
- `lib/screens/tab3_story.dart`
- `lib/screens/tab1_home.dart`
- `lib/screens/tab4_faq.dart`

## 검증

- 라이트 모드에서 4탭 시각 확인
- 선착장 칩 선택 시 Tab3 액센트/배지가 해당 dock 색으로 바뀌는지 확인
