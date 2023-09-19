enum AnimeStatus { airing, complete, upcoming }

extension AnimeStatusText on AnimeStatus {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
  String get lowerCase => name.toLowerCase();
}
