import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state/state.dart';

class AnimePortrait extends ConsumerWidget {
  final AnimeIntern? anime;

  const AnimePortrait(this.anime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (anime != null) {
      print(anime!.imageUrl ?? '');
    }
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                            Positioned.fill(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/coffee.webp',
                                image: anime!.imageUrl ?? '',
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) =>
                                        Text(anime!.imageUrl ?? ""),
                                placeholderErrorBuilder:
                                    (context, error, stackTrace) =>
                                        Text(anime!.imageUrl ?? ""),
                              ),
                            ),
                            // CachedNetworkImage(
                            //   imageUrl: anime!.imageUrl ?? '',
                            //   placeholder: (context, url) =>
                            //       CircularProgressIndicator(),
                            //   errorWidget: (context, url, error) =>
                            //       Icon(Icons.error),
                            //   fit: BoxFit.cover,
                            //   alignment: Alignment.topLeft,
                            // ),
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
                                padding: const EdgeInsets.all(10),
                                child: Row(children: [
                                  Icon(
                                    (anime!.isFavorite ?? false)
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    size: 24,
                                    color: Colors.red[700],
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
                                color: Colors.grey[800],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                    ),
                                    Text(
                                      anime!.score?.toStringAsFixed(1) ?? "",
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${anime!.episodes} episodes",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey[800],
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
