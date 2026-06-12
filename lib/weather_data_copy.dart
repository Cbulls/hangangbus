// import 'dart:ui';

// class WeatherData {
//   final String areaName;
//   final CurrentWeather current;
//   final List<HourlyForecast> hourlyForecasts;

//   WeatherData({
//     required this.areaName,
//     required this.current,
//     required this.hourlyForecasts,
//   });

//   factory WeatherData.fromJson(Map<String, dynamic> json, String areaName) {
//     final weatherList = json['WEATHER_STTS'] as List?;

//     if (weatherList == null || weatherList.isEmpty) {
//       return WeatherData(
//         areaName: areaName,
//         current: CurrentWeather.empty(),
//         hourlyForecasts: [],
//       );
//     }

//     final weatherData = weatherList[0] as Map<String, dynamic>;

//     return WeatherData(
//       areaName: areaName,
//       current: CurrentWeather.fromJson(weatherData),
//       hourlyForecasts: _parseHourlyForecasts(weatherData),
//     );
//   }

//   static List<HourlyForecast> _parseHourlyForecasts(Map<String, dynamic> json) {
//     final List<HourlyForecast> forecasts = [];

//     // 기상청 API는 3시간 단위로 제공되므로 8개 항목 (24시간)
//     for (int i = 0; i < 8; i++) {
//       final forecast = HourlyForecast.fromJson(json, i);
//       if (forecast != null) {
//         forecasts.add(forecast);
//       }
//     }

//     return forecasts;
//   }
// }

// class CurrentWeather {
//   final double temperature; // 현재 기온
//   final String skyStatus; // 하늘 상태 (맑음/흐림/비)
//   final int precipitation; // 강수량 (mm)
//   final double humidity; // 습도 (%)
//   final String windSpeed; // 풍속 (m/s)
//   final int pm10; // 미세먼지 (㎍/㎥)
//   final int pm25; // 초미세먼지 (㎍/㎥)
//   final String uvIndex; // 자외선 지수
//   final String sensoryTemp; // 체감온도

//   CurrentWeather({
//     required this.temperature,
//     required this.skyStatus,
//     required this.precipitation,
//     required this.humidity,
//     required this.windSpeed,
//     required this.pm10,
//     required this.pm25,
//     required this.uvIndex,
//     required this.sensoryTemp,
//   });

//   factory CurrentWeather.fromJson(Map<String, dynamic> json) {
//     return CurrentWeather(
//       temperature: _parseDouble(json['TEMP'] ?? json['TMP']),
//       skyStatus: _parseSkyStatus(json['SKY'] ?? json['PTY']),
//       precipitation: _parseInt(json['PCP'] ?? json['RN1']),
//       humidity: _parseDouble(json['REH'] ?? json['HUM']),
//       windSpeed: json['WSD']?.toString() ?? '0',
//       pm10: _parseInt(json['PM10']),
//       pm25: _parseInt(json['PM25']),
//       uvIndex: json['UV_INDEX']?.toString() ?? '보통',
//       sensoryTemp:
//           json['SENSORY_TEMP']?.toString() ?? '${_parseDouble(json['TEMP'])}',
//     );
//   }

//   factory CurrentWeather.empty() {
//     return CurrentWeather(
//       temperature: 0,
//       skyStatus: '정보 없음',
//       precipitation: 0,
//       humidity: 0,
//       windSpeed: '0',
//       pm10: 0,
//       pm25: 0,
//       uvIndex: '보통',
//       sensoryTemp: '0',
//     );
//   }

//   String get weatherIcon {
//     if (skyStatus.contains('비') || skyStatus.contains('소나기')) return '🌧️';
//     if (skyStatus.contains('눈')) return '❄️';
//     if (skyStatus.contains('흐림')) return '☁️';
//     if (skyStatus.contains('구름')) return '⛅';
//     return '☀️';
//   }

//   String get pm10Level {
//     if (pm10 <= 30) return '좋음';
//     if (pm10 <= 80) return '보통';
//     if (pm10 <= 150) return '나쁨';
//     return '매우나쁨';
//   }

//   Color get pm10Color {
//     if (pm10 <= 30) return const Color(0xFF4CAF50);
//     if (pm10 <= 80) return const Color(0xFFFFC107);
//     if (pm10 <= 150) return const Color(0xFFFF9800);
//     return const Color(0xFFE53935);
//   }

//   static double _parseDouble(dynamic value) {
//     if (value == null) return 0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     return double.tryParse(value.toString()) ?? 0;
//   }

//   static int _parseInt(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is double) return value.toInt();
//     return int.tryParse(value.toString()) ?? 0;
//   }

//   static String _parseSkyStatus(dynamic value) {
//     if (value == null) return '정보 없음';
//     final code = value.toString();

//     // PTY (강수형태)
//     if (code == '1') return '비';
//     if (code == '2') return '비/눈';
//     if (code == '3') return '눈';
//     if (code == '4') return '소나기';

//     // SKY (하늘상태)
//     if (code == '1') return '맑음';
//     if (code == '3') return '구름많음';
//     if (code == '4') return '흐림';

//     return '정보 없음';
//   }
// }

// class HourlyForecast {
//   final DateTime time;
//   final double temperature;
//   final String skyStatus;
//   final int precipitationProbability; // 강수확률 (%)
//   final String weatherIcon;

//   HourlyForecast({
//     required this.time,
//     required this.temperature,
//     required this.skyStatus,
//     required this.precipitationProbability,
//     required this.weatherIcon,
//   });

//   static HourlyForecast? fromJson(Map<String, dynamic> json, int hourOffset) {
//     try {
//       // 3시간 단위 예보 데이터 파싱
//       final tempKey = 'FCST${hourOffset}_TEMP';
//       final skyKey = 'FCST${hourOffset}_SKY';
//       final popKey = 'FCST${hourOffset}_POP'; // 강수확률

//       if (!json.containsKey(tempKey)) return null;

//       final temp = CurrentWeather._parseDouble(json[tempKey]);
//       final sky = CurrentWeather._parseSkyStatus(json[skyKey]);
//       final pop = CurrentWeather._parseInt(json[popKey]);

//       return HourlyForecast(
//         time: DateTime.now().add(Duration(hours: hourOffset * 3)),
//         temperature: temp,
//         skyStatus: sky,
//         precipitationProbability: pop,
//         weatherIcon: _getWeatherIcon(sky, pop),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static String _getWeatherIcon(String skyStatus, int pop) {
//     if (skyStatus.contains('비') || pop >= 70) return '🌧️';
//     if (skyStatus.contains('눈')) return '❄️';
//     if (skyStatus.contains('흐림')) return '☁️';
//     if (skyStatus.contains('구름')) return '⛅';
//     return '☀️';
//   }

//   String get timeString {
//     final hour = time.hour;
//     if (hour == 0) return '자정';
//     if (hour < 12) return '오전 ${hour}시';
//     if (hour == 12) return '정오';
//     return '오후 ${hour - 12}시';
//   }
// }
