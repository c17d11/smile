import 'package:app/ui/selection_widget/src/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeOrderItem with SelectionItem {
  AnimeOrder order;
  AnimeOrderItem(this.order);

  @override
  String get displayName => order.displayName;
}

extension AnimeOrderDisplayName on AnimeOrder {
  String get displayName {
    switch (this) {
      case AnimeOrder.malId:
        return "Mal ID";
      case AnimeOrder.title:
        return "Title";
      case AnimeOrder.startDate:
        return "Start date";
      case AnimeOrder.endDate:
        return "End date";
      case AnimeOrder.episodes:
        return "Episodes";
      case AnimeOrder.score:
        return "Score";
      case AnimeOrder.scoredBy:
        return "Scored By";
      case AnimeOrder.rank:
        return "Rank";
      case AnimeOrder.popularity:
        return "Popularity";
      case AnimeOrder.members:
        return "Members";
      case AnimeOrder.favorites:
        return "Favorites";
    }
  }
}
