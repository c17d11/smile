import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnimeResponseView extends ConsumerWidget {
  final AnimeQueryIntern query;
  final void Function(int?) onLastPage;
  const AnimeResponseView(
      {required this.onLastPage, required this.query, super.key});

  Widget buildLoading() {
    return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget buildNoData() {
    return const SliverFillRemaining(
        child: Center(child: TextHeadline("No data")));
  }

  Widget buildHeader(AnimeResponseIntern? res, BuildContext context) {
    String currentPage = res?.pagination?.currentPage.toString() ?? "";
    String lastPage = res?.pagination?.lastVisiblePage.toString() ?? "";

    onLastPage(res?.pagination?.lastVisiblePage);

    return SliverPinnedHeader(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: TextDivider("Page $currentPage of $lastPage"),
      ),
    );
  }

  Widget buildAnimeList(
      int? page, List<IsarAnime> animes, void Function(IsarAnime) onChanged) {
    return animes.isEmpty
        ? Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextHeadline("No data")))
        : SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: animes.length,
              (context, index) => AnimePortrait(
                animes[index],
                responseId: page.toString(),
                onTap: onChanged,
              ),
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 7 / 10,
            ),
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<IsarAnimeResponse> res = ref.watch(animeSearch(query));

    ref.listen<AsyncValue<AnimeResponseIntern>>(
        animeSearch(query), (_, state) => state.showSnackBarOnError(context));

    void saveAnime(AnimeIntern anime) {
      AnimeResponseIntern newRes = res.value!;
      newRes.data =
          newRes.data?.map((e) => e.malId == anime.malId ? anime : e).toList();

      try {
        ref.read(animeSearch(query).notifier).update(newRes);
      } on Exception catch (e, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unable to save anime.")));
      }
    }

    List<IsarAnime>? animes = res.value?.isarAnimes.toList();

    if (res.isLoading) {
      return buildLoading();
    }
    if (animes == null) {
      return buildNoData();
    }
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        buildHeader(res.value, context),
        buildAnimeList(
          res.value?.pagination?.currentPage,
          animes,
          saveAnime,
        ),
      ],
    );
  }
}
