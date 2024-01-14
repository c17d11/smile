import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  String toString() => "$page-${day?.code}-$isForKids-$sfw-$isApproved";

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
          ..page = null;
      case ScheduleTuesday:
        return query
          ..day = ScheduleWednesDay()
          ..page = null;
      case ScheduleWednesDay:
        return query
          ..day = ScheduleThursday()
          ..page = null;
      case ScheduleThursday:
        return query
          ..day = ScheduleFriday()
          ..page = null;
      case ScheduleFriday:
        return query
          ..day = ScheduleSaturday()
          ..page = null;
      case ScheduleSaturday:
        return query
          ..day = ScheduleSunday()
          ..page = null;
      case ScheduleSunday:
        return query
          ..day = ScheduleOther()
          ..page = null;
      case ScheduleOther:
        return query
          ..day = ScheduleUnknown()
          ..page = null;
      case ScheduleUnknown:
        return null;
      default:
        throw Exception('Wrong schedule query day');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ScheduleQueryIntern &&
      other.page == page &&
      other.day == day &&
      other.isForKids == isForKids &&
      other.sfw == sfw &&
      other.isApproved == isApproved;

  @override
  int get hashCode =>
      page.hashCode ^
      day.hashCode ^
      isForKids.hashCode ^
      sfw.hashCode ^
      isApproved.hashCode;
}

class ScheduleQueryNotifier extends StateNotifier<ScheduleQueryIntern> {
  final Database db;
  ScheduleQueryNotifier(this.db) : super(ScheduleQueryIntern());

  Future<void> load() async {
    ScheduleQueryIntern? query = await db.getScheduleQuery();
    state = query ?? ScheduleQueryIntern();
  }

  Future<void> set(ScheduleQueryIntern newQuery) async {
    await db.updateScheduleQuery(newQuery);
    state = newQuery;
  }
}
