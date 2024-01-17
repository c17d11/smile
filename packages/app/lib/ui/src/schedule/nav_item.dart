import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/schedule/page.dart';
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
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, 'schedule-query');
      },
      icon: const Icon(Icons.sort),
    );
  }
}
