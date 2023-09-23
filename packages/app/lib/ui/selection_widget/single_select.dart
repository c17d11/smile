import 'package:app/ui/selection_widget/select_item.dart';
import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:flutter/material.dart';

class SingleSelect extends StatefulWidget {
  final String title;
  final List<SelectionWrapper> options;
  final SelectionWrapper? initialValue;
  final Function(SelectionWrapper? selected)? onChanged;
  final bool doShowReset;

  const SingleSelect(this.options, this.title,
      {super.key, this.onChanged, this.initialValue, this.doShowReset = true});

  @override
  State<SingleSelect> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect> {
  SelectionWrapper? _selected;
  SelectChip selectedTemplate = SelectChip(
      background: Colors.green[400]!, foreground: Colors.white, isPadded: true);
  SelectChip unselectedTemplate =
      SelectChip(background: Colors.grey[400]!, foreground: Colors.white);

  void callWidgetOnChanged(SelectionWrapper? e) {
    if (widget.onChanged != null) {
      widget.onChanged!(e);
    }
  }

  Function() createChipOnPressed(SelectionWrapper e) {
    return () {
      setState(() {
        _selected = e;
      });
      callWidgetOnChanged(e);
    };
  }

  void clearSelection() {
    setState(() {
      _selected = null;
    });
    callWidgetOnChanged(null);
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      int index = widget.options.indexWhere((e) {
        return e == widget.initialValue!;
      });
      if (index != -1) {
        _selected = widget.options[index];
      }
    }
  }

  Widget buildItem(SelectionWrapper e) {
    return e == _selected
        ? selectedTemplate.copyWith(
            text: e.item.displayName,
            onPressed: createChipOnPressed(e),
          )
        : unselectedTemplate.copyWith(
            text: e.item.displayName,
            onPressed: createChipOnPressed(e),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 5,
                      spacing: 5,
                      direction: Axis.horizontal,
                      children:
                          widget.options.map((e) => buildItem(e)).toList(),
                    ),
                  ),
                  if (_selected != null) ...[
                    IconButton(
                      disabledColor: Colors.grey[400],
                      icon: const Icon(Icons.clear),
                      color: Colors.red[400],
                      onPressed: clearSelection,
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
