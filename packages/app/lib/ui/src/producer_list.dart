import 'package:app/object/anime_query.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/nav_items.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:intl/intl.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

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

class ProducerResponseView extends ConsumerWidget {
  final ProducerQuery query;
  final void Function(int?) onLastPage;
  const ProducerResponseView(
      {required this.onLastPage, required this.query, super.key});

  Widget buildLoading() {
    return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget buildNoData() {
    return const SliverFillRemaining(
        child: Center(child: TextHeadline("No data")));
  }

  Widget buildHeader(ProducerResponse? res, BuildContext context) {
    String currentPage = res?.pagination?.currentPage.toString() ?? "";
    String lastPage = res?.pagination?.lastVisiblePage.toString() ?? "";

    onLastPage(res?.pagination?.lastVisiblePage);

    return SliverPinnedHeader(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: TextDivider("Page $currentPage of $lastPage"),
      ),
    );
  }

  Widget buildProducerList(
      int? page, List<Producer> producers, void Function(Producer) onChanged) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: producers.length,
        (context, index) => ProducerPortrait(
          producers[index],
          responseId: page.toString(),
          refQuery: query,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 7 / 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ProducerResponse> res = ref.watch(producerSearchPod(query));

    ref.listen<AsyncValue<ProducerResponse>>(producerSearchPod(query),
        (_, state) => state.showSnackBarOnError(context));

    ProducerResponse? resIntern = res.value;
    List<Producer>? producers = resIntern?.producers;

    if (res.isLoading) {
      return buildLoading();
    }
    if (producers == null || producers.isEmpty) {
      return buildNoData();
    }
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        buildHeader(resIntern, context),
        buildProducerList(
          resIntern?.pagination?.currentPage,
          producers,
          (_) {},
        ),
      ],
    );
  }

  Widget buildData(ProducerResponse? resIntern, BuildContext context) {
    List<Producer>? producers = resIntern?.producers;
    if (producers == null) {
      return buildNoData();
    }
    return MultiSliver(children: [
      buildHeader(resIntern, context),
      buildProducerList(
        resIntern?.pagination?.currentPage,
        producers,
        (_) {},
      ),
    ]);
  }
}

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

Future showProducerDetailsPopUp(BuildContext context, Producer producer) async {
  String s = "";
  if (producer.established != null) {
    String ss =
        producer.established!.substring(0, producer.established!.indexOf('+'));
    DateTime dt = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(ss);
    s = DateFormat('yyyy-MM-dd').format(dt);
  }

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                producer!.imageUrl ?? '',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              "${producer.title}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: _foreground,
              ),
            ),
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 600,
          maxWidth: 300,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                "ESTABLISHED",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundSecondary,
                ),
              ),
              Text(
                s.isNotEmpty ? s : '-',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundThird,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "ANIMES",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundSecondary,
                ),
              ),
              Text(
                producer.count != null ? "${producer.count} animes" : '-',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundThird,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "ABOUT",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundSecondary,
                ),
              ),
              Text(
                producer.about ?? '-',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundThird,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
