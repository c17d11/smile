import 'package:app/ui/common/animated_nav_item.dart';
import 'package:app/ui/common/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IconItem extends NavItem {
  String get label;
  Icon get icon;
  Icon get selectedIcon;

  Widget buildContent(WidgetRef ref);

  Widget buildAppBarTitle();

  Widget? buildFab(BuildContext context, WidgetRef ref);

  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref);

  @override
  Widget build(bool isSelected, void Function()? onPressed) => AnimatedNavItem(
      label: label,
      icon: icon,
      selectedIcon: selectedIcon,
      isSelected: isSelected,
      onPressed: onPressed);

  @override
  String get id => label;

  @override
  bool operator ==(Object other) => other is IconItem && other.label == label;

  @override
  int get hashCode => label.hashCode;
}
