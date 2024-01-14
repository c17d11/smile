import 'package:app/ui/src/favorite/favorite_state.dart';
import 'package:app/ui/src/schedule/schedule_state.dart';
import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/ui/src/anime_details.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/test_page/test_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

class AnimePortraitTrashArgs {
  // Problem: Riverpod Ref gets disposed when Navigating to other page
  // and stays there long enough.

  // The provider need to have .autoDispose since it recieves an argument
  // for the query, and otherwise the number of providers would start building
  // up and consume lots of RAM.

  // Hero-animations is used to animate the transition from AnimePortait
  // to the Detail page, because of this any async database interaction
  // need to be performed after the transition back from the Detail page is
  // done.

  // If database interaction is done just before navgating back from the
  // Detail page, the Hero-animation will lag.

  // Also the Anime needs to be save from the AnimeSearch provider etc. Since
  // Those providers are state-notifiers and updating the Anime in a separate
  // provider and the watch that change in the AnimeSearch provider will cause
  // all animes in the reponse to refresh. This means flickering, which is
  // annoying.

  // My conclusion is that the anime need to be saved after navigating back.
  // And to do that the AnimeSearch provider etc need to be keeps alive.
  // To solve this the AnimeSearch provider is watched here, this prevents
  // the provider from disposing. Since this page can be called from different
  // places curresponding to different providers, different args are needed to
  // indicate which provider to watch.

  AnimeQueryIntern? animeQuery;
  ScheduleQueryIntern? scheduleQuery;
  int? favoritePage;
  Tuple2<int, Tag>? collectionQuery;
}

class AnimePortrait extends ConsumerWidget {
  final IsarAnime? anime;
  final String responseId;
  final Function() onAnimeUpdate;
  const AnimePortrait(
    this.anime, {
    required this.responseId,
    required this.onAnimeUpdate,
    super.key,
  });

  Widget buildNull() {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: _backgroundSecondary,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String heroTag = "$responseId-anime-${anime?.malId}";

    return anime == null
        ? buildNull()
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'anime-details',
                arguments: AnimeDetailsArgs(anime!, heroTag),
              ).then((value) async {
                await ref
                    .read(testAnimeUpdatePod.notifier)
                    .update(value as IsarAnime);
                onAnimeUpdate();
              });
            },
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: GridTile(
                footer: GridTileBar(
                  backgroundColor:
                      Theme.of(context).colorScheme.background.withAlpha(190),
                  title: Text(
                    anime!.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: _foreground,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: _foregroundSecondary,
                          ),
                          Text(
                            anime!.score?.toStringAsFixed(1) ?? "",
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: _foregroundSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${anime!.episodes} episodes",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Hero(
                      tag: heroTag,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/coffee.webp',
                        image: anime!.imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Text(anime!.imageUrl ?? ""),
                        placeholderErrorBuilder: (context, error, stackTrace) =>
                            Text(anime!.imageUrl ?? ""),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x90000000),
                            Color(0x70000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                ref.read(testAnimeUpdatePod.notifier).update(
                                    anime!
                                      ..isFavorite =
                                          !(anime!.isFavorite ?? false));

                                onAnimeUpdate();
                              },
                              child: Icon(
                                (anime?.isFavorite ?? false)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 24,
                                color: Colors.red[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
