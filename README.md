# 한강버스 (Hangang Bus) 🚢

서울 한강을 운항하는 **한강버스(수상 대중교통)** 정보를 제공하는 다국어 모바일 앱입니다. 선착장별 실시간 운항·날씨·혼잡도 정보부터 한강 주변 관광지 탐색까지, 한강버스를 이용하는 시민과 관광객을 위한 종합 가이드입니다.

> **Flutter · BLoC · KakaoMap** 기반으로 제작되었으며, 한국어/영어/일본어/중국어 4개 언어를 지원합니다.

---

## ✨ 주요 기능

### 🏠 홈 (선착장 카드)
- **8개 선착장**(마곡·망원·여의도·압구정·옥수·뚝섬·잠실·서울숲) 정보를 카드 캐러셀로 제공
- **다음 배 출발 시각** 실시간 카운트다운 (운항 종료 시 다음날 첫차 안내)
- **대표 날씨 + 미세먼지** 표시 (서울시 API → Open-Meteo 자동 폴백)
- **실시간 정보**: 주차 가능 면수, 가까운 따릉이 대여소, 혼잡도
- **셔틀버스 운행 정보** (마곡·잠실만 운행)
- **편의시설** 안내 (편의점·카페·라면 등)
- 카드 탭 → 상세 정보 시트 / 지도 버튼 → 선착장 지도
- 내용량에 따라 **카드 높이가 자동 조절**되는 동적 캐러셀 (오버플로우 없음)

### 🗓️ 시간표
- 선착장·방향별 **운항 시간표**를 타임라인 형태로 제공
- 현재 시각 기준 **다음 출발 편 하이라이트**
- 마곡↔여의도 / 여의도↔잠실 등 구간별 운항 정보

### 📖 한강 이야기 (스토리)
- 선착장별 **역사·먹거리 콘텐츠** (여의도·망원·마곡 등 18개 스토리)
- 카테고리(역사/먹거리)별 분류, 상세 화면 제공
- 4개 언어 콘텐츠 완비

### ❓ FAQ & 안전 수칙
- 한강버스 이용 **자주 묻는 질문** (아코디언 UI)
- **승선 안전 수칙**: 구명조끼 위치·착용법, 비상 대피, 긴급 신고 방법
- 긴급 연락 배너 (한강 경찰대·소방구조대 연계)

### 🗺️ 한강 지도 (HangangMapScreen)
- 선착장 8곳 + **한강 관광지 31곳**을 한 지도에 표시
- 마커 탭 → 선착장/관광지 정보 시트 (BottomSheet)
- **주변 탐색**: 공원/명소 버튼을 누르면 현재 선착장 주변의 명소를 가로 카드로 표시
  - 예) 마곡 → 양천향교·서울식물원·겸재정선미술관
- 카드 탭 → 해당 위치로 지도 이동 + 상세 정보
- 카카오맵 길찾기 연동

### 🌐 다국어 지원
- **한국어 / English / 日本語 / 中文(간체)** 4개 언어 완전 지원
- 기기 언어에 따라 자동 전환 (`gen-l10n` 기반)
- UI 텍스트 150개 키 + 콘텐츠(스토리·FAQ·관광지) 전체 번역

### 🔠 큰글씨 (고령층 접근성)
- 홈 화면에서 **글씨 크기 3단계** 조절 (보통 / 크게 / 아주 크게)
- 앱 전역에 즉시 적용 (`MediaQuery.textScaler`)
- 설정값은 기기에 영구 저장 (`shared_preferences`)

---

## 🛠️ 기술 스택

| 분류 | 기술 |
|------|------|
| 프레임워크 | Flutter (Dart SDK ^3.10) |
| 상태 관리 | flutter_bloc, bloc, equatable |
| 지도 | kakao_map_plugin, kakao_flutter_sdk |
| 네트워크 | http, web_socket_channel |
| 국제화 | flutter_localizations, intl, gen-l10n |
| 저장소 | shared_preferences |
| 기타 | flutter_animate, url_launcher, webview_flutter, flutter_dotenv |

---

## 🏗️ 아키텍처

본 프로젝트는 **BLoC 패턴** 기반의 계층형 아키텍처를 따릅니다.

```
UI (Screens/Widgets)
   ↕  이벤트 / 상태
BLoC (상태 관리)
   ↕
Repository (데이터 추상화)
   ↕
Service / API (서울시 OpenAPI, Open-Meteo, KakaoMap)
```

### BLoC 목록
| BLoC | 역할 |
|------|------|
| `NavigationBloc` | 하단 탭 네비게이션 |
| `ClockBloc` | 분 단위 현재 시각 (카운트다운 갱신) |
| `WeatherBloc` | 대표 날씨·미세먼지 (10분 주기 갱신) |
| `RealtimeBloc` | 실시간 주차·따릉이·혼잡도 |
| `ScheduleBloc` | 시간표 선착장/방향 선택 |
| `StoryBloc` / `FaqBloc` | 스토리·FAQ 탭 상태 |
| `SettingsBloc` | 큰글씨 등 앱 설정 (영구 저장) |

### 디렉토리 구조
```
lib/
├── main.dart                 # 앱 진입점, BlocProvider 등록, 글씨 배율 적용
├── blocs/                    # 상태 관리 (bloc/event/state)
│   ├── navigation/  clock/  weather/  realtime/
│   ├── schedule/  story/  faq/  settings/
├── repositories/             # 데이터 추상화 계층
├── services/                 # 외부 API 호출 (서울시, Open-Meteo)
├── models/                   # 데이터 모델
│   ├── dock_location.dart    # 선착장 좌표·정보
│   ├── attraction.dart       # 관광지 모델
│   ├── weather_data.dart     # 날씨·미세먼지
│   └── ...
├── data/                     # 정적 데이터 (스토리·FAQ·관광지, 4개 언어)
├── screens/                  # 화면
│   ├── tab1_home.dart        # 홈 (선착장 카드)
│   ├── tab2_schedule.dart    # 시간표
│   ├── tab3_story.dart       # 한강 이야기
│   ├── tab4_faq.dart         # FAQ & 안전수칙
│   ├── dock_map_screen.dart  # 선착장 지도
│   └── hangang_map_screen.dart # 한강 통합 지도 (관광지 탐색)
├── widgets/                  # 재사용 위젯
└── l10n/                     # 다국어 arb (ko/en/ja/zh)
```

---

## 🌦️ 데이터 소스

| 데이터 | 소스 | 비고 |
|--------|------|------|
| 날씨·미세먼지 | 서울시 실시간 도시데이터 API (citydata) | 1차 |
| 날씨·미세먼지 (폴백) | Open-Meteo (날씨 + 대기질 API) | 서울시 API 응답 지연 시 자동 전환 |
| 주차·따릉이·혼잡도 | 서울시 실시간 도시데이터 API | |
| 지도·길찾기 | KakaoMap | |
| 운항 시간표 | 앱 내장 정적 데이터 | |

> 서울시 API는 응답이 불안정할 수 있어, **타임아웃 시 1회 재시도 후 Open-Meteo로 폴백**하는 이중화 구조로 안정성을 확보했습니다.


## 📱 지원 플랫폼
- Android
- iOS

---

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.

---

## 🙋 문의

이슈나 제안은 ato701@naver.com을 통해 남겨주세요.
