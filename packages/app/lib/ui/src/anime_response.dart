import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnimeResponseView extends ConsumerWidget {
  final AnimeQueryIntern query;
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

  Widget buildHeader(AnimeResponseIntern? res, BuildContext context) {
    String currentPage = res?.pagination?.currentPage.toString() ?? "";
    String lastPage = res?.pagination?.lastVisiblePage.toString() ?? "";

    onLastPage(res?.pagination?.lastVisiblePage);

    return SliverPinnedHeader(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: TextDivider("Page $currentPage of $lastPage"),
      ),
    );
  }

  Widget buildAnimeList(int? page, List<AnimeIntern> animes,
      void Function(AnimeIntern) onChanged) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: animes.length,
        (context, index) => AnimePortrait(
          animes[index],
          responseId: page.toString(),
          onChange: onChanged,
          refQuery: query,
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
        ref.watch(animeSearchControllerPod(query));

    ref.listen<AsyncValue<AnimeResponseIntern>>(animeSearchControllerPod(query),
        (_, state) => state.showSnackBarOnError(context));

    // onChange(value) =>
    //     ref.read(animeSearchControllerPod(query).notifier).update(value);

    AnimeResponseIntern? resIntern = res.value;
    List<AnimeIntern>? animes = resIntern?.data;

    if (res.isLoading) {
      return buildLoading();
    }
    if (animes == null) {
      return buildNoData();
    }
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        buildHeader(resIntern, context),
        buildAnimeList(
          resIntern?.pagination?.currentPage,
          animes,
          (_) {},
        ),
      ],
    );
  }
}

// class AnimeResponseSliver extends ConsumerWidget {
//   final AnimeResponseIntern response;
//   const AnimeResponseSliver({required this.response, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     String currentPage = response.pagination?.currentPage.toString() ?? "";
//     String lastPage = response.pagination?.lastVisiblePage.toString() ?? "";
//     List<AnimeIntern> animes = response.data ?? [];

//     return MultiSliver(
//       pushPinnedChildren: true,
//       children: <Widget>[
//         SliverPinnedHeader(
//           child: Container(
//             color: Theme.of(context).colorScheme.background,
//             child: TextDivider("Page $currentPage of $lastPage"),
//           ),
//         ),
//         SliverGrid(
//           delegate: SliverChildBuilderDelegate(
//             childCount: animes.length,
//             (context, index) => AnimePortrait(animes[index],
//                 responseId: currentPage.toString(), onChange: (value) => null
//                 // ref.read(animeSearchControllerPod(query).notifier).update(value),
//                 ),
//           ),
//           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: 150,
//             childAspectRatio: 7 / 10,
//           ),
//         ),
//       ],
//     );
//   }
// }
