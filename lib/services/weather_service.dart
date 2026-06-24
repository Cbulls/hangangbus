import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hangangbus/models/weather_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WeatherService
//
// SeoulApiService.getCompleteData() 와 독립적으로도 사용 가능합니다.
// tab1_home.dart 에서 직접 호출하거나,
// SeoulApiService 를 통해 WeatherData.fromJson() 으로 받아써도 됩니다.
//
// 사용 예:
//   // (A) SeoulApiService 경유 — 한 번의 API 호출로 실시간 + 날씨 동시 수신
//   final result = await SeoulApiService.getCompleteData('여의도한강공원');
//   final weather = result['weather'] as WeatherData?;
//
//   // (B) WeatherService 단독 호출
//   final weather = await WeatherService.fetch('여의도한강공원');
//
//   print(weather?.current.temperature);  // → 실시간 기온(°C)
//
// .env 에 SEOUL_API_KEY=YOUR_KEY 를 설정하세요.
// ─────────────────────────────────────────────────────────────────────────────

class WeatherService {
  static const String _baseUrl = 'http://openapi.seoul.go.kr:8088';

  // 서울시 120장소 목록에 등록된 한강공원 장소명 매핑
  // 목록에 없는 공원은 가장 가까운 등록 장소를 사용
  static const Map<String, String> _parkAreaMap = {
    '여의도한강공원': '여의도한강공원',
    '망원한강공원': '망원한강공원',
    '마곡나루역': '여의도한강공원',
    '뚝섬한강공원': '뚝섬한강공원',
    '잠실한강공원': '잠실한강공원',
    '가양': '여의도한강공원', // 미등록 → 여의도 대체
    '난지': '망원한강공원', // 미등록 → 망원 대체
    '이촌한강공원': '이촌한강공원',
    '반포한강공원': '반포한강공원',
  };

  static String get _apiKey => dotenv.env['SEOUL_API_KEY'] ?? '';

  /// 공원 이름으로 날씨 데이터 단독 조회
  static Future<WeatherData?> fetch(String parkAreaName) async {
    debugPrint(
      '🔑 SEOUL_API_KEY 길이: ${_apiKey.length} '
      '(0이면 .env 미로드)',
    );
    if (_apiKey.isEmpty) {
      debugPrint('⚠️ SEOUL_API_KEY 가 .env 에 설정되지 않았습니다. fallback 사용.');
      return fetchSeoulFallback();
    }

    final areaName = _parkAreaMap[parkAreaName] ?? parkAreaName;

    try {
      final uri = Uri.parse(
        '$_baseUrl/$_apiKey/json/citydata/1/1/${Uri.encodeComponent(areaName)}',
      );

      debugPrint('🌐 날씨 API 호출: $areaName');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) {
        debugPrint('❌ HTTP 오류: ${res.statusCode}');
        return fetchSeoulFallback();
      }

      final body =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      if (!body.containsKey('CITYDATA')) {
        final code = body['RESULT']?['CODE'] ?? '?';
        final msg = body['RESULT']?['MESSAGE'] ?? '알 수 없는 오류';
        debugPrint('⚠️ API 응답 오류 [$code]: $msg');
        return fetchSeoulFallback();
      }

      debugPrint('✅ 날씨 수신 성공: $areaName');
      final parsed = WeatherData.fromJson(
        body['CITYDATA'] as Map<String, dynamic>,
        areaName,
      );
      debugPrint(
        '🌡️ 파싱 결과: 기온 ${parsed.current.temperature}°, '
        '습도 ${parsed.current.humidity}%',
      );
      return parsed;
    } catch (e) {
      debugPrint('❌ 날씨 fetch 에러 ($parkAreaName): $e');
      return fetchSeoulFallback();
    }
  }

  /// 서울시 API 실패 시 사용하는 공개 날씨 fallback.
  /// API 키 없이 서울 중심 좌표의 현재 기온 + 미세먼지(대기질)를 조회합니다.
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

      // 날씨 + 대기질 병렬 호출 (대기질 실패해도 날씨는 표시)
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

      if (weatherRes.statusCode != 200) {
        debugPrint('❌ Open-Meteo HTTP 오류: ${weatherRes.statusCode}');
        return null;
      }

      final body =
          jsonDecode(utf8.decode(weatherRes.bodyBytes)) as Map<String, dynamic>;

      Map<String, dynamic>? airBody;
      if (airRes != null && airRes.statusCode == 200) {
        airBody =
            jsonDecode(utf8.decode(airRes.bodyBytes)) as Map<String, dynamic>;
        debugPrint('🌫️ Open-Meteo 대기질 수신 성공');
      } else {
        debugPrint('⚠️ Open-Meteo 대기질 미수신 (미세먼지 정보없음 처리)');
      }

      debugPrint('🌡️ fallback 파싱(기온+미세먼지) 완료');
      return WeatherData.fromOpenMeteo(body, air: airBody);
    } catch (e) {
      debugPrint('❌ Open-Meteo 날씨 fetch 에러: $e');
      return null;
    }
  }
}
