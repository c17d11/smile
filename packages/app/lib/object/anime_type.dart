import 'package:app/ui/common/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeTypeItem with SelectionItem {
  JikanAnimeType type;
  AnimeTypeItem(this.type);

  @override
  String get displayName => type.capitalize;
}

extension AnimeTypeItemText on JikanAnimeType {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
}
