import 'package:app/ui/common/selection_widget/src/future_tag_dialog.dart';
import 'package:app/ui/common/selection_widget/src/select_item.dart';
import 'package:app/ui/common/selection_widget/src/selection_item.dart';
import 'package:app/ui/common/selection_widget/src/selection_wrapper.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _primary = Colors.teal.shade200;
final Color _primarySecondary = Colors.teal.shade400;

class TagSelect<T extends SelectionItem> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() loadOptions;
  final ValueChanged<List<SelectionItem>>? onChangedInclude;
  final List<SelectionWrapper>? initialSelected;

  Future<List<SelectionWrapper>> load() async {
    List<T> options = await loadOptions();
    return options.map((e) => SelectionWrapper(e)).toList();
  }

  TagSelect(
      {this.title = "",
      required this.loadOptions,
      this.onChangedInclude,
      List<T>? initialSelected,
      super.key})
      : initialSelected =
            initialSelected?.map((e) => SelectionWrapper(e)).toList();

  @override
  State<TagSelect> createState() => _TagSelectState();
}

class _TagSelectState extends State<TagSelect> {
  late List<SelectionWrapper> _selectedItems;

  @override
  void initState() {
    super.initState();

    _selectedItems = widget.initialSelected ?? [];
  }

  void showDialog() {
    void onChanged(WrapperList selected) {
      setState(() {
        _selectedItems = selected;
      });
      if (widget.onChangedInclude != null) {
        widget.onChangedInclude!(_selectedItems.map((e) => e.item).toList());
      }
    }

    final dialog = FutureTagDialog(
        widget.title, context, _selectedItems, widget.load(), onChanged);

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
                    _selectedItems,
                    SelectedChip(),
                    widget.onChangedInclude,
                  ),
                  const SizedBox(height: 5),
                ],
              ],
            ),
          ),
          if (_selectedItems.isNotEmpty) ...[
            buildReset(),
          ],
        ],
      ),
    );
  }

  Widget buildSelectedItems(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 5),
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 5,
          spacing: 5,
          children: items
              .map((e) => template.copyWith(
                    text: e.item.displayName,
                    onClear: () => onPressed(e),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget buildReset() {
    void onPressed() {
      setState(() {
        _selectedItems = [];
      });
      if (widget.onChangedInclude != null) {
        widget.onChangedInclude!([]);
      }
    }

    return ResetIcon(onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _background,
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
