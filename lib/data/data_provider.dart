import 'package:flutter/material.dart';
import 'package:hangangbus/data/faq_data_en.dart' as faq_en;
import 'package:hangangbus/data/faq_data_ko.dart' as faq_ko;
import 'package:hangangbus/data/faq_data_ja.dart' as faq_ja;
import 'package:hangangbus/data/faq_data_zh.dart' as faq_zh;
import 'package:hangangbus/data/story_data_en.dart';
import 'package:hangangbus/data/story_data_ko.dart';
import 'package:hangangbus/data/story_data_ja.dart';
import 'package:hangangbus/data/story_data_zh.dart';
import 'package:hangangbus/models/data.dart';

/// 로케일(언어 코드)에 따라 스토리/FAQ 정적 콘텐츠를 반환하는 단일 진입점.
///
/// 콘텐츠 분기는 이 클래스 한 곳에서만 수행한다.
/// (과거 ContentRepository 와 분기 로직이 중복되어 일본어가 누락되던 문제를 일원화)
class DataProvider {
  static List<StoryItem> getStories(BuildContext context) =>
      storiesFor(Localizations.localeOf(context).languageCode);

  static List<FaqItem> getFaqs(BuildContext context) =>
      faqsFor(Localizations.localeOf(context).languageCode);

  /// 언어 코드로 직접 조회 (Bloc/Repository 등 context 없는 곳에서 사용).
  static List<StoryItem> storiesFor(String languageCode) {
    switch (languageCode) {
      case 'ja':
        return storyDataJa;
      case 'zh':
        return storyDataZh;
      case 'en':
        return storyDataEn;
      case 'ko':
      default:
        return storyDataKo;
    }
  }

  static List<FaqItem> faqsFor(String languageCode) {
    switch (languageCode) {
      case 'ja':
        return faq_ja.faqDataJa;
      case 'zh':
        return faq_zh.faqDataZh;
      case 'en':
        return faq_en.faqDataEn;
      case 'ko':
      default:
        return faq_ko.faqDataKo;
    }
  }
}
