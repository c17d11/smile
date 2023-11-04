import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/database/src/isar/collection/isar_schedule_query.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarScheduleQueryModel extends IsarModel implements ScheduleQueryModel {
  IsarScheduleQueryModel(super.db, {required super.expirationHours});

  @override
  Future<ScheduleQueryIntern?> getScheduleQuery() async {
    IsarScheduleQuery? query;
    await read(() async {
      query = await db.isarScheduleQuerys.where().findFirst();
    });
    return query;
  }

  @override
  Future<void> updateScheduleQuery(ScheduleQueryIntern query) async {
    IsarScheduleQuery isarScheduleQuery = IsarScheduleQuery.from(query);
    await write(() async {
      await db.isarScheduleQuerys.put(isarScheduleQuery);
    });
  }
}
