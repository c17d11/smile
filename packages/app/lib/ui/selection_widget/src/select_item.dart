import 'package:flutter/material.dart';

class SelectedChip extends SelectChip {
  SelectedChip({super.text, super.onPressed, super.key})
      : super(
          foreground: const Color.fromARGB(255, 161, 202, 200),
          foregroundSecondary: Colors.blueGrey,
        );
}

class UnselectedChip extends SelectChip {
  UnselectedChip({super.text, super.onPressed, super.key})
      : super(
          foreground: const Color.fromARGB(255, 199, 100, 146),
          foregroundSecondary: const Color.fromARGB(255, 122, 79, 115),
        );
}

class SelectChip extends StatelessWidget {
  final Color foregroundSecondary;
  final Color foreground;
  final String text;
  final Function()? onPressed;
  final Function()? onClear;
  final bool isPadded;
  final double fontSize;

  const SelectChip({
    this.text = "",
    this.foregroundSecondary = Colors.white,
    this.foreground = Colors.black,
    this.isPadded = false,
    this.onPressed,
    this.onClear,
    this.fontSize = 10.0,
    super.key,
  });

  SelectChip copyWith({
    String? text,
    Color? foregroundSecondary,
    Color? foreground,
    Function()? onPressed,
    Function()? onClear,
    bool? isPadded,
  }) {
    return SelectChip(
      text: text ?? this.text,
      foregroundSecondary: foregroundSecondary ?? this.foregroundSecondary,
      foreground: foreground ?? this.foreground,
      onPressed: onPressed ?? this.onPressed,
      onClear: onClear ?? this.onClear,
      isPadded: isPadded ?? this.isPadded,
    );
  }

  BorderRadius getTextBorder() {
    return (onClear != null)
        ? const BorderRadius.horizontal(left: Radius.circular(100))
        : const BorderRadius.all(Radius.circular(100));
  }

  Widget buildText(BuildContext context) {
    return SizedBox(
      height: 24.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: foreground,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              disabledForegroundColor:
                  foreground, // Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: getTextBorder(),
              ),
            ),
            onPressed: onPressed,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                text.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          if (onClear != null) ...[
            SizedBox(
              height: 20,
              child: VerticalDivider(
                color: foregroundSecondary,
                width: 1,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
            ),
            IconButton(
              onPressed: onClear,
              hoverColor: foregroundSecondary,
              icon: FittedBox(
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              style: IconButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(100),
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isPadded ? 10 : 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: foreground),
          borderRadius: BorderRadius.circular(100),
        ),
        child: buildText(context),
      ),
    );
  }
}
