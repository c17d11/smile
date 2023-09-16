import 'package:app/controller/state.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'pod.dart';

class AnimeList extends ConsumerStatefulWidget {
  const AnimeList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimeListState();
}

class _AnimeListState extends ConsumerState<AnimeList> {
  final ScrollController _scrollViewController = ScrollController();
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<AnimeIntern>> animes = ref.watch(animeSearchControllerPod);

    ref.listen<AsyncValue<List<AnimeIntern>>>(animeSearchControllerPod,
        (_, state) => state.showSnackBarOnError(context));

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(microseconds: 200),
          curve: Curves.fastOutSlowIn,
          height: isScrollingDown ? 0 : 40,
          child: AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sort),
              )
            ],
          ),
        ),
        TextButton(
            onPressed: () =>
                ref.read(animeSearchControllerPod.notifier).get(AnimeQuery()),
            child: const Text("Load data")),
        Expanded(
          child: GridView.builder(
              itemCount: animes.value?.length,
              controller: _scrollViewController,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: (7 / 10),
              ),
              itemBuilder: (context, index) =>
                  AnimePortrait(animes.value?[index])),
        ),
      ],
    );
  }
}
