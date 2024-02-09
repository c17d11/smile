import 'dart:io';

import 'package:app/database/src/isar/anime_note/model.dart';
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
import 'package:app/database/src/isar/anime/collection.dart';
import 'package:app/database/src/isar/anime_note/collection.dart';
import 'package:app/database/src/isar/anime_query/collection.dart';
import 'package:app/database/src/isar/anime_query/model.dart';
import 'package:app/database/src/isar/anime_response/collection.dart';
import 'package:app/database/src/isar/anime_response/model.dart';
import 'package:app/database/src/isar/genre/collection.dart';
import 'package:app/database/src/isar/genre/model.dart';
import 'package:app/database/src/isar/anime/model.dart';
import 'package:app/database/src/isar/producer/collection.dart';
import 'package:app/database/src/isar/producer/model.dart';
import 'package:app/database/src/isar/producer_query/collection.dart';
import 'package:app/database/src/isar/producer_query/model.dart';
import 'package:app/database/src/isar/producer_response/collection.dart';
import 'package:app/database/src/isar/producer_response/model.dart';
import 'package:app/database/src/isar/schedule_query/collection.dart';
import 'package:app/database/src/isar/schedule_query/model.dart';
import 'package:app/database/src/isar/settings/collection.dart';
import 'package:app/database/src/isar/settings/model.dart';
import 'package:app/database/src/isar/tag/collection.dart';
import 'package:app/database/src/isar/tag/model.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../interface/database.dart';

class IsarDatabase implements Database {
  late final Isar instance;

  late IsarSettingsModel settingsModel = IsarSettingsModel(instance);
  late IsarAnimeModel animeModel = IsarAnimeModel(instance);
  late IsarAnimeNoteModel animeNoteModel = IsarAnimeNoteModel(instance);
  late IsarProducerModel producerModel = IsarProducerModel(instance);
  late IsarGenreModel genreModel = IsarGenreModel(instance);
  late IsarAnimeQueryModel animeQueryModel = IsarAnimeQueryModel(instance);
  late IsarProducerQueryModel producerQueryModel =
      IsarProducerQueryModel(instance);
  late IsarScheduleQueryModel scheduleQueryModel =
      IsarScheduleQueryModel(instance);
  late IsarTagModel tagModel = IsarTagModel(instance);
  late IsarAnimeResponseModel animeResponseModel =
      IsarAnimeResponseModel(instance);
  late IsarProducerResponseModel producerResponseModel =
      IsarProducerResponseModel(instance);

  @override
  Future<void> init() async {
    String name = 'isar';
    Directory dir = await getApplicationDocumentsDirectory();
    if (!Isar.instanceNames.contains(name)) {
      instance = await Isar.open(
        [
          IsarAnimeSchema,
          IsarAnimeNoteSchema,
          IsarAnimeQuerySchema,
          IsarAnimeResponseSchema,
          IsarGenreSchema,
          IsarProducerSchema,
          IsarProducerQuerySchema,
          IsarProducerResponseSchema,
          IsarScheduleQuerySchema,
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
  Future<bool> deleteTag(Tag tag) async {
    late bool success = false;
    await instance.writeTxn(() async {
      success = await tagModel.deleteTag(tag);
    });
    return success;
  }

  @override
  Future<List<Genre>> getAllGenres() async {
    late List<Genre> genres;
    await instance.txn(() async {
      genres = await genreModel.getAllGenres();
    });
    return genres;
  }

  @override
  Future<List<Tag>> getAllTags() async {
    late List<Tag> tags;
    await instance.txn(() async {
      tags = await tagModel.getAllTags();
    });
    return tags;
  }

  @override
  Future<AnimeQuery?> getAnimeQuery() async {
    late AnimeQuery? query;
    await instance.txn(() async {
      query = await animeQueryModel.getAnimeQuery();
    });
    return query;
  }

  @override
  Future<AnimeResponse?> getAnimeResponse(String query) async {
    late AnimeResponse? res;
    await instance.txn(() async {
      res = await animeResponseModel.getAnimeResponse(query);
    });
    return res;
  }

  @override
  Future<AnimeResponse> getFavoriteAnimes() async {
    late AnimeResponse res;
    await instance.txn(() async {
      res = await animeResponseModel.getFavoriteAnimes();
    });
    return res;
  }

  @override
  Future<ProducerQuery?> getProducerQuery(String page) async {
    late ProducerQuery? query;
    await instance.txn(() async {
      query = await producerQueryModel.getProducerQuery(page);
    });
    return query;
  }

  @override
  Future<ProducerResponse?> getProducerResponse(String query) async {
    late ProducerResponse? res;
    await instance.txn(() async {
      res = await producerResponseModel.getProducerResponse(query);
    });
    return res;
  }

  @override
  Future<ScheduleQuery?> getScheduleQuery() async {
    late ScheduleQuery? query;
    await instance.txn(() async {
      query = await scheduleQueryModel.getScheduleQuery();
    });
    return query;
  }

  @override
  Future<Settings?> getSettings() async {
    late Settings? settings;
    await instance.txn(() async {
      settings = await settingsModel.getSettings();
    });
    return settings;
  }

  @override
  Future<void> insertAnimeResponse(AnimeResponse res) async {
    await instance.writeTxn(() async {
      await animeResponseModel.insertAnimeResponse(res);
    });
  }

  @override
  Future<void> insertGenres(List<Genre> genres) async {
    await instance.writeTxn(() async {
      await genreModel.insertGenres(genres);
    });
  }

  @override
  Future<void> insertTags(List<Tag> tags) async {
    await instance.writeTxn(() async {
      await tagModel.insertTags(tags);
    });
  }

  @override
  Future<void> updateAnimeQuery(AnimeQuery query) async {
    await instance.writeTxn(() async {
      animeQueryModel.updateAnimeQuery(query);
    });
  }

  @override
  Future<void> updateProducerQuery(ProducerQuery query) async {
    await instance.writeTxn(() async {
      producerQueryModel.updateProducerQuery(query);
    });
  }

  @override
  Future<void> updateScheduleQuery(ScheduleQuery query) async {
    await instance.writeTxn(() async {
      await scheduleQueryModel.updateScheduleQuery(query);
    });
  }

  @override
  Future<void> updateSettings(Settings s) async {
    await instance.writeTxn(() async {
      await settingsModel.updateSettings(s);
    });
  }

  @override
  Future<AnimeResponse> getTagAnimes(String tagName) async {
    late AnimeResponse res;
    await instance.txn(() async {
      res = await animeResponseModel.getTagAnimes(tagName);
    });
    return res;
  }

  @override
  Future<void> updateAnimeNotes(AnimeNotes notes) async {
    await instance.writeTxn(() async {
      await animeNoteModel.updateAnimeNotes(notes);
    });
  }

  @override
  Future<void> insertProducerResponse(ProducerResponse res) async {
    await instance.writeTxn(() async {
      await producerResponseModel.insertProducerResponse(res);
    });
  }

  @override
  Future<List<Producer>> getAllProducers() async {
    late List<Producer> producers;
    await instance.txn(() async {
      producers = await producerModel.getAllProducers();
    });
    return producers;
  }

  @override
  Future<Anime?> getAnime(int malId) async {
    late Anime? anime;
    await instance.txn(() async {
      anime = await animeModel.getAnime(malId);
    });
    return anime;
  }

  @override
  Future<bool> isExpired(Expiration expiration) async {
    late bool expired = false;
    await instance.txn(() async {
      expired = await settingsModel.isExpired(expiration);
    });
    return expired;
  }

  @override
  Future<List<int>> getFavoriteAnimeIds() {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getTagAnimeIds(String tagName) {
    throw UnimplementedError();
  }

  @override
  Future<AnimeResponse?> getLastResponse() async {
    late AnimeResponse? res;
    await instance.txn(() async {
      res = await animeResponseModel.getLastResponse();
    });
    return res;
  }
}

Database get database => IsarDatabase();
