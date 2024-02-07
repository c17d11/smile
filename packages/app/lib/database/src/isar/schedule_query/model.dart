import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/schedule_query/collection.dart';
import 'package:app/database/src/isar/schedule_query/converter.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/object/schedule_query.dart';
import 'package:isar/isar.dart';

class IsarScheduleQueryModel extends IsarModel implements ScheduleQueryModel {
  final IsarScheduleQueryConverter _scheduleQueryConverter =
      IsarScheduleQueryConverter();
  IsarScheduleQueryModel(super.db);

  Future<ScheduleQuery?> get() async {
    IsarScheduleQuery? ret = await db.isarScheduleQuerys.where().findFirst();

    if (ret == null) return null;

    ScheduleQuery q = _scheduleQueryConverter.fromImpl(ret);
    return q;
  }

  Future<int> insert(ScheduleQuery queryIn) async {
    IsarScheduleQuery queryImpl = _scheduleQueryConverter.toImpl(queryIn);
    int id = await db.isarScheduleQuerys.put(queryImpl);
    return id;
  }

  @override
  Future<ScheduleQuery?> getScheduleQuery() async {
    return await get();
  }

  @override
  Future<void> updateScheduleQuery(ScheduleQuery query) async {
    await insert(query);
  }
}
