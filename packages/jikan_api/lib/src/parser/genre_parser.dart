import 'parser.dart';
import 'jikan_parser.dart';
import '../object/genre.dart';

class GenreParserImp implements GenreParser {
  Parser<Map<String, dynamic>> dataParser = DataParser();

  @override
  Genre parseGenre(Map<String, dynamic> data) {
    return Genre()
      ..malId = data['mal_id']
      ..name = data['name']
      ..count = data['count'];
  }

  @override
  Genre parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    Genre genre = parseGenre(data);
    return genre;
  }
}
