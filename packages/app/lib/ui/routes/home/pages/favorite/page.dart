import 'package:app/ui/routes/home/pages/favorite/reponse.dart';
import 'package:app/ui/routes/home/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pageIndexPod);

    return const FavoriteList();
  }
}

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<FavoriteResponse> pages = [];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);

    pages.add(FavoriteResponse(
        heroId: pages.length,
        page: 1,
        updateLastPage: (int page) => lastPage = page));
  }

  void _onScroll() {
    // at bottom
    if (_scroll.offset >= _scroll.position.maxScrollExtent) loadNextPage();
  }

  void loadNextPage() {
    FavoriteResponse nextRes = pages.last.next();
    if (lastPage > nextRes.page) {
      setState(() {
        pages.add(nextRes);
      });
    }
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
            loadNextPage();
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
