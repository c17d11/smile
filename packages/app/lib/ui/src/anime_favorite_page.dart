import 'package:app/controller/src/object/anime_order.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/anime_type.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/selection_widget/src/single_select.dart';
import 'package:app/ui/src/anime_list.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/sliver_app_bar_delegate.dart';
import 'package:app/ui/style/style.dart';
import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeFavoritePage extends ConsumerWidget {
  final IconItem page;

  const AnimeFavoritePage({required this.page, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimeQueryIntern query = ref.watch(animeQueryPod(page));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            floating: true,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'anime-query', arguments: page);
                },
                icon: const Icon(Icons.sort),
              )
            ],
          ),
        ],
        body: AnimeList(
          page: page,
          initQuery: query..isFavorite = true,
          onNextPageQuery: (query) => AnimeQueryIntern.nextPage(query),
          onLastQuery: (query) => null,
          key: UniqueKey(),
        ),
      ),
    );
  }
}
