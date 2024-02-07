import 'package:app/ui/common/selection_widget/src/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeRatingItem with SelectionItem {
  JikanAnimeRating rating;
  AnimeRatingItem(this.rating);

  @override
  String get displayName => rating.capitalize;
}

extension AnimeRatingItemText on JikanAnimeRating {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
}
