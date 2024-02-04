import 'package:app/ui/selection_widget/src/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class Genre extends JikanGenre with SelectionItem {
  @override
  String get displayName => name ?? '';

  static Genre from(JikanGenre g) {
    Genre genreIntern = Genre()
      ..malId = g.malId
      ..name = g.name
      ..count = g.count;
    return genreIntern;
  }
}
