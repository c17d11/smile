import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;

  const TextDivider(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Divider(),
          ),
          if (text != "") ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DefaultTextStyle(
                style: AppStyle.headline,
                child: Text(
                  text.toUpperCase(),
                ),
              ),
            ),
            const Expanded(
              child: Divider(),
            ),
          ]
        ],
      ),
    );
  }
}

class TextActionDivider extends StatelessWidget {
  final String text;
  final Widget tailing;
  final Function() onPressed;

  const TextActionDivider(
    this.text, {
    required this.tailing,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 1,
            child: Divider(),
          ),
          if (text != "") ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DefaultTextStyle(
                style: AppStyle.headline,
                child: Text(
                  text.toUpperCase(),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(onTap: onPressed, child: tailing),
                    ),
                  ],
                )),
          ]
        ],
      ),
    );
  }
}
