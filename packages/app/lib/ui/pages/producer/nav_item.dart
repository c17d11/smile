import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/pages/producer/page.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProducersNavItem extends IconItem {
  @override
  String get label => "Producers";

  @override
  Icon get icon => const Icon(Icons.business_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.business);

  @override
  Widget buildContent(WidgetRef ref) {
    return ProducerListPage(page: this);
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Producers");
  }
}
