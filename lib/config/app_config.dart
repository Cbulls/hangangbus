/// 빌드 타임 시크릿/설정.
///
/// 키는 바이너리 asset(.env)이 아니라 `--dart-define` 으로만 주입한다.
///
/// ```bash
/// flutter run \
///   --dart-define=KAKAO_APP_KEY=xxx \
///   --dart-define=SEOUL_API_KEY=yyy \
///   --dart-define=SENTRY_DSN=https://...
/// ```
class AppConfig {
  AppConfig._();

  static const String kakaoAppKey = String.fromEnvironment('KAKAO_APP_KEY');
  static const String seoulApiKey = String.fromEnvironment('SEOUL_API_KEY');
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// 앱 내 개인정보처리방침 링크 (스토어 리스팅과 동일 URL 유지).
  static const String privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://heeyun.github.io/hangangbus/privacy',
  );

  static bool get hasKakaoKey => kakaoAppKey.isNotEmpty;
  static bool get hasSeoulKey => seoulApiKey.isNotEmpty;
  static bool get hasSentry => sentryDsn.isNotEmpty;
}
