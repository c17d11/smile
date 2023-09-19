enum AnimeType { tv, movie, ova, special, ona, music }

extension AnimeTypeText on AnimeType {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
  String get lowerCase => name.toLowerCase();
}
