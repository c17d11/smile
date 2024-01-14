import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class BrowseStateNotifier extends StateNotifier<AsyncValue<IsarAnimeResponse>> {
  late final Database _database;
  late final JikanApi _api;
  final StateNotifierProviderRef ref;

  BrowseStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
    _api = ref.watch(apiPod);
  }

  Future<AnimeResponseIntern> _getApiResponse(AnimeQuery query) async {
    AnimeResponse res = await _api.searchAnimes(query);
    AnimeResponseIntern resIntern = _database.createAnimeResponseIntern(res);
    return resIntern;
  }

  Future<IsarAnimeResponse> _getSearchResponse(AnimeQueryIntern query) async {
    String queryString = _api.buildAnimeSearchQuery(query);
    IsarAnimeResponse? res = await _database.getAnimeResponse(queryString);
    if (res == null) {
      final resIntern = await _getApiResponse(query);
      res = await _database.insertAnimeResponse(resIntern);
    }
    return res;
  }

  Future<void> get(AnimeQueryIntern query) async {
    try {
      state = const AsyncLoading();
      IsarAnimeResponse res = await _getSearchResponse(query);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> refresh() async {
    state = AsyncValue.data(state.value!);
  }
}

final animeBrowse = StateNotifierProvider.family.autoDispose<
    BrowseStateNotifier,
    AsyncValue<IsarAnimeResponse>,
    AnimeQueryIntern>((ref, arg) {
  BrowseStateNotifier controller = BrowseStateNotifier(ref);
  controller.get(arg);
  return controller;
});
