import 'api.dart';
import '../object/exception.dart';
import '../object/anime.dart';
import '../parser/anime_parser.dart';
import '../parser/exception_parser.dart';
import '../parser/parser.dart';
import '../http/http.dart';
import '../http/http_result.dart';

class AnimeApi implements Api<int, JikanAnime> {
  Http client;
  Parser<JikanAnime> animeParser = AnimeApiParser();
  ErrorParser errorParser = ErrorParser();

  AnimeApi(this.client);

  @override
  Future<JikanAnime> call(int arg) async {
    HttpResult res = await client.get("anime/$arg");
    if (res.error != null) {
      JikanApiException e = errorParser.parse(res.error!);
      return Future.error(e);
    }
    JikanAnime anime = animeParser.parse(res.data ?? {});
    return anime;
  }
}
