import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_schedule_response.dart';
import 'package:flutter/material.dart';

class AnimeScheduleList extends StatefulWidget {
  final IconItem page;
  final ScheduleQueryIntern initQuery;
  final Function(ScheduleQueryIntern) onNextPageQuery;
  final Function(ScheduleQueryIntern) onLastQuery;

  const AnimeScheduleList({
    required this.page,
    required this.initQuery,
    required this.onNextPageQuery,
    required this.onLastQuery,
    super.key,
  });

  @override
  State<AnimeScheduleList> createState() => _AnimeScheduleListState();
}

class _AnimeScheduleListState extends State<AnimeScheduleList> {
  final _scroll = ScrollController();
  int lastPage = 1;

  late List<AnimeScheduleResponseView> pages;

  void onLastPage(int? last) {
    if (last != null) {
      lastPage = last;
    }
  }

  void loadNext() {
    ScheduleQueryIntern lastQuery = ScheduleQueryIntern.from(pages.last.query);
    ScheduleQueryIntern newQuery = widget.onNextPageQuery(lastQuery);

    if (newQuery.page! <= lastPage) {
      setState(() {
        pages.add(
            AnimeScheduleResponseView(onLastPage: onLastPage, query: newQuery));
      });
    } else {
      ScheduleQueryIntern? newQuery = widget.onLastQuery(lastQuery);
      if (newQuery != null) {
        setState(() {
          pages.add(AnimeScheduleResponseView(
              onLastPage: onLastPage, query: newQuery));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    pages = [
      AnimeScheduleResponseView(onLastPage: onLastPage, query: widget.initQuery)
    ];

    _scroll.addListener(() {
      // at bottom
      if (_scroll.offset >= _scroll.position.maxScrollExtent) {
        loadNext();
      }
    });
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
          loadNext();
        }
        return false;
      },
      child: CustomScrollView(
        controller: _scroll,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'anime-query',
                      arguments: widget.page);
                },
                icon: const Icon(Icons.sort),
              )
            ],
          ),
          ...pages,
        ],
      ),
    );
  }
}
