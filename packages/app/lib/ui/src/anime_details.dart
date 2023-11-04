import 'dart:ui';

import 'package:app/controller/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final width;

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

class _AnimeDetailsState extends ConsumerState<AnimeDetails> {
  bool isCollapsed = false;
  final scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    final anime = ModalRoute.of(context)?.settings.arguments as AnimeIntern;
    const collapsedBarHeight = 60.0;
    const expandedBarHeight = 600.0;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        setState(() {
          isCollapsed = scroll.hasClients &&
              scroll.offset > (expandedBarHeight - collapsedBarHeight);
        });
        return false;
      },
      child: CustomScrollView(
        controller: scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: isCollapsed ? Colors.black : Colors.white,
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context, anime);
              },
            ),
            pinned: true,
            expandedHeight: expandedBarHeight,
            collapsedHeight: collapsedBarHeight,
            flexibleSpace: FlexibleSpaceBar(
              title: isCollapsed
                  ? Text(
                      "${anime.title}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
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
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.3)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "anime-${anime.malId}",
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/coffee.webp',
                            image: anime.imageUrl ?? '',
                            // fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${anime.title}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w400,
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
                                text: "${anime.score}", icon: Icons.star),
                            CustomTextChip(text: "${anime.episodes} episodes"),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   "Rate ",
                                  //   style: TextStyle(
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.w800,
                                  //       color: Colors.grey[800]),
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        anime.isFavorite =
                                            !(anime.isFavorite ?? false);
                                      });
                                      // ref
                                      //     .read(animeControllerPod
                                      //         .notifier)
                                      //     .update(anime
                                      //       ..isFavorite =
                                      //           !(anime.isFavorite ??
                                      //               false));
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
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            IntrinsicHeight(
                              child: CustomDisplayRow(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      15,
                                  title: "TYPE",
                                  items: [anime.type ?? '']),
                            ),
                            IntrinsicHeight(
                              child: CustomDisplayRow(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      15,
                                  title: "STATUS",
                                  items: [anime.status ?? '']),
                            ),
                            IntrinsicHeight(
                              child: CustomDisplayRow(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      15,
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
              ),
            ),
          ),
        ],
      ),
    );
    //   },
    // );
  }
}
