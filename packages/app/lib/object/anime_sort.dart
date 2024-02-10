import 'package:app/ui/common/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeSortItem with SelectionItem {
  JikanAnimeSort sort;
  AnimeSortItem(this.sort);

  @override
  String get displayName => sort.displayName;
}

extension AnimeSortDisplayName on JikanAnimeSort {
  String get displayName {
    switch (this) {
      case JikanAnimeSort.asc:
        return "Ascending";
      case JikanAnimeSort.desc:
        return "Descending";
    }
  }
}
