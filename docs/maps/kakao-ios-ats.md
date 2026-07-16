# iOS 카카오맵 빈 화면 (ATS)

## 배경

Android에서는 지도가 보이는데 iOS에서만 `KakaoMap` 영역이 비었다. `kakao_map_plugin`은 네이티브 SDK가 아니라 **WKWebView + Kakao Maps JS SDK**로 타일을 로드한다.

## 원인

- Android: `usesCleartextTraffic` / 네트워크 허용으로 WebView 리소스 로드 가능
- iOS: App Transport Security가 WebView 내부 외부 리소스(스크립트·타일·CDN)를 막을 수 있음
- 플러그인 README는 `NSAllowsArbitraryLoadsInWebContent` 를 요구
- 기존 Info.plist는 도메인별 `NSExceptionDomains`만 있고 WebContent 허용이 없었음

## 변경 요약

[`ios/Runner/Info.plist`](../../ios/Runner/Info.plist) `NSAppTransportSecurity`에 추가:

```xml
<key>NSAllowsArbitraryLoadsInWebContent</key>
<true/>
```

기존 Seoul/Kakao 도메인 예외는 유지. 앱 전역 `NSAllowsArbitraryLoads`보다 WebView 범위만 열어 App Store 관점에서 유리하다.

## 검증

1. `flutter clean && flutter run` (iOS)
2. 홈 → 주변 명소 / 선착장 지도에서 타일 표시
3. 홈 날씨·실시간(서울시 API) 정상 여부

여전히 비면: 완전 재빌드 → (최후) `NSAllowsArbitraryLoads` → 카카오 JS 키/번들 제한 확인
