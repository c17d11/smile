import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerController
    extends StateNotifier<AsyncValue<List<ProducerIntern>>> {
  final Database _database;

  ProducerController(this._database) : super(const AsyncLoading());

  Future<List<ProducerIntern>> _getDatabaseProducers() async {
    List<ProducerIntern> producers = await _database.getAllProducers();
    return producers;
  }

  Future<List<ProducerIntern>> _getProducers() async {
    List<ProducerIntern> producers = await _getDatabaseProducers();
    return producers;
  }

  Future<void> get(int malId) async {
    try {
      state = const AsyncLoading();
      List<ProducerIntern> producers = await _getProducers();

      state = AsyncValue.data(producers);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}
