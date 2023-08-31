abstract class AnimeType {
  String get code;
  String get text;
}

class TypeTv implements AnimeType {
  @override
  String get code => "tv";

  @override
  String get text => "TV";
}

class TypeMovie implements AnimeType {
  @override
  String get code => "movie";

  @override
  String get text => "Movie";
}

class TypeOva implements AnimeType {
  @override
  String get code => "ova";

  @override
  String get text => "Ova";
}

class TypeSpecial implements AnimeType {
  @override
  String get code => "special";

  @override
  String get text => "Special";
}

class TypeOna implements AnimeType {
  @override
  String get code => "ona";

  @override
  String get text => "Ona";
}

class TypeMusic implements AnimeType {
  @override
  String get code => "music";

  @override
  String get text => "Music";
}
