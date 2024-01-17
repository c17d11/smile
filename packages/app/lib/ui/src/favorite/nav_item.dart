import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/favorite/page.dart';
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
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
