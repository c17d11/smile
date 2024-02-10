import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/schedule_query/collection.dart';
import 'package:app/database/src/isar/schedule_query/converter.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/tag/model.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/object/tag.dart';
import 'package:isar/isar.dart';

class IsarScheduleQueryModel extends IsarModel implements ScheduleQueryModel {
  final IsarScheduleQueryConverter _scheduleQueryConverter =
      IsarScheduleQueryConverter();
  final IsarTagModel _tagModel;
  IsarScheduleQueryModel(super.db) : _tagModel = IsarTagModel(db);

  Future<ScheduleQuery?> get() async {
    IsarScheduleQuery? ret = await db.isarScheduleQuerys.where().findFirst();

    if (ret == null) return null;

    ScheduleQuery q = _scheduleQueryConverter.fromImpl(ret);
    for (String tagId in ret.showOnlyTagIds ?? []) {
      Tag? t = await _tagModel.get(tagId);
      if (t != null) {
        q.appFilter.showOnlyTags.add(t);
      }
    }

    return q;
  }

  Future<int> insert(ScheduleQuery queryIn) async {
    IsarScheduleQuery queryImpl = _scheduleQueryConverter.toImpl(queryIn);

    for (var tag in queryIn.appFilter.showOnlyTags) {
      String id = await _tagModel.insert(tag);
      queryImpl.showOnlyTagIds ??= [];
      queryImpl.showOnlyTagIds!.add(id);
    }

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
