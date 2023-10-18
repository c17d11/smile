import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeListPage extends ConsumerWidget {
  final IconItem page;

  const AnimeListPage({required this.page, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimeQueryIntern query = ref.watch(animeQueryPod(page));

    return AnimeList(page: page, initQuery: query, key: UniqueKey());
  }
}

class AnimeList extends StatefulWidget {
  final IconItem page;
  final AnimeQueryIntern initQuery;

  const AnimeList({required this.page, required this.initQuery, super.key});

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  final _scroll = ScrollController();
  int lastPage = 1;
  int currentPage = 1;

  late List<AnimeResponseView> pages;

  void onLastPage(int? last) {
    if (last != null) {
      lastPage = last;
    }
  }

  void loadNext() {
    AnimeQueryIntern newQuery = AnimeQueryIntern.from(pages.last.query);
    ++currentPage;
    if (currentPage <= lastPage) {
      newQuery.page = currentPage;
      setState(() {
        pages.add(AnimeResponseView(onLastPage: onLastPage, query: newQuery));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    pages = [
      AnimeResponseView(onLastPage: onLastPage, query: widget.initQuery)
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
