import 'package:app/controller/src/controller/anime_collection_state_controller.dart';
import 'package:app/controller/src/controller/anime_schedule_state_controller.dart';
import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeFavoriteStateController
    extends StateNotifier<AsyncValue<AnimeResponseIntern>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  AnimeFavoriteStateController(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
  }

  Future<AnimeResponseIntern> _getFavorites(int page) async {
    List<AnimeIntern> favorites = await _database.getFavoriteAnimes(page);
    int favoriteCount = await _database.countFavoriteAnimes();
    int pageCount = _database.countFavoriteAnimePages(favoriteCount);

    AnimeResponseIntern res = IsarAnimeResponse(q: "favorites");
    res.data = favorites;
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
      AnimeResponseIntern res = await _getFavorites(page);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> update(AnimeResponseIntern res) async {
    try {
      await _database.insertAnimeResponse(res);
      if (!mounted) return;

      state = AsyncValue.data(res);
      ref.read(favoriteChangePod.notifier).state =
          (ref.read(favoriteChangePod.notifier).state + 1) % 10;
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}

final favoriteChangePod = StateProvider((ref) => 1);

final animeFavorite = StateNotifierProvider.family.autoDispose<
    AnimeFavoriteStateController,
    AsyncValue<AnimeResponseIntern>,
    int>((ref, arg) {
  ref.watch(searchChangePod);
  ref.watch(scheduleChangePod);
  ref.watch(collectionChangePod);

  AnimeFavoriteStateController controller = AnimeFavoriteStateController(ref);
  controller.get(arg);
  return controller;
});
