import 'package:jikan_api/jikan_api.dart';

Future<void> exampleAnime() async {
  JikanApi api = JikanApiImpl();
  JikanAnime anime = await api.getAnime(1);
  print(anime);
}

Future<void> exampleFetchAllProducers() async {
  JikanApi api = JikanApiImpl();
  Stream<double> progress = api.fetchAllProducers();
  await for (double d in progress) {
    print('Loading progress ${(d * 100).toInt()} %');
  }
  print(api.getFetchAllProducerResult());
  print(api.getFetchAllProducerResult().length);
}

Future<void> exampleScheduleSearch() async {
  JikanApi api = JikanApiImpl();
  JikanAnimeResponse res =
      await api.searchSchedule(JikanScheduleQuery()..day = ScheduleFriday());
  print(res);
}

void main() async {
  await exampleAnime();
  await exampleFetchAllProducers();
  await exampleScheduleSearch();
}
