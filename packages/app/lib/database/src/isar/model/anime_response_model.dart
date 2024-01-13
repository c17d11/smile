import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/model/anime_model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

class IsarAnimeResponseModel extends IsarModel implements AnimeResponseModel {
  final IsarAnimeModel _animeModel;
  IsarAnimeResponseModel(super.db, {required super.expirationHours})
      : _animeModel = IsarAnimeModel(db, expirationHours: expirationHours);

  @override
  Future<IsarAnimeResponse> insertAnimeResponse(AnimeResponseIntern arg) async {
    IsarAnimeResponse res = arg as IsarAnimeResponse;
    res.isarPagination = IsarPagination.from(res.pagination);

    await write(() async {
      final isarAnimes = await _animeModel.insertAnimesInTxn(res.data ?? []);
      res.isarAnimes.clear();
      res.isarAnimes.addAll(isarAnimes);
      await db.isarAnimeResponses.put(res);
      await res.isarAnimes.save();
    });
    return res;
  }

  @override
  Future<IsarAnimeResponse?> getAnimeResponse(String query) async {
    // TODO: check query string and prevent possible injection.
    IsarAnimeResponse? res;
    await read(() async {
      res = await db.isarAnimeResponses.where().qEqualTo(query).findFirst();
    });
    if (isExpired(res)) return null;

    res?.data = _animeModel.getAnimesFromIsar(res?.isarAnimes.toList() ?? []);
    res?.pagination = res?.isarPagination;
    return res;
  }

  @override
  Future<bool> deleteAnimeResponse(String query) async {
    // TODO: check query string and prevent possible injection.
    bool success = false;
    await write(() async {
      success = await db.isarAnimeResponses.deleteByIndex("q", [query]);
    });

    return success;
  }

  @override
  AnimeResponseIntern createAnimeResponseIntern(AnimeResponse res) {
    return IsarAnimeResponse.from(res);
  }
}
