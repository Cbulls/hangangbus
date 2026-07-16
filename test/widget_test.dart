import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangangbus/data/data_provider.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:hangangbus/repositories/content_repository.dart';

void main() {
  test('AppLocalizations supports ko/en/ja/zh', () {
    expect(AppLocalizations.supportedLocales.map((l) => l.languageCode),
        containsAll(['ko', 'en', 'ja', 'zh']));
    expect(lookupAppLocalizations(const Locale('zh')).navHome, isNotEmpty);
    expect(lookupAppLocalizations(const Locale('ko')).navHome, isNotEmpty);
  });

  test('ContentRepository exposes stories for all docks in EN/JA/ZH', () {
    const repo = ContentRepository();
    for (final lang in ['en', 'ja', 'zh']) {
      final docks = repo.stories(lang).map((s) => s.dockName).toSet();
      expect(
        docks,
        containsAll(['여의도', '망원', '마곡', '옥수', '서울숲', '뚝섬', '압구정', '잠실']),
        reason: 'lang=$lang',
      );
    }
  });

  test('DataProvider storiesFor matches ContentRepository', () {
    const repo = ContentRepository();
    expect(DataProvider.storiesFor('ko').length, repo.stories('ko').length);
    expect(DataProvider.faqsFor('en').length, repo.faqs('en').length);
  });

  testWidgets('zh locale loads without throwing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(body: Text(l10n.navHome));
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Text), findsOneWidget);
  });
}
