import 'package:app/object/anime.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/object/anime_response.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class BrowseStateNotifier extends StateNotifier<AsyncValue<AnimeResponse>> {
  late final Database _database;
  late final JikanApi _api;
  final StateNotifierProviderRef ref;

  BrowseStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databasePod);
    _api = ref.watch(apiPod);
  }

  Future<AnimeResponse> _getApiResponse(AnimeQuery query) async {
    JikanAnimeResponse res = await _api.searchAnimes(query);
    return AnimeResponse.from(res);
  }

  Future<AnimeResponse> _getSearchResponse(AnimeQuery query) async {
    String queryString = _api.buildAnimeSearchQuery(query);
    AnimeResponse? res = await _database.getAnimeResponse(queryString);
    if (res == null || await _database.isExpired(res)) {
      res = await _getApiResponse(query);
      await _database.insertAnimeResponse(res);
      res = await _database.getAnimeResponse(queryString);
    }
    return res!;
  }

  Future<void> get(AnimeQuery query) async {
    try {
      state = const AsyncLoading();
      AnimeResponse res = await _getSearchResponse(query);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> refresh(int animeId) async {
    Anime? anime = await _database.getAnime(animeId);
    AnimeResponse res = state.value!;
    res.animes =
        res.animes?.map((e) => e.malId == animeId ? anime! : e).toList();

    state = AsyncValue.data(res);
  }
}

final animeBrowse = StateNotifierProvider.family
    .autoDispose<BrowseStateNotifier, AsyncValue<AnimeResponse>, AnimeQuery>(
        (ref, arg) {
  BrowseStateNotifier controller = BrowseStateNotifier(ref);
  controller.get(arg);
  return controller;
});
