import 'package:flutter/material.dart';
import 'package:navigation_container/src/nav_item.dart';

abstract class NavBar extends StatelessWidget {
  final List<NavItem> items;
  final NavItem selectedItem;
  final void Function(NavItem selected) onSelected;

  const NavBar(
      {required this.items,
      required this.selectedItem,
      required this.onSelected,
      super.key});

  List<Widget> buildItems() => items
      .map((e) => e.build(e == selectedItem, () => onSelected(e)))
      .toList();
}

class NavBarLandscape extends NavBar {
  const NavBarLandscape(
      {required super.items,
      required super.selectedItem,
      required super.onSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buildItems(),
      ),
    );
  }
}

class NavBarPortrait extends NavBar {
  const NavBarPortrait(
      {required super.items,
      required super.selectedItem,
      required super.onSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: buildItems(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
      ]),
    );
  }
}
