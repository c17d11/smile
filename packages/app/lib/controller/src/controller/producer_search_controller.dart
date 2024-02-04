import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

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
