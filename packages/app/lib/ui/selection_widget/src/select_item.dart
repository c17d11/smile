import 'package:flutter/material.dart';

class SelectChip extends StatelessWidget {
  final Color background;
  final Color foreground;
  final String text;
  final Function()? onPressed;
  final bool isPadded;

  const SelectChip({
    this.text = "",
    this.background = Colors.white,
    this.foreground = Colors.black,
    this.isPadded = false,
    this.onPressed,
    super.key,
  });

  SelectChip copyWith({
    String? text,
    Color? background,
    Color? foreground,
    Function()? onPressed,
    bool? isPadded,
  }) {
    return SelectChip(
      text: text ?? this.text,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      onPressed: onPressed ?? this.onPressed,
      isPadded: isPadded ?? this.isPadded,
    );
  }

  Widget buildText() {
    return Text(
      text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        minimumSize: const Size(10, 10),
        foregroundColor: foreground,
        backgroundColor: background,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: isPadded
          ? Padding(padding: const EdgeInsets.all(3), child: buildText())
          : buildText(),
    );
  }
}
