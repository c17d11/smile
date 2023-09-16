import 'package:jikan_api/jikan_api.dart';
import 'package:jikan_api/src/jikan_api.dart';

Future<void> exampleAnime() async {
  JikanApiBase api = JikanApi();
  Anime anime = await api.getAnime(1);
  print(anime);
}

Future<void> exampleFetchAllProducers() async {
  JikanApiBase api = JikanApi();
  Stream<double> progress = api.fetchAllProducers();
  await for (double d in progress) {
    print('Loading progress ${(d * 100).toInt()} %');
  }
  print(api.getFetchAllProducerResult());
  print(api.getFetchAllProducerResult().length);
}

Future<void> exampleScheduleSearch() async {
  JikanApiBase api = JikanApi();
  AnimeResponse res =
      await api.searchSchedule(ScheduleQuery()..day = ScheduleFriday());
  print(res);
}

void main() async {
  await exampleAnime();
  await exampleFetchAllProducers();
  await exampleScheduleSearch();
}
