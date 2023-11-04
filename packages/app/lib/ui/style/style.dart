import 'package:flutter/material.dart';

class AppStyle {
  static TextStyle get windowtitle => TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey[800],
      );

  static TextStyle get textfield => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      );

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

  static TextStyle get textOption => TextStyle(
        fontSize: 14,
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  static ButtonStyle get menuButtonActiveStyle => IconButton.styleFrom(
      backgroundColor: Colors.grey[300],
      minimumSize: const Size(50, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      hoverColor: Colors.grey[300]);

  static ButtonStyle get menuButtonInactiveStyle => IconButton.styleFrom(
        minimumSize: const Size(50, 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      );

  static ButtonStyle get actionButtonStyle => IconButton.styleFrom(
        padding: const EdgeInsets.all(10),
      );
}

class TextWindow extends StatelessWidget {
  final String text;
  const TextWindow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.windowtitle);
  }
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

class TextOption extends StatelessWidget {
  final String text;
  const TextOption(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.textOption);
  }
}

class TextFields extends StatelessWidget {
  final String text;
  const TextFields(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppStyle.textfield);
  }
}

class AddIcon extends ActionIcon {
  AddIcon({super.onPressed, super.key})
      : super(
          icon: const Icon(Icons.add),
          color: Colors.grey[600],
          disabledColor: Colors.grey[400]!,
        );
}

class ResetIcon extends ActionIcon {
  ResetIcon({super.onPressed, super.key})
      : super(
          icon: const Icon(Icons.clear),
          color: Colors.red[600],
          disabledColor: Colors.grey[400]!,
        );
}

class InfoIcon extends ActionIcon {
  InfoIcon({super.onPressed, super.key})
      : super(
          icon: const Icon(Icons.question_mark),
          color: Colors.grey[600],
          disabledColor: Colors.grey[600],
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
      iconSize: 24,
      disabledColor: disabledColor,
      style: AppStyle.actionButtonStyle,
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String? initialValue;
  final Function? onChanged;

  const CustomTextField({this.initialValue, this.onChanged, super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  bool showReset = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // they are not the same
      if (_controller.text.isNotEmpty ^ showReset) {
        setState(() {
          showReset = !showReset;
        });
      }
    });

    if (widget.onChanged != null) {
      _controller.addListener(() {
        widget.onChanged!(_controller.text);
      });
    }
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 14.0),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        suffixIcon: showReset
            ? ResetIcon(
                onPressed: () {
                  _controller.text = "";
                },
              )
            : null,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        hintText: "Enter title",
      ),
    );
  }
}
