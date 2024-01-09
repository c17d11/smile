import 'package:app/controller/src/controller/anime_favorite_state_controller.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnimeFavoritePage extends ConsumerStatefulWidget {
  const AnimeFavoritePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimeFavoritePageState();
}

class _AnimeFavoritePageState extends ConsumerState<AnimeFavoritePage> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<FavoriteResponseView> responses = [];

  void loadNextResponse() {
    FavoriteResponseView nextRes = responses.last.next();
    if (lastPage > nextRes.page) {
      setState(() {
        responses.add(nextRes);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    responses.add(FavoriteResponseView(
        page: 1, updateLastPage: (int page) => lastPage = page));

    _scroll.addListener(() {
      if (_scroll.offset >= _scroll.position.maxScrollExtent) {
        loadNextResponse();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentTotal <
              MediaQuery.of(context).size.height) {
            loadNextResponse();
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scroll,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[...responses],
        ),
      ),
    );
  }
}

class FavoriteResponseView extends ConsumerWidget with AnimeResponseViewUtils {
  final int page;
  final void Function(int) updateLastPage;

  FavoriteResponseView(
      {required this.page, required this.updateLastPage, super.key});

  FavoriteResponseView next() =>
      FavoriteResponseView(page: page + 1, updateLastPage: updateLastPage);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(animeFavorite(page));

    ref.listen<AsyncValue<AnimeResponseIntern>>(
        animeFavorite(page), (_, state) => state.showSnackBarOnError(context));

    void saveAnime(AnimeIntern anime) {
      AnimeResponseIntern newRes = res.value!;
      newRes.data =
          newRes.data?.map((e) => e.malId == anime.malId ? anime : e).toList();

      try {
        ref.read(animeFavorite(page).notifier).update(newRes);
      } on Exception catch (e, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unable to save anime.")));
      }
    }

    if (res.hasValue) {
      updateLastPage(res.value!.pagination?.lastVisiblePage ?? 1);
    }

    return buildResponse(res, saveAnime);
  }
}

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
      child: Container(
        // color: Theme.of(context).colorScheme.background,
        child: TextDivider("Page $currentPage of $lastPage"),
      ),
    );
  }

  Widget buildAnimeList(int? page, List<AnimeIntern> animes,
      void Function(AnimeIntern) saveAnime) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: animes.length,
        (context, index) => AnimePortrait(
          animes[index],
          responseId: page.toString(),
          onTap: saveAnime,
          trashArgs: AnimePortraitTrashArgs()..favoritePage = page,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 7 / 10,
      ),
    );
  }

  Widget buildResponse(AsyncValue<AnimeResponseIntern> res,
      void Function(AnimeIntern) saveAnime) {
    List<AnimeIntern>? animes = res.value?.data;
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
