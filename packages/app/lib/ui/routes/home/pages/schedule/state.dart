import 'package:app/object/anime.dart';
import 'package:app/object/anime_response.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ScheduleStateNotifier extends StateNotifier<AsyncValue<AnimeResponse>> {
  late final Database _database;
  late final JikanApi _api;
  final StateNotifierProviderRef ref;

  ScheduleStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databasePod);
    _api = ref.watch(apiPod);
  }

  Future<AnimeResponse> _getApiScheduleResponse(ScheduleQuery query) async {
    JikanAnimeResponse res = await _api.searchSchedule(query);
    return AnimeResponse.from(res);
  }

  Future<AnimeResponse> _getScheduleResponse(ScheduleQuery query) async {
    String queryString = _api.buildScheduleSearchQuery(query);
    AnimeResponse? res = await _database.getAnimeResponse(queryString);
    if (res == null || await _database.isExpired(res)) {
      res = await _getApiScheduleResponse(query);
      await _database.insertAnimeResponse(res);
      res = await _database.getAnimeResponse(queryString);
    }
    return res!;
  }

  Future<void> get(ScheduleQuery query) async {
    try {
      state = const AsyncLoading();
      AnimeResponse res = await _getScheduleResponse(query);
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

final animeSchedule = StateNotifierProvider.family.autoDispose<
    ScheduleStateNotifier,
    AsyncValue<AnimeResponse>,
    ScheduleQuery>((ref, arg) {
  ScheduleStateNotifier controller = ScheduleStateNotifier(ref);
  controller.get(arg);
  return controller;
});
