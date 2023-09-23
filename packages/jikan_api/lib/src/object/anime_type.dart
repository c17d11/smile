enum AnimeType { tv, movie, ova, special, ona, music }

extension AnimeTypeText on AnimeType {
  String get lowerCase => name.toLowerCase();
}
