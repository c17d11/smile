import '../object/response.dart';
import '../api/producer_search_api.dart';
import '../http/http.dart';
import '../object/producer_query.dart';
import 'task.dart';
import '../object/producer.dart';

class ProducerFetchAllTask implements Task<List<JikanProducer>> {
  ProducerSearchApi producerApi;

  List<JikanProducer> producers = [];
  int totalPages = 1;
  int cachedPages = 0;
  double get progress => cachedPages / totalPages;

  ProducerFetchAllTask(Http client) : producerApi = ProducerSearchApi(client);

  Future<void> cacheResult({required int page}) async {
    // TODO catch exceptions
    JikanProducerResponse res =
        await producerApi.call(JikanProducerQuery()..page = page);
    producers.addAll(res.data ?? []);
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
  List<JikanProducer> getResult() => producers;
}
