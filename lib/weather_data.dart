import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// 데이터 모델
// 서울시 실시간 도시데이터 API: CITYDATA > WEATHER[0] 필드 기준
//
// 주요 필드:
//   TEMP           기온(°C)
//   SENSIBLE_TEMP  체감온도(°C)
//   HUMIDITY       습도(%)
//   WIND_SPD       풍속(m/s)
//   WIND_DIRCT     풍향
//   SKY_STTS       하늘상태 ("맑음" / "구름조금" / "구름많음" / "흐림" 등)
//   PRECIPITATION  강수량(mm, 없으면 "-")
//   PM10           미세먼지(µg/m³)
//   PM25           초미세먼지(µg/m³)
//   UV_INDEX       자외선지수
//   WEATHER_TIME   데이터 업데이트 시각
// ─────────────────────────────────────────────────────────────────────────────

class CurrentWeather {
  final double temperature; // TEMP
  final double sensoryTemp; // SENSIBLE_TEMP
  final double humidity; // HUMIDITY
  final double windSpeed; // WIND_SPD
  final String windDirection; // WIND_DIRCT
  final String skyStatus; // SKY_STTS (원본 한글)
  final String weatherIcon; // SKY_STTS + 시간 기반 이모지
  final String precipitation; // PRECIPITATION
  final int pm10; // PM10
  final int pm25; // PM25
  final String pm10Level; // 좋음 / 보통 / 나쁨 / 매우나쁨
  final Color pm10Color;
  final String uvIndex; // UV_INDEX
  final String weatherTime; // WEATHER_TIME

  const CurrentWeather({
    required this.temperature,
    required this.sensoryTemp,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.skyStatus,
    required this.weatherIcon,
    required this.precipitation,
    required this.pm10,
    required this.pm25,
    required this.pm10Level,
    required this.pm10Color,
    required this.uvIndex,
    required this.weatherTime,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// WeatherData — SeoulApiService 에서 넘겨받은 CITYDATA 맵을 직접 파싱
// ─────────────────────────────────────────────────────────────────────────────

class WeatherData {
  final CurrentWeather current;

  const WeatherData({required this.current});

  factory WeatherData.fromOpenMeteo(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final temp = _toDouble(current['temperature_2m'], 10.0);
    final humidity = _toDouble(current['relative_humidity_2m'], 60.0);
    final windSpeed = _toDouble(current['wind_speed_10m'], 1.5);
    final weatherCode = int.tryParse(current['weather_code']?.toString() ?? '');

    return WeatherData(
      current: CurrentWeather(
        temperature: temp,
        sensoryTemp: temp,
        humidity: humidity,
        windSpeed: windSpeed,
        windDirection: '',
        skyStatus: _openMeteoSkyStatus(weatherCode),
        weatherIcon: _openMeteoIcon(weatherCode),
        precipitation: '-',
        pm10: 0,
        pm25: 0,
        pm10Level: '정보 없음',
        pm10Color: const Color(0xFF78909C),
        uvIndex: '-',
        weatherTime: current['time']?.toString() ?? '',
      ),
    );
  }

  // cityData = jsonData['CITYDATA']  (SeoulApiService 와 동일한 인터페이스)
  factory WeatherData.fromJson(Map<String, dynamic> cityData, String areaName) {
    // WEATHER 는 배열. 첫 번째 항목 사용
    final weatherList = cityData['WEATHER_STTS'] as List?;
    if (weatherList == null || weatherList.isEmpty) {
      print('⚠️ 날씨 데이터(WEATHER_STTS)를 찾을 수 없습니다.');
    }
    final w = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final temp = _toDouble(w['TEMP'], 10.0);
    final sensory = _toDouble(w['SENSIBLE_TEMP'], temp);
    final humidity = _toDouble(w['HUMIDITY'], 60.0);
    final windSpd = _toDouble(w['WIND_SPD'], 1.5);
    final windDir = _str(w['WIND_DIRCT'], '');
    final skyRaw = _str(w['SKY_STTS'], '맑음');
    final precip = _str(w['PRECIPITATION'], '-');
    final pm10val = _toDouble(w['PM10'], 30.0).toInt();
    final pm25val = _toDouble(w['PM25'], 15.0).toInt();
    final uvIndex = _str(w['UV_INDEX'], '-');
    final wTime = _str(w['WEATHER_TIME'], '');

    // 강수 여부 판단 (값이 "-" 이거나 "0" 이면 강수 없음)
    final isRain = precip != '-' && precip != '0' && precip.isNotEmpty;

    final hour = DateTime.now().hour;
    final icon = isRain ? _rainIcon(skyRaw) : _skyIcon(skyRaw, hour);

    final pm10Info = _pm10Info(pm10val);

    return WeatherData(
      current: CurrentWeather(
        temperature: temp,
        sensoryTemp: sensory,
        humidity: humidity,
        windSpeed: windSpd,
        windDirection: windDir,
        skyStatus: skyRaw,
        weatherIcon: icon,
        precipitation: precip,
        pm10: pm10val,
        pm25: pm25val,
        pm10Level: pm10Info.$1,
        pm10Color: pm10Info.$2,
        uvIndex: uvIndex,
        weatherTime: wTime,
      ),
    );
  }

  // ── 내부 헬퍼 ──────────────────────────────────────────────────────────────

  static double _toDouble(dynamic v, double fallback) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(',', '').trim()) ?? fallback;
  }

  static String _str(dynamic v, String fallback) =>
      v?.toString().trim().isNotEmpty == true ? v.toString().trim() : fallback;

  /// 맑음·구름 상태 → 낮/밤 이모지
  static String _skyIcon(String sky, int hour) {
    final isDay = hour >= 6 && hour < 19;
    if (sky.contains('맑')) return isDay ? '☀️' : '🌙';
    if (sky.contains('구름조금')) return isDay ? '🌤️' : '🌙';
    if (sky.contains('구름많')) return isDay ? '⛅' : '🌥️';
    if (sky.contains('흐')) return '☁️';
    return isDay ? '🌤️' : '🌙';
  }

  /// 강수 상태 → 이모지
  static String _rainIcon(String sky) {
    if (sky.contains('눈')) return '❄️';
    if (sky.contains('비') && sky.contains('눈')) return '🌨️';
    return '🌧️';
  }

  /// PM10 등급 및 색상
  static (String, Color) _pm10Info(int val) {
    if (val <= 30) return ('좋음', const Color(0xFF00C853));
    if (val <= 80) return ('보통', const Color(0xFF2196F3));
    if (val <= 150) return ('나쁨', const Color(0xFFFF9800));
    return ('매우나쁨', const Color(0xFFE53935));
  }

  static String _openMeteoSkyStatus(int? code) {
    if (code == null) return '정보 없음';
    if (code == 0) return '맑음';
    if (code <= 3) return '구름많음';
    if (code >= 51 && code <= 67) return '비';
    if (code >= 71 && code <= 77) return '눈';
    if (code >= 80 && code <= 82) return '비';
    return '흐림';
  }

  static String _openMeteoIcon(int? code) {
    final hour = DateTime.now().hour;
    final sky = _openMeteoSkyStatus(code);
    if (sky == '비') return '🌧️';
    if (sky == '눈') return '❄️';
    return _skyIcon(sky, hour);
  }
}

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
    if (_apiKey.isEmpty) {
      debugPrint('⚠️ SEOUL_API_KEY 가 .env 에 설정되지 않았습니다.');
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
      return WeatherData.fromJson(
        body['CITYDATA'] as Map<String, dynamic>,
        areaName,
      );
    } catch (e) {
      debugPrint('❌ 날씨 fetch 에러 ($parkAreaName): $e');
      return fetchSeoulFallback();
    }
  }

  /// 서울시 API 실패 시 사용하는 공개 기온 fallback.
  /// API 키 없이 서울 중심 좌표의 현재 기온을 조회합니다.
  static Future<WeatherData?> fetchSeoulFallback() async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=37.5665&longitude=126.9780'
        '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code'
        '&timezone=Asia%2FSeoul',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) {
        debugPrint('❌ Open-Meteo HTTP 오류: ${res.statusCode}');
        return null;
      }

      final body =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      return WeatherData.fromOpenMeteo(body);
    } catch (e) {
      debugPrint('❌ Open-Meteo 날씨 fetch 에러: $e');
      return null;
    }
  }
}
