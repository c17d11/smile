import 'package:app/ui/src/favorite/state.dart';
import 'package:app/ui/src/schedule/state.dart';
import 'package:app/ui/src/browse/state.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:tuple/tuple.dart';

class AnimeCollectionStateController
    extends StateNotifier<AsyncValue<IsarAnimeResponse>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  AnimeCollectionStateController(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
  }

  Future<IsarAnimeResponse> _getCollection(int page, Tag tag) async {
    List<IsarAnime> animes = await _database.getCollection(tag, page);
    int collectionCount = await _database.countCollectionAnimes(tag);
    int pageCount = _database.countFavoriteAnimePages(collectionCount);

    IsarAnimeResponse res = IsarAnimeResponse(q: "tag${tag.name}");
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
      IsarAnimeResponse res = await _getCollection(page, tag);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }
}

final animeCollection = StateNotifierProvider.family.autoDispose<
    AnimeCollectionStateController,
    AsyncValue<IsarAnimeResponse>,
    Tuple2<int, Tag>>((ref, arg) {
  AnimeCollectionStateController controller =
      AnimeCollectionStateController(ref);
  controller.get(arg.item1, arg.item2);
  return controller;
});
