// ignore_for_file: avoid_print
/// 서울시 CITYDATA + Open-Meteo 실네트워크 성능 벤치마크 (순수 Dart).
///
/// Flutter/`SeoulApiService` 에 의존하지 않는다. 캐시는 앱과 동일한 60s TTL 로직을
/// 이 스크립트 안에서 미러링해 검증한다.
///
/// ```bash
/// export SEOUL_API_KEY="$(grep '^SEOUL_API_KEY=' .env | cut -d= -f2-)"
/// dart run tool/api_perf_bench.dart
/// ```
///
/// 의존: `http` (프로젝트 pubspec). 키는 로그/리포트에 출력하지 않는다.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

const _areas = [
  '여의도한강공원',
  '망원한강공원',
  '서울식물원·마곡나루역',
  '뚝섬한강공원',
  '잠실한강공원',
];

const _coldRuns = 5;
const _throttleMs = 300;
const _baseUrl = 'http://openapi.seoul.go.kr:8088';
const _cacheTtl = Duration(seconds: 60);

/// SeoulApiService 와 동일한 60s 캐시 미러.
final Map<String, ({DateTime time, Map<String, dynamic> data})> _cache = {};

void main() async {
  final apiKey = Platform.environment['SEOUL_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    stderr.writeln(
      'SEOUL_API_KEY 가 없습니다.\n'
      '  export SEOUL_API_KEY="\$(grep \'^SEOUL_API_KEY=\' .env | cut -d= -f2-)"\n'
      '  dart run tool/api_perf_bench.dart',
    );
    exit(1);
  }

  final lines = <String>[];
  void log(String s) {
    print(s);
    lines.add(s);
  }

  final started = DateTime.now().toUtc();
  log('# API Performance Report');
  log('');
  log('- Generated (UTC): `${started.toIso8601String()}`');
  log('- Cold runs per area: $_coldRuns');
  log('- Throttle between calls: ${_throttleMs}ms');
  log('- API key: `(redacted, length=${apiKey.length})`');
  log('');

  log('## Seoul CITYDATA (cold)');
  log('');
  log('| Area | ok | p50 http | p95 http | avg http | p50 parse | avg bytes | notes |');
  log('|------|----|----------|----------|----------|-----------|-----------|-------|');

  final allHttp = <int>[];
  final allParse = <int>[];
  var successCount = 0;
  var totalAttempts = 0;

  for (final area in _areas) {
    final summary = await _benchAreaCold(apiKey, area);
    successCount += summary.successes;
    totalAttempts += summary.attempts;
    allHttp.addAll(summary.httpMs);
    allParse.addAll(summary.parseMs);

    log(
      '| $area | ${summary.successes}/$_coldRuns | '
      '${_fmtMs(summary.httpP50)} | ${_fmtMs(summary.httpP95)} | '
      '${_fmtMs(summary.httpAvg)} | ${_fmtMs(summary.parseP50)} | '
      '${summary.avgBytes.round()} | ${summary.notes} |',
    );

    await Future<void>.delayed(const Duration(milliseconds: _throttleMs));
  }

  final overallSuccessRate =
      totalAttempts == 0 ? 0.0 : successCount / totalAttempts;
  final httpP95 = _percentile(allHttp, 0.95);
  log('');
  log('### Overall CITYDATA');
  log('');
  log('- Success rate: **${(overallSuccessRate * 100).toStringAsFixed(1)}%** '
      '($successCount/$totalAttempts)');
  log('- HTTP p50: **${_fmtMs(_percentile(allHttp, 0.50))}**');
  log('- HTTP p95: **${_fmtMs(httpP95)}**');
  log('- Parse p50: **${_fmtMs(_percentile(allParse, 0.50))}**');
  log('- Criterion HTTP p95 < 3000ms: '
      '**${httpP95 < 3000 ? "PASS" : "FAIL"}**');
  log('- Criterion success ≥ 80%: '
      '**${overallSuccessRate >= 0.80 ? "PASS" : "FAIL"}**');
  log('');

  // Cache mirror (same semantics as SeoulApiService)
  log('## Cache mirror (60s TTL, same as SeoulApiService)');
  log('');
  const cacheArea = '여의도한강공원';
  _cache.clear();
  final t1 = Stopwatch()..start();
  final r1 = await _getCompleteDataCached(apiKey, cacheArea);
  t1.stop();
  final t2 = Stopwatch()..start();
  final r2 = await _getCompleteDataCached(apiKey, cacheArea);
  t2.stop();
  final hitOk =
      t2.elapsedMilliseconds < 5 && r1['ok'] == true && r2['ok'] == true;
  log('| Call | Latency | ok |');
  log('|------|---------|----|');
  log('| 1st (miss/network) | ${t1.elapsedMilliseconds}ms | ${r1['ok']} |');
  log('| 2nd (expect cache) | ${t2.elapsedMilliseconds}ms | ${r2['ok']} |');
  log('');
  log('- Cache hit criterion (2nd < 5ms + data present): '
      '**${hitOk ? "PASS" : "FAIL"}**');
  log('');

  log('## Open-Meteo fallback');
  log('');
  final meteo = await _benchOpenMeteo();
  log('| Mode | Latency | weather HTTP | air HTTP | ok |');
  log('|------|---------|--------------|----------|----|');
  log('| sequential | ${meteo.sequentialMs}ms | '
      '${meteo.weatherMs}ms | ${meteo.airMs}ms | ${meteo.ok} |');
  log('| parallel | ${meteo.parallelMs}ms | — | — | ${meteo.parallelOk} |');
  log('');

  log('## Interpretation');
  log('');
  log('- CITYDATA payloads are large (~25–54KB); parse is cheap vs HTTP.');
  log('- App uses `compute()` for parse on a background isolate '
      '(not measured here) to avoid UI jank.');
  log('- 60s in-memory cache in `SeoulApiService` collapses weather+realtime '
      'duplicate fetches on the home screen.');
  log('- Magok realtime uses `서울식물원·마곡나루역` (solo `마곡나루역` is ERROR-500). '
      'Weather stays on representative `여의도한강공원` via WeatherBloc.');
  log('- Open-Meteo sequential ~2× parallel; fallback should stay parallel '
      '(already does in `WeatherService.fetchSeoulFallback`).');
  log('- Throttle 200–300ms between multi-area calls to reduce Seoul API '
      'rate-limit risk; do not use this tool for load testing.');
  log('');

  final out = File('docs/performance/api_perf_report.md');
  await out.parent.create(recursive: true);
  await out.writeAsString('${lines.join('\n')}\n');
  print('');
  print('Wrote ${out.path}');
}

Future<_AreaSummary> _benchAreaCold(String apiKey, String area) async {
  final httpMs = <int>[];
  final parseMs = <int>[];
  final bytes = <int>[];
  var successes = 0;
  final notes = <String>[];

  for (var i = 0; i < _coldRuns; i++) {
    final uri = Uri.parse(
      '$_baseUrl/$apiKey/json/citydata/1/1/${Uri.encodeComponent(area)}',
    );
    final sw = Stopwatch()..start();
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      sw.stop();
      httpMs.add(sw.elapsedMilliseconds);
      bytes.add(res.bodyBytes.length);

      if (res.statusCode != 200) {
        notes.add('HTTP ${res.statusCode}');
      } else {
        final psw = Stopwatch()..start();
        final decoded = utf8.decode(res.bodyBytes);
        final jsonData = json.decode(decoded) as Map<String, dynamic>;
        if (jsonData.containsKey('CITYDATA')) {
          final city = jsonData['CITYDATA'] as Map<String, dynamic>;
          // App과 유사한 파싱 비용: 주요 리스트 walk
          _walkCityData(city);
          psw.stop();
          parseMs.add(psw.elapsedMilliseconds);
          successes++;
        } else if (jsonData.containsKey('RESULT')) {
          final result = jsonData['RESULT'] as Map<String, dynamic>?;
          notes.add('RESULT ${result?['CODE'] ?? "?"}');
          psw.stop();
        } else if (jsonData.containsKey('RESULT.CODE')) {
          // 일부 오류는 중첩 RESULT 없이 flat 키로 온다.
          notes.add('RESULT ${jsonData['RESULT.CODE']}');
          psw.stop();
        } else {
          notes.add('unknown body');
          psw.stop();
        }
      }
    } catch (e) {
      sw.stop();
      httpMs.add(sw.elapsedMilliseconds);
      notes.add(e.runtimeType.toString());
    }

    if (i < _coldRuns - 1) {
      await Future<void>.delayed(const Duration(milliseconds: _throttleMs));
    }
  }

  return _AreaSummary(
    successes: successes,
    attempts: _coldRuns,
    httpMs: httpMs,
    parseMs: parseMs,
    avgBytes: bytes.isEmpty ? 0 : bytes.reduce((a, b) => a + b) / bytes.length,
    notes: notes.isEmpty ? '—' : notes.toSet().join(', '),
  );
}

/// HangangRealtimeData/WeatherData 파싱과 비슷한 순회 비용.
void _walkCityData(Map<String, dynamic> city) {
  for (final key in const [
    'LIVE_PPLTN_STTS',
    'SBIKE_STTS',
    'PRK_STTS',
    'WEATHER_STTS',
  ]) {
    final v = city[key];
    if (v is List) {
      for (final item in v) {
        if (item is Map) {
          item.length;
        }
      }
    }
  }
}

Future<Map<String, dynamic>> _getCompleteDataCached(
  String apiKey,
  String areaName,
) async {
  final cached = _cache[areaName];
  if (cached != null && DateTime.now().difference(cached.time) < _cacheTtl) {
    return cached.data;
  }

  final uri = Uri.parse(
    '$_baseUrl/$apiKey/json/citydata/1/1/${Uri.encodeComponent(areaName)}',
  );
  final res = await http.get(uri).timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) {
    return {'ok': false};
  }
  final jsonData =
      json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  final ok = jsonData.containsKey('CITYDATA');
  final data = {'ok': ok};
  if (ok) {
    _cache[areaName] = (time: DateTime.now(), data: data);
  }
  return data;
}

Future<_MeteoSummary> _benchOpenMeteo() async {
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

  final wSw = Stopwatch()..start();
  http.Response? weatherRes;
  try {
    weatherRes = await http.get(weatherUri).timeout(const Duration(seconds: 5));
  } catch (_) {}
  wSw.stop();

  final aSw = Stopwatch()..start();
  http.Response? airRes;
  try {
    airRes = await http.get(airUri).timeout(const Duration(seconds: 5));
  } catch (_) {}
  aSw.stop();

  final pSw = Stopwatch()..start();
  final results = await Future.wait([
    http
        .get(weatherUri)
        .timeout(const Duration(seconds: 5))
        .then<http.Response?>((r) => r)
        .catchError((_) => null),
    http
        .get(airUri)
        .timeout(const Duration(seconds: 5))
        .then<http.Response?>((r) => r)
        .catchError((_) => null),
  ]);
  pSw.stop();

  return _MeteoSummary(
    weatherMs: wSw.elapsedMilliseconds,
    airMs: aSw.elapsedMilliseconds,
    sequentialMs: wSw.elapsedMilliseconds + aSw.elapsedMilliseconds,
    parallelMs: pSw.elapsedMilliseconds,
    ok: weatherRes?.statusCode == 200,
    parallelOk: results[0]?.statusCode == 200,
  );
}

class _AreaSummary {
  final int successes;
  final int attempts;
  final List<int> httpMs;
  final List<int> parseMs;
  final double avgBytes;
  final String notes;

  _AreaSummary({
    required this.successes,
    required this.attempts,
    required this.httpMs,
    required this.parseMs,
    required this.avgBytes,
    required this.notes,
  });

  int get httpP50 => _percentile(httpMs, 0.50);
  int get httpP95 => _percentile(httpMs, 0.95);
  int get httpAvg => httpMs.isEmpty
      ? 0
      : (httpMs.reduce((a, b) => a + b) / httpMs.length).round();
  int get parseP50 => _percentile(parseMs, 0.50);
}

class _MeteoSummary {
  final int weatherMs;
  final int airMs;
  final int sequentialMs;
  final int parallelMs;
  final bool ok;
  final bool parallelOk;

  _MeteoSummary({
    required this.weatherMs,
    required this.airMs,
    required this.sequentialMs,
    required this.parallelMs,
    required this.ok,
    required this.parallelOk,
  });
}

int _percentile(List<int> values, double p) {
  if (values.isEmpty) return 0;
  final sorted = [...values]..sort();
  final idx = min(sorted.length - 1, max(0, (p * (sorted.length - 1)).round()));
  return sorted[idx];
}

String _fmtMs(int ms) => '${ms}ms';
