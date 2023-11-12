import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import '../collection/isar_anime.dart';

class IsarAnimeModel extends IsarModel implements AnimeModel {
  IsarAnimeModel(super.db, {required super.expirationHours});

  @override
  Future<void> insertAnime(AnimeIntern anime) async {
    IsarAnime isarAnime = anime as IsarAnime;
    List<IsarTag> tags =
        isarAnime.tags?.map<IsarTag>((e) => IsarTag.fromTag(e)).toList() ?? [];

    await write(() async {
      if (tags.isNotEmpty) {
        await db.isarTags.putAll(tags);
        isarAnime.isarTags.addAll(tags);
      }
      await db.isarAnimes.put(isarAnime);
      await isarAnime.isarTags.save();
    });
  }

  @override
  Future<AnimeIntern?> getAnime(int malId) async {
    IsarAnime? anime;
    await read(() async {
      anime = await db.isarAnimes.get(malId);
    });
    if (isExpired(anime)) return null;
    return anime;
  }

  @override
  Future<List<AnimeIntern>> getAllAnimes() async {
    late List<IsarAnime> animes;
    await read(() async {
      animes = await db.isarAnimes.where().findAll();
    });
    return animes;
  }

  @override
  Future<List<AnimeIntern>> getFavoriteAnimes(int page) async {
    late List<IsarAnime> animes;
    await read(() async {
      animes = await db.isarAnimes
          .filter()
          .isFavoriteEqualTo(true)
          .offset(10 * (page - 1))
          .limit(10)
          .findAll();
    });
    return animes;
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
