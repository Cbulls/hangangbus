# API 성능 벤치마크

## 배경

서울시 CITYDATA·Open-Meteo 폴백의 실제 지연·페이로드·캐시 동작을 수치로 확인하기 위해 CLI 벤치를 둔다. CI에는 넣지 않는다(키·외부 의존).

## 도구

[`tool/api_perf_bench.dart`](../../tool/api_perf_bench.dart) — 순수 Dart + `package:http`.

측정: 장소당 cold 5회, HTTP/parse 분리, 페이로드 크기, 60s 캐시 미러, Open-Meteo 순차/병렬.

## 실행

```bash
export SEOUL_API_KEY="$(grep '^SEOUL_API_KEY=' .env | cut -d= -f2-)"
dart run tool/api_perf_bench.dart
# → docs/performance/api_perf_report.md
```

키는 로그·리포트에 출력하지 않는다.

## 성공 기준

- CITYDATA HTTP p95 < 3000ms
- 캐시 2회차 < 5ms
- 5장소 성공률 ≥ 80%

## 장소 목록 (앱과 동일)

여의도한강공원, 망원한강공원, **서울식물원·마곡나루역**, 뚝섬한강공원, 잠실한강공원  
(마곡나루역 단독은 ERROR-500 — [magok-citydata.md](../api/magok-citydata.md))

## 결과

최신 실행 스냅샷: [api_perf_report.md](api_perf_report.md)  
(과거 리포트에 `마곡나루역` 실패가 남아 있을 수 있음. 재실행하면 합성명으로 갱신된다.)
