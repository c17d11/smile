import 'package:app/database/src/interface/database.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleQueryNotifier extends StateNotifier<ScheduleQuery> {
  final Database db;
  ScheduleQueryNotifier(this.db) : super(ScheduleQuery());

  Future<void> load() async {
    ScheduleQuery? query = await db.getScheduleQuery();
    state = query ?? ScheduleQuery();
  }

  Future<void> set(ScheduleQuery newQuery) async {
    await db.updateScheduleQuery(newQuery);
    state = newQuery;
  }
}

final scheduleQueryPod =
    StateNotifierProvider<ScheduleQueryNotifier, ScheduleQuery>((ref) {
  Database db = ref.watch(databasePod);
  final notifier = ScheduleQueryNotifier(db);
  notifier.load();
  return notifier;
});
