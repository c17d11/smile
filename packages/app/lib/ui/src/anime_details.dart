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

class CustomChip extends StatelessWidget {
  final Widget child;

  const CustomChip({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey[300]!)),
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
              color: Colors.grey[800]!,
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
                color: Colors.grey[800]!,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800]!,
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

    return Container(
      color: Colors.grey[200],
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
                  color: Colors.grey[800]),
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
    return Container(
      color: Colors.grey[300],
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  IntrinsicHeight(
                    child: CustomDisplayRow(
                        width: MediaQuery.of(context).size.width / 3 - 15,
                        title: "TYPE",
                        items: [anime.type ?? '']),
                  ),
                  IntrinsicHeight(
                    child: CustomDisplayRow(
                        width: MediaQuery.of(context).size.width / 3 - 15,
                        title: "STATUS",
                        items: [anime.status ?? '']),
                  ),
                  IntrinsicHeight(
                    child: CustomDisplayRow(
                        width: MediaQuery.of(context).size.width / 3 - 15,
                        title: "RATING",
                        items: [anime.rating ?? '']),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              Container(
                color: Colors.grey[200],
                child: Padding(
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
                            color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${anime.synopsis}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.grey[200],
                child: Padding(
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
                            color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${anime.background}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget buildCustomContent(AnimeIntern anime) {
    return Container(
      color: Colors.grey[300],
      child: Padding(
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
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  Material(
                    child: SliderSelect(
                      "Personal score",
                      """How about it?""",
                      5,
                      stepSize: 0.5,
                      showInts: false,
                      min: 0,
                      max: 10,
                      onChanged: (value) {},
                    ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animeArgs =
        ModalRoute.of(context)?.settings.arguments as AnimeDetailsArgs;
    final anime = animeArgs.anime;
    const expandedBarHeight = 600.0;

    List<Tuple2<String, Widget>> tabs = [
      Tuple2("info", buildApiContent(anime)),
      Tuple2("notes", buildCustomContent(anime)),
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
                    backgroundColor: Colors.black,
                    leading: BackButton(
                      color: Colors.white,
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

                      return FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        title: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x00000000),
                                Color(0x90000000),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 72 +
                                  (top - kToolbarHeight) /
                                      (expandedBarHeight - kToolbarHeight) *
                                      (20 - 72),
                              bottom: 16,
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
                              style: const TextStyle(
                                color: Colors.white,
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
                                filter:
                                    ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
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
                                  const SizedBox(height: 20),
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      CustomTextChip(text: "${anime.year}"),
                                      CustomIconTextChip(
                                          text: "${anime.score}",
                                          icon: Icons.star),
                                      CustomTextChip(
                                          text: "${anime.episodes} episodes"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 40,
                      maxHeight: 40,
                      child: Material(
                        child: Container(
                          color: Colors.grey[300],
                          child: TabBar(
                            tabs: tabs
                                .map((e) => Tab(
                                        child: Text(
                                      e.item1.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    )))
                                .toList(),
                          ),
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
