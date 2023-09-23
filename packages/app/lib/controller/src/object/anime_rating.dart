import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeRatingItem with SelectionItem {
  AnimeRating rating;
  AnimeRatingItem(this.rating);

  @override
  String get displayName => rating.capitalize;
}

extension AnimeRatingItemText on AnimeRating {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
}
