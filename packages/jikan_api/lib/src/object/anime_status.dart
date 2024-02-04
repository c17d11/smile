enum JikanAnimeStatus { airing, complete, upcoming }

extension AnimeStatusText on JikanAnimeStatus {
  String get lowerCase => name.toLowerCase();
}
