import '../object/response.dart';
import '../api/schedule_search_api.dart';
import '../http/http.dart';
import '../object/schedule_query.dart';
import 'task.dart';
import '../object/anime.dart';

class ScheduleFetchAllTask implements Task<List<JikanAnime>> {
  ScheduleSearchApi scheduleApi;

  List<JikanAnime> animes = [];
  int totalPages = 1;
  int cachedPages = 0;
  double get progress => cachedPages / totalPages;

  ScheduleFetchAllTask(Http client) : scheduleApi = ScheduleSearchApi(client);

  Future<void> cacheResult({required int page}) async {
    // TODO catch exceptions
    JikanAnimeResponse res =
        await scheduleApi.call(JikanScheduleQuery()..page = page);
    animes.addAll(res.data ?? []);
    totalPages = res.pagination?.lastVisiblePage ?? totalPages;
  }

  @override
  Stream<double> run() async* {
    do {
      yield progress;
      await cacheResult(page: ++cachedPages);
    } while (cachedPages < totalPages);
    yield progress;
  }

  @override
  List<JikanAnime> getResult() => animes;
}
