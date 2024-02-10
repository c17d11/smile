import 'package:app/ui/common/icon_item.dart';
import 'package:app/ui/routes/home/pages/genre/page.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenresNavItem extends IconItem {
  @override
  String get label => "Genres";

  @override
  Icon get icon => const Icon(Icons.label_outline);

  @override
  Icon get selectedIcon => const Icon(Icons.label);

  @override
  Widget buildContent(WidgetRef ref) {
    return const GenreListPage();
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
