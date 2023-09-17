import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/database/src/database_base.dart';
import 'package:jikan_api/jikan_api.dart';

class PopulateDatabase {
  final Database _db;
  final JikanApi _api;
  PopulateDatabase(this._db, this._api);

  Future<void> populate() async {
    ProducerResponse res = await _api.searchProducers(ProducerQuery());
    ProducerResponseIntern resIntern =
        _db.createProducerResponseIntern(res, ProducerQuery());
    await _db.insertProducerResponse(resIntern);
  }
}
