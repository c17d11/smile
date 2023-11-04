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

    return AnimeList(
      page: page,
      initQuery: query..isFavorite = true,
      onNextPageQuery: (query) => AnimeQueryIntern.nextPage(query),
      onLastQuery: (query) => null,
      key: UniqueKey(),
    );
  }
}
