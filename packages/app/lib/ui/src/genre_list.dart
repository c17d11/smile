import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/ui/src/browse/nav_item.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;

class GenreListPage extends ConsumerWidget {
  const GenreListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<GenreIntern>> futureGenres = ref.watch(genrePod);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        futureGenres.when(
          data: (genres) => SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList.separated(
              itemCount: genres.length,
              itemBuilder: (context, index) => ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                leading: Icon(Icons.label),
                title: Text('${genres[index].name}'),
                subtitle: Text("${genres[index].count} animes"),
                tileColor: Theme.of(context).primaryColor,
                onTap: () async {
                  await ref
                      .read(animeQueryPod.notifier)
                      .set(AnimeQueryIntern()..genresInclude = [genres[index]]);
                  ref.read(pageGroupPod.notifier).state = AnimeGroup();
                  ref.read(pageIndexPod.notifier).state = 0;
                },
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
          ),
          error: (e, _) => const SliverFillRemaining(
            child: Center(
              child: TextHeadline("No genres"),
            ),
          ),
          loading: () => const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    ));
  }
}
