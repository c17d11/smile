import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeSearchController
    extends StateNotifier<AsyncValue<AnimeResponseIntern>> {
  final Database _database;
  final JikanApi _api;

  AnimeSearchController(this._database, this._api)
      : super(AsyncValue.data(IsarAnimeResponse(q: "")));

  Future<AnimeResponseIntern?> _getDatabaseResponse(String query) async {
    AnimeResponseIntern? res = await _database.getAnimeResponse(query);
    return res;
  }

  Future<AnimeResponseIntern> _getApiResponse(AnimeQuery query) async {
    AnimeResponse res = await _api.searchAnimes(query);
    AnimeResponseIntern resIntern = _database.createAnimeResponseIntern(res);
    return resIntern;
  }

  Future<AnimeResponseIntern> _getApiScheduleResponse(
      ScheduleQuery query) async {
    AnimeResponse res = await _api.searchSchedule(query);
    AnimeResponseIntern resIntern = _database.createAnimeResponseIntern(res);
    return resIntern;
  }

  Future<void> _storeResponse(AnimeResponseIntern res) async {
    await _database.insertAnimeResponse(res);
  }

  Future<AnimeResponseIntern> _getResponse(AnimeQuery query) async {
    String queryString = _api.buildAnimeSearchQuery(query);

    AnimeResponseIntern? res = await _getDatabaseResponse(queryString);
    if (res == null) {
      res = await _getApiResponse(query);
      await _storeResponse(res);
    }
    return res;
  }

  Future<AnimeResponseIntern> _getScheduleResponse(ScheduleQuery query) async {
    String queryString = _api.buildScheduleSearchQuery(query);

    AnimeResponseIntern? res = await _getDatabaseResponse(queryString);
    if (res == null) {
      res = await _getApiScheduleResponse(query);
      await _storeResponse(res);
    }
    return res;
  }

  Future<void> get(AnimeQueryIntern query) async {
    try {
      state = const AsyncLoading();
      late AnimeResponseIntern res;
      if (query.isFavorite ?? false) {
        res = await _getFavorites(query.page ?? 1);
      } else if (query.tag != null) {
        res = await _getCollection(query);
      } else {
        res = await _getResponse(query);
      }

      state = AsyncValue.data(res);
    } on Exception catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
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

  Future<AnimeResponseIntern> _getCollection(AnimeQueryIntern query) async {
    if (query.tag == null || query.page == null) {
      return IsarAnimeResponse(q: "");
    }

    Tag tag = query.tag!;
    int page = query.page!;

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

  Future<void> getSchedule(ScheduleQueryIntern query) async {
    try {
      state = const AsyncLoading();
      AnimeResponseIntern res = await _getScheduleResponse(query);
      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> update(AnimeIntern anime) async {
    try {
      // state = const AsyncLoading();
      await _database.insertAnime(anime);

      if (state.hasValue) {
        AnimeResponseIntern res = state.value!;
        res.data =
            res.data?.map((a) => a.malId == anime.malId ? anime : a).toList();

        state = AsyncValue.data(res);
      }
      // assert(state.hasValue);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}
