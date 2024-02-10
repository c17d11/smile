import 'package:app/object/bool_text_item.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/object/bool_item.dart';
import 'package:app/object/tag.dart';
import 'package:app/ui/common/multiple_select.dart';
import 'package:app/ui/common/single_select.dart';
import 'package:app/ui/common/text_divider.dart';
import 'package:app/ui/state/schedule_query.dart';
import 'package:app/ui/state/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleQueryPage extends ConsumerStatefulWidget {
  const ScheduleQueryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduleQueryPageState();
}

class _ScheduleQueryPageState extends ConsumerState<ScheduleQueryPage> {
  Future<List<Tag>> loadTags() async {
    await ref.read(tagPod.notifier).get();
    return ref.read(tagPod).value ?? [];
  }

  Widget buildSfwWidget(ScheduleQuery localQuery) {
    return SingleSelect(
      'Sfw',
      [BoolItem(true), BoolItem(false)],
      onChanged: (item) {
        localQuery.sfw = (item != null) ? (item as BoolItem).value : null;
      },
      initialValue: (localQuery.sfw != null) ? BoolItem(localQuery.sfw!) : null,
    );
  }

  Widget buildIsForKidsWidget(ScheduleQuery localQuery) {
    return SingleSelect(
      'Is For Kids',
      [BoolItem(true), BoolItem(false)],
      onChanged: (item) {
        localQuery.isForKids = (item != null) ? (item as BoolItem).value : null;
      },
      initialValue: (localQuery.isForKids != null)
          ? BoolItem(localQuery.isForKids!)
          : null,
    );
  }

  Widget buildIsApprovedWidget(ScheduleQuery localQuery) {
    return SingleSelect(
      'Is Approved',
      [BoolItem(true), BoolItem(false)],
      onChanged: (item) {
        localQuery.isApproved =
            (item != null) ? (item as BoolItem).value : null;
      },
      initialValue: (localQuery.isApproved != null)
          ? BoolItem(localQuery.isApproved!)
          : null,
    );
  }

  Widget buildFavoriteWidget(ScheduleQuery localQuery) {
    var itemTrue = BoolItem(true);
    // var itemFalse = BoolItem(false);

    return SingleSelect(
      'only favorites',
      [itemTrue],
      onChanged: (item) {
        localQuery.appFilter.showOnlyFavorites =
            (item != null) ? (item as BoolItem).value : false;
      },
      initialValue: localQuery.appFilter.showOnlyFavorites ? itemTrue : null,
    );
  }

  Widget buildTagWidget(ScheduleQuery localQuery) {
    return MultiSelect<Tag>(
        title: 'only these tags',
        loadOptions: loadTags,
        initialSelected: localQuery.appFilter.showOnlyTags,
        onChangedInclude: (items) => localQuery.appFilter.showOnlyTags =
            items.map((e) => e as Tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.read(scheduleQueryPod);
    ScheduleQuery localQuery = ScheduleQuery.from(query);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref
              .read(scheduleQueryPod.notifier)
              .set(localQuery)
              .then((value) => Navigator.pop(context));
        },
        label: const Text('Search'),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const TextDivider("API QUERY"),
                    buildSfwWidget(localQuery),
                    const SizedBox(height: 10),
                    buildIsForKidsWidget(localQuery),
                    const SizedBox(height: 10),
                    buildIsApprovedWidget(localQuery),
                    const TextDivider("APP FILTER"),
                    buildFavoriteWidget(localQuery),
                    buildTagWidget(localQuery),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
