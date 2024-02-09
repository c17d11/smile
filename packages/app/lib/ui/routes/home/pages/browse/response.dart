import 'package:app/object/anime_response.dart';
import 'package:app/ui/common/text_divider.dart';
import 'package:app/ui/routes/home/common/snackbar.dart';
import 'package:app/ui/routes/home/pages/browse/state.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/ui/routes/home/common/anime_portrait.dart';
import 'package:app/ui/state/settings.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class BrowseResponse extends ConsumerWidget {
  final int heroId;
  final AnimeQuery query;
  final void Function(int?) updateLastPage;
  const BrowseResponse(
      {required this.heroId,
      required this.updateLastPage,
      required this.query,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsPod);
    AsyncValue<AnimeResponse> ret = ref.watch(animeBrowse(query));

    ref.listen<AsyncValue<AnimeResponse>>(
        animeBrowse(query), (_, state) => state.showSnackBarOnError(context));

    if (ret.hasValue) {
      updateLastPage(ret.value!.pagination?.lastVisiblePage ?? 1);
    }

    return ret.when(
      loading: () => const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => SliverFillRemaining(
          child: Center(child: Text("Error", style: AppTextStyle.small))),
      data: (res) {
        String currentPage = res.pagination?.currentPage.toString() ?? "";
        String lastPage = res.pagination?.lastVisiblePage.toString() ?? "";

        return MultiSliver(
          pushPinnedChildren: true,
          children: <Widget>[
            SliverPinnedHeader(
              child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: TextDivider("Page $currentPage of $lastPage")),
            ),
            res.animes?.isEmpty ?? true
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("No data", style: AppTextStyle.small)))
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: res.animes!.length,
                      (context, index) => AnimePortrait(
                        res.animes!.elementAt(index),
                        heroId: "$heroId-$index",
                        onAnimeUpdate: (animeId) => ref
                            .read(animeBrowse(query).notifier)
                            .refresh(animeId),
                      ),
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width /
                          settings.viewSettings.animePerDeviceWidth,
                      childAspectRatio: settings.viewSettings.animeRatio,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
