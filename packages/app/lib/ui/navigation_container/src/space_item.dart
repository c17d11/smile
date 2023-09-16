import 'package:app/ui/navigation_container/src/nav_item.dart';
import 'package:flutter/material.dart';

class SpaceItem extends NavItem {
  @override
  Widget build(bool isSelected, void Function()? onPressed) =>
      const Expanded(child: Spacer());

  @override
  String get id => '';
}
