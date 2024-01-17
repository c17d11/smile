import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/ui/src/browse/response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowsePage extends ConsumerWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimeQueryIntern query = ref.watch(animeQueryPod);

    return Scaffold(
      body: BrowseList(
        initQuery: query,
        onNextPageQuery: (query) => AnimeQueryIntern.nextPage(query),
        onLastQuery: (query) => null,
        key: UniqueKey(),
      ),
    );
  }
}

class BrowseList extends StatefulWidget {
  final AnimeQueryIntern initQuery;
  final Function(AnimeQueryIntern) onNextPageQuery;
  final Function(AnimeQueryIntern) onLastQuery;

  const BrowseList({
    required this.initQuery,
    required this.onNextPageQuery,
    required this.onLastQuery,
    super.key,
  });

  @override
  State<BrowseList> createState() => _BrowseListState();
}

class _BrowseListState extends State<BrowseList> {
  final _scroll = ScrollController();
  int lastPage = 1;
  // int currentPage = 1;
  List<BrowseResponse> pages = [];

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
    AnimeQueryIntern newQuery = pages.isEmpty
        ? widget.initQuery
        : widget.onNextPageQuery(pages.last.query);
    AnimeQueryIntern? nextQuery =
        pages.isEmpty ? widget.initQuery : widget.onLastQuery(pages.last.query);

    BrowseResponse? res;
    if ((newQuery.page ?? 1) <= lastPage) {
      res = BrowseResponse(
          heroId: pages.length, updateLastPage: onLastPage, query: newQuery);
    } else if (nextQuery != null) {
      res = BrowseResponse(
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
          slivers: pages),
    );
  }
}
