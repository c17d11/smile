import '../object/response.dart';
import '../api/schedule_search_api.dart';
import '../http/http.dart';
import '../object/schedule_query.dart';
import 'task.dart';
import '../object/anime.dart';

class ScheduleFetchAllTask implements Task<List<Anime>> {
  ScheduleSearchApi scheduleApi;

  List<Anime> animes = [];
  int totalPages = 1;
  int cachedPages = 0;
  double get progress => cachedPages / totalPages;

  ScheduleFetchAllTask(Http client) : scheduleApi = ScheduleSearchApi(client);

  Future<void> cacheResult({required int page}) async {
    // TODO catch exceptions
    AnimeResponse res = await scheduleApi.call(ScheduleQuery()..page = page);
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
  List<Anime> getResult() => animes;
}
