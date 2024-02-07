import 'package:app/controller/state.dart';
import 'package:app/object/collection_query.dart';
import 'package:app/ui/selection_widget/src/confirm_button.dart';
import 'package:app/ui/pages/collections/state.dart';
import 'package:app/ui/pages/anime_portrait.dart';
import 'package:app/ui/pages/pod.dart';
import 'package:app/ui/pages/text_divider.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CollectionResponse extends ConsumerWidget {
  final int heroId;
  final CollectionQuery query;
  final void Function(int?) updateLastPage;
  final void Function() onDone;
  const CollectionResponse(
      {required this.heroId,
      required this.updateLastPage,
      required this.query,
      required this.onDone,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<AnimeResponse> ret = ref.watch(animeCollection(query));

    ref.listen<AsyncValue<AnimeResponse>>(animeCollection(query),
        (_, state) => state.showSnackBarOnError(context));

    if (ret.hasValue) {
      updateLastPage(ret.value!.pagination?.lastVisiblePage ?? 1);
    }

    return ret.when(
      loading: () => const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => SliverFillRemaining(
          child: Center(child: Text("Error", style: AppTextStyle.small))),
      data: (res) {
        onDone();

        return MultiSliver(
          pushPinnedChildren: true,
          children: <Widget>[
            SliverPinnedHeader(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: TextActionDivider(
                  "${query.collectionName}",
                  tailing: const Icon(Icons.delete_forever),
                  onPressed: () => confirm(
                    "Remove collection?",
                    "The collection can not be restored later.",
                    context,
                    () async {
                      await deleteCollection(ref, query.collectionName!);
                      ref.invalidate(collectionNames);
                    },
                  ),
                ),
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
                            .read(animeCollection(query).notifier)
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
