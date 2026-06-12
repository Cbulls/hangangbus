import 'package:flutter/material.dart';
import 'package:hangangbus/data/faq_data_en.dart' as faq_en;
import 'package:hangangbus/data/faq_data_ko.dart' as faq_ko;
import 'package:hangangbus/data/story_data_en.dart';
import 'package:hangangbus/data/story_data_ko.dart';
import 'package:hangangbus/models/data.dart';

/// 로케일에 따라 적절한 데이터를 반환하는 헬퍼 클래스
class DataProvider {
  static List<StoryItem> getStories(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ko' ? storyDataKo : storyDataEn;
  }

  static List<FaqItem> getFaqs(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ko' ? faq_ko.faqDataKo : faq_en.faqDataEn;
  }
}
