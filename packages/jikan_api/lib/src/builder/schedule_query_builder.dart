import 'builder.dart';
import '../object/schedule_day.dart';
import '../object/schedule_query.dart';

class ScheduleQueryBuilder extends Builder<JikanScheduleQuery, String> {
  String buildPageQuery(int? page) {
    return page != null ? "page=$page" : "";
  }

  String buildDayQuery(JikanScheduleDay? day) {
    if (day == null) {
      return "";
    }
    return "filter=${day.code}";
  }

  String boolToString(bool b) {
    return b ? "true" : "false";
  }

  String buildKidsQuery(bool? isForKids) {
    return isForKids != null ? "kids=${boolToString(isForKids)}" : "";
  }

  String buildSfwQuery(bool? sfw) {
    return sfw != null && sfw ? "sfw" : "";
  }

  String buildIsApprovedQuery(bool? isApproved) {
    return isApproved != null && !isApproved ? "unapproved" : "";
  }

  @override
  String build(JikanScheduleQuery arg) {
    List<String> queries = [
      buildDayQuery(arg.day),
      buildKidsQuery(arg.isForKids),
      buildSfwQuery(arg.sfw),
      buildIsApprovedQuery(arg.isApproved),
      buildPageQuery(arg.page),
    ];
    return queries.where((e) => e.isNotEmpty).join("&");
  }
}
