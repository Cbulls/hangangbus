import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangangbus/data_provider.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'dart:ui';
import 'data.dart';

class Tab3Story extends StatefulWidget {
  const Tab3Story({super.key});

  @override
  State<Tab3Story> createState() => _Tab3StoryState();
}

class _Tab3StoryState extends State<Tab3Story> with TickerProviderStateMixin {
  late TabController _dockTabController;
  late TabController _categoryTabController;

  // ✅ 핵심 수정: 선택된 인덱스를 직접 상태로 관리
  int _selectedDockIndex = 0;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _dockTabController = TabController(length: 3, vsync: this);
    _categoryTabController = TabController(length: 2, vsync: this);

    // ✅ 컨트롤러 변경 시 상태 업데이트
    _dockTabController.addListener(() {
      if (!_dockTabController.indexIsChanging) {
        setState(() => _selectedDockIndex = _dockTabController.index);
      }
    });
    _categoryTabController.addListener(() {
      if (!_categoryTabController.indexIsChanging) {
        setState(() => _selectedCategoryIndex = _categoryTabController.index);
      }
    });
  }

  @override
  void dispose() {
    _dockTabController.dispose();
    _categoryTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final dockNames = [l10n.dockYeouido, l10n.dockMangwon, l10n.dockMagok];
    final categories = [l10n.categoryHistory, l10n.categoryFood];

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0A0E27)
          : const Color(0xFFFFFBF5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDarkMode, l10n),
            const SizedBox(height: 20),
            _buildDockTabs(isDarkMode, dockNames),
            const SizedBox(height: 16),
            _buildCategoryTabs(isDarkMode, categories),
            const SizedBox(height: 20),

            // ✅ 핵심 수정: 중첩 TabBarView 제거 → 인덱스 기반 단일 콘텐츠 렌더링
            Expanded(
              child: _buildContent(
                _selectedDockIndex, // 인덱스 전달
                _selectedCategoryIndex, // 인덱스 전달
                isDarkMode,
                l10n,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDarkMode
                        ? [Colors.white, Colors.white.withValues(alpha: 0.8)]
                        : [const Color(0xFF0064B0), const Color(0xFF0099CC)],
                  ).createShader(bounds),
                  child: Text(
                    l10n.storyPageTitle,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.storyPageSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.5)
                        : const Color(0xFF757575),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDockTabs(bool isDarkMode, List<String> dockNames) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.8),
              ),
            ),
            child: TabBar(
              controller: _dockTabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [
                          const Color(0xFF667eea).withValues(alpha: 0.6),
                          const Color(0xFF764ba2).withValues(alpha: 0.6),
                        ]
                      : [
                          const Color(0xFF0099CC).withValues(alpha: 0.15),
                          const Color(0xFF87CEEB).withValues(alpha: 0.15),
                        ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: isDarkMode ? Colors.white : const Color(0xFF0064B0),
              unselectedLabelColor: isDarkMode
                  ? Colors.white.withValues(alpha: 0.4)
                  : const Color(0xFF0064B0).withValues(alpha: 0.4),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
              tabs: dockNames.map((name) => Tab(text: name)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(bool isDarkMode, List<String> categories) {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        controller: _categoryTabController,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: isDarkMode ? Colors.white : const Color(0xFF0064B0),
            ),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelColor: isDarkMode ? Colors.white : const Color(0xFF0064B0),
        unselectedLabelColor: isDarkMode
            ? Colors.white.withValues(alpha: 0.3)
            : const Color(0xFF0064B0).withValues(alpha: 0.3),
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        tabs: categories.map((name) => Tab(text: name)).toList(),
      ),
    );
  }

  Widget _buildContent(
    int dockIndex, // 문자열 대신 인덱스를 직접 전달받음
    int categoryIndex,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    final allStories = DataProvider.getStories(context);

    // 데이터 모델에 정의된 정확한 한글 Key 리스트
    const List<String> dockKeys = ['여의도', '망원', '마곡'];
    const List<String> categoryKeys = ['HISTORY', 'FOOD'];

    final targetDockKey = dockKeys[dockIndex];
    final targetCategoryKey = categoryKeys[categoryIndex];

    final items = allStories.where((item) {
      // 데이터의 dockName과 category가 정확히 일치하는지 비교
      return item.dockName == targetDockKey &&
          item.category == targetCategoryKey;
    }).toList();

    if (items.isEmpty) {
      return Center(
        child: Text(
          l10n.comingSoon,
          style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildStoryCard(items[index], isDarkMode, l10n);
      },
    );
  }

  Widget _buildStoryCard(
    StoryItem item,
    bool isDarkMode,
    AppLocalizations l10n,
  ) {
    final isHistory = item.category == 'HISTORY';

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.04),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.7),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 영역
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isHistory
                                    ? isDarkMode
                                          ? [
                                              const Color(
                                                0xFF8B7355,
                                              ).withValues(alpha: 0.3),
                                              const Color(
                                                0xFFA0826D,
                                              ).withValues(alpha: 0.2),
                                            ]
                                          : [
                                              const Color(
                                                0xFFD2B48C,
                                              ).withValues(alpha: 0.3),
                                              const Color(
                                                0xFFDEB887,
                                              ).withValues(alpha: 0.2),
                                            ]
                                    : isDarkMode
                                    ? [
                                        const Color(
                                          0xFFFF6B6B,
                                        ).withValues(alpha: 0.3),
                                        const Color(
                                          0xFFFFB88C,
                                        ).withValues(alpha: 0.2),
                                      ]
                                    : [
                                        const Color(
                                          0xFFFFE5E5,
                                        ).withValues(alpha: 0.6),
                                        const Color(
                                          0xFFFFF5E6,
                                        ).withValues(alpha: 0.4),
                                      ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                isHistory ? "歷" : "食",
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w200,
                                  color: isDarkMode
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : Colors.black.withValues(alpha: 0.08),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 카테고리 배지 (l10n 적용)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isHistory
                                ? const Color(
                                    0xFF8B7355,
                                  ).withValues(alpha: 0.15)
                                : const Color(
                                    0xFFFF6B6B,
                                  ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isHistory
                                ? l10n.categoryHistory
                                : l10n.categoryFood,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isHistory
                                  ? const Color(0xFF8B7355)
                                  : const Color(0xFFFF6B6B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF2C2C2C),
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
                                : const Color(0xFF666666),
                            height: 1.4,
                            letterSpacing: 0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 16),

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
                                      : const Color(0xFF999999),
                                  letterSpacing: 0,
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
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.historicalPeriod!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : const Color(0xFF999999),
                                  ),
                                ),
                              ),
                            if (!isHistory && item.priceRange != null)
                              Text(
                                item.priceRange!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF6B6B),
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

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0A0E27)
          : const Color(0xFFFFFBF5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDarkMode
                ? const Color(0xFF0A0E27)
                : const Color(0xFFFFFBF5),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDarkMode ? Colors.white : const Color(0xFF2C2C2C),
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isHistory
                                ? isDarkMode
                                      ? [
                                          const Color(
                                            0xFF8B7355,
                                          ).withValues(alpha: 0.4),
                                          const Color(
                                            0xFF0A0E27,
                                          ).withValues(alpha: 0.8),
                                        ]
                                      : [
                                          const Color(
                                            0xFFD2B48C,
                                          ).withValues(alpha: 0.3),
                                          const Color(
                                            0xFFFFFBF5,
                                          ).withValues(alpha: 0.9),
                                        ]
                                : isDarkMode
                                ? [
                                    const Color(
                                      0xFFFF6B6B,
                                    ).withValues(alpha: 0.4),
                                    const Color(
                                      0xFF0A0E27,
                                    ).withValues(alpha: 0.8),
                                  ]
                                : [
                                    const Color(
                                      0xFFFFE5E5,
                                    ).withValues(alpha: 0.6),
                                    const Color(
                                      0xFFFFFBF5,
                                    ).withValues(alpha: 0.9),
                                  ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isHistory ? "歷" : "食",
                            style: TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.w100,
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.05),
                            ),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isHistory
                          ? const Color(0xFF8B7355).withValues(alpha: 0.15)
                          : const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isHistory ? l10n.categoryHistory : l10n.categoryFood,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isHistory
                            ? const Color(0xFF8B7355)
                            : const Color(0xFFFF6B6B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF2C2C2C),
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
                          : const Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkMode
                                ? [
                                    Colors.white.withValues(alpha: 0.08),
                                    Colors.white.withValues(alpha: 0.04),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.9),
                                    Colors.white.withValues(alpha: 0.7),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              label: l10n.infoLabelLocation,
                              value: l10n.dockSuffix(dockDisplayName),
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              label: l10n.infoLabelAccess,
                              value: item.accessInfo,
                              isDarkMode: isDarkMode,
                            ),
                            if (isHistory && item.historicalPeriod != null) ...[
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                label: l10n.infoLabelPeriod,
                                value: item.historicalPeriod!,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                            if (!isHistory) ...[
                              if (item.openingHours != null) ...[
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  label: l10n.infoLabelHours,
                                  value: item.openingHours!,
                                  isDarkMode: isDarkMode,
                                ),
                              ],
                              if (item.priceRange != null) ...[
                                const SizedBox(height: 16),
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
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.8)
                          : const Color(0xFF4A4A4A),
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
                  : const Color(0xFF999999),
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
                  : const Color(0xFF2C2C2C),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
