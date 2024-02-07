import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/producer_query/collection.dart';
import 'package:app/database/src/isar/producer_query/converter.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/object/producer_query.dart';
import 'package:isar/isar.dart';

class IsarProducerQueryModel extends IsarModel implements ProducerQueryModel {
  final IsarProducerQueryConverter _producerQueryConverter =
      IsarProducerQueryConverter();
  IsarProducerQueryModel(super.db);

  Future<ProducerQuery?> get() async {
    IsarProducerQuery? ret = await db.isarProducerQuerys.where().findFirst();

    if (ret == null) return null;

    ProducerQuery q = _producerQueryConverter.fromImpl(ret);
    return q;
  }

  Future<int> insert(ProducerQuery queryIn) async {
    IsarProducerQuery queryImpl = _producerQueryConverter.toImpl(queryIn);
    int id = await db.isarProducerQuerys.put(queryImpl);
    return id;
  }

  @override
  Future<ProducerQuery?> getProducerQuery(String page) async {
    return await get();
  }

  @override
  Future<void> updateProducerQuery(ProducerQuery query) async {
    await insert(query);
  }
}
