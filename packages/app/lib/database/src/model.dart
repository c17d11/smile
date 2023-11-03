import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/settings_intern.dart';
import 'package:app/controller/state.dart';
import 'package:jikan_api/jikan_api.dart';

abstract interface class AnimeModel {
  Future<void> insertAnime(AnimeIntern anime);
  Future<AnimeIntern?> getAnime(int malId);
  Future<List<AnimeIntern>> getAllAnimes();
  Future<List<AnimeIntern>> getFavoriteAnimes(int page);
  Future<int> countFavoriteAnimes();
  int countFavoriteAnimePages(int favoriteAnimeCount);
  Future<bool> deleteAnime(int malId);
  AnimeIntern createAnimeIntern(Anime anime);
}

abstract interface class AnimeResponseModel {
  Future<void> insertAnimeResponse(AnimeResponseIntern res);
  Future<AnimeResponseIntern?> getAnimeResponse(String query);
  Future<bool> deleteAnimeResponse(String query);
  AnimeResponseIntern createAnimeResponseIntern(AnimeResponse res);
}

abstract interface class ProducerModel {
  Future<void> insertProducer(ProducerIntern producer);
  Future<ProducerIntern?> getProducer(int malId);
  Future<List<ProducerIntern>> getAllProducers();
  Future<bool> deleteProducer(int malId);
}

abstract interface class ProducerResponseModel {
  Future<void> insertProducerResponse(ProducerResponseIntern res);
  Future<ProducerResponseIntern?> getProducerResponse(ProducerQuery query);
  Future<bool> deleteProducerResponse(ProducerQuery query);
  ProducerResponseIntern createProducerResponseIntern(
      ProducerResponse res, ProducerQuery query);
}

abstract interface class GenreModel {
  Future<void> insertGenre(GenreIntern genre);
  Future<void> insertGenres(List<Genre> genres);
  Future<GenreIntern?> getGenre(int malId);
  Future<List<GenreIntern>> getAllGenres();
  Future<bool> deleteGenre(int malId);
}

abstract interface class AnimeQueryModel {
  Future<void> updateAnimeQuery(String page, AnimeQueryIntern query);
  Future<AnimeQueryIntern?> getAnimeQuery(String page);
}

abstract interface class ScheduleQueryModel {
  Future<void> updateScheduleQuery(ScheduleQueryIntern query);
  Future<ScheduleQueryIntern?> getScheduleQuery();
}

abstract interface class SettingsModel {
  Future<Settings?> getSettings();
  Future<void> updateSettings(Settings s);
}

abstract interface class ModelProxy
    implements
        AnimeModel,
        AnimeResponseModel,
        ProducerModel,
        ProducerResponseModel,
        GenreModel,
        AnimeQueryModel,
        ScheduleQueryModel,
        SettingsModel {}
