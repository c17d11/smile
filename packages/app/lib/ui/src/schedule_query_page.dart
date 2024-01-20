import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/sfw_item.dart';
import 'package:app/ui/selection_widget/src/single_select.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleQueryPage extends ConsumerStatefulWidget {
  const ScheduleQueryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduleQueryPageState();
}

class _ScheduleQueryPageState extends ConsumerState<ScheduleQueryPage> {
  Widget buildSfwWidget(ScheduleQueryIntern localQuery) {
    return SingleSelect(
      'Sfw',
      [SfwItem(true), SfwItem(false)],
      onChanged: (item) {
        localQuery.sfw = (item != null) ? (item as SfwItem).sfw : null;
      },
      initialValue: (localQuery.sfw != null) ? SfwItem(localQuery.sfw!) : null,
    );
  }

  Widget buildIsForKidsWidget(ScheduleQueryIntern localQuery) {
    return SingleSelect(
      'Is For Kids',
      [SfwItem(true), SfwItem(false)],
      onChanged: (item) {
        localQuery.isForKids = (item != null) ? (item as SfwItem).sfw : null;
      },
      initialValue: (localQuery.isForKids != null)
          ? SfwItem(localQuery.isForKids!)
          : null,
    );
  }

  Widget buildIsApprovedWidget(ScheduleQueryIntern localQuery) {
    return SingleSelect(
      'Is Approved',
      [SfwItem(true), SfwItem(false)],
      onChanged: (item) {
        localQuery.isApproved = (item != null) ? (item as SfwItem).sfw : null;
      },
      initialValue: (localQuery.isApproved != null)
          ? SfwItem(localQuery.isApproved!)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.read(scheduleQueryPod);
    ScheduleQueryIntern localQuery = ScheduleQueryIntern.from(query);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(scheduleQueryPod.notifier).set(localQuery);
          Navigator.pop(context);
        },
        label: const Text('Search'),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      buildSfwWidget(localQuery),
                      const SizedBox(height: 10),
                      buildIsForKidsWidget(localQuery),
                      const SizedBox(height: 10),
                      buildIsApprovedWidget(localQuery),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
