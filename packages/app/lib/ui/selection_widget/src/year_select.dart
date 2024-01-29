import 'package:app/ui/selection_widget/src/scroll_select.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                const TextSubtitle("FROM:"),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ScrollSelect(
                    title: "Min Year",
                    value: minYear ?? maxYear ?? DateTime.now().year,
                    isSet: minYear != null,
                    minValue: 0,
                    maxValue: maxYear ?? DateTime.now().year,
                    onSelect: (min) {
                      setState(() => minYear = min);
                      widget.onMinChanged(min);
                    },
                  ),
                ),
              ]),
              TableRow(
                children: [
                  const TextSubtitle("TO:"),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ScrollSelect(
                      title: "Max Year",
                      value: maxYear ?? DateTime.now().year,
                      isSet: maxYear != null,
                      minValue: minYear ?? 0,
                      maxValue: DateTime.now().year,
                      onSelect: (max) {
                        setState(() => maxYear = max);
                        widget.onMaxChanged(max);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          ResetIcon(onPressed: isValueSet() ? clearSelection : null),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMenuRow(),
        buildContentRow(),
      ],
    );
  }
}
