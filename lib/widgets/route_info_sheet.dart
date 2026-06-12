import 'package:flutter/material.dart';
import 'package:hangangbus/utils/distance_calculator.dart';
import 'package:hangangbus/models/dock_location.dart';
import 'dart:ui';

class RouteInfoSheet extends StatefulWidget {
  final Function(String?, String?) onRouteChanged;

  const RouteInfoSheet({super.key, required this.onRouteChanged});

  @override
  State<RouteInfoSheet> createState() => _RouteInfoSheetState();
}

class _RouteInfoSheetState extends State<RouteInfoSheet> {
  String? _selectedFrom;
  String? _selectedTo;

  double? _distance;
  int? _duration;
  DateTime? _eta;

  void _calculateRoute() {
    if (_selectedFrom == null || _selectedTo == null) {
      setState(() {
        _distance = null;
        _duration = null;
        _eta = null;
      });
      widget.onRouteChanged(null, null);
      return;
    }

    if (_selectedFrom == _selectedTo) {
      setState(() {
        _distance = null;
        _duration = null;
        _eta = null;
      });
      widget.onRouteChanged(null, null);
      return;
    }

    // 선착장 찾기
    final fromDock = docks.firstWhere((d) => d.name == _selectedFrom);
    final toDock = docks.firstWhere((d) => d.name == _selectedTo);

    // 거리 계산
    final distance = DistanceCalculator.calculateDistance(
      fromDock.position,
      toDock.position,
    );

    // 소요 시간 계산
    final duration = DistanceCalculator.calculateDuration(distance);

    // 도착 예정 시간 (현재 시간 기준)
    final eta = DistanceCalculator.calculateETA(distance, DateTime.now());

    setState(() {
      _distance = distance;
      _duration = duration;
      _eta = eta;
    });

    widget.onRouteChanged(_selectedFrom, _selectedTo);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xFF1A1A1A).withValues(alpha: 0.95),
                      const Color(0xFF0A0E27).withValues(alpha: 0.95),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFFFFBF5).withValues(alpha: 0.95),
                    ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 타이틀
                Text(
                  "경로 정보",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF2C2C2C),
                  ),
                ),

                const SizedBox(height: 24),

                // 출발 선착장
                _buildDockSelector(
                  label: "출발 선착장",
                  value: _selectedFrom,
                  onChanged: (value) {
                    setState(() => _selectedFrom = value);
                    _calculateRoute();
                  },
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 16),

                // 도착 선착장
                _buildDockSelector(
                  label: "도착 선착장",
                  value: _selectedTo,
                  onChanged: (value) {
                    setState(() => _selectedTo = value);
                    _calculateRoute();
                  },
                  isDarkMode: isDarkMode,
                ),

                // 결과 정보
                if (_distance != null && _duration != null && _eta != null) ...[
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.05)
                          : const Color(0xFF0099CC).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF0099CC).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "예상 정보",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.6)
                                : const Color(0xFF666666),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildInfoRow(
                          icon: Icons.straighten,
                          label: "거리",
                          value: DistanceCalculator.formatDistance(_distance!),
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 12),

                        _buildInfoRow(
                          icon: Icons.schedule,
                          label: "소요 시간",
                          value: DistanceCalculator.formatDuration(_duration!),
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 12),

                        _buildInfoRow(
                          icon: Icons.access_time,
                          label: "도착 예정",
                          value:
                              "${_eta!.hour.toString().padLeft(2, '0')}:${_eta!.minute.toString().padLeft(2, '0')}",
                          isDarkMode: isDarkMode,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "※ 평균 속도 11 km/h 기준\n※ 실제 운항 시간은 상황에 따라 달라질 수 있습니다",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.4)
                                : const Color(0xFF999999),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockSelector({
    required String label,
    required String? value,
    required Function(String?) onChanged,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.6)
                : const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(
              "선택하세요",
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.3)
                    : const Color(0xFF999999),
              ),
            ),
            dropdownColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFF2C2C2C),
            ),
            items: docks.map((dock) {
              return DropdownMenuItem<String>(
                value: dock.name,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: dock.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(dock.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0099CC)),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.6)
                : const Color(0xFF666666),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDarkMode
                ? const Color(0xFFE0E0E0)
                : const Color(0xFF2C2C2C),
          ),
        ),
      ],
    );
  }
}
