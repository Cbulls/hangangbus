import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hangangbus/models/hangang_realtime_data.dart';
import 'package:hangangbus/models/weather_data.dart';
import 'package:http/http.dart' as http;

/// 대용량 CITYDATA 응답을 백그라운드 아이솔레이트에서 디코딩/파싱한다.
/// (compute 콜백은 최상위 함수여야 하므로 클래스 밖에 둔다.)
Map<String, dynamic> _parseCityDataResponse((Uint8List, String) input) {
  final bytes = input.$1;
  final areaName = input.$2;
  // 한글 깨짐 방지를 위한 utf8 디코딩
  final Map<String, dynamic> jsonData = json.decode(utf8.decode(bytes));

  if (jsonData.containsKey('CITYDATA')) {
    final cityData = jsonData['CITYDATA'];
    return {
      'realtime': HangangRealtimeData.fromJson(cityData, areaName),
      'weather': WeatherData.fromJson(cityData, areaName),
    };
  }

  if (jsonData.containsKey('RESULT')) {
    final result = jsonData['RESULT'];
    return {
      'realtime': null,
      'weather': null,
      'message': '[${result['CODE']}] ${result['MESSAGE']}',
    };
  }

  return {'realtime': null, 'weather': null, 'message': '알 수 없는 응답 구조'};
}

/// 지역별 CITYDATA 단기 캐시 엔트리.
class _CityDataCacheEntry {
  final DateTime time;
  final Map<String, dynamic> data;
  const _CityDataCacheEntry(this.time, this.data);
}

class SeoulApiService {
  static final String _baseUrl = 'http://openapi.seoul.go.kr:8088';
  static final String _apiKey = dotenv.env['SEOUL_API_KEY'] ?? '';

  // 지역별 CITYDATA 단기 캐시: 같은 지역을 여러 Bloc(날씨/실시간)이
  // 중복 호출하는 것을 막는다(예: 여의도한강공원).
  static final Map<String, _CityDataCacheEntry> _cache = {};
  static const Duration _cacheTtl = Duration(seconds: 60);

  /// 타임아웃/일시적 네트워크 오류 시 1회 재시도하는 HTTP GET.
  /// 각 시도는 10초 타임아웃을 유지한다.
  static Future<http.Response> _getWithRetry(Uri url, {int retries = 1}) async {
    int attempt = 0;
    while (true) {
      try {
        return await http.get(url).timeout(const Duration(seconds: 10));
      } catch (e) {
        if (attempt >= retries) rethrow;
        attempt++;
        debugPrint('⏳ 재시도 $attempt회 ($url): $e');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  /// 통합 데이터 로드 (서울시 실시간 도시데이터 API 최적화 버전)
  static Future<Map<String, dynamic>> getCompleteData(String areaName) async {
    if (_apiKey.isEmpty) {
      debugPrint('❌ API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
      return {'realtime': null, 'weather': null};
    }

    // 단기 캐시 히트 시 네트워크/파싱을 생략하고 재사용.
    final cached = _cache[areaName];
    if (cached != null && DateTime.now().difference(cached.time) < _cacheTtl) {
      return cached.data;
    }

    // 호출 위치(1/1)와 장소명(areaName)을 포함한 URL 생성
    final url = Uri.parse('$_baseUrl/$_apiKey/json/citydata/1/1/$areaName');

    try {
      debugPrint('🌐 API 호출 시작: $areaName');
      final response = await _getWithRetry(url);

      if (response.statusCode == 200) {
        // 디코딩+파싱은 payload 가 커서 UI 프레임 드랍을 유발할 수 있으므로
        // compute()로 백그라운드 아이솔레이트에서 처리한다.
        final parsed = await compute(
          _parseCityDataResponse,
          (response.bodyBytes, areaName),
        );

        final result = {
          'realtime': parsed['realtime'],
          'weather': parsed['weather'],
        };

        if (parsed['realtime'] != null) {
          debugPrint('✅ $areaName 데이터 수신 성공');
          // 성공 결과만 캐시(실패/제한 응답은 캐시하지 않음).
          _cache[areaName] = _CityDataCacheEntry(DateTime.now(), result);
        } else if (parsed['message'] != null) {
          debugPrint('⚠️ API 응답 제한/오류: ${parsed['message']}');
        }

        return result;
      } else {
        debugPrint('❌ HTTP 오류 발생: ${response.statusCode}');
        return {'realtime': null, 'weather': null};
      }
    } catch (e) {
      debugPrint('❌ 네트워크 또는 파싱 에러 ($areaName): $e');
      return {'realtime': null, 'weather': null};
    }
  }

  /// (참고) 여러 지역 순차 조회 시 호출 제한 방지를 위한 지연 시간 권장
  static Future<Map<String, dynamic>> getMultipleAreasData(
    List<String> areaNames,
  ) async {
    final Map<String, dynamic> allResults = {};
    for (var name in areaNames) {
      allResults[name] = await getCompleteData(name);
      // 초당 호출 제한(Throttling)을 피하기 위한 미세한 지연
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return allResults;
  }
}
