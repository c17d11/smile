import 'package:app/ui/selection_widget/future_dialog.dart';
import 'package:app/ui/selection_widget/select_item.dart';
import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiSelect extends ConsumerStatefulWidget {
  final Future<List<SelectionWrapper>> Function() loadOptions;
  final bool tristate;
  final String title;
  final ValueChanged<List<SelectionWrapper>>? onChangedInclude;
  final ValueChanged<List<SelectionWrapper>>? onChangedExclude;
  final List<SelectionWrapper>? initialSelected;
  final List<SelectionWrapper>? initialUnselected;

  const MultiSelect(
      {required this.loadOptions,
      this.tristate = false,
      this.title = "",
      this.onChangedInclude,
      this.onChangedExclude,
      this.initialSelected,
      this.initialUnselected,
      super.key});

  @override
  ConsumerState<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends ConsumerState<MultiSelect> {
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
        widget.loadOptions(), (selected, unselected) {
      setState(() {
        _selectedItems = selected;
        _unselectedItems = unselected;
      });
      if (widget.onChangedInclude != null) {
        widget.onChangedInclude!(_selectedItems);
      }
      if (widget.onChangedExclude != null) {
        widget.onChangedExclude!(_unselectedItems);
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
          Row(
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
                                                _selectedItems);
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
                                                _unselectedItems);
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
