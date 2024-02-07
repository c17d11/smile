import 'package:app/ui/common/navigation_container/src/nav_item.dart';
import 'package:app/ui/common/text_divider.dart';
import 'package:flutter/material.dart';

class DividerItem extends NavItem {
  final String text;
  DividerItem(this.text);

  @override
  Widget build(bool isSelected, void Function()? onPressed) {
    return TextDivider(text);
  }

  @override
  // TODO: implement id
  String get id => '';
}
