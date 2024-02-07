import 'package:app/ui/routes/home/pages/schedule/state.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/routes/home/pages/anime_portrait.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
import 'package:app/ui/routes/home/pages/text_divider.dart';
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
                            .read(animeSchedule(query).notifier)
                            .refresh(animeId),
                      ),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 7 / 10,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
