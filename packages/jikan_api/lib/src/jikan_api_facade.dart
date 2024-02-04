import 'api/anime_api.dart';
import 'api/anime_search_api.dart';
import 'api/genre_search_api.dart';
import 'api/producer_api.dart';
import 'api/producer_search_api.dart';
import 'api/schedule_search_api.dart';
import 'http/http.dart';
import 'http/jikan_client.dart';
import 'object/anime.dart';
import 'object/anime_query.dart';
import 'object/genre.dart';
import 'object/producer.dart';
import 'object/producer_query.dart';
import 'object/response.dart';
import 'object/schedule_query.dart';
import 'task/producer_fetch_all_task.dart';
import 'task/schedule_fetch_all_task.dart';
import 'package:rate_manager/rate_manager.dart';

class JikanApi {
  final Http _httpClient;
  late Http _primaryHttpClient;
  late Http _secondaryHttpClient;

  late AnimeApi _animeApi;
  late AnimeSearchApi _animeSearchApi;
  late GenreSearchApi _genreSearchApi;
  late ProducerApi _producerApi;
  late ProducerSearchApi _producerSearchApi;
  late ScheduleSearchApi _scheduleSearchApi;

  late ProducerFetchAllTask _fetchAllProducerTask;
  late ScheduleFetchAllTask _fetchAllScheduleTask;

  JikanApi(this._httpClient) {
    setRequestRate();
  }

  void init(RateManger rateManager) {
    _primaryHttpClient = PrimaryHttpClient(_httpClient, rateManager);
    _secondaryHttpClient = SecondaryHttpClient(_httpClient, rateManager);

    _animeApi = AnimeApi(_primaryHttpClient);
    _animeSearchApi = AnimeSearchApi(_primaryHttpClient);
    _genreSearchApi = GenreSearchApi(_primaryHttpClient);
    _producerApi = ProducerApi(_primaryHttpClient);
    _producerSearchApi = ProducerSearchApi(_primaryHttpClient);
    _scheduleSearchApi = ScheduleSearchApi(_primaryHttpClient);

    _fetchAllProducerTask = ProducerFetchAllTask(_secondaryHttpClient);
    _fetchAllScheduleTask = ScheduleFetchAllTask(_secondaryHttpClient);
  }

  void setRequestRate({int? requestsPerSecond, int? requestsPerMinute}) {
    init(
      RateManger(
        [
          RateLimit(requestsPerSecond ?? 2, 1, const Duration(seconds: 1)),
          RateLimit(requestsPerMinute ?? 50, 10, const Duration(seconds: 60)),
        ],
      ),
    );
  }

  Future<JikanAnime> getAnime(int malId) async {
    JikanAnime anime = await _animeApi.call(malId);
    return anime;
  }

  String buildAnimeSearchQuery(JikanAnimeQuery query) {
    return _animeSearchApi.buildQuery(query);
  }

  Future<JikanAnimeResponse> searchAnimes(JikanAnimeQuery query) async {
    JikanAnimeResponse res = await _animeSearchApi.call(query);
    return res;
  }

  Future<List<JikanGenre>> searchGenres() async {
    List<JikanGenre> genres = await _genreSearchApi.call(null);
    return genres;
  }

  Future<JikanProducer> getProducer(int malId) async {
    JikanProducer producer = await _producerApi.call(malId);
    return producer;
  }

  Future<JikanProducerResponse> searchProducers(
      JikanProducerQuery query) async {
    JikanProducerResponse res = await _producerSearchApi.call(query);
    return res;
  }

  String buildScheduleSearchQuery(JikanScheduleQuery query) {
    return _scheduleSearchApi.buildQuery(query);
  }

  Future<JikanAnimeResponse> searchSchedule(JikanScheduleQuery query) async {
    JikanAnimeResponse res = await _scheduleSearchApi.call(query);
    return res;
  }

  Stream<double> fetchAllProducers() async* {
    Stream<double> progress = _fetchAllProducerTask.run();
    await for (double d in progress) {
      yield d;
    }
  }

  List<JikanProducer> getFetchAllProducerResult() {
    return _fetchAllProducerTask.getResult();
  }

  Stream<double> fetchAllSchedule() async* {
    Stream<double> progress = _fetchAllScheduleTask.run();
    await for (double d in progress) {
      yield d;
    }
  }

  List<JikanAnime> getFetchAllScheduleResult() {
    return _fetchAllScheduleTask.getResult();
  }

  String buildProducerSearchQuery(JikanProducerQuery query) {
    return _producerSearchApi.buildQuery(query);
  }
}
