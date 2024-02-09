import 'package:app/object/anime.dart';
import 'package:app/object/anime_notes.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/object/anime_response.dart';
import 'package:app/object/expiration.dart';
import 'package:app/object/genre.dart';
import 'package:app/object/producer.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/object/settings.dart';
import 'package:app/object/tag.dart';

abstract interface class AnimeModel {
  Future<Anime?> getAnime(int malId);
}

abstract interface class AnimeNotesModel {
  Future<void> updateAnimeNotes(AnimeNotes notes);
  Future<List<int>> getFavoriteAnimeIds();
  Future<List<int>> getTagAnimeIds(String tagName);
}

abstract interface class AnimeResponseModel {
  Future<void> insertAnimeResponse(AnimeResponse res);
  Future<AnimeResponse?> getAnimeResponse(String query);
  Future<AnimeResponse> getFavoriteAnimes();
  Future<AnimeResponse> getTagAnimes(String tagName);
  Future<AnimeResponse?> getLastResponse();
}

abstract interface class ProducerResponseModel {
  Future<void> insertProducerResponse(ProducerResponse res);
  Future<ProducerResponse?> getProducerResponse(String query);
}

abstract interface class GenreModel {
  Future<void> insertGenres(List<Genre> genres);
  Future<List<Genre>> getAllGenres();
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
  Future<bool> isExpired(Expiration expiration);
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
