import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/model/genre_model.dart';
import 'package:app/database/src/isar/model/producer_model.dart';
import 'package:app/database/src/isar/model/tag_model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import '../collection/isar_anime.dart';

class IsarAnimeModel extends IsarModel implements AnimeModel {
  final IsarTagModel _tagModel;
  final IsarProducerModel _producerModel;
  final IsarGenreModel _genreModel;

  IsarAnimeModel(super.db, {required super.expirationHours})
      : _tagModel = IsarTagModel(db, expirationHours: expirationHours),
        _producerModel =
            IsarProducerModel(db, expirationHours: expirationHours),
        _genreModel = IsarGenreModel(db, expirationHours: expirationHours);

  Future<List<IsarAnime>> insertAnimesInTxn(List<AnimeIntern> animes) async {
    List<IsarAnime> isarAnimes = [];
    for (var anime in animes) {
      IsarAnime isarAnime = IsarAnime.from(anime);

      // Store linked objects first
      final isarTags = await _tagModel.insertTagsInTxn(isarAnime.tags ?? []);
      final isarProducers = await _producerModel.insertProducersInTxn(
          isarAnime.producers?.map((e) => ProducerIntern.from(e)).toList() ??
              []);
      final isarGenres = await _genreModel.insertGenresInTxn(
          isarAnime.genres?.map((e) => GenreIntern.from(e)).toList() ?? []);

      // Then store the anime object
      await db.isarAnimes.put(isarAnime);

      // Update the links
      await isarAnime.isarTags.reset();
      isarAnime.isarTags.addAll(isarTags);
      await isarAnime.isarTags.save();

      await isarAnime.isarProducers.reset();
      isarAnime.isarProducers.addAll(isarProducers);
      await isarAnime.isarProducers.save();

      await isarAnime.isarGenres.reset();
      isarAnime.isarGenres.addAll(isarGenres);
      await isarAnime.isarGenres.save();

      // Done
      isarAnimes.add(isarAnime);
    }
    return isarAnimes;
  }

  List<AnimeIntern> getAnimesFromIsar(List<IsarAnime> isarAnimes) {
    return isarAnimes.map((e) => e.toAnime()).toList();
  }

  @override
  Future<IsarAnime> insertAnime(AnimeIntern anime) async {
    late IsarAnime isarAnime;
    await write(() async {
      List<IsarAnime> animes = await insertAnimesInTxn([anime]);
      isarAnime = animes[0];
    });
    return isarAnime;
  }

  @override
  Future<IsarAnime?> getAnime(int malId) async {
    IsarAnime? anime;
    await read(() async {
      anime = await db.isarAnimes.get(malId);
    });
    if (isExpired(anime)) return null;
    return anime;
  }

  @override
  Future<List<IsarAnime>> getAllAnimes() async {
    late List<IsarAnime> animes;
    await read(() async {
      animes = await db.isarAnimes.where().findAll();
    });
    return animes;
  }

  @override
  Future<List<IsarAnime>> getFavoriteAnimes(int page) async {
    late List<IsarAnime> isarAnimes;
    await read(() async {
      isarAnimes = await db.isarAnimes
          .filter()
          .isFavoriteEqualTo(true)
          .offset(10 * (page - 1))
          .limit(10)
          .findAll();
    });
    return isarAnimes;
  }

  @override
  Future<List<IsarAnime>> getCollection(Tag tag, int page) async {
    late List<IsarAnime> isarAnimes;
    await read(() async {
      isarAnimes = await db.isarAnimes
          .filter()
          .isarTags((q) => q.nameEqualTo(tag.name))
          .offset(10 * (page - 1))
          .limit(10)
          .findAll();
    });
    return isarAnimes;
  }

  @override
  Future<int> countFavoriteAnimes() async {
    late int favoriteCount;
    await read(() async {
      favoriteCount =
          await db.isarAnimes.filter().isFavoriteEqualTo(true).count();
    });
    return favoriteCount;
  }

  @override
  Future<int> countCollectionAnimes(Tag tag) async {
    late int animeCount;
    await read(() async {
      animeCount = await db.isarAnimes
          .filter()
          .isarTags((q) => q.nameEqualTo(tag.name))
          .count();
    });
    return animeCount;
  }

  @override
  int countFavoriteAnimePages(int favoriteAnimeCount) {
    return (favoriteAnimeCount / 10).ceil();
  }

  @override
  Future<bool> deleteAnime(int malId) async {
    bool success = false;
    await write(() async {
      success = await db.isarAnimes.delete(malId);
    });
    return success;
  }

  @override
  AnimeIntern createAnimeIntern(Anime anime) {
    return IsarAnime.from(anime);
  }
}
