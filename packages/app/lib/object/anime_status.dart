import 'package:app/ui/common/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeStatusItem with SelectionItem {
  JikanAnimeStatus status;
  AnimeStatusItem(this.status);

  @override
  String get displayName => status.capitalize;
}

extension AnimeStatusItemText on JikanAnimeStatus {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
}
