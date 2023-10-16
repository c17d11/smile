import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

class IsarAnimeResponseModel extends IsarModel implements AnimeResponseModel {
  IsarAnimeResponseModel(super.db);

  @override
  Future<void> insertAnimeResponse(AnimeResponseIntern arg) async {
    IsarAnimeResponse res = arg as IsarAnimeResponse;
    res.isarPagination = IsarPagination.from(res.pagination);

    List<IsarAnime> animes =
        res.data?.map((e) => IsarAnime.fromIntern(e)).toList() ?? [];
    await write(() async {
      if (animes.isNotEmpty) {
        await db.isarAnimes.putAll(animes);
        res.isarAnimes.addAll(animes);
      }
      await db.isarAnimeResponses.put(res);
      await res.isarAnimes.save();
    });
  }

  @override
  Future<AnimeResponseIntern?> getAnimeResponse(AnimeQuery query) async {
    String isarQuery = IsarAnimeResponse.createQueryString(query);
    IsarAnimeResponse? res;
    await read(() async {
      res = await db.isarAnimeResponses.where().qEqualTo(isarQuery).findFirst();
    });

    res?.data = res?.isarAnimes.toList();
    res?.pagination = res?.isarPagination;
    return res;
  }

  @override
  Future<bool> deleteAnimeResponse(AnimeQuery query) async {
    String isarQuery = IsarAnimeResponse.createQueryString(query);

    bool success = false;
    await write(() async {
      success = await db.isarAnimeResponses.deleteByIndex("q", [isarQuery]);
    });

    return success;
  }

  @override
  AnimeResponseIntern createAnimeResponseIntern(
      AnimeResponse res, AnimeQuery query) {
    return IsarAnimeResponse.from(res, query);
  }
}
