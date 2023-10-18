import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_list.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimeFavoritePage extends ConsumerWidget {
  final IconItem page;

  const AnimeFavoritePage({required this.page, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AnimeQueryIntern query = ref.watch(animeQueryPod(page));

    return
        //Container();
        AnimeList(
            page: page, initQuery: query..isFavorite = true, key: UniqueKey());

    // return CustomScrollView(
    //   shrinkWrap: true,
    //   physics: const AlwaysScrollableScrollPhysics(),
    //   slivers: <Widget>[
    //     SliverAppBar(
    //       backgroundColor: Colors.white,
    //       floating: true,
    //       pinned: false,
    //       actions: [
    //         IconButton(
    //           onPressed: () {
    //             // Navigator.pushNamed(context, 'anime-query',
    //             //     arguments: widget.page);
    //           },
    //           icon: const Icon(Icons.sort),
    //         )
    //       ],
    //     ),
    //     AnimeResponseView(
    //         query: AnimeQueryIntern()..isFavorite = true, returnPage: (_) {}),
    //   ],
    // );
  }
}
