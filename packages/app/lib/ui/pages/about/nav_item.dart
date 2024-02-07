import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/about/page.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutNavItem extends IconItem {
  @override
  String get label => "About";

  @override
  Icon get icon => const Icon(Icons.info_outline);

  @override
  Icon get selectedIcon => const Icon(Icons.info);

  @override
  Widget buildContent(WidgetRef ref) {
    return const AboutPage();
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("About");
  }
}
