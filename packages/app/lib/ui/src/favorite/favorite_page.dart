import 'package:app/ui/src/favorite/favorite_state.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/ui/src/anime_portrait.dart';
import 'package:app/ui/src/favorite/favorite_reponse.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnimeFavoritePage extends ConsumerStatefulWidget {
  const AnimeFavoritePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimeFavoritePageState();
}

class _AnimeFavoritePageState extends ConsumerState<AnimeFavoritePage> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<FavoriteResponse> responses = [];

  void loadNextResponse() {
    FavoriteResponse nextRes = responses.last.next();
    if (lastPage > nextRes.page) {
      setState(() {
        responses.add(nextRes);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    responses.add(FavoriteResponse(
        page: 1, updateLastPage: (int page) => lastPage = page));

    _scroll.addListener(() {
      if (_scroll.offset >= _scroll.position.maxScrollExtent) {
        loadNextResponse();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentTotal <
              MediaQuery.of(context).size.height) {
            loadNextResponse();
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scroll,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[...responses],
        ),
      ),
    );
  }
}
