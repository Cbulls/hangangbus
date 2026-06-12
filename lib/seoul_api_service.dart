import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hangangbus/hangang_realtime_data.dart';
import 'package:hangangbus/weather_data.dart';
import 'package:http/http.dart' as http;

class SeoulApiService {
  static final String _baseUrl = 'http://openapi.seoul.go.kr:8088';
  static final String _apiKey = dotenv.env['SEOUL_API_KEY'] ?? '';

  /// 통합 데이터 로드 (서울시 실시간 도시데이터 API 최적화 버전)
  static Future<Map<String, dynamic>> getCompleteData(String areaName) async {
    if (_apiKey.isEmpty) {
      print('❌ API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
      return {'realtime': null, 'weather': null};
    }

    // 호출 위치(1/1)와 장소명(areaName)을 포함한 URL 생성
    final url = Uri.parse('$_baseUrl/$_apiKey/json/citydata/1/1/$areaName');

    try {
      print('🌐 API 호출 시작: $areaName');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위한 utf8 디코딩
        final Map<String, dynamic> jsonData = json.decode(
          utf8.decode(response.bodyBytes),
        );

        // 1. 성공 데이터(CITYDATA) 존재 여부 확인
        // 이 API는 성공 시 최상위에 CITYDATA 키를 둡니다.
        if (jsonData.containsKey('CITYDATA')) {
          final cityData = jsonData['CITYDATA'];

          print('✅ $areaName 데이터 수신 성공');

          // 모델 클래스(fromJson)가 CITYDATA 내부 구조를 바로 읽을 수 있도록
          // cityData 노드를 직접 넘겨주는 것이 훨씬 안전하고 깔끔합니다.
          return {
            'realtime': HangangRealtimeData.fromJson(cityData, areaName),
            'weather': WeatherData.fromJson(cityData, areaName),
          };
        }

        // 2. 실패 시 RESULT 키 확인 (데이터 없음 혹은 키 오류 등)
        if (jsonData.containsKey('RESULT')) {
          final result = jsonData['RESULT'];
          print('⚠️ API 응답 제한/오류: [${result['CODE']}] ${result['MESSAGE']}');
        } else {
          print('❌ 알 수 없는 응답 구조: $jsonData');
        }

        return {'realtime': null, 'weather': null};
      } else {
        print('❌ HTTP 오류 발생: ${response.statusCode}');
        return {'realtime': null, 'weather': null};
      }
    } catch (e) {
      print('❌ 네트워크 또는 파싱 에러 ($areaName): $e');
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
