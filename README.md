# 한강버스 (Hangang Bus)

서울 한강을 운항하는 **한강버스(수상 대중교통)** 정보를 제공하는 다국어 모바일 앱입니다.

> Flutter · BLoC · KakaoMap · 한국어/영어/일본어/중국어(간체)

---

## 주요 기능

- **홈**: 8개 선착장 카드, 다음 배 카운트다운, 날씨·혼잡도·주차·따릉이
- **시간표**: 선착장·방향별 타임라인
- **한강 이야기**: 선착장별 역사·맛집 (KO/EN/JA/ZH 8선착장)
- **FAQ·안전 수칙** + 개인정보 처리방침 링크
- **한강 지도**: 선착장 + 관광지 마커, 주변 탐색

---

## 실행 방법 (시크릿)

API 키는 **바이너리 asset이 아니라** 빌드 타임 `--dart-define` 으로만 주입합니다.  
로컬에서는 `.env`를 `--dart-define-from-file`로 넘깁니다 (`flutter_dotenv` / asset 번들 아님).

```bash
flutter pub get
cp .env.example .env   # 최초 1회 — 키 채우기

# 권장
./scripts/run.sh
# 또는
flutter run --dart-define-from-file=.env
```

개별 플래그도 가능합니다:

```bash
flutter run \
  --dart-define=KAKAO_APP_KEY=your_kakao_js_key \
  --dart-define=SEOUL_API_KEY=your_seoul_openapi_key \
  --dart-define=SENTRY_DSN=   # optional
```

샘플 키 자리표시자는 [`.env.example`](.env.example) 를 참고하세요.  
`.env` 를 assets 로 넣지 마세요. (키가 앱 패키지에 포함됩니다.)  
IDE Run은 [`.vscode/launch.json`](.vscode/launch.json)이 같은 플래그를 씁니다.

> **보안:** 과거에 저장소/스크립트에 노출된 Seoul OpenAPI 키가 있다면 [서울 열린데이터광장](https://data.seoul.go.kr/)에서 **즉시 재발급(로테이션)** 하세요.

Android 네이티브 카카오 메타데이터는 `android/local.properties` 의 `KAKAO_APP_KEY` 를 사용합니다.

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| 프레임워크 | Flutter (Dart SDK ^3.10) |
| 상태 관리 | flutter_bloc, bloc, equatable |
| 지도 | kakao_map_plugin |
| 네트워크 | http |
| 국제화 | flutter_localizations, gen-l10n |
| 크래시 | sentry_flutter (DSN 있을 때만) |
| 저장소 | shared_preferences |

---

## 아키텍처

```
UI → BLoC → Repository → Service / 정적 데이터
```

콘텐츠(스토리·FAQ)는 `ContentRepository` → `DataProvider` 경로를 사용합니다.

---

## API 성능 벤치

서울시 CITYDATA(5장소) + Open-Meteo 폴백 지연/페이로드를 측정합니다.

```bash
export SEOUL_API_KEY="$(grep '^SEOUL_API_KEY=' .env | cut -d= -f2-)"
dart run tool/api_perf_bench.dart
# → docs/performance/api_perf_report.md
```

사용법·성공 기준: [`docs/performance/api-bench.md`](docs/performance/api-bench.md)  
작업 기록 전체: [`docs/README.md`](docs/README.md)

## CI

PR/푸시 시 GitHub Actions 가 `flutter analyze` + `flutter test` 를 실행합니다.

---

## 개인정보

초안: [`docs/legal/privacy.md`](docs/legal/privacy.md)  
앱 FAQ 탭의 개인정보 처리방침 링크는 `PRIVACY_POLICY_URL` (기본: GitHub Pages 플레이스홀더)을 엽니다.
