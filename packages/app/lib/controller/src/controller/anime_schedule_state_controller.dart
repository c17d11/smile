import 'package:app/controller/src/controller/anime_collection_state_controller.dart';
import 'package:app/controller/src/controller/anime_favorite_state_controller.dart';
import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeScheduleStateController
    extends StateNotifier<AsyncValue<IsarAnimeResponse>> {
  late final Database _database;
  late final JikanApi _api;
  final StateNotifierProviderRef ref;

  AnimeScheduleStateController(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
    _api = ref.watch(apiPod);
  }

  Future<AnimeResponseIntern> _getApiScheduleResponse(
      ScheduleQuery query) async {
    AnimeResponse res = await _api.searchSchedule(query);
    AnimeResponseIntern resIntern = _database.createAnimeResponseIntern(res);
    return resIntern;
  }

  Future<IsarAnimeResponse> _getScheduleResponse(ScheduleQuery query) async {
    String queryString = _api.buildScheduleSearchQuery(query);
    IsarAnimeResponse? res = await _database.getAnimeResponse(queryString);
    if (res == null) {
      final resIntern = await _getApiScheduleResponse(query);
      res = await _database.insertAnimeResponse(resIntern);
    }
    return res;
  }

  Future<void> get(ScheduleQueryIntern query) async {
    try {
      state = const AsyncLoading();
      IsarAnimeResponse res = await _getScheduleResponse(query);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> update(AnimeResponseIntern res) async {
    try {
      final updated = await _database.insertAnimeResponse(res);
      if (!mounted) return;

      state = AsyncValue.data(updated);
      ref.read(scheduleChangePod.notifier).state =
          (ref.read(scheduleChangePod.notifier).state + 1) % 10;
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}

final scheduleChangePod = StateProvider((ref) => 1);

final animeSchedule = StateNotifierProvider.family.autoDispose<
    AnimeScheduleStateController,
    AsyncValue<IsarAnimeResponse>,
    ScheduleQueryIntern>((ref, arg) {
  ref.watch(searchChangePod);
  ref.watch(favoriteChangePod);
  ref.watch(collectionChangePod);
  AnimeScheduleStateController controller = AnimeScheduleStateController(ref);
  controller.get(arg);
  return controller;
});
