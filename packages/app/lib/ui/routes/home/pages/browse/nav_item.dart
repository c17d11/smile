import 'package:app/ui/common/icon_item.dart';
import 'package:app/ui/routes/home/pages/browse/page.dart';
import 'package:app/ui/state/hide_titles.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowseNavItem extends IconItem {
  @override
  String get label => "Browse";

  @override
  Icon get icon => const Icon(Icons.home_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.home);

  @override
  Widget buildContent(WidgetRef ref) {
    return const BrowsePage();
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
          Navigator.pushNamed(context, 'anime-query', arguments: this);
        },
        icon: const Icon(Icons.sort),
      ),
    ];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Browse");
  }

  @override
  Widget? buildFab(_, __) => null;
}
