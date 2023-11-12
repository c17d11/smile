import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_response.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;

class AnimeListPage extends ConsumerWidget {
  final IconItem page;

  const AnimeListPage({required this.page, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimeQueryIntern query = ref.watch(animeQueryPod(page));

    return AnimeList(
      page: page,
      initQuery: query,
      onNextPageQuery: (query) => AnimeQueryIntern.nextPage(query),
      onLastQuery: (query) => null,
      key: UniqueKey(),
    );
  }
}

class AnimeList extends StatefulWidget {
  final IconItem page;
  final AnimeQueryIntern initQuery;
  final Function(AnimeQueryIntern) onNextPageQuery;
  final Function(AnimeQueryIntern) onLastQuery;

  const AnimeList({
    required this.page,
    required this.initQuery,
    required this.onNextPageQuery,
    required this.onLastQuery,
    super.key,
  });

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
    AnimeQueryIntern lastQuery = AnimeQueryIntern.from(pages.last.query);
    AnimeQueryIntern newQuery = widget.onNextPageQuery(lastQuery);

    if (newQuery.page! <= lastPage) {
      setState(() {
        pages.add(AnimeResponseView(
          onLastPage: onLastPage,
          query: newQuery,
        ));
      });
    } else {
      AnimeQueryIntern? newQuery = widget.onLastQuery(lastQuery);
      if (newQuery != null) {
        setState(() {
          pages.add(AnimeResponseView(onLastPage: onLastPage, query: newQuery));
        });
      }
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
            backgroundColor: _background,
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
