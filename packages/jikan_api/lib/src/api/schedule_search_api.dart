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

class ScheduleSearchApi implements Api<ScheduleQuery, AnimeResponse> {
  Http client;
  Builder<ScheduleQuery, String> builder = ScheduleQueryBuilder();
  Parser<List<Anime>> animeSearchParser = AnimeSearchParser();
  Parser<Pagination> paginationParser = PaginationParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  ScheduleSearchApi(this.client);

  String buildQuery(ScheduleQuery arg) {
    String query = builder.build(arg);
    query = query.isEmpty ? "" : "?$query";
    return query;
  }

  @override
  Future<AnimeResponse> call(ScheduleQuery arg) async {
    String query = buildQuery(arg);
    HttpResult res = await client.get("schedules$query");
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }
    Pagination pagination = paginationParser.parse(res.data ?? {});
    List<Anime> animes = animeSearchParser.parse(res.data ?? {});
    return AnimeResponse()
      ..pagination = pagination
      ..data = animes;
  }
}
