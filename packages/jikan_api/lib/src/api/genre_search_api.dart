import 'api.dart';
import '../parser/parser.dart';
import '../parser/exception_parser.dart';
import '../parser/genre_search_parser.dart';
import '../object/exception.dart';
import '../object/genre.dart';
import '../http/http.dart';
import '../http/http_result.dart';

class GenreSearchApi implements Api<void, List<JikanGenre>> {
  Http client;
  Parser<List<JikanGenre>> genreSearchParser = GenreSearchParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  GenreSearchApi(this.client);

  @override
  Future<List<JikanGenre>> call(void arg) async {
    HttpResult res = await client.get("genres/anime");
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }
    List<JikanGenre> genres = genreSearchParser.parse(res.data ?? {});
    return genres;
  }
}
