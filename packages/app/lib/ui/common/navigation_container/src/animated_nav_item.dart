import 'package:app/ui/navigation_container/src/animated_icon_button.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

class AnimatedNavItem extends StatelessWidget {
  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final bool isSelected;
  final void Function()? onPressed;

  const AnimatedNavItem(
      {required this.label,
      required this.icon,
      required this.selectedIcon,
      required this.isSelected,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedIconButton(
            icon: icon,
            selectedIcon: selectedIcon,
            isSelected: isSelected,
            onPressed: onPressed,
          ),
          const SizedBox(height: 5),
          Text(label, maxLines: 1, style: AppStyle.menu),
        ],
      ),
    );
  }
}
