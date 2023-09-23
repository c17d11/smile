import 'package:app/controller/src/object/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class GenreIntern extends Genre with SelectionItem {
  @override
  String get displayName => name ?? '';

  static GenreIntern from(Genre g) {
    GenreIntern genreIntern = GenreIntern()
      ..malId = g.malId
      ..name = g.name
      ..count = g.count;
    return genreIntern;
  }
}
