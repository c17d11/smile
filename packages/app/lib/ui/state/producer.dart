import 'package:app/database/src/interface/database.dart';
import 'package:app/object/producer.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerController extends StateNotifier<AsyncValue<List<Producer>>> {
  final Database _database;

  ProducerController(this._database) : super(const AsyncLoading());

  Future<List<Producer>> _getDatabaseProducers() async {
    List<Producer> producers = await _database.getAllProducers();
    return producers;
  }

  Future<List<Producer>> _getProducers() async {
    List<Producer> producers = await _getDatabaseProducers();
    return producers;
  }

  Future<void> get(int malId) async {
    try {
      state = const AsyncLoading();
      List<Producer> producers = await _getProducers();

      state = AsyncValue.data(producers);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}

final producerPod =
    StateNotifierProvider<ProducerController, AsyncValue<List<Producer>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  return ProducerController(db);
});
