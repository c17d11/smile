import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/ui/src/test_page/test_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {
  final _scroll = ScrollController();
  List<TestResponse> pages = [];
  int lastPage = 5;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    // at bottom
    if (_scroll.offset >= _scroll.position.maxScrollExtent) loadNextPage();
  }

  void loadNextPage() async {
    AnimeQueryIntern lastQuery = AnimeQueryIntern.from(
        pages.isEmpty ? AnimeQueryIntern() : pages.last.query);
    AnimeQueryIntern newQuery = lastQuery..page = (lastQuery.page ?? 0) + 1;

    if (newQuery.page! <= lastPage) {
      setState(() {
        pages.add(TestResponse(newQuery));
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
