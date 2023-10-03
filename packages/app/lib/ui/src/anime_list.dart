import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeList extends ConsumerStatefulWidget {
  final IconItem page;

  const AnimeList({required this.page, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimeListState();
}

class _AnimeListState extends ConsumerState<AnimeList> {
  final _scroll = ScrollController();

  List<AnimeResponseView> pages = [
    AnimeResponseView(query: AnimeQuery()),
  ];

  void load() {
    AnimeQuery lastQuery = pages.last.query;
    int nextPage = (pages.last.query.page ?? 1) + 1;

    setState(() {
      pages.add(AnimeResponseView(query: lastQuery..page = nextPage));
      // pages.add(AnimeResponseView(query: lastQuery));
    });
  }

  @override
  void initState() {
    super.initState();

    _scroll.addListener(() {
      // at bottom
      if (_scroll.offset >= _scroll.position.maxScrollExtent) {
        load();
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
    return NotificationListener(
      child: CustomScrollView(
        controller: _scroll,
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
      onNotification: (scrollNotification) {
        // load more if viewport fits all at start
        // if (scrollNotification is ScrollMetricsNotification) {
        //   ScrollMetricsNotification scroll = scrollNotification;
        //   if (scroll.metrics.extentAfter < scroll.metrics.extentInside) {
        //     load();
        //   }
        // }
        return true;
      },
    );
  }
}
