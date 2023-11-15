import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/src/anime_list.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/sliver_app_bar_delegate.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class AnimeCollectionPage extends ConsumerStatefulWidget {
  const AnimeCollectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimeCollectionPageState();
}

class _AnimeCollectionPageState extends ConsumerState<AnimeCollectionPage> {
  String? search;
  // Tag? tag;

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
    final IconItem page = args.page;
    final Tag tag = args.tag;

    AnimeQueryIntern query = AnimeQueryIntern();

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
        body: AnimeList(
          page: page,
          initQuery: query
            ..page = 1
            ..tag = tag,
          onNextPageQuery: (query) => AnimeQueryIntern.nextPage(query),
          onLastQuery: (query) => null,
          key: UniqueKey(),
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
              setState(() {
                ref.invalidate(tagPod);
              });
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
    AnimeQueryIntern query = AnimeQueryIntern();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController controller =
                                TextEditingController();
                            return WillPopScope(
                              onWillPop: () async {
                                return true;
                              },
                              child: AlertDialog(
                                title: TextWindow("Enter tag name"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                content: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                    ),
                                    child: SizedBox(
                                        height: 150,
                                        width: 200,
                                        child:
                                            TextField(controller: controller)),
                                  );
                                }),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Apply'),
                                    onPressed: () {
                                      Navigator.pop(context, controller.text);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ).then((value) async {
                          if (value != null) {
                            await ref
                                .read(tagPod.notifier)
                                .insertTags([Tag(value, 0)]);
                            setState(() {});
                          }
                        }),
                    child: Text("New collection"))
              ],
            )),
          ),
          buildTags(tags),
        ],
      ),
    );
  }
}
