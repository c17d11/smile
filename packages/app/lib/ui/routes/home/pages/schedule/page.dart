import 'package:app/object/schedule_query.dart';
import 'package:app/ui/routes/home/pages/home.dart';
import 'package:app/ui/routes/home/pages/schedule/response.dart';
import 'package:app/ui/state/schedule_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScheduleQuery query = ref.watch(scheduleQueryPod);
    ref.watch(pageIndexPod);

    return ScheduleList(
      initQuery: query..day = JikanScheduleDay.monday,
      onNextPageQuery: (query) => ScheduleQuery.nextPage(query),
      onLastQuery: (query) => ScheduleQuery.nextDay(query),
      key: UniqueKey(),
    );
  }
}

class ScheduleList extends StatefulWidget {
  final ScheduleQuery initQuery;
  final Function(ScheduleQuery) onNextPageQuery;
  final Function(ScheduleQuery) onLastQuery;

  const ScheduleList({
    required this.initQuery,
    required this.onNextPageQuery,
    required this.onLastQuery,
    super.key,
  });

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<ScheduleResponse> pages = [];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    // at bottom
    if (_scroll.offset >= _scroll.position.maxScrollExtent) loadNextPage();
  }

  void loadNextPage() {
    ScheduleQuery newQuery = pages.isEmpty
        ? widget.initQuery
        : widget.onNextPageQuery(pages.last.query);
    ScheduleQuery? nextQuery =
        pages.isEmpty ? widget.initQuery : widget.onLastQuery(pages.last.query);

    ScheduleResponse? res;
    if ((newQuery.page ?? 1) <= lastPage) {
      res = ScheduleResponse(
          heroId: pages.length, updateLastPage: onLastPage, query: newQuery);
    } else if (nextQuery != null) {
      res = ScheduleResponse(
          heroId: pages.length, updateLastPage: onLastPage, query: nextQuery);
    }

    if (res != null) {
      setState(() {
        pages.add(res!);
      });
    }
  }

  void onLastPage(int? last) {
    if (last != null) {
      lastPage = last;
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentTotal <
            MediaQuery.of(context).size.height) {
          loadNextPage();
        }
        return false;
      },
      child: CustomScrollView(
        controller: _scroll,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: pages,
      ),
    );
  }
}
