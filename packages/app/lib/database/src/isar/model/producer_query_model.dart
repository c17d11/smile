import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/database/src/isar/collection/isar_producer_query.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarProducerQueryModel extends IsarModel implements ProducerQueryModel {
  IsarProducerQueryModel(super.db, {required super.expirationHours});

  @override
  Future<ProducerQueryIntern?> getProducerQuery(String page) async {
    IsarProducerQuery? query;
    await read(() async {
      query =
          await db.isarProducerQuerys.filter().pageUiEqualTo(page).findFirst();
    });
    return query;
  }

  @override
  Future<void> updateProducerQuery(
      String page, ProducerQueryIntern query) async {
    IsarProducerQuery isarQuery = IsarProducerQuery.from(page, query);
    await write(() async {
      await db.isarProducerQuerys.put(isarQuery);
    });
  }
}
