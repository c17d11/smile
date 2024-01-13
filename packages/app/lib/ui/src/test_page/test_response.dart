import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/ui/src/test_page/test_anime.dart';
import 'package:app/ui/src/test_page/test_pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TestResponse extends ConsumerWidget {
  final AnimeQueryIntern query;
  const TestResponse(this.query, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ret = ref.watch(testPagePod(query));

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
                child: TextDivider("Page $currentPage of $lastPage"),
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
                      (context, index) => TestAnime(
                        res.isarAnimes.elementAt(index),
                        responseId: "${res.isarPagination?.currentPage ?? ''}",
                        onAnimeUpdate: () =>
                            ref.read(testPagePod(query).notifier).refresh(),
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
