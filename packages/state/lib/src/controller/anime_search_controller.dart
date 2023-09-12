import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';
import 'package:database/database.dart';

class AnimeSearchController
    extends StateNotifier<AsyncValue<List<AnimeIntern>>> {
  final Database _database;
  final JikanApi _api;

  AnimeSearchController(this._database, this._api) : super(AsyncValue.data([]));

  Future<AnimeResponseIntern?> _getDatabaseResponse(AnimeQuery query) async {
    AnimeResponseIntern? res = await _database.getAnimeResponse(query);
    return res;
  }

  Future<AnimeResponseIntern> _getApiResponse(AnimeQuery query) async {
    AnimeResponse res = await _api.searchAnimes(query);

    // TODO: move this function to 'state'
    AnimeResponseIntern resIntern =
        _database.createAnimeResponseIntern(res, query);
    return resIntern;
  }

  Future<void> _storeResponse(AnimeResponseIntern res) async {
    await _database.insertAnimeResponse(res);
  }

  Future<AnimeResponseIntern> _getResponse(AnimeQuery query) async {
    AnimeResponseIntern? res = await _getDatabaseResponse(query);
    if (res == null) {
      res = await _getApiResponse(query);
      await _storeResponse(res);
    }
    return res;
  }

  Future<void> get(AnimeQuery query) async {
    try {
      state = const AsyncLoading();
      AnimeResponseIntern res = await _getResponse(query);

      List<AnimeIntern> animes = res.data ?? [];
      state = AsyncValue.data(animes);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}
