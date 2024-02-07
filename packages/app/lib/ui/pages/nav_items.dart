import 'package:app/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/pages/favorite/page.dart';
import 'package:app/ui/pages/genre/page.dart';
import 'package:app/ui/pages/home.dart';
import 'package:app/ui/pages/browse/page.dart';
import 'package:app/ui/pages/schedule/page.dart';
import 'package:app/ui/pages/collections/page.dart';
import 'package:app/ui/pages/pod.dart';
import 'package:app/ui/pages/producer/page.dart';
import 'package:app/ui/pages/settings_page.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNavItem extends IconItem {
  @override
  String get label => "Settings";

  @override
  Icon get icon => const Icon(Icons.settings_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.settings);

  @override
  Widget buildContent(WidgetRef ref) {
    return const SettingsPage();
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [];
  }

  @override
  Widget buildAppBarTitle() {
    return TextFields("Settings");
  }
}
