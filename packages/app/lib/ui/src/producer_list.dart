import 'package:app/controller/src/controller/producer_search_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/producer_response_intern.dart';
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
    ProducerQueryIntern query = ref.watch(producerQueryPod(page));

    return Scaffold(
        body: ProducerList(
      page: page,
      initQuery: query,
      onNextPageQuery: (query) => ProducerQueryIntern.nextPage(query),
      onLastQuery: (query) => null,
      key: UniqueKey(),
    ));
  }
}

class ProducerList extends StatefulWidget {
  final IconItem page;
  final ProducerQueryIntern initQuery;
  final Function(ProducerQueryIntern) onNextPageQuery;
  final Function(ProducerQueryIntern) onLastQuery;

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
    ProducerQueryIntern lastQuery = ProducerQueryIntern.from(pages.last.query);
    ProducerQueryIntern newQuery = widget.onNextPageQuery(lastQuery);

    if (newQuery.page! <= lastPage) {
      setState(() {
        pages.add(ProducerResponseView(
          onLastPage: onLastPage,
          query: newQuery,
        ));
      });
    } else {
      ProducerQueryIntern? newQuery = widget.onLastQuery(lastQuery);
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
        return false;
      },
      child: CustomScrollView(
        controller: _scroll,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          ...pages,
        ],
      ),
    );
  }
}

class ProducerResponseView extends ConsumerWidget {
  final ProducerQueryIntern query;
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

  Widget buildHeader(ProducerResponseIntern? res, BuildContext context) {
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

  Widget buildProducerList(int? page, List<ProducerIntern> producers,
      void Function(ProducerIntern) onChanged) {
    return
        // SliverPadding(
        //   padding: const EdgeInsets.all(10),
        //   sliver: SliverList.separated(
        //     itemCount: producers.length,
        //     itemBuilder: (context, index) => ProducerPortrait(
        //       producers[index],
        //       responseId: page.toString(),
        //       onChange: onChanged,
        //       refQuery: query,
        //     ),
        //     separatorBuilder: (context, index) => const SizedBox(height: 10),
        //   ),
        // );

        SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: producers.length,
        (context, index) => ProducerPortrait(
          producers[index],
          responseId: page.toString(),
          onChange: onChanged,
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
    AsyncValue<ProducerResponseIntern> res =
        ref.watch(producerSearchPod(query));

    ref.listen<AsyncValue<ProducerResponseIntern>>(producerSearchPod(query),
        (_, state) => state.showSnackBarOnError(context));

    // onChange(value) =>
    //     ref.read(animeSearchControllerPod(query).notifier).update(value);

    ProducerResponseIntern? resIntern = res.value;
    List<ProducerIntern>? animes = resIntern?.data;

    if (res.isLoading) {
      return buildLoading();
    }
    if (animes == null) {
      return buildNoData();
    }
    return MultiSliver(
      pushPinnedChildren: true,
      children: <Widget>[
        buildHeader(resIntern, context),
        buildProducerList(
          resIntern?.pagination?.currentPage,
          animes,
          (_) {},
        ),
      ],
    );
  }
}

class ProducerPortrait extends ConsumerWidget {
  final ProducerIntern? producer;
  final String responseId;
  final void Function(ProducerIntern) onChange;
  final ProducerQueryIntern refQuery;
  const ProducerPortrait(
    this.producer, {
    required this.responseId,
    required this.onChange,
    required this.refQuery,
    super.key,
  });

  Widget buildNull() {
    return
        // ListTile(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        // );

        Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: _backgroundSecondary,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String heroTag = "$responseId-producer-${producer?.malId}";

    String s = "";
    if (producer?.established != null) {
      String ss = producer!.established!
          .substring(0, producer!.established!.indexOf('+'));
      DateTime dt = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(ss);
      s = DateFormat('yyyy-MM-dd').format(dt);
    }

    return producer == null
        ? buildNull()
        : GestureDetector(
            onTap: () => showDialog(
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
                    Text(
                      "${producer?.title}",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                        color: _foreground,
                      ),
                    ),
                  ],
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "ESTABLISHED",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundSecondary,
                        ),
                      ),
                      Text(
                        s.isNotEmpty ? s : '-',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundThird,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "ANIMES",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundSecondary,
                        ),
                      ),
                      Text(
                        producer?.count != null
                            ? "${producer!.count} animes"
                            : '-',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundThird,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "ABOUT",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundSecondary,
                        ),
                      ),
                      Text(
                        "${producer!.about ?? '-'}",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                          color: _foregroundThird,
                        ),
                      ),
                    ],
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
            ),
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
                                  await ref
                                      .read(
                                          animeQueryPod(HomeNavItem()).notifier)
                                      .set(AnimeQueryIntern()
                                        ..producers = [
                                          ProducerIntern.to(producer!)
                                        ]);
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
