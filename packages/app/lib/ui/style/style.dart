import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

class AppStyle {
  static TextStyle get windowtitle => TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey[800],
      );

  static TextStyle get textfield => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: _foregroundSecondary,
      );

  static TextStyle get headline => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: _foregroundSecondary,
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 9.0,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      );

  static TextStyle get menu => TextStyle(
        fontSize: 10,
        color: _foregroundSecondary,
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
      backgroundColor: _backgroundSecondary,
      minimumSize: const Size(50, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      hoverColor: _backgroundSecondary);

  static ButtonStyle get menuButtonInactiveStyle => IconButton.styleFrom(
        foregroundColor: _foregroundThird,
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
          color: _foregroundSecondary,
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
  final String? customSuffixText;
  final Function(String)? onCustomSuffixPress;

  const CustomTextField(
      {this.initialValue,
      this.onChanged,
      this.customSuffixText,
      this.onCustomSuffixPress,
      super.key});

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
      style: const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        suffixIcon: showReset
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.customSuffixText != null)
                    TextButton(
                        onPressed: () {
                          if (widget.onCustomSuffixPress != null) {
                            widget.onCustomSuffixPress!(_controller.text);
                          }
                        },
                        child: Text(widget.customSuffixText!)),
                  ResetIcon(
                    onPressed: () {
                      _controller.text = "";
                    },
                  )
                ],
              )
            : null,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground, width: 2),
        ),
        hintText: "Enter title",
      ),
    );
  }
}

class ActionTextField extends StatefulWidget {
  final Function? onPressed;

  const ActionTextField({this.onPressed, super.key});

  @override
  State<ActionTextField> createState() => _ActionTextFieldState();
}

class _ActionTextFieldState extends State<ActionTextField> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 14.0),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: AddIcon(
          onPressed: () {
            if (widget.onPressed != null) widget.onPressed!(_controller.text);
          },
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground, width: 2),
        ),
        hintText: "Enter text",
      ),
    );
  }
}
