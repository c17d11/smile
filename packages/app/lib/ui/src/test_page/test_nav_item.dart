import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/test_page/test_page.dart';
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
  Widget buildContent() {
    return const TestPage();
  }

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return Container(color: Colors.orange);
  }
}
