import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ScheduleStateNotifier
    extends StateNotifier<AsyncValue<IsarAnimeResponse>> {
  late final Database _database;
  late final JikanApi _api;
  final StateNotifierProviderRef ref;

  ScheduleStateNotifier(this.ref) : super(const AsyncLoading()) {
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

  Future<void> refresh() async {
    state = AsyncValue.data(state.value!);
  }
}

final animeSchedule = StateNotifierProvider.family.autoDispose<
    ScheduleStateNotifier,
    AsyncValue<IsarAnimeResponse>,
    ScheduleQueryIntern>((ref, arg) {
  ScheduleStateNotifier controller = ScheduleStateNotifier(ref);
  controller.get(arg);
  return controller;
});
