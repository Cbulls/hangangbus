import 'package:hangangbus/models/data.dart';
import 'package:hangangbus/data/data_provider.dart';

/// 스토리/FAQ 정적 콘텐츠 접근 저장소.
///
/// 실제 로케일 분기는 [DataProvider] 한 곳에서만 수행하고,
/// 이 클래스는 언어 코드를 받아 위임만 한다(분기 중복 제거).
class ContentRepository {
  const ContentRepository();

  List<StoryItem> stories(String languageCode) =>
      DataProvider.storiesFor(languageCode);

  List<FaqItem> faqs(String languageCode) => DataProvider.faqsFor(languageCode);
}
