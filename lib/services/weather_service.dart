import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hangangbus/config/app_config.dart';
import 'package:hangangbus/models/weather_data.dart';
import 'package:hangangbus/services/app_telemetry.dart';
import 'package:http/http.dart' as http;

/// 서울시 CITYDATA 기반 날씨 조회 (+ Open-Meteo 폴백).
///
/// 앱 런타임 날씨는 [WeatherBloc]이 `여의도한강공원` 대표 1건만 조회한다.
/// 이 맵은 하위 호환·직접 `fetch(park)` 호출용이다. 마곡 관련 키는
/// 실시간 CITYDATA 장소(`서울식물원·마곡나루역`)와 무관하게 여의도로 보낸다
/// (선착장별 기온 차이를 내지 않기 위함).
///
/// `SEOUL_API_KEY` 는 `--dart-define=SEOUL_API_KEY=...` 로 주입한다.
class WeatherService {
  static const String _baseUrl = 'http://openapi.seoul.go.kr:8088';

  static const Map<String, String> _parkAreaMap = {
    '여의도한강공원': '여의도한강공원',
    '망원한강공원': '망원한강공원',
    // 마곡: 날씨는 서울 대표(여의도). 실시간은 DockCatalog의 식물원 합성명 사용.
    '마곡나루역': '여의도한강공원',
    '서울식물원·마곡나루역': '여의도한강공원',
    '뚝섬한강공원': '뚝섬한강공원',
    '잠실한강공원': '잠실한강공원',
    '가양': '여의도한강공원',
    '난지': '망원한강공원',
    '이촌한강공원': '이촌한강공원',
    '반포한강공원': '반포한강공원',
  };

  static String get _apiKey => AppConfig.seoulApiKey;

  static Future<WeatherData?> fetch(String parkAreaName) async {
    if (_apiKey.isEmpty) {
      debugPrint('SEOUL_API_KEY 미설정 — Open-Meteo fallback 사용');
      return fetchSeoulFallback();
    }

    final areaName = _parkAreaMap[parkAreaName] ?? parkAreaName;

    try {
      final uri = Uri.parse(
        '$_baseUrl/$_apiKey/json/citydata/1/1/${Uri.encodeComponent(areaName)}',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        return fetchSeoulFallback();
      }

      final body =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      if (!body.containsKey('CITYDATA')) {
        return fetchSeoulFallback();
      }

      return WeatherData.fromJson(
        body['CITYDATA'] as Map<String, dynamic>,
        areaName,
      );
    } catch (e, st) {
      debugPrint('날씨 fetch 에러 ($parkAreaName): $e');
      await AppTelemetry.captureException(e, stackTrace: st, hint: 'weather');
      return fetchSeoulFallback();
    }
  }

  /// 서울시 API 실패 시 공개 Open-Meteo 폴백.
  static Future<WeatherData?> fetchSeoulFallback() async {
    try {
      final weatherUri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=37.5665&longitude=126.9780'
        '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code'
        '&timezone=Asia%2FSeoul',
      );
      final airUri = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality'
        '?latitude=37.5665&longitude=126.9780'
        '&current=pm10,pm2_5'
        '&timezone=Asia%2FSeoul',
      );

      final results = await Future.wait([
        http.get(weatherUri).timeout(const Duration(seconds: 5)),
        http
            .get(airUri)
            .timeout(const Duration(seconds: 5))
            .then<http.Response?>((r) => r)
            .catchError((_) => null),
      ]);

      final weatherRes = results[0] as http.Response;
      final airRes = results[1];

      if (weatherRes.statusCode != 200) return null;

      final body =
          jsonDecode(utf8.decode(weatherRes.bodyBytes)) as Map<String, dynamic>;

      Map<String, dynamic>? airBody;
      if (airRes != null && airRes.statusCode == 200) {
        airBody =
            jsonDecode(utf8.decode(airRes.bodyBytes)) as Map<String, dynamic>;
      }

      return WeatherData.fromOpenMeteo(body, air: airBody);
    } catch (e, st) {
      debugPrint('Open-Meteo 날씨 fetch 에러: $e');
      await AppTelemetry.captureException(
        e,
        stackTrace: st,
        hint: 'weather_fallback',
      );
      return null;
    }
  }
}
