import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeResponseView extends ConsumerWidget {
  final AnimeQuery query;
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

  Widget buildHeader(AnimeResponseIntern? res) {
    String currentPage = res?.pagination?.currentPage.toString() ?? "";
    String lastPage = res?.pagination?.lastVisiblePage.toString() ?? "";

    onLastPage(res?.pagination?.lastVisiblePage);

    return SliverToBoxAdapter(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [const Divider(), TextHeadline("$currentPage / $lastPage")],
    ));
  }

  Widget buildAnimeList(List<AnimeIntern> animes) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
          childCount: animes.length,
          (context, index) => AnimePortrait(animes[index])),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 7 / 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<AnimeResponseIntern> res =
        ref.watch(animeSearchControllerPod(query));

    ref.listen<AsyncValue<AnimeResponseIntern>>(animeSearchControllerPod(query),
        (_, state) => state.showSnackBarOnError(context));

    AnimeResponseIntern? resIntern = res.value;
    List<AnimeIntern>? animes = resIntern?.data;

    return res.isLoading
        ? buildLoading()
        : animes == null
            ? buildNoData()
            : SliverMainAxisGroup(
                slivers: <Widget>[
                  buildHeader(resIntern),
                  buildAnimeList(animes),
                ],
              );
  }
}
