import 'package:hangangbus/models/data.dart';
import 'package:hangangbus/data/faq_data_en.dart' as faq_en;
import 'package:hangangbus/data/faq_data_ko.dart' as faq_ko;
import 'package:hangangbus/data/story_data_en.dart';
import 'package:hangangbus/data/story_data_ko.dart';

/// 스토리/FAQ 정적 콘텐츠 접근 저장소.
/// 로케일(언어 코드)에 따라 한국어/영어 데이터를 반환한다.
class ContentRepository {
  const ContentRepository();

  List<StoryItem> stories(String languageCode) =>
      languageCode == 'ko' ? storyDataKo : storyDataEn;

  List<FaqItem> faqs(String languageCode) =>
      languageCode == 'ko' ? faq_ko.faqDataKo : faq_en.faqDataEn;
}
