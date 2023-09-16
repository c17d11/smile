import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeController extends StateNotifier<AsyncValue<AnimeIntern?>> {
  final Database _database;
  final JikanApi _api;

  AnimeController(this._database, this._api)
      : super(const AsyncValue.data(null));

  Future<AnimeIntern?> _getDatabaseAnime(int malId) async {
    AnimeIntern? anime = await _database.getAnime(malId);
    return anime;
  }

  Future<AnimeIntern> _getApiAnime(int malId) async {
    Anime anime = await _api.getAnime(malId);

    // TODO: move this function to 'state'
    AnimeIntern animeIntern = _database.createAnimeIntern(anime);
    return animeIntern;
  }

  Future<void> _storeResponse(AnimeIntern anime) async {
    await _database.insertAnime(anime);
  }

  Future<AnimeIntern> _getAnime(int malId) async {
    AnimeIntern? anime = await _getDatabaseAnime(malId);
    if (anime == null) {
      anime = await _getApiAnime(malId);
      await _storeResponse(anime);
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
