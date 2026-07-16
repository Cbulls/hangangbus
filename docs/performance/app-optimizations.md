# 앱 UI·데이터 성능

## 배경

홈 스크롤/카드 전환 시 프레임 드랍, 동일 CITYDATA 중복 호출, UI isolate에서 대용량 JSON 파싱이 병목이었다.

## 변경 요약

| 영역 | 내용 |
|------|------|
| 홈 pulse | 상태 배지 불필요 `AnimatedBuilder` 제거, pulse 요소 `RepaintBoundary` |
| Blur | 스크롤 리스트 카드별 `BackdropFilter` 제거 |
| Bloc 범위 | `WeatherBloc` 구독을 헤더로 한정 |
| 이미지 | `Image.asset`에 `cacheWidth` |
| CITYDATA | `compute()`로 파싱 오프로드, 60s TTL 캐시 ([`SeoulApiService`](../../lib/services/seoul_api_service.dart)) |
| RealtimeBloc | 캐시 있을 때 `loading` emit 스킵 |
| 로깅 | `print` → `debugPrint`, build 중 과도한 로그 제거 |

## 주요 파일

- `lib/screens/tab1_home.dart`
- `lib/screens/tab3_story.dart`
- `lib/services/seoul_api_service.dart`
- `lib/blocs/realtime/realtime_bloc.dart`
- `lib/blocs/weather/weather_bloc.dart` (대표 날씨 1건으로 API 호출 축소)

## 검증

- 홈에서 선착장 스와이프·LIVE 갱신 시 체감 jank
- 동일 공원 연속 조회 시 캐시 히트(네트워크 생략)
- `flutter analyze` on touched files
