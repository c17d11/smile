import 'package:app/ui/common/navigation_container/navigation_container.dart';
import 'package:app/ui/routes/home/pages/favorite/page.dart';
import 'package:app/ui/routes/home/pages/pod.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNavItem extends IconItem {
  @override
  String get label => "Favorite";

  @override
  Icon get icon => const Icon(Icons.favorite_outline);

  @override
  Icon get selectedIcon => const Icon(Icons.favorite);

  @override
  Widget buildContent(WidgetRef ref) {
    return const FavoriteList();
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
    ];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Favorite");
  }
}
