import 'parser.dart';
import 'genre_parser.dart';
import 'jikan_parser.dart';
import '../object/genre.dart';

class GenreSearchParser implements Parser<List<JikanGenre>> {
  Parser<List> listParser = ListParser();
  GenreParser genreParser = GenreParserImp();

  List<JikanGenre> parseGenreSearch(List data) {
    if (data.isEmpty) {
      return [];
    }
    List<JikanGenre> genres =
        data.map((e) => genreParser.parseGenre(e)).toList();
    return genres;
  }

  @override
  List<JikanGenre> parse(Map<String, dynamic> value) {
    List data = listParser.parse(value);
    List<JikanGenre> genres = parseGenreSearch(data);
    return genres;
  }
}
