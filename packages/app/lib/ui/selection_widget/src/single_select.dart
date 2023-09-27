import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/selection_widget/src/selection_item.dart';
import 'package:app/ui/selection_widget/src/selection_wrapper.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

class SingleSelect<T extends SelectionItem> extends StatefulWidget {
  final String title;
  final List<SelectionWrapper> options;
  final SelectionWrapper? initialValue;
  final Function(SelectionItem? selected)? onChanged;

  SingleSelect(this.title, List<T> options,
      {super.key, this.onChanged, initialValue})
      : options = options.map((e) => SelectionWrapper(e)).toList(),
        initialValue =
            initialValue != null ? SelectionWrapper(initialValue) : null;

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
      widget.onChanged!(e?.item);
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

  Widget buildMenuRow() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextHeadline(widget.title.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget buildContentRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
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
              children: widget.options.map((e) => buildItem(e)).toList(),
            ),
          ),
          if (_selected != null) ...[
            ResetIcon(onPressed: clearSelection),
          ]
        ],
      ),
    );
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
