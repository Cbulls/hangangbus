import 'package:flutter/material.dart';

enum StoryCategory { history, food }

enum DockType { yeouido, mangwon, magok }

class LocalizedText {
  final String ko;
  final String en;

  const LocalizedText({required this.ko, required this.en});

  String byLocale(Locale locale) {
    return locale.languageCode == 'ko' ? ko : en;
  }
}

class StoryItem {
  final DockType dock;
  final StoryCategory category;

  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText description;
  final LocalizedText accessInfo;

  final LocalizedText? historicalPeriod;
  final LocalizedText? openingHours;
  final LocalizedText? priceRange;

  const StoryItem({
    required this.dock,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accessInfo,
    this.historicalPeriod,
    this.openingHours,
    this.priceRange,
  });
}
