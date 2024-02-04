import 'parser.dart';
import '../object/anime.dart';
import '../object/exception.dart';
import '../object/genre.dart';
import '../object/producer.dart';

class DataParser implements Parser<Map<String, dynamic>> {
  @override
  Map<String, dynamic> parse(Map<String, dynamic> value) {
    if (!value.containsKey("data")) {
      throw JikanParseException();
    }
    return value['data'];
  }
}

class ListParser implements Parser<List> {
  @override
  List parse(Map<String, dynamic> value) {
    if (!value.containsKey("data")) {
      throw JikanParseException();
    }
    return value['data'];
  }
}

abstract class AnimeParser implements Parser<JikanAnime> {
  JikanAnime parseAnime(Map<String, dynamic> data);
}

abstract class ProducerParser implements Parser<JikanProducer> {
  JikanProducer parseProducer(Map<String, dynamic> data);
}

abstract class GenreParser implements Parser<JikanGenre> {
  JikanGenre parseGenre(Map<String, dynamic> data);
}
