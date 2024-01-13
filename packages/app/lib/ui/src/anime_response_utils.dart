import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
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

  Widget buildHeader(AnimeResponseIntern? res) {
    String currentPage = res?.pagination?.currentPage.toString() ?? "";
    String lastPage = res?.pagination?.lastVisiblePage.toString() ?? "";

    return SliverPinnedHeader(
      child: TextDivider("Page $currentPage of $lastPage"),
    );
  }

  Widget buildAnimeList(
      int? page, List<IsarAnime> animes, void Function(IsarAnime) saveAnime) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: animes.length,
        (context, index) => AnimePortrait(
          animes[index],
          responseId: page.toString(),
          onTap: saveAnime,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 7 / 10,
      ),
    );
  }

  Widget buildResponse(
      AsyncValue<IsarAnimeResponse> res, void Function(IsarAnime) saveAnime) {
    List<IsarAnime>? animes = res.value?.isarAnimes.toList();
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
