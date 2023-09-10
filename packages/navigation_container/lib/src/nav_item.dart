import 'package:flutter/material.dart';

abstract class NavItem {
  String get id;

  Widget build(bool isSelected, void Function()? onPressed);
  @override
  bool operator ==(Object other) => (other is NavItem) && other.id == id;
}
