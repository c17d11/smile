import 'package:app/ui/common/icon_item.dart';
import 'package:app/ui/routes/home/pages/schedule/page.dart';
import 'package:app/ui/state/hide_titles.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleNavItem extends IconItem {
  @override
  String get label => "Schedule";

  @override
  Icon get icon => const Icon(Icons.calendar_month_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.calendar_month);

  @override
  Widget buildContent(WidgetRef ref) {
    return const SchedulePage();
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [
      IconButton(
          onPressed: () {
            ref.read(hideTitles.notifier).state =
                !ref.read(hideTitles.notifier).state;
          },
          icon: const Icon(Icons.text_fields)),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, 'schedule-query');
        },
        icon: const Icon(Icons.sort),
      ),
    ];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Schedule");
  }

  @override
  Widget? buildFab(_, __) => null;
}
