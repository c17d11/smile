import 'dart:io';

import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/collection_query_intern.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/settings_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_genre.dart';
import 'package:app/database/src/isar/collection/isar_producer_query.dart';
import 'package:app/database/src/isar/collection/isar_producer_response.dart';
import 'package:app/database/src/isar/collection/isar_anime_query.dart';
import 'package:app/database/src/isar/collection/isar_schedule_query.dart';
import 'package:app/database/src/isar/collection/isar_settings.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/database/src/isar/model/anime_model.dart';
import 'package:app/database/src/isar/model/anime_query_model.dart';
import 'package:app/database/src/isar/model/anime_response_model.dart';
import 'package:app/database/src/isar/model/genre_model.dart';
import 'package:app/database/src/isar/model/producer_model.dart';
import 'package:app/database/src/isar/model/producer_query_model.dart';
import 'package:app/database/src/isar/model/producer_response_model.dart';
import 'package:app/database/src/isar/model/schedule_query_model.dart';
import 'package:app/database/src/isar/model/settings_model.dart';
import 'package:app/database/src/isar/model/tag_model.dart';
import 'package:app/ui/src/collections/state.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'collection/isar_anime_response.dart';
import 'collection/isar_producer.dart';
import '../database_base.dart';

class IsarDatabase implements Database {
  late final Isar instance;

  late IsarAnimeModel animeModel =
      IsarAnimeModel(instance, expirationHours: 24);
  late IsarAnimeResponseModel animeResponseModel =
      IsarAnimeResponseModel(instance, expirationHours: 24);
  late IsarProducerModel producerModel =
      IsarProducerModel(instance, expirationHours: 24);
  late IsarProducerResponseModel producerResponseModel =
      IsarProducerResponseModel(instance, expirationHours: 24);
  late IsarGenreModel genreModel =
      IsarGenreModel(instance, expirationHours: 24);
  late IsarAnimeQueryModel animeQueryModel =
      IsarAnimeQueryModel(instance, expirationHours: 24);
  late IsarProducerQueryModel producerQueryModel =
      IsarProducerQueryModel(instance, expirationHours: 24);
  late IsarScheduleQueryModel scheduleQueryModel =
      IsarScheduleQueryModel(instance, expirationHours: 24);
  late IsarSettingsModel settingsModel =
      IsarSettingsModel(instance, expirationHours: 24);
  late IsarTagModel tagModel = IsarTagModel(instance, expirationHours: 24);

  @override
  Future<void> init() async {
    String name = 'isar';
    Directory dir = await getApplicationDocumentsDirectory();
    if (!Isar.instanceNames.contains(name)) {
      instance = await Isar.open(
        [
          IsarAnimeSchema,
          IsarAnimeResponseSchema,
          IsarProducerSchema,
          IsarProducerResponseSchema,
          IsarGenreSchema,
          IsarAnimeQuerySchema,
          IsarScheduleQuerySchema,
          IsarProducerQuerySchema,
          IsarSettingsSchema,
          IsarTagSchema,
        ],
        directory: dir.path,
        inspector: true,
        name: name,
      );
      // instance.writeTxnSync(() => instance.clearSync());
    }
  }

  @override
  Future<void> clear() async {
    await instance.writeTxn(() async {
      await instance.clear();
    });
  }

  @override
  Future<void> close() async {
    await init();
    await instance.close(deleteFromDisk: false);
  }

  @override
  Future<void> remove() async {
    await init();
    await instance.writeTxn(() async {
      await instance.clear();
    });
  }

  @override
  Future<String> getDatabaseSize() async {
    Directory dir = await getApplicationDocumentsDirectory();

    try {
      if (dir.existsSync()) {
        int sizeBytes = 0;
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File &&
              (basename(entity.path).endsWith("isar") ||
                  basename(entity.path).endsWith("isar.lock"))) {
            sizeBytes += entity.lengthSync();
          }
        });
        if (sizeBytes > (1024 * 1024)) {
          return "${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB";
        }
        if (sizeBytes > 1024) {
          return "${(sizeBytes / 1024).toStringAsFixed(1)} KB";
        }
        return "$sizeBytes B";
      }
      // ignore: empty_catches
    } catch (e) {}
    return "Empty";
  }

  @override
  AnimeResponseIntern createAnimeResponseIntern(AnimeResponse res) {
    return animeResponseModel.createAnimeResponseIntern(res);
  }

  @override
  AnimeIntern createAnimeIntern(Anime anime) {
    return animeModel.createAnimeIntern(anime);
  }

  @override
  Future<bool> deleteAnime(int malId) async {
    return await animeModel.deleteAnime(malId);
  }

  @override
  Future<bool> deleteAnimeResponse(String query) async {
    return await animeResponseModel.deleteAnimeResponse(query);
  }

  @override
  Future<bool> deleteProducer(int malId) async {
    return producerModel.deleteProducer(malId);
  }

  @override
  Future<List<IsarAnime>> getAllAnimes() async {
    return await animeModel.getAllAnimes();
  }

  @override
  Future<List<IsarAnime>> getFavoriteAnimes(int page) async {
    return await animeModel.getFavoriteAnimes(page);
  }

  @override
  Future<List<IsarAnime>> getCollection(CollectionQueryIntern query) async {
    return await animeModel.getCollection(query);
  }

  @override
  Future<int> countFavoriteAnimes() async {
    return await animeModel.countFavoriteAnimes();
  }

  @override
  int countFavoriteAnimePages(int favoriteAnimeCount) {
    return animeModel.countFavoriteAnimePages(favoriteAnimeCount);
  }

  @override
  Future<List<ProducerIntern>> getAllProducers() async {
    return await producerModel.getAllProducers();
  }

  @override
  Future<IsarAnime?> getAnime(int malId) async {
    return await animeModel.getAnime(malId);
  }

  @override
  Future<IsarAnimeResponse?> getAnimeResponse(String query) async {
    return await animeResponseModel.getAnimeResponse(query);
  }

  @override
  Future<ProducerIntern?> getProducer(int malId) async {
    return await producerModel.getProducer(malId);
  }

  @override
  Future<IsarAnime> insertAnime(AnimeIntern anime) async {
    return await animeModel.insertAnime(anime);
  }

  @override
  Future<IsarAnimeResponse> insertAnimeResponse(AnimeResponseIntern res) async {
    return animeResponseModel.insertAnimeResponse(res);
  }

  @override
  Future<void> insertProducer(ProducerIntern producer) async {
    return await producerModel.insertProducer(producer);
  }

  @override
  ProducerResponseIntern createProducerResponseIntern(ProducerResponse res) {
    return IsarProducerResponse.from(res);
  }

  @override
  Future<bool> deleteProducerResponse(ProducerQuery query) async {
    return await producerResponseModel.deleteProducerResponse(query);
  }

  @override
  Future<ProducerResponseIntern?> getProducerResponse(String query) async {
    return await producerResponseModel.getProducerResponse(query);
  }

  @override
  Future<void> insertProducerResponse(ProducerResponseIntern res) async {
    return producerResponseModel.insertProducerResponse(res);
  }

  @override
  Future<bool> deleteGenre(int malId) async {
    return await genreModel.deleteGenre(malId);
  }

  @override
  Future<List<GenreIntern>> getAllGenres() async {
    return await genreModel.getAllGenres();
  }

  @override
  Future<GenreIntern?> getGenre(int malId) async {
    return await genreModel.getGenre(malId);
  }

  @override
  Future<void> insertGenre(GenreIntern genre) async {
    return await genreModel.insertGenre(genre);
  }

  @override
  Future<void> insertGenres(List<Genre> genres) async {
    await genreModel.insertGenres(genres);
  }

  @override
  Future<AnimeQueryIntern?> getAnimeQuery() async {
    return await animeQueryModel.getAnimeQuery();
  }

  @override
  Future<void> updateAnimeQuery(AnimeQueryIntern query) async {
    await animeQueryModel.updateAnimeQuery(query);
  }

  @override
  Future<ScheduleQueryIntern?> getScheduleQuery() async {
    return await scheduleQueryModel.getScheduleQuery();
  }

  @override
  Future<void> updateScheduleQuery(ScheduleQueryIntern query) async {
    return await scheduleQueryModel.updateScheduleQuery(query);
  }

  @override
  Future<Settings?> getSettings() async {
    return await settingsModel.getSettings();
  }

  @override
  Future<void> updateSettings(Settings s) async {
    await settingsModel.updateSettings(s);
  }

  @override
  void setExpirationHours(int hours) {
    animeModel.expirationHours = hours;
    animeResponseModel.expirationHours = hours;
    producerModel.expirationHours = hours;
    producerResponseModel.expirationHours = hours;
    genreModel.expirationHours = hours;
    animeQueryModel.expirationHours = hours;
    scheduleQueryModel.expirationHours = hours;
    settingsModel.expirationHours = hours;
  }

  @override
  Future<bool> deleteTag(Tag tag) async {
    return await tagModel.deleteTag(tag);
  }

  @override
  Future<List<IsarTag>> getAllTags() async {
    return await tagModel.getAllTags();
  }

  @override
  Future<IsarTag?> getTag(String tagName) async {
    return await tagModel.getTag(tagName);
  }

  @override
  Future<void> insertTags(List<Tag> tags) async {
    return await tagModel.insertTags(tags);
  }

  @override
  Future<ProducerQueryIntern?> getProducerQuery(String page) async {
    return await producerQueryModel.getProducerQuery(page);
  }

  @override
  Future<void> updateProducerQuery(
      String page, ProducerQueryIntern query) async {
    return await producerQueryModel.updateProducerQuery(page, query);
  }
}

Database get database => IsarDatabase();
