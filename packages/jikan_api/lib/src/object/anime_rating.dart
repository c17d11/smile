enum JikanAnimeRating { g, pg, pg13, r17, r, rx }

extension AnimeRatingText on JikanAnimeRating {
  String get lowerCase => name.toLowerCase();
}
