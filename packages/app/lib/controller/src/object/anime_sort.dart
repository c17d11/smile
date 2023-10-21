import 'package:app/ui/selection_widget/src/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeSortItem with SelectionItem {
  AnimeSort sort;
  AnimeSortItem(this.sort);

  @override
  String get displayName => sort.displayName;
}

extension AnimeSortDisplayName on AnimeSort {
  String get displayName {
    switch (this) {
      case AnimeSort.asc:
        return "Ascending";
      case AnimeSort.desc:
        return "Descending";
    }
  }
}
