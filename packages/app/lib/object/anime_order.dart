import 'package:app/ui/selection_widget/src/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeOrderItem with SelectionItem {
  JikanAnimeOrder order;
  AnimeOrderItem(this.order);

  @override
  String get displayName => order.displayName;
}

extension AnimeOrderDisplayName on JikanAnimeOrder {
  String get displayName {
    switch (this) {
      case JikanAnimeOrder.malId:
        return "Mal ID";
      case JikanAnimeOrder.title:
        return "Title";
      case JikanAnimeOrder.startDate:
        return "Start date";
      case JikanAnimeOrder.endDate:
        return "End date";
      case JikanAnimeOrder.episodes:
        return "Episodes";
      case JikanAnimeOrder.score:
        return "Score";
      case JikanAnimeOrder.scoredBy:
        return "Scored By";
      case JikanAnimeOrder.rank:
        return "Rank";
      case JikanAnimeOrder.popularity:
        return "Popularity";
      case JikanAnimeOrder.members:
        return "Members";
      case JikanAnimeOrder.favorites:
        return "Favorites";
    }
  }
}
