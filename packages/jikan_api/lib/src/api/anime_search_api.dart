import '../builder/builder.dart';
import '../http/http.dart';
import '../http/http_result.dart';
import '../object/anime_query.dart';
import 'api.dart';
import '../builder/anime_query_builder.dart';
import '../parser/anime_search_parser.dart';
import '../parser/exception_parser.dart';
import '../parser/pagination_parser.dart';
import '../object/anime.dart';
import '../parser/parser.dart';
import '../object/exception.dart';
import '../object/pagination.dart';
import '../object/response.dart';

class AnimeSearchApi implements Api<JikanAnimeQuery, JikanAnimeResponse> {
  Http client;
  Builder<JikanAnimeQuery, String> builder = AnimeQueryBuilder();
  Parser<List<JikanAnime>> animeSearchParser = AnimeSearchParser();
  Parser<JikanPagination> paginationParser = PaginationParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  AnimeSearchApi(this.client);

  String buildQuery(JikanAnimeQuery arg) {
    String query = builder.build(arg);
    query = query.isEmpty ? "" : "?$query";
    return "anime$query";
  }

  @override
  Future<JikanAnimeResponse> call(JikanAnimeQuery arg) async {
    String query = buildQuery(arg);
    HttpResult res = await client.get(query);
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }
    JikanPagination pagination = paginationParser.parse(res.data ?? {});
    List<JikanAnime> animes = animeSearchParser.parse(res.data ?? {});
    return JikanAnimeResponse()
      ..query = query
      ..pagination = pagination
      ..data = animes;
  }
}
