import 'dart:ui';

import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/selection_widget/src/multiple_select.dart';
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
          color: _backgroundSecondary,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _backgroundSecondary)),
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
  Future<List<GenreIntern>> loadGenres() async {
    await ref.read(genrePod.notifier).get();
    return ref.read(genrePod).value ?? [];
  }

  Widget buildApiContent(AnimeIntern anime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDisplayRow(
              width: MediaQuery.of(context).size.width,
              title: "PRODUCERS",
              items: anime.producers
                      ?.map<String>((e) => e.title ?? "")
                      .where((e) => e != "")
                      .toList() ??
                  []),
          const SizedBox(height: 10),
          CustomDisplayRow(
              width: MediaQuery.of(context).size.width,
              title: "GENRES",
              items: anime.genres
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
                  '${anime.synopsis}',
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
                  '${anime.background}',
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

  Widget buildCustomContent(AnimeIntern anime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          anime.isFavorite = !(anime.isFavorite ?? false);
                        });
                      },
                      child: Icon(
                        (anime.isFavorite ?? false)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
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
                MultiSelect<GenreIntern>(
                  title: "Tags",
                  tristate: false,
                  loadOptions: loadGenres,
                  initialSelected: [],
                  onChangedInclude: (items) {},
                ),
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
    final anime = animeArgs.anime;
    const expandedBarHeight = 500.0;

    List<Tuple2<String, Widget>> tabs = [
      Tuple2("info", buildApiContent(anime)),
      Tuple2("notes", buildCustomContent(anime)),
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
                        Navigator.pop(context, anime);
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
                                "${anime.title}",
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
                                    anime.imageUrl ?? '',
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
                                        image: anime.imageUrl ?? '',
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
                      minHeight: 40,
                      maxHeight: 100,
                      child: Container(
                        color: _background,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            CustomTextChip(text: "${anime.type}"),
                            CustomTextChip(text: "${anime.year}"),
                            CustomIconTextChip(
                                text: "${anime.score}", icon: Icons.star),
                            CustomTextChip(text: "${anime.episodes} episodes"),
                            CustomTextChip(text: "${anime.status}"),
                            CustomTextChip(text: "${anime.rating}"),
                          ],
                        ),
                      ),
                    ),
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
