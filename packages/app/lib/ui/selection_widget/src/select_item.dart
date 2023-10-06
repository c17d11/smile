import 'package:flutter/material.dart';

class SelectedChip extends SelectChip {
  SelectedChip({super.text, super.onPressed, super.key})
      : super(
          background: Colors.green[400]!,
        );
}

class UnselectedChip extends SelectChip {
  UnselectedChip({super.text, super.onPressed, super.key})
      : super(
          background: Colors.red[600]!,
        );
}

class SelectChip extends StatelessWidget {
  final Color background;
  final Color foreground;
  final String text;
  final Function()? onPressed;
  final Function()? onClear;
  final bool isPadded;
  final double fontSize;

  const SelectChip({
    this.text = "",
    this.background = Colors.white,
    this.foreground = Colors.black,
    this.isPadded = false,
    this.onPressed,
    this.onClear,
    this.fontSize = 10.0,
    super.key,
  });

  SelectChip copyWith({
    String? text,
    Color? background,
    Color? foreground,
    Function()? onPressed,
    Function()? onClear,
    bool? isPadded,
  }) {
    return SelectChip(
      text: text ?? this.text,
      background: background ?? this.background,
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
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              disabledForegroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: getTextBorder(),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              text.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(
              height: 20,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
            ),
            IconButton(
              onPressed: onClear,
              icon: FittedBox(
                child: Icon(Icons.clear, color: Colors.red[600]!),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: background),
        borderRadius: BorderRadius.circular(100),
      ),
      child: buildText(context),
    );
  }
}
