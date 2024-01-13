import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeCollectionController
    extends StateNotifier<AsyncValue<AnimeResponseIntern>> {
  final Database _database;

  AnimeCollectionController(this._database) : super(const AsyncLoading());

  Future<void> get(AnimeQueryIntern query) async {
    try {
      if (query.tag == null || query.page == null) {
        state = AsyncValue.data(IsarAnimeResponse(q: ""));
        return;
      }

      Tag tag = query.tag!;
      int page = query.page!;

      state = const AsyncLoading();
      List<IsarAnime> animes = await _database.getCollection(tag, page);
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
      state = AsyncValue.data(res);
    } on Exception catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
