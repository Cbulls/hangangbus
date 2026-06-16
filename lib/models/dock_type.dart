// dock_type.dart
import 'package:hangangbus/l10n/app_localizations.dart';

enum DockType {
  magok,
  mangwon,
  yeouido,
  apgujeong,
  oksu,
  ttukseom,
  jamsil,
  seoulforest, // 2026.6.8 신설(임시: 서울국제정원박람회 기간 ~10.30)
}

extension DockTypeL10n on DockType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case DockType.magok:
        return l10n.dockMagok;
      case DockType.mangwon:
        return l10n.dockMangwon;
      case DockType.yeouido:
        return l10n.dockYeouido;
      case DockType.apgujeong:
        return l10n.dockApgujeong;
      case DockType.oksu:
        return l10n.dockOksu;
      case DockType.ttukseom:
        return l10n.dockTtukseom;
      case DockType.jamsil:
        return l10n.dockJamsil;
      case DockType.seoulforest:
        // l10n 자동생성 키에 의존하지 않도록 locale 기반으로 직접 분기.
        return _seoulForestLabel(l10n.localeName);
    }
  }
}

/// 서울숲 라벨(현지화). app_localizations 자동생성 파일을 수정하지 않기 위해
/// 여기서 직접 처리한다.
String _seoulForestLabel(String localeName) {
  final code = localeName.toLowerCase();
  if (code.startsWith('ko')) return '서울숲';
  if (code.startsWith('ja')) return 'ソウルの森';
  return 'Seoul Forest';
}
