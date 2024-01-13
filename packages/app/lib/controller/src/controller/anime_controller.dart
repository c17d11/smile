import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeController extends StateNotifier<AsyncValue<AnimeIntern?>> {
  final Database _database;
  final JikanApi _api;

  AnimeController(this._database, this._api) : super(const AsyncLoading());

  Future<IsarAnime?> _getDatabaseAnime(int malId) async {
    IsarAnime? anime = await _database.getAnime(malId);
    return anime;
  }

  Future<AnimeIntern> _getApiAnime(int malId) async {
    Anime anime = await _api.getAnime(malId);

    // TODO: move this function to 'state'
    AnimeIntern animeIntern = _database.createAnimeIntern(anime);
    return animeIntern;
  }

  Future<IsarAnime> _storeResponse(AnimeIntern anime) async {
    return await _database.insertAnime(anime);
  }

  Future<IsarAnime> _getAnime(int malId) async {
    IsarAnime? anime = await _getDatabaseAnime(malId);
    if (anime == null) {
      AnimeIntern animeIntern = await _getApiAnime(malId);
      anime = await _storeResponse(animeIntern);
    }
    return anime;
  }

  Future<void> get(int malId) async {
    try {
      state = const AsyncLoading();
      AnimeIntern anime = await _getAnime(malId);

      state = AsyncValue.data(anime);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}
