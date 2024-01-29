import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/test_page/test_page.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestNavItem extends IconItem {
  @override
  String get label => "Test";

  @override
  Icon get icon => const Icon(Icons.try_sms_star);

  @override
  Icon get selectedIcon => const Icon(Icons.collections_bookmark);

  @override
  Widget buildContent(WidgetRef ref) {
    return const TestPage();
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Test");
  }
}
