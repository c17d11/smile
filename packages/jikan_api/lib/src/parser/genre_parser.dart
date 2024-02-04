import 'parser.dart';
import 'jikan_parser.dart';
import '../object/genre.dart';

class GenreParserImp implements GenreParser {
  Parser<Map<String, dynamic>> dataParser = DataParser();

  @override
  JikanGenre parseGenre(Map<String, dynamic> data) {
    return JikanGenre()
      ..malId = data['mal_id']
      ..name = data['name']
      ..count = data['count'];
  }

  @override
  JikanGenre parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    JikanGenre genre = parseGenre(data);
    return genre;
  }
}
