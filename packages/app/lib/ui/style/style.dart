import 'package:flutter/material.dart';

class AppStyle {
  static TextStyle get headline => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 9.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      );
}

class TextHeadline extends StatelessWidget {
  final String text;
  const TextHeadline(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.headline);
  }
}

class TextSubtitle extends StatelessWidget {
  final String text;
  const TextSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.subtitle);
  }
}

class AddIcon extends ActionIcon {
  AddIcon({super.onPressed, super.key})
      : super(
          icon: const Icon(Icons.add),
          color: Colors.grey[800],
          disabledColor: Colors.grey[400]!,
        );
}

class ResetIcon extends ActionIcon {
  ResetIcon({super.onPressed, super.key})
      : super(
          icon: const Icon(Icons.clear),
          color: Colors.red[400],
          disabledColor: Colors.grey[400]!,
        );
}

abstract class ActionIcon extends StatelessWidget {
  final void Function()? onPressed;
  final Icon icon;
  final Color? disabledColor;
  final Color? color;

  const ActionIcon(
      {required this.icon,
      required this.color,
      required this.disabledColor,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: color,
      disabledColor: disabledColor,
    );
  }
}
