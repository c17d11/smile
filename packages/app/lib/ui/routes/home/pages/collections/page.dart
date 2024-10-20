import 'package:app/object/collection_query.dart';
import 'package:app/ui/routes/home/pages/collections/response.dart';
import 'package:app/ui/routes/home/pages/collections/state.dart';
import 'package:app/ui/routes/home/pages/home.dart';
import 'package:app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ret = ref.watch(collectionNames);
    ref.watch(pageIndexPod);

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
            initQuery: CollectionQuery()..collectionName = tags[0],
            onNextPageQuery: (query) =>
                query.copyWith(page: (query.page ?? 1) + 1),
            onLastQuery: (query) {
              int currentIndex =
                  tags.indexWhere((element) => element == query.collectionName);
              if (currentIndex + 1 == tags.length) {
                return null;
              }
              return query.copyWith(
                  collectionName: tags[currentIndex + 1], page: null);
            },
            key: UniqueKey(),
          );
        });
  }
}

class CollectionList extends StatefulWidget {
  final CollectionQuery initQuery;
  final Function(CollectionQuery) onNextPageQuery;
  final Function(CollectionQuery) onLastQuery;

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

    CollectionQuery newQuery = pages.isEmpty
        ? widget.initQuery.copyWith()
        : widget.onNextPageQuery(pages.last.query);
    CollectionQuery? nextQuery = pages.isEmpty
        ? widget.initQuery.copyWith()
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
