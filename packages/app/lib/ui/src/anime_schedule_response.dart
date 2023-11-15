import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnimeScheduleResponseView extends ConsumerWidget {
  final ScheduleQueryIntern query;
  final void Function(int?) onLastPage;
  final bool bigHeader;
  const AnimeScheduleResponseView(
      {required this.onLastPage,
      required this.query,
      super.key,
      this.bigHeader = false});

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

    onLastPage(res?.pagination?.lastVisiblePage);

    return SliverPinnedHeader(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: bigHeader
            ? TextDivider("${query.day?.text}")
            : TextDivider("${query.day?.text} page $currentPage"),
      ),
    );
  }

  Widget buildAnimeList(WidgetRef ref, int? page, List<AnimeIntern> animes) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: animes.length,
        (context, index) => AnimePortrait(
          animes[index],
          responseId: page.toString(),
          onChange: (value) => ref
              .read(animeScheduleSearchControllerPod(query).notifier)
              .update(value),
          refQuery: AnimeQueryIntern(),
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
    AsyncValue<AnimeResponseIntern> res =
        ref.watch(animeScheduleSearchControllerPod(query));

    ref.listen<AsyncValue<AnimeResponseIntern>>(
        animeScheduleSearchControllerPod(query),
        (_, state) => state.showSnackBarOnError(context));

    AnimeResponseIntern? resIntern = res.value;
    List<AnimeIntern>? animes = resIntern?.data;

    return res.isLoading
        ? buildLoading()
        : animes == null
            ? buildNoData()
            : MultiSliver(
                pushPinnedChildren: true,
                children: [
                  buildHeader(resIntern, context),
                  buildAnimeList(
                    ref,
                    resIntern?.pagination?.currentPage,
                    animes,
                  ),
                ],
              );
  }
}
