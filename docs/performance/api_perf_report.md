# API Performance Report

> Snapshot from before Magok place-name fix. Re-run `dart run tool/api_perf_bench.dart` to refresh; Magok now uses `서울식물원·마곡나루역` — see [magok-citydata.md](../api/magok-citydata.md).

- Generated (UTC): `2026-07-16T05:21:14.733948Z`
- Cold runs per area: 5
- Throttle between calls: 300ms
- API key: `(redacted, length=30)`

## Seoul CITYDATA (cold)

| Area | ok | p50 http | p95 http | avg http | p50 parse | avg bytes | notes |
|------|----|----------|----------|----------|-----------|-----------|-------|
| 여의도한강공원 | 5/5 | 96ms | 151ms | 109ms | 3ms | 36784 | — |
| 망원한강공원 | 5/5 | 105ms | 111ms | 105ms | 2ms | 53547 | — |
| 마곡나루역 | 0/5 | 78ms | 84ms | 75ms | 0ms | 152 | RESULT ERROR-500 |
| 뚝섬한강공원 | 5/5 | 92ms | 100ms | 94ms | 1ms | 24916 | — |
| 잠실한강공원 | 5/5 | 90ms | 194ms | 111ms | 0ms | 24621 | — |

### Overall CITYDATA

- Success rate: **80.0%** (20/25)
- HTTP p50: **92ms**
- HTTP p95: **151ms**
- Parse p50: **1ms**
- Criterion HTTP p95 < 3000ms: **PASS**
- Criterion success ≥ 80%: **PASS**

## Cache mirror (60s TTL, same as SeoulApiService)

| Call | Latency | ok |
|------|---------|----|
| 1st (miss/network) | 91ms | true |
| 2nd (expect cache) | 1ms | true |

- Cache hit criterion (2nd < 5ms + data present): **PASS**

## Open-Meteo fallback

| Mode | Latency | weather HTTP | air HTTP | ok |
|------|---------|--------------|----------|----|
| sequential | 2410ms | 1255ms | 1155ms | true |
| parallel | 1432ms | — | — | true |

## Interpretation

- CITYDATA payloads are large (~25–54KB); parse is cheap vs HTTP.
- App uses `compute()` for parse on a background isolate (not measured here) to avoid UI jank.
- 60s in-memory cache in `SeoulApiService` collapses weather+realtime duplicate fetches on the home screen.
- `마곡나루역` often returns `RESULT.CODE=ERROR-500` (not in CITYDATA 120-place set reliably). App maps Magok weather to `여의도한강공원` in `WeatherService._parkAreaMap`; realtime still uses `마곡나루역` via `DockCatalog` — consider aligning Magok realtime to a working area name.
- Open-Meteo sequential ~2× parallel; fallback should stay parallel (already does in `WeatherService.fetchSeoulFallback`).
- Throttle 200–300ms between multi-area calls to reduce Seoul API rate-limit risk; do not use this tool for load testing.

