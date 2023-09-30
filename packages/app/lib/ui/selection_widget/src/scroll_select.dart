import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

void _pickValue(
  String title,
  BuildContext context,
  int min,
  int initValue,
  int max,
  Function(int)? onSelect,
) {
  final scroll = FixedExtentScrollController(initialItem: max - initValue);

  showDialog(
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: AlertDialog(
          title: TextWindow(title),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: SizedBox(
                height: 150,
                width: 200,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.green[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                              color: Colors.green[200]!,
                            ),
                          ),
                        ),
                        height: 30,
                      ),
                    ),
                    ListWheelScrollView.useDelegate(
                      itemExtent: 30,
                      renderChildrenOutsideViewport: false,
                      diameterRatio: 1.5,
                      controller: scroll,
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: max - min + 1,
                        builder: (context, index) => TextButton(
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "${max - index}",
                              ),
                            ),
                          ),
                          onPressed: () {
                            scroll.animateToItem(
                              index,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                if (onSelect != null) {
                  onSelect(max - scroll.selectedItem);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

class ScrollSelect extends StatelessWidget {
  final String title;
  final int minValue;
  final int maxValue;
  final int value;
  final bool isSet;
  final Function(int?) onSelect;

  const ScrollSelect({
    required this.title,
    required this.value,
    required this.isSet,
    required this.minValue,
    required this.maxValue,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SelectChip(
      text: "$value",
      background: isSet ? Colors.green[400]! : Colors.grey[400]!,
      foreground: Colors.white,
      onPressed: () => _pickValue(
        title,
        context,
        minValue,
        value,
        maxValue,
        (newValue) => onSelect(newValue),
      ),
      onClear: isSet ? () => onSelect(null) : null,
    );
  }
}
