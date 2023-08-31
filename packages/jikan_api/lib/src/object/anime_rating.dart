abstract class AnimeRating {
  String get code;
  String get text;
}

class RatingG implements AnimeRating {
  @override
  String get code => "g";

  @override
  String get text => "G";
}

class RatingPG implements AnimeRating {
  @override
  String get code => "pg";

  @override
  String get text => "PG";
}

class RatingPG13 implements AnimeRating {
  @override
  String get code => "pg13";

  @override
  String get text => "PG13";
}

class RatingR17 implements AnimeRating {
  @override
  String get code => "r17";

  @override
  String get text => "R17";
}

class RatingR implements AnimeRating {
  @override
  String get code => "r";

  @override
  String get text => "R";
}

class RatingRx implements AnimeRating {
  @override
  String get code => "rx";

  @override
  String get text => "RX";
}
