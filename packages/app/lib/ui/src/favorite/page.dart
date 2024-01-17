import 'package:app/ui/src/favorite/reponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<FavoriteResponse> pages = [];

  void loadNextResponse() {
    FavoriteResponse nextRes = pages.last.next();
    if (lastPage > nextRes.page) {
      setState(() {
        pages.add(nextRes);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    pages.add(FavoriteResponse(
        heroId: pages.length,
        page: 1,
        updateLastPage: (int page) => lastPage = page));

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
          slivers: pages,
        ),
      ),
    );
  }
}
