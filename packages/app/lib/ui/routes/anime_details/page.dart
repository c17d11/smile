import 'dart:math';
import 'dart:ui';

import 'package:app/object/anime.dart';
import 'package:app/object/anime_notes.dart';
import 'package:app/object/tag.dart';
import 'package:app/ui/common/like_select.dart';
import 'package:app/ui/common/selection_widget/src/multiple_select.dart';
import 'package:app/ui/common/slider_select.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
import 'package:app/ui/routes/anime_details/sliver_app_bar_delegate.dart';
import 'package:app/ui/state/tag.dart';
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
              style: const TextStyle(
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
  late TabController _tabController;
  int _tabIndex = 0;
  Anime? anime;

  bool? isFavorite;
  double? personalScore;
  List<Tag>? tags;
  String? personalNotes;

  final double expandedBarHeight = 500.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Tag>> loadTags() async {
    await ref.read(tagPod.notifier).get();
    return ref.read(tagPod).value ?? [];
  }

  Widget buildApiContent() {
    return MultiSliver(children: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
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
                          const Text(
                            "TYPE",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              anime!.type ?? '-',
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
                          const Text(
                            "YEAR",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "${anime!.year ?? '-'}",
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
                          const Text(
                            "RATING",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "${anime!.score ?? '-'}",
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
                          const Text(
                            "EPOSODES",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "${anime!.episodes ?? '-'}",
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
                          const Text(
                            "STATUS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              anime!.status ?? '-',
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
                          const Text(
                            "RATING",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              anime!.rating ?? '-',
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
              const SizedBox(height: 10),
              CustomDisplayRow(
                  width: MediaQuery.of(context).size.width,
                  title: "PRODUCERS",
                  items: anime!.producers
                          ?.map<String>((e) => e.title ?? "")
                          .where((e) => e != "")
                          .toList() ??
                      ['-']),
              const SizedBox(height: 10),
              CustomDisplayRow(
                  width: MediaQuery.of(context).size.width,
                  title: "GENRES",
                  items: anime!.genres
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
                      anime!.synopsis ?? '-',
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
                      anime!.background ?? '-',
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
        ),
      ),
    ]);
  }

  Widget buildCustomContent(BuildContext context) {
    return MultiSliver(children: [
      SliverToBoxAdapter(
        child: Padding(
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
                      isFavorite ?? false,
                      onChanged: (bool b) => setState(() {
                        isFavorite = b;
                      }),
                    ),
                    SliderSelect(
                      "Personal score",
                      null,
                      personalScore ?? 0,
                      stepSize: 0.5,
                      showInts: false,
                      min: 0,
                      max: 10,
                      onChanged: (value) => setState(() {
                        personalScore = value;
                      }),
                    ),
                    MultiSelect<Tag>(
                      title: 'Tags',
                      loadOptions: loadTags,
                      initialSelected: tags,
                      onChangedInclude: (items) => setState(() {
                        tags = items.map((e) => e as Tag).toList();
                      }),
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
                      child: CustomTextField(
                        hint: "Write your notes here...",
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        initialValue: personalNotes,
                        onChanged: (value) {
                          if (value != personalNotes) {
                            setState(() {
                              personalNotes = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final animeArgs =
        ModalRoute.of(context)?.settings.arguments as AnimeDetailsArgs;

    anime = animeArgs.anime;
    isFavorite ??= anime?.notes?.favorite;
    personalScore ??= anime?.notes?.score;
    tags ??= anime?.notes?.tags;
    personalNotes ??= anime?.notes?.notes;

    List<Tuple2<String, Widget>> tabs = [
      Tuple2("info", buildApiContent()),
      Tuple2("notes", buildCustomContent(context)),
    ];

    return Scaffold(
      floatingActionButton: _tabIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                ref
                    .read(databasePod)
                    .updateAnimeNotes(AnimeNotes()
                      ..malId = anime!.malId
                      ..favorite = isFavorite
                      ..score = personalScore
                      ..notes = personalNotes
                      ..tags = tags)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Saved"),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: const Duration(milliseconds: 250),
                  ));
                });
              },
              label: const Text('Save'),
              icon: const Icon(Icons.save),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: MultiSliver(
              children: [
                SliverAppBar(
                  leading: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  pinned: true,
                  expandedHeight: expandedBarHeight,
                  forceElevated: innerBoxIsScrolled,
                  collapsedHeight: kToolbarHeight, // this is the default
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;

                    var expandedProgress = (top - kToolbarHeight) /
                        (expandedBarHeight - kToolbarHeight);

                    return SafeArea(
                      child: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        title: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 72 + expandedProgress * (10 - 72),
                              bottom: 16 + expandedProgress * (10 - 16),
                              top: 16 + expandedProgress * (30 - 16),
                            ),
                            child: Text(
                              "${anime!.title}",
                              maxLines: 1 + expandedProgress.round() * (3 - 1),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
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
                                  anime!.imageUrl ?? '',
                                ),
                                fit: BoxFit.cover,
                              )),
                              height: MediaQuery.of(context).size.height,
                              child: BackdropFilter(
                                // blendMode: BlendMode.,
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: min(
                                  max(1 - 3 * (1 - expandedProgress), 0), 1),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      50, 50, 50, 150),
                                  child: Hero(
                                    tag: animeArgs.heroTag,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/coffee.webp',
                                      image: anime!.imageUrl ?? '',
                                      height: 400,
                                      fit: BoxFit.contain,
                                      // alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
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
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: TabBar(
                        controller: _tabController,
                        tabs: tabs
                            .map((e) => Tab(child: Text(e.item1.toUpperCase())))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: tabs
              .map(
                (e) => Builder(
                  builder: (BuildContext context) => CustomScrollView(
                    key: PageStorageKey<String>(e.item1),
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      e.item2,
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      // ),
    );
  }
}

class AnimeDetailsArgs {
  final Anime anime;
  final String heroTag;
  const AnimeDetailsArgs(this.anime, this.heroTag);
}
