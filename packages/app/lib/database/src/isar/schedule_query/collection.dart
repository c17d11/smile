import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

part 'collection.g.dart';

@Collection()
class IsarScheduleQuery {
  @Index(unique: true, replace: true)
  Id id = 1;

  int? page;

  @Enumerated(EnumType.name)
  JikanScheduleDay? day;

  bool? isForKids;
  bool? sfw;
  bool? isApproved;
}
