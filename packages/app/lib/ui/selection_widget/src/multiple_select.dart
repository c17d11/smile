import 'package:app/ui/selection_widget/src/future_dialog.dart';
import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/selection_widget/src/selection_item.dart';
import 'package:app/ui/selection_widget/src/selection_wrapper.dart';
import 'package:flutter/material.dart';

class MultiSelect<T extends SelectionItem> extends StatefulWidget {
  final Future<List<T>> Function() loadOptions;
  final bool tristate;
  final String title;
  final ValueChanged<List<SelectionItem>>? onChangedInclude;
  final ValueChanged<List<SelectionItem>>? onChangedExclude;
  final List<SelectionWrapper>? initialSelected;
  final List<SelectionWrapper>? initialUnselected;

  Future<List<SelectionWrapper>> load() async {
    List<T> options = await loadOptions();
    return options.map((e) => SelectionWrapper(e)).toList();
  }

  MultiSelect(
      {required this.loadOptions,
      this.tristate = false,
      this.title = "",
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
    final dialog = FutureDialog(
        widget.title,
        widget.tristate,
        context,
        _selectedItems,
        _unselectedItems,
        widget.load(), (selected, unselected) {
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
    });

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.grey[800],
                      onPressed: showDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_selectedItems.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Include".toUpperCase(),
                              style: TextStyle(
                                fontSize: 9.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 5,
                              spacing: 5,
                              children: _selectedItems
                                  .map((e) => SelectChip(
                                        text: e.item.displayName,
                                        background: Colors.green[400]!,
                                        foreground: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            _selectedItems.remove(e);
                                          });
                                          if (widget.onChangedInclude != null) {
                                            widget.onChangedInclude!(
                                                _selectedItems
                                                    .map((e) => e.item)
                                                    .toList());
                                          }
                                        },
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      )
                    ],
                    if (_unselectedItems.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exclude".toUpperCase(),
                              style: TextStyle(
                                fontSize: 9.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 5,
                              spacing: 5,
                              children: _unselectedItems
                                  .map((e) => SelectChip(
                                        text: e.item.displayName,
                                        background: Colors.red[400]!,
                                        foreground: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            _unselectedItems.remove(e);
                                          });
                                          if (widget.onChangedInclude != null) {
                                            widget.onChangedInclude!(
                                                _unselectedItems
                                                    .map((e) => e.item)
                                                    .toList());
                                          }
                                        },
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_selectedItems.isNotEmpty ||
                      _unselectedItems.isNotEmpty) ...[
                    IconButton(
                      onPressed: () {
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
                      },
                      icon: const Icon(Icons.clear),
                      color: Colors.red[400],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool newMethod() {
    return widget.tristate &&
        (_selectedItems.isNotEmpty || _unselectedItems.isNotEmpty);
  }
}
