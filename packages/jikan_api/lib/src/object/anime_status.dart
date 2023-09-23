enum AnimeStatus { airing, complete, upcoming }

extension AnimeStatusText on AnimeStatus {
  String get lowerCase => name.toLowerCase();
}
