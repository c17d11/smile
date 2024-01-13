import 'package:app/controller/src/controller/anime_collection_state_controller.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_page_template.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class CollectionResponseView extends ResponseView {
  final Tag tag;
  CollectionResponseView(
      {required this.tag, super.key, super.page, super.updateLastPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(animeCollection(Tuple2(page ?? 1, tag)));

    ref.listen<AsyncValue<AnimeResponseIntern>>(
        animeCollection(Tuple2(page ?? 1, tag)),
        (_, state) => state.showSnackBarOnError(context));

    void saveAnime(AnimeIntern anime) {
      AnimeResponseIntern newRes = res.value!;
      newRes.data =
          newRes.data?.map((e) => e.malId == anime.malId ? anime : e).toList();

      try {
        ref
            .read(animeCollection(Tuple2(page ?? 1, tag)).notifier)
            .update(newRes);
      } on Exception catch (e, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unable to save anime.")));
      }
    }

    if (res.hasValue && updateLastPage != null) {
      updateLastPage!(res.value!.pagination?.lastVisiblePage ?? 1);
    }

    return buildResponse(
      res,
      saveAnime,
      AnimePortraitTrashArgs()..collectionQuery = Tuple2(page ?? 1, tag),
    );
  }

  @override
  ResponseView copyWith({page, updateLastPage}) {
    return CollectionResponseView(
        tag: tag,
        page: page ?? this.page,
        updateLastPage: updateLastPage ?? this.updateLastPage);
  }

  @override
  ResponseView next() =>
      CollectionResponseView(tag: tag, page: (page ?? 1) + 1);
}

class AnimeCollectionPage extends AnimePageTemplate<CollectionResponseView> {
  const AnimeCollectionPage(super.responseTemplate, {super.key});

  Widget buildTags(AsyncValue<List<Tag>> tags) {
    Widget? tagWidget;
    if (tags.isLoading) {
      tagWidget = const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: CircularProgressIndicator())],
      );
    } else if (tags.value == null || tags.value!.isEmpty) {
      tagWidget = const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [TextHeadline("No data")],
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: tagWidget ?? const Placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final tag = ref.watch(tagQueryPod);

    // final args =
    //     ModalRoute.of(context)?.settings.arguments as AnimeCollectionPageArgs;

    // responseTemplate.update(args.tag);

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                    SliverAppBar(
                      // backgroundColor: Theme.of(context).colorScheme.background,
                      leading: BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      pinned: true,
                    ),
                  ],
          body: super),
    );
  }
}

// ConsumerStatefulWidget {
//   const AnimeCollectionPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _AnimeCollectionPageState();
// }

class _AnimeCollectionPageState extends ConsumerState<AnimeCollectionPage> {
  String? search;
  final _scroll = ScrollController();
  int lastPage = 1;
  List<CollectionResponseView> responses = [];

  void loadNextResponse() {
    ResponseView nextRes = responses.last.next();
    if (lastPage > nextRes.page!) {
      setState(() {
        responses.add(nextRes as CollectionResponseView);
      });
    }
  }

  @override
  void initState() {
    super.initState();

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

  Widget buildTags(AsyncValue<List<Tag>> tags) {
    Widget? tagWidget;
    if (tags.isLoading) {
      tagWidget = const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: CircularProgressIndicator())],
      );
    } else if (tags.value == null || tags.value!.isEmpty) {
      tagWidget = const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [TextHeadline("No data")],
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: tagWidget ?? const Placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as AnimeCollectionPageArgs;

    responses.add(CollectionResponseView(
        page: 1, tag: args.tag, updateLastPage: (int page) => lastPage = page));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            pinned: true,
          ),
        ],
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
      ),
    );
  }
}

class AnimeCollectionPageArgs {
  IconItem page;
  Tag tag;
  AnimeCollectionPageArgs({required this.page, required this.tag});
}

class CollectionPage extends ConsumerStatefulWidget {
  final IconItem page;
  const CollectionPage({required this.page, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  Widget buildTags(AsyncValue<List<Tag>> tags) {
    Widget tagWidget;
    if (tags.isLoading) {
      tagWidget = const SliverFillRemaining(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: CircularProgressIndicator())],
      ));
    } else if (tags.value == null || tags.value!.isEmpty) {
      tagWidget = const SliverFillRemaining(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [TextHeadline("No collections")],
      ));
    } else {
      tagWidget = SliverPadding(
        padding: const EdgeInsets.all(10),
        sliver: SliverList.separated(
          itemCount: tags.value!.length,
          itemBuilder: (context, index) => ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Icon(Icons.bookmarks),
            title: Text('${tags.value![index].name}'),
            subtitle: Text("${tags.value![index].animeCount} animes"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red[600],
              onPressed: () async {
                await ref.read(tagPod.notifier).removeTag(tags.value![index]);
              },
            ),
            tileColor: Theme.of(context).primaryColor,
            onTap: () async {
              await Navigator.pushNamed(context, 'collection',
                  arguments: AnimeCollectionPageArgs(
                      page: widget.page, tag: tags.value![index]));
              // setState(() {
              //   ref.invalidate(tagPod);
              // });
            },
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
        ),
      );
    }

    return tagWidget;
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(tagPod);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildTags(tags),
        ],
      ),
    );
  }
}

// class CollectionResponseView extends ConsumerWidget
//     with AnimeResponseViewUtils {
//   final int page;
//   final Tag tag;
//   final void Function(int) updateLastPage;

//   CollectionResponseView(
//       {required this.page,
//       required this.tag,
//       required this.updateLastPage,
//       super.key});

//   CollectionResponseView next() => CollectionResponseView(
//       page: page + 1, tag: tag, updateLastPage: updateLastPage);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final res = ref.watch(animeCollection(Tuple2(page, tag)));

//     ref.listen<AsyncValue<AnimeResponseIntern>>(
//         animeCollection(Tuple2(page, tag)),
//         (_, state) => state.showSnackBarOnError(context));

//     void saveAnime(AnimeIntern anime) {
//       AnimeResponseIntern newRes = res.value!;
//       newRes.data =
//           newRes.data?.map((e) => e.malId == anime.malId ? anime : e).toList();
//       ref.read(animeChange('collection').notifier).update(newRes);
//     }

//     if (res.hasValue) {
//       updateLastPage(res.value!.pagination?.lastVisiblePage ?? 1);
//     }

//     return buildResponse(res, saveAnime);
//   }
// }
