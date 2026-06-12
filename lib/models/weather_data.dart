import 'package:flutter/material.dart';

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
      debugPrint('⚠️ 날씨 데이터(WEATHER_STTS)를 찾을 수 없습니다.');
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
