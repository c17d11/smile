enum AnimeRating { g, pg, pg13, r17, r, rx }

extension AnimeRatingText on AnimeRating {
  String get lowerCase => name.toLowerCase();
}
