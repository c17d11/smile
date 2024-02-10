import 'package:app/object/anime.dart';
import 'package:app/object/anime_response.dart';
import 'package:app/ui/common/text_divider.dart';
import 'package:app/ui/common/snackbar.dart';
import 'package:app/ui/routes/home/pages/schedule/state.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/ui/common/anime_portrait.dart';
import 'package:app/ui/state/settings.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ScheduleResponse extends ConsumerWidget {
  final int heroId;
  final ScheduleQuery query;
  final void Function(int?) updateLastPage;
  const ScheduleResponse(
      {required this.heroId,
      required this.updateLastPage,
      required this.query,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsPod);
    AsyncValue<AnimeResponse> ret = ref.watch(animeSchedule(query));

    ref.listen<AsyncValue<AnimeResponse>>(
        animeSchedule(query), (_, state) => state.showSnackBarOnError(context));

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
        List<Anime> animes = res.animes!.where((e) {
          return !query.appFilter.showOnlyFavorites ||
              (e.notes?.favorite ?? false) == query.appFilter.showOnlyFavorites;
        }).where((e) {
          return query.appFilter.showOnlyTags.isEmpty ||
              query.appFilter.showOnlyTags
                  .toSet()
                  .intersection(e.notes?.tags?.toSet() ?? {})
                  .isNotEmpty;
        }).toList();

        return MultiSliver(
          pushPinnedChildren: true,
          children: <Widget>[
            SliverPinnedHeader(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: TextDivider(
                    "${query.day?.text ?? '-'} page $currentPage of $lastPage"),
              ),
            ),
            animes.isEmpty
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("No data", style: AppTextStyle.small)))
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: animes.length,
                      (context, index) => AnimePortrait(
                        animes.elementAt(index),
                        heroId: "$heroId-$index",
                        onAnimeUpdate: (animeId) => ref
                            .read(animeSchedule(query).notifier)
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
