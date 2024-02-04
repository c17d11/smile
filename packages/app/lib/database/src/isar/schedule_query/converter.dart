import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/schedule_query/collection.dart';
import 'package:app/object/schedule_query.dart';

class IsarScheduleQueryConverter
    extends Converter<ScheduleQuery, IsarScheduleQuery> {
  @override
  ScheduleQuery fromImpl(IsarScheduleQuery t) {
    return ScheduleQuery()
      ..page = t.page
      ..day = t.day
      ..isForKids = t.isForKids
      ..sfw = t.sfw
      ..isApproved = t.isApproved;
  }

  @override
  IsarScheduleQuery toImpl(ScheduleQuery t) {
    return IsarScheduleQuery()
      ..page = t.page
      ..day = t.day
      ..isForKids = t.isForKids
      ..sfw = t.sfw
      ..isApproved = t.isApproved;
  }
}
