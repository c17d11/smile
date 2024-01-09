import 'package:app/controller/src/controller/anime_schedule_state_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
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

  Widget buildAnimeList(int? page, List<AnimeIntern> animes,
      void Function(AnimeIntern) onChanged) {
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
                responseId: (query.day?.text ?? '') + page.toString(),
                onTap: onChanged,
                trashArgs: AnimePortraitTrashArgs()..scheduleQuery = query,
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
    AsyncValue<AnimeResponseIntern> res = ref.watch(animeSchedule(query));

    ref.listen<AsyncValue<AnimeResponseIntern>>(
        animeSchedule(query), (_, state) => state.showSnackBarOnError(context));

    void saveAnime(AnimeIntern anime) {
      AnimeResponseIntern newRes = res.value!;
      newRes.data =
          newRes.data?.map((e) => e.malId == anime.malId ? anime : e).toList();
      try {
        ref.read(animeSchedule(query).notifier).update(newRes);
      } on Exception catch (e, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unable to save anime.")));
      }
    }

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
                    resIntern?.pagination?.currentPage,
                    animes,
                    saveAnime,
                  ),
                ],
              );
  }
}
