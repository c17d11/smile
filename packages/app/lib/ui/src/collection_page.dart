import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_list.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          buildTags(tags),
        ],
      ),
    );
  }
}
