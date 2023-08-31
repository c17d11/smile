import 'parser.dart';
import 'genre_parser.dart';
import 'jikan_parser.dart';
import '../object/genre.dart';

class GenreSearchParser implements Parser<List<Genre>> {
  Parser<List> listParser = ListParser();
  GenreParser genreParser = GenreParserImp();

  List<Genre> parseGenreSearch(List data) {
    if (data.isEmpty) {
      return [];
    }
    List<Genre> genres = data.map((e) => genreParser.parseGenre(e)).toList();
    return genres;
  }

  @override
  List<Genre> parse(Map<String, dynamic> value) {
    List data = listParser.parse(value);
    List<Genre> genres = parseGenreSearch(data);
    return genres;
  }
}
