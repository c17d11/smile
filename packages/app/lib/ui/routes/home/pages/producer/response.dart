import 'package:app/controller/state.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/ui/common/text_divider.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
import 'package:app/ui/routes/home/pages/producer/item.dart';
import 'package:app/ui/routes/home/pages/producer/state.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
