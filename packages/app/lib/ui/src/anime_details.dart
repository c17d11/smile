import 'dart:ui';

import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/selection_widget/src/multiple_select.dart';
import 'package:app/ui/selection_widget/src/single_select.dart';
import 'package:app/ui/selection_widget/src/tag_select.dart';
import 'package:app/ui/src/like_select.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/slider_select.dart';
import 'package:app/ui/src/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _primary = Colors.teal.shade200;
final Color _primarySecondary = Colors.teal.shade400;

class CustomChip extends StatelessWidget {
  final Widget child;

  const CustomChip({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _backgroundSecondary, width: 2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: child,
      ),
    );
  }
}

class CustomTextChip extends CustomChip {
  CustomTextChip({super.key, required text})
      : super(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _foregroundSecondary,
            ),
          ),
        );
}

class CustomIconTextChip extends CustomChip {
  CustomIconTextChip({super.key, required text, required IconData icon})
      : super(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: _foregroundSecondary,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _foregroundSecondary,
                ),
              ),
            ],
          ),
        );
}

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
    List<Widget> prods = items.map((e) => CustomTextChip(text: e)).toList();

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
                  color: _foreground),
            ),
            if (prods.isNotEmpty) ...[
              const SizedBox(height: 5),
              Wrap(
                spacing: 5,
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
  AnimeIntern? localAnime;

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
          CustomDisplayRow(
              width: MediaQuery.of(context).size.width,
              title: "PRODUCERS",
              items: localAnime!.producers
                      ?.map<String>((e) => e.title ?? "")
                      .where((e) => e != "")
                      .toList() ??
                  []),
          const SizedBox(height: 10),
          CustomDisplayRow(
              width: MediaQuery.of(context).size.width,
              title: "GENRES",
              items: localAnime!.genres
                      ?.map<String>((e) => e.name ?? "")
                      .where((e) => e != "")
                      .toList() ??
                  []),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'SYNPOSIS',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _foreground),
                ),
                const SizedBox(height: 5),
                Text(
                  '${localAnime!.synopsis}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _foregroundSecondary),
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
                Text(
                  'BACKGROUND',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _foreground),
                ),
                const SizedBox(height: 5),
                Text(
                  '${localAnime!.background}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _foregroundSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomContent() {
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
                  """How about it?""",
                  5,
                  stepSize: 0.5,
                  showInts: false,
                  min: 0,
                  max: 10,
                  onChanged: (value) {},
                ),
                MultiSelect<Tag>(
                  title: 'Tags',
                  loadOptions: loadTags,
                  initialSelected: localAnime!.tags,
                  onChangedInclude: (items) {
                    localAnime!.tags = items.map((e) => e as Tag).toList();
                  },
                ),
                // TagSelect<Tag>(
                //   title: "Tags",
                //   loadOptions: loadTags,
                //   initialSelected: const [],
                //   onChangedInclude: (items) {
                //     // ref.read(tagPod.notifier).
                // },
                // ),
                const TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
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
    const expandedBarHeight = 500.0;

    List<Tuple2<String, Widget>> tabs = [
      Tuple2("info", buildApiContent()),
      Tuple2("notes", buildCustomContent()),
    ];

    return Scaffold(
      backgroundColor: _background,
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
                    backgroundColor: _background,
                    leading: BackButton(
                      color: _foreground,
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
                          title: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withAlpha(0),
                                  Colors.black.withAlpha(255),
                                ],
                              ),
                            ),
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
                                  color: _foreground,
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
                                        color: Colors.black.withOpacity(0.3)),
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
                    pinned: false,
                    delegate: SliverAppBarDelegate(
                        minHeight: 90,
                        maxHeight: 90,
                        child: Container(
                          color: Theme.of(context).colorScheme.background,
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CustomTextChip(
                                          text: "${localAnime!.type}"),
                                      const SizedBox(width: 10),
                                      CustomTextChip(
                                          text: "${localAnime!.year}"),
                                      const SizedBox(width: 10),
                                      CustomIconTextChip(
                                          text: "${localAnime!.score}",
                                          icon: Icons.star),
                                      const SizedBox(width: 10),
                                      CustomTextChip(
                                          text:
                                              "${localAnime!.episodes} episodes")
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      CustomTextChip(
                                          text: "${localAnime!.status}"),
                                      const SizedBox(width: 10),
                                      CustomTextChip(
                                          text: "${localAnime!.rating}"),
                                    ],
                                  )
                                ],
                              )),
                        )),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 40,
                      maxHeight: 40,
                      child: Container(
                        color: _background,
                        child: TabBar(
                          indicatorColor: _foregroundSecondary,
                          labelColor: _foreground,
                          unselectedLabelColor: _foregroundSecondary,
                          dividerColor: _foreground,
                          tabs: tabs
                              .map((e) =>
                                  Tab(child: Text(e.item1.toUpperCase())))
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
            children: tabs
                .map((e) => Builder(
                    builder: (BuildContext context) => CustomScrollView(
                            key: PageStorageKey<String>(e.item1),
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              SliverToBoxAdapter(
                                child: e.item2,
                              ),
                            ])))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class AnimeDetailsArgs {
  final AnimeIntern anime;
  final String heroTag;
  const AnimeDetailsArgs(this.anime, this.heroTag);
}
