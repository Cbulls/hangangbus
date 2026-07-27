import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangangbus/blocs/story/story_bloc.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/models/data.dart';
import 'package:hangangbus/models/dock_location.dart';
import 'package:hangangbus/repositories/content_repository.dart';
import 'package:hangangbus/theme/app_colors.dart';

class Tab3Story extends StatelessWidget {
  const Tab3Story({super.key});

  /// 현재 언어의 스토리 데이터에 존재하는 선착장만 docks 정규 순서로 반환.
  List<String> _computeActiveDockKeys(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final present = context
        .read<ContentRepository>()
        .stories(lang)
        .map((s) => s.dockName)
        .toSet();
    return docks.map((d) => d.name).where(present.contains).toList();
  }

  /// 선착장 한글 키를 현재 언어 라벨로 변환.
  static String dockLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case '마곡':
        return l10n.dockMagok;
      case '망원':
        return l10n.dockMangwon;
      case '여의도':
        return l10n.dockYeouido;
      case '압구정':
        return l10n.dockApgujeong;
      case '옥수':
        return l10n.dockOksu;
      case '뚝섬':
        return l10n.dockTtukseom;
      case '잠실':
        return l10n.dockJamsil;
      case '서울숲':
        return l10n.dockSeoulForest;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<StoryBloc>().state;

    final dockKeys = _computeActiveDockKeys(context);
    final categories = [l10n.categoryHistory, l10n.categoryFood];

    // 언어 전환 등으로 인덱스가 범위를 벗어날 수 있어 방어적으로 보정.
    final dockIndex = dockKeys.isEmpty
        ? 0
        : state.selectedDockIndex.clamp(0, dockKeys.length - 1);
    final categoryIndex = state.selectedCategoryIndex.clamp(0, 1);
    final selectedDockKey = dockKeys.isEmpty ? null : dockKeys[dockIndex];
    final dockColor = selectedDockKey == null
        ? AppColors.primary
        : AppColors.dockColorOf(selectedDockKey);

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(isDarkMode: isDarkMode, l10n: l10n, accentColor: dockColor),
            const SizedBox(height: 16),
            _DockChips(
              dockKeys: dockKeys,
              selectedIndex: dockIndex,
              isDarkMode: isDarkMode,
              l10n: l10n,
              onSelected: (i) {
                HapticFeedback.selectionClick();
                context.read<StoryBloc>().add(StoryDockSelected(i));
              },
            ),
            const SizedBox(height: 12),
            _CategorySegmentedControl(
              labels: categories,
              selectedIndex: categoryIndex,
              isDarkMode: isDarkMode,
              onSelected: (i) {
                HapticFeedback.selectionClick();
                context.read<StoryBloc>().add(StoryCategorySelected(i));
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _StoryList(
                dockKey: selectedDockKey,
                categoryIndex: categoryIndex,
                dockColor: dockColor,
                isDarkMode: isDarkMode,
                l10n: l10n,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDarkMode;
  final AppLocalizations l10n;
  final Color accentColor;

  const _Header({
    required this.isDarkMode,
    required this.l10n,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storyPageTitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : AppColors.ink,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // 선택된 선착장 색으로 부드럽게 전환되는 액센트 바
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.storyPageSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.55)
                        : AppColors.inkSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DockChips extends StatelessWidget {
  final List<String> dockKeys;
  final int selectedIndex;
  final bool isDarkMode;
  final AppLocalizations l10n;
  final ValueChanged<int> onSelected;

  const _DockChips({
    required this.dockKeys,
    required this.selectedIndex,
    required this.isDarkMode,
    required this.l10n,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dockKeys.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final key = dockKeys[index];
          final selected = index == selectedIndex;
          final dockColor = AppColors.dockColorOf(key);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(19),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? dockColor
                      : (isDarkMode ? AppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: selected
                        ? dockColor
                        : (isDarkMode
                              ? Colors.white.withValues(alpha: 0.12)
                              : AppColors.hairline),
                  ),
                ),
                child: Text(
                  Tab3Story.dockLabel(key, l10n),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : (isDarkMode
                              ? Colors.white.withValues(alpha: 0.65)
                              : AppColors.inkSecondary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategorySegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final bool isDarkMode;
  final ValueChanged<int> onSelected;

  const _CategorySegmentedControl({
    required this.labels,
    required this.selectedIndex,
    required this.isDarkMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final trackColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFEDEFF2);
    final thumbColor = isDarkMode ? const Color(0xFF2A3245) : Colors.white;

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                left: segmentWidth * selectedIndex,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: thumbColor,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (index) {
                  final selected = index == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onSelected(index),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? (isDarkMode ? Colors.white : AppColors.ink)
                                : (isDarkMode
                                      ? Colors.white.withValues(alpha: 0.45)
                                      : AppColors.inkTertiary),
                          ),
                          child: Text(labels[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StoryList extends StatelessWidget {
  final String? dockKey;
  final int categoryIndex;
  final Color dockColor;
  final bool isDarkMode;
  final AppLocalizations l10n;

  const _StoryList({
    required this.dockKey,
    required this.categoryIndex,
    required this.dockColor,
    required this.isDarkMode,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    const categoryKeys = ['HISTORY', 'FOOD'];

    if (dockKey == null) {
      return Center(
        child: Text(
          l10n.comingSoon,
          style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
        ),
      );
    }

    final targetCategoryKey = categoryKeys[categoryIndex];
    final lang = Localizations.localeOf(context).languageCode;
    final items = context
        .read<ContentRepository>()
        .stories(lang)
        .where(
          (item) =>
              item.dockName == dockKey && item.category == targetCategoryKey,
        )
        .toList();

    if (items.isEmpty) {
      return Center(
        child: Text(
          l10n.comingSoon,
          style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _StoryCard(
          item: items[index],
          dockColor: dockColor,
          isDarkMode: isDarkMode,
          l10n: l10n,
        );
      },
    );
  }
}

class _StoryCard extends StatelessWidget {
  final StoryItem item;
  final Color dockColor;
  final bool isDarkMode;
  final AppLocalizations l10n;

  const _StoryCard({
    required this.item,
    required this.dockColor,
    required this.isDarkMode,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final isHistory = item.category == 'HISTORY';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.hairline,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryDetailScreen(item: item),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  // 표시 크기에 맞춰 디코딩해 메모리/디코드 비용을 줄인다.
                  cacheWidth:
                      (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio)
                          .round(),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: AppColors.tint(dockColor, isDarkMode ? 0.0 : 0.88)
                          .withValues(alpha: isDarkMode ? 0.15 : 1.0),
                      child: Center(
                        child: Icon(
                          isHistory
                              ? Icons.account_balance_outlined
                              : Icons.restaurant_outlined,
                          size: 48,
                          color: dockColor.withValues(alpha: 0.35),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카테고리 배지: 선착장 색 tint
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: dockColor.withValues(
                          alpha: isDarkMode ? 0.22 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isHistory ? l10n.categoryHistory : l10n.categoryFood,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode
                              ? AppColors.tint(dockColor, 0.35)
                              : AppColors.shade(dockColor, 0.15),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode
                            ? const Color(0xFFE8E8E8)
                            : AppColors.ink,
                        letterSpacing: -0.3,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.6)
                            : AppColors.inkSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.accessInfo,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : AppColors.inkTertiary,
                            ),
                          ),
                        ),
                        if (isHistory && item.historicalPeriod != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.historicalPeriod!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : AppColors.inkSecondary,
                              ),
                            ),
                          ),
                        if (!isHistory && item.priceRange != null)
                          Text(
                            item.priceRange!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.shade(dockColor, 0.1),
                            ),
                          ),
                      ],
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

// ─── 상세 화면 ────────────────────────────────────────────
class StoryDetailScreen extends StatelessWidget {
  final StoryItem item;
  const StoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isHistory = item.category == 'HISTORY';
    final l10n = AppLocalizations.of(context)!;
    final dockDisplayName = item.displayDockName ?? item.dockName;
    final dockColor = AppColors.dockColorOf(item.dockName);

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDarkMode
                ? AppColors.darkBackground
                : AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDarkMode ? Colors.white : AppColors.ink,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRect(
                child: SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    // 표시 크기에 맞춰 디코딩해 메모리/디코드 비용을 줄인다.
                    cacheWidth:
                        (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio)
                            .round(),
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDarkMode
                            ? dockColor.withValues(alpha: 0.15)
                            : AppColors.tint(dockColor, 0.88),
                        child: Center(
                          child: Icon(
                            isHistory
                                ? Icons.account_balance_outlined
                                : Icons.restaurant_outlined,
                            size: 72,
                            color: dockColor.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // 카테고리 배지
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: dockColor.withValues(
                            alpha: isDarkMode ? 0.22 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isHistory ? l10n.categoryHistory : l10n.categoryFood,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode
                                ? AppColors.tint(dockColor, 0.35)
                                : AppColors.shade(dockColor, 0.15),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 선착장 배지
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.1)
                                : AppColors.hairline,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: dockColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.dockSuffix(dockDisplayName),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppColors.inkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode
                          ? const Color(0xFFE8E8E8)
                          : AppColors.ink,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppColors.inkSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 정보 카드 (플랫)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.08)
                            : AppColors.hairline,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          label: l10n.infoLabelLocation,
                          value: l10n.dockSuffix(dockDisplayName),
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          label: l10n.infoLabelAccess,
                          value: item.accessInfo,
                          isDarkMode: isDarkMode,
                        ),
                        if (isHistory && item.historicalPeriod != null) ...[
                          const SizedBox(height: 14),
                          _buildInfoRow(
                            label: l10n.infoLabelPeriod,
                            value: item.historicalPeriod!,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                        if (!isHistory) ...[
                          if (item.openingHours != null) ...[
                            const SizedBox(height: 14),
                            _buildInfoRow(
                              label: l10n.infoLabelHours,
                              value: item.openingHours!,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                          if (item.priceRange != null) ...[
                            const SizedBox(height: 14),
                            _buildInfoRow(
                              label: l10n.infoLabelPrice,
                              value: item.priceRange!,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.8)
                          : const Color(0xFF3E434B),
                      height: 1.8,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.4)
                  : AppColors.inkTertiary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.ink,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
