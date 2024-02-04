enum JikanAnimeType { tv, movie, ova, special, ona, music }

extension AnimeTypeText on JikanAnimeType {
  String get lowerCase => name.toLowerCase();
}
