import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/ui/src/anime_details.dart';
import 'package:app/ui/src/test_page/test_pod.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestAnime extends ConsumerWidget {
  final IsarAnime? anime;
  final String responseId;
  final Function() onAnimeUpdate;

  const TestAnime(
    this.anime, {
    required this.responseId,
    required this.onAnimeUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String heroTag = "$responseId-anime-${anime?.malId}";

    return anime == null
        ? Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(context).colorScheme.secondary,
          )
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
                  backgroundColor: AppColors.backgroundSecond.withAlpha(190),
                  title: Text(anime!.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.small
                          .copyWith(color: AppColors.foreground)),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.star,
                              size: 14, color: AppColors.foregroundSecond),
                          Text(
                            anime!.score?.toStringAsFixed(1) ?? "",
                            style: AppTextStyle.tiny
                                .copyWith(color: AppColors.foregroundSecond),
                          ),
                        ],
                      ),
                      Text(
                        "${anime!.episodes} episodes",
                        style: AppTextStyle.tiny
                            .copyWith(color: AppColors.foregroundSecond),
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
                                await ref
                                    .read(testAnimeUpdatePod.notifier)
                                    .update(anime!
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
