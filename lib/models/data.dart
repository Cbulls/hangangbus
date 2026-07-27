// --- 모델 정의 ---
class StoryItem {
  final String category; // 'FOOD' or 'HISTORY'
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final String dockName;
  final String? displayDockName;
  final String accessInfo;
  final String? openingHours; // 맛집용
  final String? priceRange; // 맛집용
  final String? historicalPeriod; // 역사용

  StoryItem({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.dockName,
    this.displayDockName,
    required this.accessInfo,
    this.openingHours,
    this.priceRange,
    this.historicalPeriod,
  });
}

class FaqItem {
  final String question;
  final String answer;
  FaqItem({required this.question, required this.answer});
}
