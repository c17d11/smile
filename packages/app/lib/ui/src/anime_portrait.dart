import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_details.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

class AnimePortrait extends ConsumerWidget {
  final AnimeIntern? anime;
  final String responseId;
  final void Function(AnimeIntern) onChange;
  final AnimeQueryIntern refQuery;
  const AnimePortrait(
    this.anime, {
    required this.responseId,
    required this.onChange,
    required this.refQuery,
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
                    .read(animeSearchControllerPod(refQuery).notifier)
                    .update(value as AnimeIntern);
                ref.invalidate(tagPod);
              });
            },
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Theme.of(context).colorScheme.background,
              child: (anime == null)
                  ? Container(
                      color: Colors.green[200],
                    )
                  : Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
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
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                              Text(anime!.imageUrl ?? ""),
                                      placeholderErrorBuilder:
                                          (context, error, stackTrace) =>
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () => ref
                                                  .read(
                                                      animeSearchControllerPod(
                                                              refQuery)
                                                          .notifier)
                                                  .update(anime!
                                                    ..isFavorite =
                                                        !(anime!.isFavorite ??
                                                            false)),
                                              child: Icon(
                                                (anime?.isFavorite ?? false)
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 24,
                                                color: Colors.red[900],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    anime!.title ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: _foregroundSecondary,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: _foregroundThird,
                                          ),
                                          Text(
                                            anime!.score?.toStringAsFixed(1) ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w800,
                                              color: _foregroundThird,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${anime!.episodes} episodes",
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w800,
                                          color: _foregroundThird,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
            ),
          );
  }
}
