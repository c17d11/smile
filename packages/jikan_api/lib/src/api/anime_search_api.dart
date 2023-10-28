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

class AnimeSearchApi implements Api<AnimeQuery, AnimeResponse> {
  Http client;
  Builder<AnimeQuery, String> builder = AnimeQueryBuilder();
  Parser<List<Anime>> animeSearchParser = AnimeSearchParser();
  Parser<Pagination> paginationParser = PaginationParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  AnimeSearchApi(this.client);

  String buildQuery(AnimeQuery arg) {
    String query = builder.build(arg);
    query = query.isEmpty ? "" : "?$query";
    return query;
  }

  @override
  Future<AnimeResponse> call(AnimeQuery arg) async {
    String query = "anime${buildQuery(arg)}";
    HttpResult res = await client.get(query);
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }
    Pagination pagination = paginationParser.parse(res.data ?? {});
    List<Anime> animes = animeSearchParser.parse(res.data ?? {});
    return AnimeResponse()
      ..query = query
      ..pagination = pagination
      ..data = animes;
  }
}
