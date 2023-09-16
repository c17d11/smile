import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  final void Function()? onPressed;
  final Icon icon;
  final Icon selectedIcon;
  final bool isSelected;

  const AnimatedIconButton(
      {required this.icon,
      required this.selectedIcon,
      required this.isSelected,
      required this.onPressed,
      super.key});

  @override
  State<StatefulWidget> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: IconButton(
        key: ValueKey<bool>(widget.isSelected),
        onPressed: widget.onPressed,
        style: IconButton.styleFrom(
          backgroundColor: widget.isSelected ? Colors.grey[300] : null,
        ),
        icon: widget.icon,
        selectedIcon: widget.selectedIcon,
        isSelected: widget.isSelected,
      ),
    );
  }
}
