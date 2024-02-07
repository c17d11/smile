import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

mixin AnimeResponseViewUtils {
  Widget buildLoading() {
    return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget buildNoData() {
    return const SliverFillRemaining(
        child: Center(child: TextHeadline("No data")));
  }

  Widget buildHeader(AnimeResponse? res) {
    String currentPage = res?.pagination?.currentPage.toString() ?? "";
    String lastPage = res?.pagination?.lastVisiblePage.toString() ?? "";

    return SliverPinnedHeader(
      child: TextDivider("Page $currentPage of $lastPage"),
    );
  }

  Widget buildAnimeList(
      int? page, List<Anime> animes, void Function(int) saveAnime) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: animes.length,
        (context, index) => AnimePortrait(
          animes[index],
          heroId: page.toString(),
          onAnimeUpdate: saveAnime,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 7 / 10,
      ),
    );
  }

  Widget buildResponse(
      AsyncValue<AnimeResponse> res, void Function(int) saveAnime) {
    List<Anime>? animes = res.value?.animes;
    // lastPage = res.value?.pagination?.lastVisiblePage ?? 1;

    if (res.isLoading) {
      return buildLoading();
    }
    if (animes == null) {
      return buildNoData();
    }
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        buildHeader(res.value!),
        buildAnimeList(
          res.value!.pagination?.currentPage,
          animes,
          saveAnime,
        ),
      ],
    );
  }
}
