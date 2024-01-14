import 'package:app/ui/src/schedule/schedule_state.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ScheduleResponse extends ConsumerWidget {
  final ScheduleQueryIntern query;
  final void Function(int?) updateLastPage;
  const ScheduleResponse(
      {required this.updateLastPage, required this.query, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<IsarAnimeResponse> ret = ref.watch(animeSchedule(query));

    ref.listen<AsyncValue<AnimeResponseIntern>>(
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
            res.data?.isEmpty ?? true
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("No data", style: AppTextStyle.small)))
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: res.data!.length,
                      (context, index) => AnimePortrait(
                        res.isarAnimes.elementAt(index),
                        responseId: "${res.isarPagination?.currentPage ?? ''}",
                        onAnimeUpdate: () =>
                            ref.read(animeSchedule(query).notifier).refresh(),
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
