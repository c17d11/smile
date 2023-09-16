import 'package:app/ui/navigation_container/src/animated_nav_item.dart';
import 'package:app/ui/navigation_container/src/nav_item.dart';
import 'package:flutter/material.dart';

abstract class IconItem extends NavItem {
  String get label;
  Icon get icon;
  Icon get selectedIcon;

  Widget buildContent();

  @override
  Widget build(bool isSelected, void Function()? onPressed) => AnimatedNavItem(
      label: label,
      icon: icon,
      selectedIcon: selectedIcon,
      isSelected: isSelected,
      onPressed: onPressed);

  @override
  String get id => label;
}
