import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangangbus/blocs/faq/faq_bloc.dart';
import 'package:hangangbus/data/data_provider.dart';
import 'package:hangangbus/l10n/app_localizations.dart'; // l10n 임포트

class Tab4Faq extends StatefulWidget {
  const Tab4Faq({super.key});

  @override
  State<Tab4Faq> createState() => _Tab4FaqState();
}

class _Tab4FaqState extends State<Tab4Faq> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = context.read<FaqBloc>().state.selectedTabIndex;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
    // 상단 탭 변경을 FaqBloc 으로 동기화
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<FaqBloc>().add(FaqTabSelected(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[100]!, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: l10n.tabFaq),
              Tab(text: l10n.tabSafety),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_FaqTab(), _SafetyTab()],
      ),
    );
  }
}

// ─── FAQ 탭 (모던 아코디언 스타일) ──────────────────────
class _FaqTab extends StatelessWidget {
  const _FaqTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final faqs = DataProvider.getFaqs(context);

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: faqs.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24, top: 8),
            child: Text(
              l10n.tabFaq,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          );
        }
        final item = faqs[index - 1];
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 4,
              ),
              title: Text(
                item.question,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    item.answer,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── 안전 수칙 탭 (가독성 중심의 정보 나열) ─────────────────
class _SafetyTab extends StatelessWidget {
  const _SafetyTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24, top: 8),
          child: Text(
            l10n.tabSafety,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        _buildSafetySection(l10n.safetyTitleLifeVest, [
          _SafetyItem('📍', l10n.safetyLifeVestAdult),
          _SafetyItem('👶', l10n.safetyLifeVestChild),
          _SafetyItem('🔴', l10n.safetyLifeVestAccess),
        ]),
        _buildSafetySection(l10n.safetyTitleHowToWear, [
          _SafetyItem('1.', l10n.safetyWearStep1),
          _SafetyItem('2.', l10n.safetyWearStep2),
          _SafetyItem('3.', l10n.safetyWearStep3),
          _SafetyItem('4.', l10n.safetyWearStep4),
          _SafetyItem('5.', l10n.safetyWearStep5),
          _SafetyItem('💡', l10n.safetyWearTip),
        ]),
        _buildSafetySection(l10n.safetyTitleEvacuation, [
          _SafetyItem('🚪', l10n.safetyEvacExit),
          _SafetyItem('🏃', l10n.safetyEvacCalm),
          _SafetyItem('⚠️', l10n.safetyEvacStay),
          _SafetyItem('🛟', l10n.safetyEvacRescue),
        ]),
        const _EmergencyBanner(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSafetySection(String title, List<_SafetyItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    item.leading,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 48, thickness: 1, color: Color(0xFFF5F5F5)),
      ],
    );
  }
}

class _SafetyItem {
  final String leading;
  final String text;
  _SafetyItem(this.leading, this.text);
}

// ─── 긴급 연락 배너 (경고 가독성 강화) ────────────────────
class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // 다크 테마로 주의 환기
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.emergencyBannerTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.emergencyBannerContact,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.emergencyBannerRescue,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
