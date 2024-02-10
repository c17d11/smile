import 'package:app/object/producer_query.dart';
import 'package:app/ui/common/icon_item.dart';
import 'package:app/ui/routes/home/pages/producer/nav_item.dart';
import 'package:app/ui/routes/home/pages/producer/response.dart';
import 'package:app/ui/routes/home/pages/producer/state.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Color _foregroundSecondary = Colors.grey[400]!;

class ProducerListPage extends ConsumerWidget {
  final IconItem page;

  const ProducerListPage({required this.page, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProducerQuery query = ref.watch(producerQueryPod(ProducersNavItem()));

    return Scaffold(
      body: ProducerList(
        page: page,
        initQuery: query,
        onNextPageQuery: (query) => ProducerQuery.nextPage(query),
        onLastQuery: (query) => null,
        key: UniqueKey(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  String? text;
                  return AlertDialog(
                    title: Text(
                      "Search producer",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w400,
                        color: _foregroundSecondary,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    content: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: CustomTextField(
                          hint: "Search producer title...",
                          initialValue: null,
                          onChanged: (value) => text = value,
                        )),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Apply'),
                        onPressed: () {
                          Navigator.pop(context, text);
                        },
                      ),
                    ],
                  );
                },
              ).then((value) async {
                await ref
                    .read(producerQueryPod(ProducersNavItem()).notifier)
                    .set(ProducerQuery()..searchTerm = value);
                ref.invalidate(producerQueryPod(ProducersNavItem()));
                ref.invalidate(producerSearchPod(query));
              }),
          child: const Icon(Icons.search)),
    );
  }
}

class ProducerList extends StatefulWidget {
  final IconItem page;
  final ProducerQuery initQuery;
  final Function(ProducerQuery) onNextPageQuery;
  final Function(ProducerQuery) onLastQuery;

  const ProducerList({
    required this.page,
    required this.initQuery,
    required this.onNextPageQuery,
    required this.onLastQuery,
    super.key,
  });

  @override
  State<ProducerList> createState() => _ProducerListState();
}

class _ProducerListState extends State<ProducerList> {
  final _scroll = ScrollController();
  int lastPage = 1;
  int currentPage = 1;

  late List<ProducerResponseView> pages;

  void onLastPage(int? last) {
    if (last != null) {
      lastPage = last;
    }
  }

  void loadNext() {
    ProducerQuery lastQuery = ProducerQuery.from(pages.last.query);
    ProducerQuery newQuery = widget.onNextPageQuery(lastQuery);

    if (newQuery.page! <= lastPage) {
      setState(() {
        pages.add(ProducerResponseView(
          onLastPage: onLastPage,
          query: newQuery,
        ));
      });
    } else {
      ProducerQuery? newQuery = widget.onLastQuery(lastQuery);
      if (newQuery != null) {
        setState(() {
          pages.add(
              ProducerResponseView(onLastPage: onLastPage, query: newQuery));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    pages = [
      ProducerResponseView(onLastPage: onLastPage, query: widget.initQuery)
    ];

    _scroll.addListener(() {
      // at bottom
      if (_scroll.offset >= _scroll.position.maxScrollExtent) {
        loadNext();
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
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentTotal <
            MediaQuery.of(context).size.height) {
          loadNext();
        }
        return true;
      },
      child: CustomScrollView(
        controller: _scroll,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          if (pages.last.query.searchTerm != null) ...[
            SliverAppBar(
                title: Text(
                  "Searching for:    '${pages.last.query.searchTerm?[0] ?? ''}'",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: _foregroundSecondary,
                  ),
                ),
                pinned: true),
          ],
          ...pages,
        ],
      ),
    );
  }
}
