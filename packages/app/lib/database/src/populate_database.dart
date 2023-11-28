import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/database/src/database_base.dart';
import 'package:jikan_api/jikan_api.dart';

class PopulateDatabase {
  final Database _db;
  final JikanApi _api;
  PopulateDatabase(this._db, this._api);

  Future<void> populateProducers() async {
    ProducerResponse res = await _api.searchProducers(ProducerQuery());
    ProducerResponseIntern resIntern = _db.createProducerResponseIntern(res);
    await _db.insertProducerResponse(resIntern);
  }

  Future<void> populateGenres() async {
    List<Genre> res = await _api.searchGenres();
    await _db.insertGenres(res);
  }

  Future<void> populate() async {
    await populateProducers();
    await populateGenres();
  }
}
