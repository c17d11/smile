import 'package:app/ui/common/navigation_container/navigation_container.dart';
import 'package:app/ui/common/navigation_container/src/nav_bar.dart';
import 'package:app/ui/common/navigation_container/src/nav_item.dart';
import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;

class NavigationContainer extends StatelessWidget {
  final NavItem startItem;
  final List<NavItem> landscapeItems;
  final List<NavItem> portraitItems;
  final Widget content;
  final void Function(IconItem selected) onClick;

  const NavigationContainer(
      {required this.startItem,
      required this.landscapeItems,
      required this.portraitItems,
      required this.content,
      required this.onClick,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.aspectRatio > 1;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: isWideScreen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavBarPortrait(
                    items: portraitItems,
                    onSelected: (NavItem e) => {if (e is IconItem) onClick(e)},
                    selectedItem: startItem),
                Expanded(child: content),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: content),
                NavBarLandscape(
                    items: landscapeItems,
                    onSelected: (NavItem e) => {if (e is IconItem) onClick(e)},
                    selectedItem: startItem),
              ],
            ),
    );
  }
}
