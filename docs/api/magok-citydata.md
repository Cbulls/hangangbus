# 마곡 CITYDATA 장소명 정리

## 배경

날씨(Weather)와 실시간(혼잡·따릉이·주차)은 **다른 줄기**다.

| 줄기 | Bloc | 역할 |
|------|------|------|
| 날씨 | `WeatherBloc` | 서울 대표 **여의도한강공원 1건**을 전 선착장 공유 |
| 실시간 | `RealtimeBloc` | 공원별 CITYDATA (장소 의존) |

벤치에서 `마곡나루역` 단독 조회는 `RESULT.CODE=ERROR-500` (152B). 마곡 LIVE만 비었다.

## 결정

1. **여의도 실시간을 마곡 카드에 붙이지 않음** — 거리·혼잡·주차장이 달라 오안내
2. **`서울식물원·마곡나루역` 검증 → 채택** (CITYDATA OK, ~49KB, 인구·따릉이·주차 포함)
3. 날씨는 여의도 대표 유지

## 변경 요약

- `DockCatalog` / `DockGeo` / `RealtimeBloc._parks` / 벤치 목록:  
  `마곡나루역` → **`서울식물원·마곡나루역`**
- `WeatherService._parkAreaMap`: 마곡 관련 키 → 여의도 (직접 fetch 호환). 런타임 날씨는 여전히 WeatherBloc 대표 경로

## 주요 파일

- [`lib/data/dock_catalog.dart`](../../lib/data/dock_catalog.dart)
- [`lib/models/dock_geo.dart`](../../lib/models/dock_geo.dart)
- [`lib/blocs/realtime/realtime_bloc.dart`](../../lib/blocs/realtime/realtime_bloc.dart)
- [`lib/blocs/weather/weather_bloc.dart`](../../lib/blocs/weather/weather_bloc.dart)
- [`lib/services/weather_service.dart`](../../lib/services/weather_service.dart)

## 검증

```bash
export SEOUL_API_KEY="$(grep '^SEOUL_API_KEY=' .env | cut -d= -f2-)"
# CITYDATA 키 존재 여부
python3 -c "
import os,urllib.request,urllib.parse,json
k=os.environ['SEOUL_API_KEY']
n=urllib.parse.quote('서울식물원·마곡나루역')
u=f'http://openapi.seoul.go.kr:8088/{k}/json/citydata/1/1/{n}'
d=json.loads(urllib.request.urlopen(u,timeout=10).read())
print('OK' if 'CITYDATA' in d else d)
"
```

앱: 마곡 선착장 선택 → LIVE에 혼잡/따릉이/주차 표시, 헤더 날씨는 전 선착장 동일.
