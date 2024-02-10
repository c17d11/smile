import 'package:app/object/anime_app_filter.dart';
import 'package:jikan_api/jikan_api.dart';

class ScheduleQuery extends JikanScheduleQuery {
  AnimeAppFilter appFilter = AnimeAppFilter();

  static ScheduleQuery from(ScheduleQuery q) {
    ScheduleQuery queryIntern = ScheduleQuery()
      ..page = q.page
      ..day = q.day
      ..isForKids = q.isForKids
      ..sfw = q.sfw
      ..isApproved = q.isApproved
      ..appFilter = q.appFilter.copy();
    return queryIntern;
  }

  @override
  String toString() => "$page-${day?.code}-$isForKids-$sfw-$isApproved";

  static ScheduleQuery nextPage(ScheduleQuery q) {
    ScheduleQuery query = ScheduleQuery.from(q);
    query.page = (query.page ?? 1) + 1;
    return query;
  }

  static ScheduleQuery? nextDay(ScheduleQuery q) {
    ScheduleQuery query = ScheduleQuery.from(q);
    switch (query.day) {
      case JikanScheduleDay.monday:
        return query
          ..day = JikanScheduleDay.tuesday
          ..page = null;
      case JikanScheduleDay.tuesday:
        return query
          ..day = JikanScheduleDay.wednesday
          ..page = null;
      case JikanScheduleDay.wednesday:
        return query
          ..day = JikanScheduleDay.thursday
          ..page = null;
      case JikanScheduleDay.thursday:
        return query
          ..day = JikanScheduleDay.friday
          ..page = null;
      case JikanScheduleDay.friday:
        return query
          ..day = JikanScheduleDay.saturday
          ..page = null;
      case JikanScheduleDay.saturday:
        return query
          ..day = JikanScheduleDay.sunday
          ..page = null;
      case JikanScheduleDay.sunday:
        return query
          ..day = JikanScheduleDay.other
          ..page = null;
      case JikanScheduleDay.other:
        return query
          ..day = JikanScheduleDay.unknown
          ..page = null;
      case JikanScheduleDay.unknown:
        return null;
      default:
        throw Exception('Wrong schedule query day');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ScheduleQuery &&
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
