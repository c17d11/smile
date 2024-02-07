import 'package:app/object/anime_query.dart';
import 'package:app/ui/pages/browse/response.dart';
import 'package:app/ui/pages/home.dart';
import 'package:app/ui/pages/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowsePage extends ConsumerWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimeQuery query = ref.watch(animeQueryPod);
    ref.watch(pageIndexPod);

    return Scaffold(
      body: BrowseList(
        initQuery: query,
        onNextPageQuery: (query) => AnimeQuery.nextPage(query),
        onLastQuery: (query) => null,
        key: UniqueKey(),
      ),
    );
  }
}

class BrowseList extends StatefulWidget {
  final AnimeQuery initQuery;
  final Function(AnimeQuery) onNextPageQuery;
  final Function(AnimeQuery) onLastQuery;

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
    AnimeQuery newQuery = pages.isEmpty
        ? widget.initQuery
        : widget.onNextPageQuery(pages.last.query);
    AnimeQuery? nextQuery =
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
