import 'package:app/ui/common/future_dialog.dart';
import 'package:app/ui/common/select_item.dart';
import 'package:app/ui/common/selection_item.dart';
import 'package:app/ui/common/selection_wrapper.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

final Color _foregroundThird = Colors.grey[600]!;

class MultiSelect<T extends SelectionItem> extends StatefulWidget {
  final String title;
  final bool tristate;
  final Future<List<T>> Function() loadOptions;
  final ValueChanged<List<SelectionItem>>? onChangedInclude;
  final ValueChanged<List<SelectionItem>>? onChangedExclude;
  final List<SelectionWrapper>? initialSelected;
  final List<SelectionWrapper>? initialUnselected;

  Future<List<SelectionWrapper>> load() async {
    List<T> options = await loadOptions();
    return options.map((e) => SelectionWrapper(e)).toList();
  }

  MultiSelect(
      {this.title = "",
      this.tristate = false,
      required this.loadOptions,
      this.onChangedInclude,
      this.onChangedExclude,
      List<T>? initialSelected,
      List<T>? initialUnselected,
      super.key})
      : initialSelected =
            initialSelected?.map((e) => SelectionWrapper(e)).toList(),
        initialUnselected =
            initialUnselected?.map((e) => SelectionWrapper(e)).toList();

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late List<SelectionWrapper> _selectedItems;
  late List<SelectionWrapper> _unselectedItems;

  @override
  void initState() {
    super.initState();

    _selectedItems = widget.initialSelected ?? [];
    _unselectedItems = widget.initialUnselected ?? [];
  }

  void showDialog() {
    void onChanged(WrapperList selected, WrapperList unselected) {
      setState(() {
        _selectedItems = selected;
        _unselectedItems = unselected;
      });
      if (widget.onChangedInclude != null) {
        widget.onChangedInclude!(_selectedItems.map((e) => e.item).toList());
      }
      if (widget.onChangedExclude != null) {
        widget.onChangedExclude!(_unselectedItems.map((e) => e.item).toList());
      }
    }

    final dialog = FutureDialog(widget.title, widget.tristate, context,
        _selectedItems, _unselectedItems, widget.load(), onChanged);

    dialog.show();
  }

  Widget buildMenuRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextHeadline(widget.title.toUpperCase()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AddIcon(onPressed: showDialog),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContentRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_selectedItems.isNotEmpty) ...[
                  buildSelectedItems(
                    "",
                    _selectedItems,
                    SelectedChip(),
                    widget.onChangedInclude,
                  ),
                  const SizedBox(height: 5),
                ],
                if (_selectedItems.isNotEmpty &&
                    _unselectedItems.isNotEmpty) ...[
                  const SizedBox(height: 20),
                ],
                if (_unselectedItems.isNotEmpty) ...[
                  buildSelectedItems(
                    "",
                    _unselectedItems,
                    UnselectedChip(),
                    widget.onChangedExclude,
                  ),
                  const SizedBox(height: 5),
                ],
                if (_selectedItems.isNotEmpty ||
                    _unselectedItems.isNotEmpty) ...[
                  const SizedBox(height: 5),
                ],
                if (_selectedItems.isEmpty && _unselectedItems.isEmpty) ...[
                  Text("None selected",
                      style: TextStyle(
                        fontSize: 12,
                        color: _foregroundThird,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                      ))
                ]
              ],
            ),
          ),
          if (_selectedItems.isNotEmpty || _unselectedItems.isNotEmpty) ...[
            buildReset(),
          ],
        ],
      ),
    );
  }

  Widget buildSelectedItems(
    String title,
    WrapperList items,
    SelectChip template,
    void Function(SelectionList l)? callback,
  ) {
    void onPressed(Wrapper e) {
      setState(() {
        items.remove(e);
      });
      if (callback != null) {
        callback(items.map((e) => e.item).toList());
      }
    }

    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 5,
      spacing: 5,
      children: items
          .map((e) => template.copyWith(
                text: e.item.displayName,
                onClear: () => onPressed(e),
              ))
          .toList(),
    );
  }

  Widget buildReset() {
    void onPressed() {
      setState(() {
        _selectedItems = [];
        _unselectedItems = [];
      });
      if (widget.onChangedInclude != null) {
        widget.onChangedInclude!([]);
      }
      if (widget.onChangedExclude != null) {
        widget.onChangedExclude!([]);
      }
    }

    return ResetIcon(onPressed: onPressed);
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
