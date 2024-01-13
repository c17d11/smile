import 'dart:ui';

import 'package:app/controller/src/controller/anime_collection_state_controller.dart';
import 'package:app/ui/src/favorite/favorite_state.dart';
import 'package:app/controller/src/controller/anime_schedule_state_controller.dart';
import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/ui/selection_widget/src/multiple_select.dart';
import 'package:app/ui/src/like_select.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/slider_select.dart';
import 'package:app/ui/src/sliver_app_bar_delegate.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

class CustomDisplayRow extends StatelessWidget {
  final List<String> items;
  final String title;
  final double width;

  const CustomDisplayRow(
      {required this.title,
      required this.items,
      required this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> prods = items
        .map(
          (e) => Text(
            e,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        )
        .toList();

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (prods.isNotEmpty) ...[
              const SizedBox(height: 5),
              Wrap(
                spacing: 15,
                runSpacing: 5,
                children: prods,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class AnimeDetails extends ConsumerStatefulWidget {
  const AnimeDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends ConsumerState<AnimeDetails>
    with SingleTickerProviderStateMixin {
  IsarAnime? localAnime;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && localAnime != null) {
        localAnime!.personalNotes = _controller.text;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Tag>> loadTags() async {
    await ref.read(tagPod.notifier).get();
    return ref.read(tagPod).value ?? [];
  }

  Widget buildApiContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 10,
                spacing: 10,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TYPE",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${localAnime!.type ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "YEAR",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${localAnime!.year ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RATING",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${localAnime!.score ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EPOSODES",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${localAnime!.episodes ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "STATUS",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${localAnime!.status ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RATING",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${localAnime!.rating ?? '-'}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomDisplayRow(
              width: MediaQuery.of(context).size.width,
              title: "PRODUCERS",
              items: localAnime!.producers
                      ?.map<String>((e) => e.title ?? "")
                      .where((e) => e != "")
                      .toList() ??
                  ['-']),
          const SizedBox(height: 10),
          CustomDisplayRow(
              width: MediaQuery.of(context).size.width,
              title: "GENRES",
              items: localAnime!.genres
                      ?.map<String>((e) => e.name ?? "")
                      .where((e) => e != "")
                      .toList() ??
                  ['-']),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'SYNPOSIS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${localAnime!.synopsis ?? '-'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'BACKGROUND',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${localAnime!.background ?? '-'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LikeSelect(
                  "Favorite",
                  localAnime!.isFavorite ?? false,
                  onChanged: (bool b) => setState(() {
                    localAnime!.isFavorite = b;
                  }),
                ),
                SliderSelect(
                  "Personal score",
                  null,
                  localAnime?.personalScore ?? 0,
                  stepSize: 0.5,
                  showInts: false,
                  min: 0,
                  max: 10,
                  onChanged: (value) {
                    if (value != null && localAnime != null) {
                      localAnime!.personalScore = value;
                    }
                  },
                ),
                MultiSelect<Tag>(
                  title: 'Tags',
                  loadOptions: loadTags,
                  initialSelected: localAnime!.tags,
                  onChangedInclude: (items) {
                    localAnime!.tags = items.map((e) => e as Tag).toList();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextHeadline("Notes".toUpperCase()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                            width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                            width: 2),
                      ),
                      hintText: "...",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animeArgs =
        ModalRoute.of(context)?.settings.arguments as AnimeDetailsArgs;

    localAnime = animeArgs.anime;
    if (localAnime!.personalNotes != null) {
      _controller.text = localAnime!.personalNotes!;
    }
    const expandedBarHeight = 500.0;

    List<Tuple2<String, Widget>> tabs = [
      Tuple2("info", buildApiContent()),
      Tuple2("notes", buildCustomContent(context)),
    ];

    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: MultiSliver(
                children: [
                  SliverAppBar(
                    leading: BackButton(
                      onPressed: () {
                        Navigator.pop(context, localAnime);
                      },
                    ),
                    pinned: true,
                    expandedHeight: expandedBarHeight,
                    forceElevated: innerBoxIsScrolled,
                    collapsedHeight: kToolbarHeight, // this is the default
                    flexibleSpace: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      var top = constraints.biggest.height;
                      return SafeArea(
                        child: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.zero,
                          title: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 72 +
                                    (top - kToolbarHeight) /
                                        (expandedBarHeight - kToolbarHeight) *
                                        (10 - 72),
                                bottom: 16 +
                                    (top - kToolbarHeight) /
                                        (expandedBarHeight - kToolbarHeight) *
                                        (10 - 16),
                                top: 16 +
                                    (top - kToolbarHeight) /
                                        (expandedBarHeight - kToolbarHeight) *
                                        (30 - 16),
                              ),
                              child: Text(
                                "${localAnime!.title}",
                                maxLines: 1 +
                                    ((top - kToolbarHeight) /
                                                (expandedBarHeight -
                                                    kToolbarHeight))
                                            .round() *
                                        (3 - 1),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          collapseMode: CollapseMode.parallax,
                          stretchModes: const [
                            StretchMode.zoomBackground,
                            StretchMode.blurBackground,
                            StretchMode.fadeTitle,
                          ],
                          background: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: NetworkImage(
                                    localAnime!.imageUrl ?? '',
                                  ),
                                  fit: BoxFit.cover,
                                )),
                                height: MediaQuery.of(context).size.height,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8.0, sigmaY: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: animeArgs.heroTag,
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/coffee.webp',
                                        image: localAnime!.imageUrl ?? '',
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 40,
                      maxHeight: 40,
                      child: TabBar(
                        tabs: tabs
                            .map((e) => Tab(child: Text(e.item1.toUpperCase())))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: tabs
                .map(
                  (e) => Builder(
                    builder: (BuildContext context) => CustomScrollView(
                      key: PageStorageKey<String>(e.item1),
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverToBoxAdapter(
                          child: e.item2,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class AnimeDetailsArgs {
  final IsarAnime anime;
  final String heroTag;
  const AnimeDetailsArgs(this.anime, this.heroTag);
}
