import 'package:app/object/anime.dart';
import 'package:app/object/anime_notes.dart';
import 'package:app/ui/routes/anime_details/page.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

class AnimePortrait extends ConsumerWidget {
  final Anime? anime;
  final String heroId;
  final Function(int animeId) onAnimeUpdate;
  const AnimePortrait(
    this.anime, {
    required this.heroId,
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

  bool hasAnimePersonalInfo(Anime anime) {
    return (anime.notes?.favorite ?? false) ||
        (anime.notes?.tags?.isNotEmpty ?? false) ||
        anime.notes?.score != null ||
        anime.notes?.notes != null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hide = ref.watch(hideTitles);
    return anime == null
        ? buildNull()
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'anime-details',
                arguments: AnimeDetailsArgs(anime!, heroId),
              ).then((value) => onAnimeUpdate(anime!.malId!));
            },
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  side: hasAnimePersonalInfo(anime!)
                      ? const BorderSide(color: Colors.blueGrey)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(5)),
              child: GridTile(
                header: hide
                    ? null
                    : Container(
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
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await ref
                                      .read(databasePod)
                                      .updateAnimeNotes(AnimeNotes()
                                        ..malId = anime!.malId
                                        ..favorite =
                                            !(anime!.notes?.favorite ?? false)
                                        ..score = anime!.notes?.score
                                        ..notes = anime!.notes?.notes
                                        ..tags = anime!.notes?.tags);

                                  onAnimeUpdate(anime!.malId!);
                                },
                                child: Icon(
                                  (anime?.notes?.favorite ?? false)
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
                footer: hide
                    ? null
                    : GridTileBar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(190),
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
                            if (anime!.score != null) ...[
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
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w800,
                                      color: _foregroundSecondary,
                                    ),
                                  ),
                                ],
                              )
                            ],
                            if (anime!.episodes != null) ...[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "${anime!.episodes} episodes",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w800,
                                      color: _foregroundSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                child: Hero(
                  tag: heroId,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/coffee.webp',
                    image: anime!.imageUrl ?? '',
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Text(anime!.imageUrl ?? ""),
                    placeholderErrorBuilder: (context, error, stackTrace) =>
                        Text(anime!.imageUrl ?? ""),
                  ),
                ),
              ),
            ),
          );
  }
}
