import 'package:app/ui/selection_widget/src/scroll_select.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

class YearSelect extends StatefulWidget {
  final String title;
  final int? initMinValue;
  final int? initMaxValue;
  final Function(int?) onMinChanged;
  final Function(int?) onMaxChanged;

  const YearSelect({
    required this.title,
    this.initMinValue,
    this.initMaxValue,
    required this.onMinChanged,
    required this.onMaxChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _YearSelectState();
}

class _YearSelectState extends State<YearSelect> {
  int? minYear;
  int? maxYear;

  @override
  void initState() {
    super.initState();
    minYear = widget.initMinValue;
    maxYear = widget.initMaxValue;
  }

  bool isValueSet() => minYear != null || maxYear != null;

  void clearSelection() {
    setState(() {
      minYear = null;
      maxYear = null;
    });
    widget.onMinChanged(minYear);
    widget.onMaxChanged(maxYear);
  }

  Widget buildMenuRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextHeadline(widget.title.toUpperCase()),
        ],
      ),
    );
  }

  Widget buildContentRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 20,
                  runSpacing: 5,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TextSubtitle("FROM:"),
                        const SizedBox(width: 10),
                        ScrollSelect(
                          title: "Min Year",
                          value: minYear ?? maxYear ?? 2023,
                          isSet: minYear != null,
                          minValue: 0,
                          maxValue: maxYear ?? 2023,
                          onSelect: (min) {
                            setState(() => minYear = min);
                            widget.onMinChanged(min);
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TextSubtitle("TO:"),
                        const SizedBox(width: 10),
                        ScrollSelect(
                          title: "Max Year",
                          value: maxYear ?? 2023,
                          isSet: maxYear != null,
                          minValue: minYear ?? 0,
                          maxValue: 2023,
                          onSelect: (max) {
                            setState(() => maxYear = max);
                            widget.onMaxChanged(max);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          ResetIcon(onPressed: isValueSet() ? clearSelection : null),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenuRow(),
          buildContentRow(),
        ],
      ),
    );
  }
}
