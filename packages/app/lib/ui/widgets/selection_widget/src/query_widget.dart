import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

class QueryWidget extends StatelessWidget {
  final String? initialValue;
  final Function? onChanged;

  const QueryWidget({this.initialValue, this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: TextHeadline('Search'.toUpperCase()),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: CustomTextField(
                hint: "Search anime title...",
                initialValue: initialValue,
                onChanged: onChanged,
              )),
        ],
      ),
    );
  }
}
