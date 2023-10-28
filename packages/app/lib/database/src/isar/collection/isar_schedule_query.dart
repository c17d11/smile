import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:isar/isar.dart';

part 'isar_schedule_query.g.dart';

@Collection(ignore: {'page', 'day'})
class IsarScheduleQuery extends ScheduleQueryIntern {
  Id? id;

  @Index(unique: true, replace: true)
  late String pageUi;

  static IsarScheduleQuery from(ScheduleQueryIntern q) {
    IsarScheduleQuery query = IsarScheduleQuery()
      ..sfw = q.sfw
      ..isForKids = q.isForKids
      ..isApproved = q.isApproved
      ..pageUi = "";
    return query;
  }
}
