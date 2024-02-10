import 'package:app/object/tag.dart';

class AnimeAppFilter {
  bool showOnlyFavorites = false;
  List<Tag> showOnlyTags = [];

  AnimeAppFilter({bool? onlyFavorites, List<Tag>? onlyTags}) {
    if (onlyFavorites != null) showOnlyFavorites = onlyFavorites;
    if (onlyTags != null) showOnlyTags = onlyTags;
  }

  AnimeAppFilter copy() => AnimeAppFilter(
        onlyFavorites: showOnlyFavorites,
        onlyTags: showOnlyTags,
      );
}
