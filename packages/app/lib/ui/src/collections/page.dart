import 'package:app/controller/src/object/collection_query_intern.dart';
import 'package:app/ui/src/collections/response.dart';
import 'package:app/ui/src/collections/state.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ret = ref.watch(collectionNames);

    return ret.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text("Error", style: AppTextStyle.small)),
        data: (res) {
          List<String> tags = ret.value!;
          if (tags.isEmpty) {
            return Center(child: Text("No data", style: AppTextStyle.small));
          }

          return CollectionList(
            initQuery: CollectionQueryIntern()..collectionName = tags[0],
            onNextPageQuery: (query) =>
                CollectionQueryIntern.copy(query..page = (query.page ?? 1) + 1),
            onLastQuery: (query) {
              int currentIndex =
                  tags.indexWhere((element) => element == query.collectionName);
              if (currentIndex + 1 == tags.length) {
                return null;
              }
              return CollectionQueryIntern.copy(query
                ..collectionName = tags[currentIndex + 1]
                ..page = null);
            },
            key: UniqueKey(),
          );
        });
  }
}

class CollectionList extends StatefulWidget {
  final CollectionQueryIntern initQuery;
  final Function(CollectionQueryIntern) onNextPageQuery;
  final Function(CollectionQueryIntern) onLastQuery;

  const CollectionList({
    required this.initQuery,
    required this.onNextPageQuery,
    required this.onLastQuery,
    super.key,
  });

  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<CollectionResponse> pages = [];
  bool readyForNextPage = true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    // at bottom
    if (_scroll.offset >= _scroll.position.maxScrollExtent) loadNextPage();
  }

  void loadNextPage() {
    if (!readyForNextPage) return;
    readyForNextPage = false;

    CollectionQueryIntern newQuery = pages.isEmpty
        ? CollectionQueryIntern.copy(widget.initQuery)
        : widget.onNextPageQuery(pages.last.query);
    CollectionQueryIntern? nextQuery = pages.isEmpty
        ? CollectionQueryIntern.copy(widget.initQuery)
        : widget.onLastQuery(pages.last.query);

    CollectionResponse? res;
    if ((newQuery.page ?? 1) <= lastPage) {
      res = CollectionResponse(
          heroId: pages.length,
          updateLastPage: onLastPage,
          query: newQuery,
          onDone: () => readyForNextPage = true);
    } else if (nextQuery != null) {
      res = CollectionResponse(
          heroId: pages.length,
          updateLastPage: onLastPage,
          query: nextQuery,
          onDone: () => readyForNextPage = true);
    }

    if (res != null) {
      setState(() {
        pages.add(res!);
      });
    }
  }

  void onLastPage(int? last) {
    if (last != null) {
      lastPage = last;
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
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
    );
  }
}
