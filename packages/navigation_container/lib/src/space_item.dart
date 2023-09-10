import 'package:flutter/material.dart';
import 'package:navigation_container/src/nav_item.dart';

class SpaceItem extends NavItem {
  @override
  Widget build(bool isSelected, void Function()? onPressed) =>
      const Expanded(child: Spacer());

  @override
  String get id => '';
}
