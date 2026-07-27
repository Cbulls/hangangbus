import 'package:flutter/foundation.dart';
import 'package:hangangbus/config/app_config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// 크래시/이벤트 텔레메트리 파사드.
///
/// [AppConfig.sentryDsn] 이 비어 있으면 no-op (로컬/CI 안전).
class AppTelemetry {
  AppTelemetry._();

  static bool _ready = false;

  /// Sentry가 설정된 경우만 SDK를 초기화한 뒤 [appRunner] 실행.
  static Future<void> run(Future<void> Function() appRunner) async {
    if (!AppConfig.hasSentry) {
      await appRunner();
      return;
    }

    await SentryFlutter.init((options) {
      options.dsn = AppConfig.sentryDsn;
      options.tracesSampleRate = kDebugMode ? 0.0 : 0.2;
      options.environment = kDebugMode ? 'debug' : 'release';
    }, appRunner: appRunner);
    _ready = true;
  }

  static Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
  }) async {
    if (!_ready) {
      debugPrint('telemetry(exception): $error ${hint ?? ''}');
      return;
    }
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: hint == null ? null : Hint.withMap({'hint': hint}),
    );
  }

  static Future<void> breadcrumb(String message, {String category = 'app'}) async {
    if (!_ready) return;
    await Sentry.addBreadcrumb(
      Breadcrumb(message: message, category: category),
    );
  }

  /// 탭 전환 등 화면 이벤트.
  static Future<void> screen(String name) =>
      breadcrumb('screen:$name', category: 'navigation');

  /// API/데이터 계층 실패.
  static Future<void> apiError(String api, Object error) =>
      captureException(error, hint: 'api:$api');
}
