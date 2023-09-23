import 'package:app/controller/src/object/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeTypeItem with SelectionItem {
  AnimeType type;
  AnimeTypeItem(this.type);

  @override
  String get displayName => type.capitalize;
}

extension AnimeTypeItemText on AnimeType {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
}
