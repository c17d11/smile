import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/browse/page.dart';
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
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, 'anime-query', arguments: this);
      },
      icon: const Icon(Icons.sort),
    );
  }
}
