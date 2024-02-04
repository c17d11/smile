import 'api.dart';
import '../object/response.dart';
import '../builder/builder.dart';
import '../http/http.dart';
import '../http/http_result.dart';
import '../object/schedule_query.dart';
import '../parser/parser.dart';
import '../parser/anime_search_parser.dart';
import '../parser/exception_parser.dart';
import '../parser/pagination_parser.dart';
import '../builder/schedule_query_builder.dart';
import '../object/anime.dart';
import '../object/exception.dart';
import '../object/pagination.dart';

class ScheduleSearchApi implements Api<JikanScheduleQuery, JikanAnimeResponse> {
  Http client;
  Builder<JikanScheduleQuery, String> builder = ScheduleQueryBuilder();
  Parser<List<JikanAnime>> animeSearchParser = AnimeSearchParser();
  Parser<JikanPagination> paginationParser = PaginationParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  ScheduleSearchApi(this.client);

  String buildQuery(JikanScheduleQuery arg) {
    String query = builder.build(arg);
    query = query.isEmpty ? "" : "?$query";
    return "schedules$query";
  }

  @override
  Future<JikanAnimeResponse> call(JikanScheduleQuery arg) async {
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
