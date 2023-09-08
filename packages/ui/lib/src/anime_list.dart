import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';
import 'package:ui/src/anime_portrait.dart';
import 'pod.dart';

class AnimeList extends ConsumerWidget {
  const AnimeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<AnimeIntern>> animes = ref.watch(animeControllerPod);

    ref.listen<AsyncValue<List<AnimeIntern>>>(
        animeControllerPod, (_, state) => state.showSnackBarOnError(context));

    return Container(
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () =>
                  ref.read(animeControllerPod.notifier).get(AnimeQuery()),
              child: const Text("Load data")),
          Expanded(
            child: GridView.builder(
                itemCount: animes.value?.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: (7 / 10),
                ),
                itemBuilder: (context, index) =>
                    AnimePortrait(animes.value?[index])),
          ),
        ],
      ),
    );
  }
}
