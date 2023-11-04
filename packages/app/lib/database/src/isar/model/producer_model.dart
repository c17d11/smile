import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_producer.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarProducerModel extends IsarModel implements ProducerModel {
  IsarProducerModel(super.db, {required super.expirationHours});

  @override
  Future<void> insertProducer(ProducerIntern producer) async {
    IsarProducer isarProducer = producer as IsarProducer;
    await write(() async {
      await db.isarProducers.put(isarProducer);
    });
  }

  @override
  Future<ProducerIntern?> getProducer(int id) async {
    IsarProducer? producer;
    await read(() async {
      producer = await db.isarProducers.get(id);
    });
    if (isExpired(producer)) return null;
    return producer;
  }

  @override
  Future<List<ProducerIntern>> getAllProducers() async {
    late List<IsarProducer> producers;

    await read(() async {
      producers = await db.isarProducers.where().findAll();
    });
    return producers;
  }

  @override
  Future<bool> deleteProducer(int malId) async {
    bool success = false;

    await write(() async {
      success = await db.isarProducers.delete(malId);
    });

    return success;
  }
}
