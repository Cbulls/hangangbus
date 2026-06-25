import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/screens/tab1_home.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DockMapScreen extends StatefulWidget {
  final DockInfo dockInfo;

  const DockMapScreen({super.key, required this.dockInfo});

  @override
  State<DockMapScreen> createState() => _DockMapScreenState();
}

class _DockMapScreenState extends State<DockMapScreen> {
  // 🎯 정확한 선착장 좌표 (카카오맵에서 확인한 실제 위치)
  final Map<String, LatLng> _dockPositions = {
    'Yeouido': LatLng(37.52890064458423, 126.93440535180632), // 여의도 선착장
    'Mangwon': LatLng(37.55454583761357, 126.89463688749166), // 망원 선착장
    'Magok': LatLng(37.575086622786905, 126.84405715556353), // 마곡 선착장
    'Apgujeong': LatLng(37.526686379656766, 127.01647963172924), // 압구정 선착장
    'Oksu': LatLng(37.53887583066939, 127.01780841215633), // 옥수 선착장
    'Ttukseom': LatLng(37.528740236208876, 127.0664543183545), // 뚝섬 선착장
    'Jamsil': LatLng(37.51871205060492, 127.08479426715436), // 잠실 선착장
    'SeoulForest': LatLng(37.53776088589692, 127.04111182474081), // 서울숲 선착장
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
                setState(() {});
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
}
