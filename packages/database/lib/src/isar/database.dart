import 'dart:io';

import 'package:database/src/isar/model/anime_model.dart';
import 'package:database/src/isar/model/anime_response_model.dart';
import 'package:database/src/isar/model/producer_model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:state/state.dart';
import 'collection/isar_anime.dart';
import 'collection/isar_anime_response.dart';
import 'collection/isar_producer.dart';
import '../database_base.dart';

class IsarDatabase implements Database {
  late final Isar instance;

  late IsarAnimeModel animeModel = IsarAnimeModel(instance);
  late IsarAnimeResponseModel animeResponseModel =
      IsarAnimeResponseModel(instance);
  late IsarProducerModel producerModel = IsarProducerModel(instance);

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
        ],
        directory: dir.path,
        inspector: true,
        name: name,
      );
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
    await instance.close(deleteFromDisk: true);
  }

  @override
  AnimeResponseIntern createAnimeResponseIntern(
      AnimeResponse res, AnimeQuery query) {
    return animeResponseModel.createAnimeResponseIntern(res, query);
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
  Future<bool> deleteAnimeResponse(AnimeQuery query) async {
    return await animeResponseModel.deleteAnimeResponse(query);
  }

  @override
  Future<bool> deleteProducer(int malId) async {
    return producerModel.deleteProducer(malId);
  }

  @override
  Future<List<AnimeIntern>> getAllAnimes() async {
    return await animeModel.getAllAnimes();
  }

  @override
  Future<List<ProducerIntern>> getAllProducers() async {
    return await producerModel.getAllProducers();
  }

  @override
  Future<AnimeIntern?> getAnime(int malId) async {
    return await animeModel.getAnime(malId);
  }

  @override
  Future<AnimeResponseIntern?> getAnimeResponse(AnimeQuery query) async {
    return await animeResponseModel.getAnimeResponse(query);
  }

  @override
  Future<ProducerIntern?> getProducer(int malId) async {
    return await producerModel.getProducer(malId);
  }

  @override
  Future<void> insertAnime(AnimeIntern anime) async {
    return await animeModel.insertAnime(anime);
  }

  @override
  Future<void> insertAnimeResponse(AnimeResponseIntern res) async {
    return animeResponseModel.insertAnimeResponse(res);
  }

  @override
  Future<void> insertProducer(ProducerIntern producer) async {
    return await producerModel.insertProducer(producer);
  }
}

Database get database => IsarDatabase();
