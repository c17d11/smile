import 'package:app/ui/common/navigation_container/src/nav_item.dart';
import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;

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
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: buildItems(),
        ),
        VerticalDivider(thickness: 1, width: 1, color: _backgroundSecondary),
      ],
    );
  }
}
