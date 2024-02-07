import 'package:app/object/anime_query.dart';
import 'package:app/object/genre.dart';
import 'package:app/ui/routes/home/pages/genre/state.dart';
import 'package:app/ui/routes/home/pages/home.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
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
    AsyncValue<List<Genre>> futureGenres = ref.watch(genrePod);

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
                leading: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await ref
                        .read(animeQueryPod.notifier)
                        .set(AnimeQuery()..genresInclude = [genres[index]]);
                    ref.read(pageGroupPod.notifier).state = AnimeGroup();
                    ref.read(pageIndexPod.notifier).state = 0;
                  },
                ),
                title: Text('${genres[index].name}'),
                subtitle: Text("${genres[index].count} animes"),
                tileColor: Theme.of(context).primaryColor,
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
