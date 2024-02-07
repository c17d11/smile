import 'package:app/database/src/interface/database.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/pages/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerQueryNotifier extends StateNotifier<ProducerQuery> {
  final Database db;
  final String page;
  ProducerQueryNotifier(this.page, this.db) : super(ProducerQuery());

  Future<void> load() async {
    ProducerQuery? query = await db.getProducerQuery(page);
    state = query ?? ProducerQuery();
  }

  Future<void> set(ProducerQuery newQuery) async {
    await db.updateProducerQuery(newQuery);
    state = newQuery;
  }
}

final producerQueryPod = StateNotifierProvider.family<ProducerQueryNotifier,
    ProducerQuery, IconItem>((ref, arg) {
  Database db = ref.watch(databasePod);
  final notifier = ProducerQueryNotifier(arg.label, db);
  notifier.load();
  return notifier;
});

class ProducerSearchController
    extends StateNotifier<AsyncValue<ProducerResponse>> {
  final Database _database;
  final JikanApi _api;

  ProducerSearchController(this._database, this._api)
      : super(const AsyncLoading());

  Future<ProducerResponse?> _getDatabaseProducers(String query) async {
    ProducerResponse? res = await _database.getProducerResponse(query);
    return res;
  }

  Future<ProducerResponse> _getApiResponse(ProducerQuery query) async {
    JikanProducerResponse res = await _api.searchProducers(query);
    return ProducerResponse.from(res);
  }

  Future<void> _storeResponse(ProducerResponse res) async {
    await _database.insertProducerResponse(res);
  }

  Future<ProducerResponse> _getProducers(ProducerQuery query) async {
    String queryString = _api.buildProducerSearchQuery(query);

    ProducerResponse? res = await _getDatabaseProducers(queryString);
    if (res == null) {
      res = await _getApiResponse(query);
      await _storeResponse(res);
    }
    return res;
  }

  Future<void> get(ProducerQuery query) async {
    try {
      state = const AsyncLoading();
      ProducerResponse res = await _getProducers(query);
      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}

final producerSearchPod = StateNotifierProvider.family<ProducerSearchController,
    AsyncValue<ProducerResponse>, ProducerQuery>((ref, arg) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  ProducerSearchController controller = ProducerSearchController(db, api);
  controller.get(arg);
  return controller;
});
