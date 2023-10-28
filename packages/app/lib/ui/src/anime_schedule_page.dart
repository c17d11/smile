import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_schedule_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeSchedulePage extends ConsumerWidget {
  final IconItem page;

  const AnimeSchedulePage({required this.page, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScheduleQueryIntern query = ScheduleQueryIntern.from(
      ScheduleQuery()..day = ScheduleMonday(),
    );

    return AnimeScheduleList(
      page: page,
      initQuery: query,
      onNextPageQuery: (query) => ScheduleQueryIntern.nextPage(query),
      onLastQuery: (query) => ScheduleQueryIntern.nextDay(query),
      key: UniqueKey(),
    );
  }
}
