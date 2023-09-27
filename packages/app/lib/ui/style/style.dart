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
  static TextStyle get menu => TextStyle(
        fontSize: 10,
        color: Colors.grey[700],
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal,
      );

  static ButtonStyle get menuButtonActiveStyle => IconButton.styleFrom(
        backgroundColor: Colors.grey[300],
        minimumSize: const Size(50, 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      );

  static ButtonStyle get menuButtonInactiveStyle => IconButton.styleFrom(
        minimumSize: const Size(50, 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      );

  static ButtonStyle get actionButtonStyle => IconButton.styleFrom(
        padding: const EdgeInsets.all(10),
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
  final Icon icon;
  final Color? disabledColor;
  final Color? color;
  final void Function()? onPressed;

  const ActionIcon({
    required this.icon,
    required this.color,
    required this.disabledColor,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: color,
      disabledColor: disabledColor,
      style: AppStyle.actionButtonStyle,
    );
  }
}
