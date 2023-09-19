enum AnimeRating { g, pg, pg13, r17, r, rx }

extension AnimeRatingText on AnimeRating {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
  String get lowerCase => name.toLowerCase();
}
