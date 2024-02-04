import 'package:app/object/genre.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:jikan_api/jikan_api.dart';

class PopulateDatabase {
  final Database _db;
  final JikanApi _api;
  PopulateDatabase(this._db, this._api);

  Future<void> populateProducers() async {
    JikanProducerResponse res =
        await _api.searchProducers(JikanProducerQuery());
    await _db.insertProducerResponse(ProducerResponse.from(res));
  }

  Future<void> populateGenres() async {
    List<JikanGenre> res = await _api.searchGenres();
    await _db.insertGenres(res.map((e) => Genre.from(e)).toList());
  }

  Future<void> populate() async {
    await populateProducers();
    await populateGenres();
  }
}
