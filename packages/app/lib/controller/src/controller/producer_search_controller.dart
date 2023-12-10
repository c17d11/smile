import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerSearchController
    extends StateNotifier<AsyncValue<ProducerResponseIntern>> {
  final Database _database;
  final JikanApi _api;

  ProducerSearchController(this._database, this._api)
      : super(const AsyncLoading());

  Future<ProducerResponseIntern?> _getDatabaseProducers(String query) async {
    ProducerResponseIntern? res = await _database.getProducerResponse(query);
    return res;
  }

  Future<ProducerResponseIntern> _getApiResponse(
      ProducerQueryIntern query) async {
    ProducerResponse res = await _api.searchProducers(query);
    ProducerResponseIntern resIntern =
        _database.createProducerResponseIntern(res);
    return resIntern;
  }

  Future<void> _storeResponse(ProducerResponseIntern res) async {
    await _database.insertProducerResponse(res);
  }

  Future<ProducerResponseIntern> _getProducers(
      ProducerQueryIntern query) async {
    String queryString = _api.buildProducerSearchQuery(query);

    ProducerResponseIntern? res = await _getDatabaseProducers(queryString);
    if (res == null) {
      res = await _getApiResponse(query);
      await _storeResponse(res);
    }
    return res;
  }

  Future<void> get(ProducerQueryIntern query) async {
    try {
      state = const AsyncLoading();
      ProducerResponseIntern res = await _getProducers(query);
      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}
