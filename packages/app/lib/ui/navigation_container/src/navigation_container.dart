import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/navigation_container/src/nav_bar.dart';
import 'package:app/ui/navigation_container/src/nav_item.dart';
import 'package:flutter/material.dart';

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
      color: Colors.grey[200],
      child: isWideScreen
          ? Row(
              children: [
                NavBarPortrait(
                    items: portraitItems,
                    onSelected: (NavItem e) => {if (e is IconItem) onClick(e)},
                    selectedItem: startItem),
                Expanded(child: content),
              ],
            )
          : Column(
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
