// dock_type.dart
import 'package:hangangbus/l10n/app_localizations.dart';

enum DockType { magok, mangwon, yeouido, apgujeong, oksu, ttukseom, jamsil }

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
    }
  }
}
