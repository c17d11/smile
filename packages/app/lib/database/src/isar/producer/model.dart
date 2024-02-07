import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/producer/collection.dart';
import 'package:app/database/src/isar/producer/converter.dart';
import 'package:app/object/producer.dart';
import 'package:isar/isar.dart';

class IsarProducerModel extends IsarModel implements ProducerModel {
  final IsarProducerConverter _producerConverter = IsarProducerConverter();
  IsarProducerModel(super.db);

  Future<Producer?> get(int id) async {
    IsarProducer? ret = await db.isarProducers.get(id);

    if (ret == null) return null;

    Producer p = _producerConverter.fromImpl(ret);
    return p;
  }

  Future<int> insert(Producer producerIn) async {
    IsarProducer producerImpl = _producerConverter.toImpl(producerIn);
    await db.isarProducers.put(producerImpl);
    return producerIn.malId!;
  }

  @override
  Future<List<Producer>> getAllProducers() async {
    List<IsarProducer> producers = await db.isarProducers.where().findAll();
    return producers.map((e) => _producerConverter.fromImpl(e)).toList();
  }
}
