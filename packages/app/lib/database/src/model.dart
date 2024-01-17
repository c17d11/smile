import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/collection_query_intern.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/settings_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:jikan_api/jikan_api.dart';

abstract interface class AnimeModel {
  Future<IsarAnime> insertAnime(AnimeIntern anime);
  Future<IsarAnime?> getAnime(int malId);
  Future<List<IsarAnime>> getAllAnimes();
  Future<List<IsarAnime>> getFavoriteAnimes(int page);
  Future<int> countFavoriteAnimes();
  int countFavoriteAnimePages(int favoriteAnimeCount);
  Future<bool> deleteAnime(int malId);
  AnimeIntern createAnimeIntern(Anime anime);
}

abstract interface class AnimeResponseModel {
  Future<IsarAnimeResponse> insertAnimeResponse(AnimeResponseIntern res);
  Future<IsarAnimeResponse?> getAnimeResponse(String query);
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
  Future<ProducerResponseIntern?> getProducerResponse(String query);
  Future<bool> deleteProducerResponse(ProducerQuery query);
  ProducerResponseIntern createProducerResponseIntern(ProducerResponse res);
}

abstract interface class GenreModel {
  Future<void> insertGenre(GenreIntern genre);
  Future<void> insertGenres(List<Genre> genres);
  Future<GenreIntern?> getGenre(int malId);
  Future<List<GenreIntern>> getAllGenres();
  Future<bool> deleteGenre(int malId);
}

abstract interface class AnimeQueryModel {
  Future<void> updateAnimeQuery(AnimeQueryIntern query);
  Future<AnimeQueryIntern?> getAnimeQuery();
}

abstract interface class ProducerQueryModel {
  Future<void> updateProducerQuery(String page, ProducerQueryIntern query);
  Future<ProducerQueryIntern?> getProducerQuery(String page);
}

abstract interface class ScheduleQueryModel {
  Future<void> updateScheduleQuery(ScheduleQueryIntern query);
  Future<ScheduleQueryIntern?> getScheduleQuery();
}

abstract interface class SettingsModel {
  Future<Settings?> getSettings();
  Future<void> updateSettings(Settings s);
}

abstract interface class TagModel {
  Future<void> insertTags(List<Tag> tags);
  Future<List<IsarTag>> getAllTags();
  Future<IsarTag?> getTag(String tagName);
  Future<bool> deleteTag(Tag tag);
}

abstract interface class ModelProxy
    implements
        AnimeModel,
        AnimeResponseModel,
        ProducerModel,
        ProducerResponseModel,
        GenreModel,
        AnimeQueryModel,
        ProducerQueryModel,
        ScheduleQueryModel,
        SettingsModel,
        TagModel {}
