# 출시·운영 게이트 (CTO 스프린트)

## 배경

콘텐츠 MVP는 갖춰졌으나 테스트/CI/크래시/시크릿/스토어 정책이 약했다. 기능보다 운영 성숙도를 한 사이클 올렸다.

## 변경 요약

### 중국어 l10n

- `app_zh.arb` → `flutter gen-l10n`으로 `app_localizations_zh.dart` 생성
- `AppLocalizations.supportedLocales`에 `zh` 포함

### 시크릿

- `.env` asset 번들 제거
- [`lib/config/app_config.dart`](../../lib/config/app_config.dart): `--dart-define` (`KAKAO_APP_KEY`, `SEOUL_API_KEY`, `SENTRY_DSN`, `PRIVACY_POLICY_URL`)
- 노출 스크립트 `lib/test.py` 삭제 — 키가 히스토리에 있었다면 열린데이터광장에서 **재발급**

```bash
flutter run \
  --dart-define=KAKAO_APP_KEY=... \
  --dart-define=SEOUL_API_KEY=...
```

### 데드코드

- 삭제: `live_tracking_map`, `bus_info_screen`, `ship_marker_widget`
- 미사용 의존성 제거: `kakao_flutter_sdk`, `web_socket_channel`, `flutter_dotenv`, `flutter_animate`, `webview_flutter` (직접 사용분)

### CI / 테스트

- [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml): `flutter analyze` + `flutter test`
- [`test/widget_test.dart`](../../test/widget_test.dart): zh 로케일·ContentRepository·8선착장 스토리 스모크

### 크래시

- [`lib/services/app_telemetry.dart`](../../lib/services/app_telemetry.dart): Sentry (DSN 있을 때만), 탭 전환 breadcrumb, API 예외

### 스토어

- Android: 미사용 위치 권한 제거, cleartext → [`network_security_config.xml`](../../android/app/src/main/res/xml/network_security_config.xml) (openapi.seoul.go.kr만)
- iOS: [`PrivacyInfo.xcprivacy`](../../ios/Runner/PrivacyInfo.xcprivacy)
- FAQ 개인정보 링크 → [legal/privacy.md](../legal/privacy.md)

### 콘텐츠·아키텍처

- Story EN/JA/ZH: 옥수·서울숲·뚝섬·압구정·잠실 추가 (`story_extra_*.dart`)
- [`DockCatalog`](../../lib/data/dock_catalog.dart) / [`DockInfo`](../../lib/models/dock_info.dart)로 홈 메타 분리
- Tab3/Tab4 → `ContentRepository`

## 검증

```bash
flutter analyze --no-fatal-infos
flutter test
```
