import 'package:app/object/anime_query.dart';
import 'package:app/object/producer.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/ui/routes/home/pages/home.dart';
import 'package:app/ui/routes/home/pages/producer/popup.dart';
import 'package:app/ui/state/anime_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

class ProducerPortrait extends ConsumerWidget {
  final Producer? producer;
  final String responseId;
  final ProducerQuery refQuery;
  const ProducerPortrait(
    this.producer, {
    required this.responseId,
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
    return producer == null
        ? buildNull()
        : GestureDetector(
            onTap: () => showProducerDetailsPopUp(context, producer!),
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: GridTile(
                footer: GridTileBar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  title: Text(
                    producer!.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: _foregroundSecondary,
                    ),
                  ),
                  subtitle: Text(
                    "${producer!.count} animes",
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w800,
                      color: _foregroundThird,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/coffee.webp',
                      image: producer!.imageUrl ?? '',
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      height: double.infinity,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Text(producer!.imageUrl ?? ""),
                      placeholderErrorBuilder: (context, error, stackTrace) =>
                          Text(producer!.imageUrl ?? ""),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await ref.read(animeQueryPod.notifier).set(
                                      AnimeQuery()
                                        ..producers = [producer!.toJikan()]);
                                  ref.read(pageGroupPod.notifier).state =
                                      AnimeGroup();
                                  ref.read(pageIndexPod.notifier).state = 0;
                                },
                                child: Icon(
                                  Icons.search,
                                  size: 24,
                                  color: _foreground,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
