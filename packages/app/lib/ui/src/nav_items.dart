import 'package:app/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/favorite/page.dart';
import 'package:app/ui/src/genre_list.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/browse/page.dart';
import 'package:app/ui/src/schedule/page.dart';
import 'package:app/ui/src/collections/page.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/producer_list.dart';
import 'package:app/ui/src/settings_page.dart';
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
    return TextFields("Producers");
  }
}

class GenresNavItem extends IconItem {
  @override
  String get label => "Genres";

  @override
  Icon get icon => const Icon(Icons.label_outline);

  @override
  Icon get selectedIcon => const Icon(Icons.label);

  @override
  Widget buildContent(WidgetRef ref) {
    return GenreListPage();
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Genres");
  }
}
