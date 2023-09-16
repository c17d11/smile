import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import '../collection/isar_anime.dart';

class IsarAnimeModel extends IsarModel implements AnimeModel {
  IsarAnimeModel(super.db);

  @override
  Future<void> insertAnime(AnimeIntern anime) async {
    IsarAnime isarAnime = anime as IsarAnime;
    await write(() async {
      await db.isarAnimes.put(isarAnime);
    });
  }

  @override
  Future<AnimeIntern?> getAnime(int malId) async {
    IsarAnime? anime;
    await read(() async {
      anime = await db.isarAnimes.get(malId);
    });
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
