import 'package:app/controller/state.dart';
import 'package:app/object/anime_notes.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/object/genre.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/object/settings.dart';
import 'package:app/object/tag.dart';

abstract interface class AnimeModel {
  // Future<Anim> insertAnime(AnimeIntern anime);
  Future<Anime?> getAnime(int malId);
  // Future<List<IsarAnime>> getAllAnimes();
  Future<AnimeResponse> getFavoriteAnimes();
  Future<AnimeResponse> getTagAnimes(String tagName);
  // Future<int> countFavoriteAnimes();
  // int countFavoriteAnimePages(int favoriteAnimeCount);
  // Future<bool> deleteAnime(int malId);
  // AnimeIntern createAnimeIntern(Anime anime);
}

abstract interface class AnimeNotesModel {
  Future<void> updateAnimeNotes(AnimeNotes notes);
}

abstract interface class AnimeResponseModel {
  Future<void> insertAnimeResponse(AnimeResponse res);
  Future<AnimeResponse?> getAnimeResponse(String query);
  // Future<bool> deleteAnimeResponse(String query);
  // AnimeResponseIntern createAnimeResponseIntern(AnimeResponse res);
}

abstract interface class ProducerResponseModel {
  Future<void> insertProducerResponse(ProducerResponse res);
  Future<ProducerResponse?> getProducerResponse(String query);
  // Future<bool> deleteProducerResponse(ProducerQuery query);
  // ProducerResponseIntern createProducerResponseIntern(ProducerResponse res);
}

abstract interface class GenreModel {
  // Future<void> insertGenre(GenreIntern genre);
  Future<void> insertGenres(List<Genre> genres);
  // Future<GenreIntern?> getGenre(int malId);
  Future<List<Genre>> getAllGenres();
  // Future<bool> deleteGenre(int malId);
}

abstract interface class ProducerModel {
  Future<List<Producer>> getAllProducers();
}

abstract interface class AnimeQueryModel {
  Future<void> updateAnimeQuery(AnimeQuery query);
  Future<AnimeQuery?> getAnimeQuery();
}

abstract interface class ProducerQueryModel {
  Future<void> updateProducerQuery(ProducerQuery query);
  Future<ProducerQuery?> getProducerQuery(String page);
}

abstract interface class ScheduleQueryModel {
  Future<void> updateScheduleQuery(ScheduleQuery query);
  Future<ScheduleQuery?> getScheduleQuery();
}

abstract interface class SettingsModel {
  Future<Settings?> getSettings();
  Future<void> updateSettings(Settings s);
}

abstract interface class TagModel {
  Future<void> insertTags(List<Tag> tags);
  Future<List<Tag>> getAllTags();
  Future<bool> deleteTag(Tag tag);
}

abstract interface class ModelProxy
    implements
        AnimeModel,
        AnimeNotesModel,
        AnimeResponseModel,
        ProducerResponseModel,
        ProducerModel,
        GenreModel,
        AnimeQueryModel,
        ProducerQueryModel,
        ScheduleQueryModel,
        SettingsModel,
        TagModel {}
