import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/schedule_utils.dart';
import 'package:hangangbus/tab1_home.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DockMapScreen extends StatefulWidget {
  final DockInfo dockInfo;

  const DockMapScreen({super.key, required this.dockInfo});

  @override
  State<DockMapScreen> createState() => _DockMapScreenState();
}

class _DockMapScreenState extends State<DockMapScreen> {
  KakaoMapController? _mapController;

  // 🎯 정확한 선착장 좌표 (카카오맵에서 확인한 실제 위치)
  final Map<String, LatLng> _dockPositions = {
    'Yeouido': LatLng(37.52890064458423, 126.93440535180632), // 여의도 선착장
    'Mangwon': LatLng(37.55454583761357, 126.89463688749166), // 망원 선착장
    'Magok': LatLng(37.575086622786905, 126.84405715556353), // 마곡 선착장
    'Apgujeong': LatLng(37.5270, 127.0280), // 압구정 선착장
    'Oksu': LatLng(37.5400, 127.0180), // 옥수 선착장
    'Ttukseom': LatLng(37.5304, 127.0661), // 뚝섬 선착장
    'Jamsil': LatLng(37.5145, 127.0820), // 잠실 선착장
  };

  Color get _dockColor {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gradients = isDarkMode
        ? widget.dockInfo.gradientDark
        : widget.dockInfo.gradientLight;
    return gradients[0];
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ⚓ 선착장 마커 HTML (개선된 버전)
  String _createDockMarkerHtml() {
    final colorHex = _dockColor.value.toRadixString(16).substring(2);

    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  body { margin: 0; padding: 0; }
  .marker-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  }
  .marker-icon {
    width: 56px;
    height: 56px;
    background: #$colorHex;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 16px rgba(0,0,0,0.4);
    border: 4px solid white;
  }
  .marker-emoji {
    font-size: 28px;
  }
  .marker-label {
    margin-top: 6px;
    padding: 6px 12px;
    background: white;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 800;
    color: #$colorHex;
    box-shadow: 0 2px 8px rgba(0,0,0,0.25);
    white-space: nowrap;
  }
  .marker-pointer {
    width: 0;
    height: 0;
    border-left: 8px solid transparent;
    border-right: 8px solid transparent;
    border-top: 10px solid white;
    margin-top: -2px;
  }
</style>
</head>
<body>
  <div class="marker-container">
    <div class="marker-icon">
      <span class="marker-emoji">⚓</span>
    </div>
    <div class="marker-label">${widget.dockInfo.name}</div>
    <div class="marker-pointer"></div>
  </div>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final dockPosition =
        _dockPositions[widget.dockInfo.nameEn] ?? LatLng(37.5350, 126.9150);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 카카오맵 (전체 화면 배경)
          Positioned.fill(
            child: KakaoMap(
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              center: dockPosition,
              maxLevel: 12,
              markers: [
                Marker(
                  markerId: 'dock_${widget.dockInfo.name}',
                  latLng: dockPosition,
                  width: 140,
                  height: 140,
                  offsetX: 0,
                  offsetY: 0,
                  customOverlayContent: _createDockMarkerHtml(),
                  customOverlayXAnchor: 0.5,
                  customOverlayYAnchor: 0.85,
                ),
              ],
            ),
          ),

          // 2. 상단 헤더 및 뒤로가기
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCircleButton(
                    icon: Icons.arrow_back_ios_new,
                    isDarkMode: isDarkMode,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildGlassHeaderBox(isDarkMode)),
                ],
              ),
            ),
          ),

          // 3. 하단 시간표
          // DraggableScrollableSheet(
          //   controller: _sheetController,
          //   initialChildSize: 0.28,
          //   minChildSize: 0.15,
          //   maxChildSize: 0.85,
          //   snap: true,
          //   snapSizes: const [0.28, 0.6, 0.85],
          //   builder: (context, scrollController) {
          //     return _buildBottomTimeSheet(
          //       context,
          //       scrollController,
          //       isDarkMode,
          //       schedule,
          //       nextDeparture,
          //       minutesUntil,
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildGlassHeaderBox(bool isDarkMode) {
    final l10n = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.anchor, color: _dockColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.dockSheetTitle(widget.dockInfo.name),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      widget.dockInfo.address,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.white60 : Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTimeSheet(
    BuildContext context,
    ScrollController scrollController,
    bool isDarkMode,
    List<String> schedule,
    String? nextDeparture,
    int? minutesUntil,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSimpleTitle("출발 시간표", isDarkMode),
              const SizedBox(height: 16),
              if (nextDeparture != null)
                _buildNextDepartureBox(nextDeparture, minutesUntil),
              const SizedBox(height: 24),
              Text(
                "전체 시간표",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildScheduleGrid(schedule, isDarkMode),
              const SizedBox(height: 20),
              _buildAccessInfo(isDarkMode),
              const SizedBox(height: 16),
              _buildNoticeBox(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildNextDepartureBox(String time, int? minutes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_dockColor, _dockColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _dockColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "다음 출발",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ],
          ),
          if (minutes != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$minutes분 후",
                style: TextStyle(
                  color: _dockColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleGrid(List<String> schedule, bool isDarkMode) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: schedule.map((time) {
        final isPast = ScheduleUtils.isPastTime(time);
        final isNext = ScheduleUtils.isNextDeparture(
          widget.dockInfo.name,
          time,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: isNext
                ? LinearGradient(
                    colors: [_dockColor, _dockColor.withValues(alpha: 0.8)],
                  )
                : null,
            color: isNext
                ? null
                : isPast
                ? isDarkMode
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.withValues(alpha: 0.1)
                : isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
            border: isNext
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                  ),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: isNext ? FontWeight.w700 : FontWeight.w600,
              color: isNext
                  ? Colors.white
                  : isPast
                  ? Colors.grey
                  : isDarkMode
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAccessInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.05)
            : _dockColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_subway_rounded,
                size: 18,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.6)
                    : _dockColor,
              ),
              const SizedBox(width: 8),
              Text(
                widget.dockInfo.nearestSubway,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                "도보 ${widget.dockInfo.subwayWalkTime}분",
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.grey,
                ),
              ),
            ],
          ),
          if (widget.dockInfo.facilities.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.dockInfo.facilities.map((facility) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    facility,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoticeBox(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.05)
            : _dockColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.6)
                : _dockColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "기상 상황에 따라 운항이 변경될 수 있습니다",
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
