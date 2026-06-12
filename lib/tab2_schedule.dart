import 'package:flutter/material.dart';
import 'package:hangangbus/dock_type.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'dart:async';

import 'package:hangangbus/schedule_utils.dart';
import 'package:hangangbus/tab1_home.dart';

class Tab2Schedule extends StatefulWidget {
  const Tab2Schedule({super.key});

  @override
  State<Tab2Schedule> createState() => _Tab2ScheduleState();
}

class _Tab2ScheduleState extends State<Tab2Schedule> {
  int _selectedDockIndex = 0;
  ScheduleDirection _selectedDirection = ScheduleDirection.toYeouido;
  late final l10n = AppLocalizations.of(context)!;
  late Timer _timer;
  DateTime _now = DateTime.now();

  // -------------------------------
  // UI용 Dock 정의 (기존 유지)
  // -------------------------------

  late final List<DockSchedule> _docks = [
    DockSchedule(
      type: DockType.magok,
      name: l10n.dockMagok,
      subtitle: "Magok",
      color: SeoulColors.mountainGreen,
    ),
    DockSchedule(
      type: DockType.mangwon,
      name: l10n.dockMangwon,
      subtitle: "Mangwon",
      color: SeoulColors.sunsetOrange,
    ),
    DockSchedule(
      type: DockType.yeouido,
      name: l10n.dockYeouido,
      subtitle: "Yeouido",
      color: SeoulColors.hanRiverBlue,
    ),
    DockSchedule(
      type: DockType.apgujeong,
      name: l10n.dockApgujeong,
      subtitle: "Apgujeong",
      color: const Color(0xFF8E54E9),
    ),
    DockSchedule(
      type: DockType.oksu,
      name: l10n.dockOksu,
      subtitle: "Oksu",
      color: const Color(0xFF26A69A),
    ),
    DockSchedule(
      type: DockType.ttukseom,
      name: l10n.dockTtukseom,
      subtitle: "Ttukseom",
      color: const Color(0xFF42A5F5),
    ),
    DockSchedule(
      type: DockType.jamsil,
      name: l10n.dockJamsil,
      subtitle: "Jamsil",
      color: const Color(0xFF00ACC1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // -------------------------------
  // 선택된 선착장 + 방향 시간 리스트 생성
  // -------------------------------

  List<String> _getTimesForSelected(ScheduleDirection direction) {
    final dockType = _docks[_selectedDockIndex].type;
    return ScheduleUtils.getDockScheduleByDirection(dockType, direction);
  }

  int _currentMinutes() => _now.hour * 60 + _now.minute;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDock = _docks[_selectedDockIndex];
    final dockType = _docks[_selectedDockIndex].type;
    final directions = ScheduleUtils.getDirectionsForDock(dockType);
    final activeDirection = directions.contains(_selectedDirection)
        ? _selectedDirection
        : directions.first;
    final times = _getTimesForSelected(activeDirection);
    final nextTime = ScheduleUtils.getNextDepartureByDirection(
      dockType,
      activeDirection,
    );

    return CustomScrollView(
      slivers: [
        // ---------------- HEADER ----------------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Text(
              l10n.timetableTitle,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(child: _buildRouteBar(l10n)),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ---------------- 선착장 필터 ----------------
        SliverToBoxAdapter(child: _buildDockSelector()),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ---------------- 방향 선택 ----------------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                for (int i = 0; i < directions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  _buildDirectionButton(
                    _directionLabel(directions[i], l10n),
                    directions[i],
                    activeDirection,
                  ),
                ],
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        SliverToBoxAdapter(
          child: _buildSummaryCard(
            dock: selectedDock,
            direction: activeDirection,
            times: times,
            nextTime: nextTime,
            l10n: l10n,
          ),
        ),

        if (dockType == DockType.yeouido) ...[
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(child: _buildTransferCard(l10n)),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ---------------- 타임라인 ----------------
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final time = times[index];
              final minutes = ScheduleUtils.timeToMinutes(time);
              final diff = minutes - _currentMinutes();
              final isPast = diff < 0;
              final isNext = time == nextTime;

              return _buildTimelineItem(
                l10n: l10n,
                time: time,
                isPast: isPast,
                isNext: isNext,
                minutesLeft: diff,
                color: _docks[_selectedDockIndex].color,
                isLast: index == times.length - 1,
                isLastBoat: index == times.length - 1,
              );
            }, childCount: times.length),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildDirectionButton(
    String text,
    ScheduleDirection direction,
    ScheduleDirection activeDirection,
  ) {
    final isSelected = activeDirection == direction;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDirection = direction),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              maxLines: 1,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockSelector() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _docks.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedDockIndex == index;
          return GestureDetector(
            onTap: () {
              final directions = ScheduleUtils.getDirectionsForDock(
                _docks[index].type,
              );
              setState(() {
                _selectedDockIndex = index;
                if (!directions.contains(_selectedDirection)) {
                  _selectedDirection = directions.first;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              constraints: const BoxConstraints(minWidth: 76),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? _docks[index].color : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _docks[index].name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRouteBar(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.routeOverview,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _docks.length; i++) ...[
                  _buildRouteStop(_docks[i], i == _selectedDockIndex, l10n),
                  if (i < _docks.length - 1)
                    Container(width: 26, height: 2, color: Colors.grey[300]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStop(
    DockSchedule dock,
    bool isSelected,
    AppLocalizations l10n,
  ) {
    final isTransfer = dock.type == DockType.yeouido;
    return GestureDetector(
      onTap: () {
        final index = _docks.indexOf(dock);
        final directions = ScheduleUtils.getDirectionsForDock(dock.type);
        setState(() {
          _selectedDockIndex = index;
          if (!directions.contains(_selectedDirection)) {
            _selectedDirection = directions.first;
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSelected ? 28 : 22,
            height: isSelected ? 28 : 22,
            decoration: BoxDecoration(
              color: isSelected ? dock.color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? dock.color : Colors.grey[400]!,
                width: isSelected ? 3 : 2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 44),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                dock.name,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? dock.color : Colors.grey[700],
                ),
              ),
            ),
          ),
          if (isTransfer) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: SeoulColors.hanRiverBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.transferHub,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: SeoulColors.hanRiverBlue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required DockSchedule dock,
    required ScheduleDirection direction,
    required List<String> times,
    required String? nextTime,
    required AppLocalizations l10n,
  }) {
    final firstTime = times.isEmpty ? null : times.first;
    final lastTime = times.isEmpty ? null : times.last;
    final minutesLeft = ScheduleUtils.getMinutesUntilNextByDirection(
      dock.type,
      direction,
    );
    final destination = _directionDestinationLabel(direction, l10n);
    final isClosed = nextTime == null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isClosed
              ? [Colors.grey[600]!, Colors.grey[500]!]
              : [dock.color, dock.color.withValues(alpha: 0.72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: dock.color.withValues(alpha: isClosed ? 0.12 : 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${dock.name} → $destination',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isClosed ? l10n.serviceClosedToday : nextTime,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -1.2,
                    ),
                  ),
                ),
              ),
              if (!isClosed && minutesLeft != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _remainingText(minutesLeft, l10n),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isClosed
                ? l10n.tomorrowFirstBoat(firstTime ?? '--:--')
                : l10n.departIn(nextTime),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryChip('${l10n.firstBoat} ${firstTime ?? '--:--'}'),
              const SizedBox(width: 8),
              _buildSummaryChip('${l10n.lastBoat} ${lastTime ?? '--:--'}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTransferCard(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SeoulColors.hanRiverBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SeoulColors.hanRiverBlue.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yeouidoTransferTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: SeoulColors.seoulBlue,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTransferDirection(
                  l10n.directionToMagok,
                  ScheduleDirection.toMagok,
                  l10n,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTransferDirection(
                  l10n.directionToJamsil,
                  ScheduleDirection.toJamsil,
                  l10n,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferDirection(
    String label,
    ScheduleDirection direction,
    AppLocalizations l10n,
  ) {
    final nextTime = ScheduleUtils.getNextDepartureByDirection(
      DockType.yeouido,
      direction,
    );
    final firstTime = ScheduleUtils.getFirstDeparture(
      DockType.yeouido,
      direction,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: SeoulColors.seoulBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nextTime ?? l10n.tomorrowFirstBoat(firstTime ?? '--:--'),
            style: TextStyle(
              fontSize: nextTime == null ? 12 : 20,
              fontWeight: FontWeight.w900,
              color: nextTime == null ? Colors.grey[600] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _directionLabel(ScheduleDirection direction, AppLocalizations l10n) {
    switch (direction) {
      case ScheduleDirection.toYeouido:
        return l10n.directionToYeouido;
      case ScheduleDirection.toMagok:
        return l10n.directionToMagok;
      case ScheduleDirection.toJamsil:
        return l10n.directionToJamsil;
    }
  }

  String _directionDestinationLabel(
    ScheduleDirection direction,
    AppLocalizations l10n,
  ) {
    switch (direction) {
      case ScheduleDirection.toYeouido:
        return l10n.dockYeouido;
      case ScheduleDirection.toMagok:
        return l10n.dockMagok;
      case ScheduleDirection.toJamsil:
        return l10n.dockJamsil;
    }
  }

  String _remainingText(int minutes, AppLocalizations l10n) {
    if (minutes < 60) return l10n.minutesLeft(minutes);
    return l10n.hoursMinutesLeft(minutes ~/ 60, minutes % 60);
  }

  Widget _buildTimelineItem({
    required String time,
    required bool isPast,
    required bool isNext,
    required int minutesLeft,
    required Color color,
    required bool isLast,
    required bool isLastBoat,
    required dynamic l10n,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPast
                    ? Colors.grey[300]
                    : isNext
                    ? color
                    : Colors.white,
                border: Border.all(
                  color: isPast ? Colors.grey[300]! : color,
                  width: isPast ? 1 : 2.5,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isPast ? Colors.grey[200] : color.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isNext
                  ? color.withValues(alpha: 0.06)
                  : isPast
                  ? Colors.grey[50]
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isNext
                    ? color.withValues(alpha: 0.3)
                    : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isPast ? Colors.grey[400] : Colors.grey[900],
                  ),
                ),
                const SizedBox(width: 10),
                if (isNext)
                  _buildTimeBadge(l10n.nextBoat, color)
                else if (isLastBoat)
                  _buildTimeBadge(l10n.lastBoat, Colors.grey[700]!),
                const Spacer(),
                if (!isPast)
                  Text(
                    _remainingText(minutesLeft, l10n),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isNext ? color : Colors.grey[600],
                    ),
                  )
                else
                  Text(
                    l10n.departed,
                    style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class DockSchedule {
  final DockType type;
  final String name;
  final String subtitle;
  final Color color;

  DockSchedule({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.color,
  });
}
