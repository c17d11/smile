import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class FavoriteStateNotifier
    extends StateNotifier<AsyncValue<IsarAnimeResponse>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  FavoriteStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
  }

  Future<IsarAnimeResponse> _getFavorites(int page) async {
    List<IsarAnime> favorites = await _database.getFavoriteAnimes(page);
    int favoriteCount = await _database.countFavoriteAnimes();
    int pageCount = _database.countFavoriteAnimePages(favoriteCount);

    IsarAnimeResponse res = IsarAnimeResponse(q: "favorites");
    res.data = favorites
        .map((e) => e..tags = e.isarTags.map((e) => e.toTag()).toList())
        .toList();
    res.pagination = Pagination()
      ..currentPage = page
      ..hasNextPage = false
      ..itemCount = favorites.length
      ..itemPerPage = favorites.length
      ..itemTotal = favoriteCount
      ..lastVisiblePage = pageCount;
    return res;
  }

  Future<void> get(int page) async {
    try {
      state = const AsyncLoading();
      IsarAnimeResponse res = await _getFavorites(page);
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

final animeFavorite = StateNotifierProvider.family
    .autoDispose<FavoriteStateNotifier, AsyncValue<IsarAnimeResponse>, int>(
        (ref, arg) {
  FavoriteStateNotifier controller = FavoriteStateNotifier(ref);
  controller.get(arg);
  return controller;
});
