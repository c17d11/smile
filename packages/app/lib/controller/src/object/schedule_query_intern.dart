import 'package:jikan_api/jikan_api.dart';

class ScheduleQueryIntern extends ScheduleQuery {
  static ScheduleQueryIntern from(ScheduleQuery q) {
    ScheduleQueryIntern queryIntern = ScheduleQueryIntern()
      ..page = q.page
      ..day = q.day
      ..isForKids = q.isForKids
      ..sfw = q.sfw
      ..isApproved = q.isApproved;
    return queryIntern;
  }

  static ScheduleQueryIntern nextPage(ScheduleQuery q) {
    ScheduleQueryIntern query = ScheduleQueryIntern.from(q);
    query.page = (query.page ?? 1) + 1;
    return query;
  }

  static ScheduleQueryIntern? nextDay(ScheduleQuery q) {
    ScheduleQueryIntern query = ScheduleQueryIntern.from(q);
    switch (query.day.runtimeType) {
      case ScheduleMonday:
        return query
          ..day = ScheduleTuesday()
          ..page = 1;
      case ScheduleTuesday:
        return query
          ..day = ScheduleWednesDay()
          ..page = 1;
      case ScheduleWednesDay:
        return query
          ..day = ScheduleThursday()
          ..page = 1;
      case ScheduleThursday:
        return query
          ..day = ScheduleFriday()
          ..page = 1;
      case ScheduleFriday:
        return query
          ..day = ScheduleOther()
          ..page = 1;
      case ScheduleOther:
        return query
          ..day = ScheduleUnknown()
          ..page = 1;
      case ScheduleUnknown:
        return null;
      default:
        throw Exception('Wrong schedule query day');
    }
  }
}
