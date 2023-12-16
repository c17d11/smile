import 'package:app/controller/src/controller/anime_favorite_state_controller.dart';
import 'package:app/controller/src/controller/anime_schedule_state_controller.dart';
import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:tuple/tuple.dart';

class AnimeCollectionStateController
    extends StateNotifier<AsyncValue<AnimeResponseIntern>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  AnimeCollectionStateController(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
  }

  Future<AnimeResponseIntern> _getCollection(int page, Tag tag) async {
    List<AnimeIntern> animes = await _database.getCollection(tag, page);
    int collectionCount = await _database.countCollectionAnimes(tag);
    int pageCount = _database.countFavoriteAnimePages(collectionCount);

    AnimeResponseIntern res = IsarAnimeResponse(q: "tag${tag.name}");
    res.data = animes;
    res.pagination = Pagination()
      ..currentPage = page
      ..hasNextPage = false
      ..itemCount = animes.length
      ..itemPerPage = animes.length
      ..itemTotal = collectionCount
      ..lastVisiblePage = pageCount;
    return res;
  }

  Future<void> get(int page, Tag tag) async {
    try {
      state = const AsyncLoading();
      AnimeResponseIntern res = await _getCollection(page, tag);
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
      ref.read(collectionChangePod.notifier).state =
          (ref.read(collectionChangePod.notifier).state + 1) % 10;
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}

final collectionChangePod = StateProvider((ref) => 1);

final animeCollection = StateNotifierProvider.family.autoDispose<
    AnimeCollectionStateController,
    AsyncValue<AnimeResponseIntern>,
    Tuple2<int, Tag>>((ref, arg) {
  ref.watch(searchChangePod);
  ref.watch(scheduleChangePod);
  ref.watch(favoriteChangePod);
  AnimeCollectionStateController controller =
      AnimeCollectionStateController(ref);
  controller.get(arg.item1, arg.item2);
  return controller;
});
