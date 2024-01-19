import 'dart:math';

import 'package:app/ui/selection_widget/src/selection_wrapper.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _primary = Colors.teal.shade200;
final Color _primarySecondary = Colors.teal.shade400;

class FutureDialog {
  final String title;
  BuildContext context;
  final Future<WrapperList> future;
  final void Function(WrapperList selected, WrapperList unselected) callback;

  WrapperList options = [];
  WrapperList optionsFiltered = [];
  WrapperList optionsSelected;
  WrapperList optionsUnselected;
  bool tristate;

  FutureDialog(
    this.title,
    this.tristate,
    this.context,
    optionsSelected,
    optionsUnselected,
    this.future,
    this.callback,
  )   : optionsSelected = [...optionsSelected],
        optionsUnselected = [...optionsUnselected];

  Widget wrapInBoxConstraints(Widget w) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      child: w,
    );
  }

  Widget buildTextSearch(StateSetter setState) {
    return CustomTextField(
      hint: "Search...",
      onChanged: (s) {
        setState(
          () {
            optionsFiltered = [...options]
                .where((e) =>
                    e.item.displayName.toLowerCase().contains(s.toLowerCase()))
                .toList();
          },
        );
      },
    );
  }

  Widget buildOptionsList(StateSetter setState) {
    void onTap(SelectionWrapper item) {
      setState(
        () {
          if (tristate) {
            if (optionsSelected.contains(item)) {
              optionsSelected.remove(item);
              optionsUnselected.add(item);
            } else if (optionsUnselected.contains(item)) {
              optionsUnselected.remove(item);
            } else {
              optionsSelected.add(item);
            }
          } else {
            if (optionsSelected.contains(item)) {
              optionsSelected.remove(item);
            } else {
              optionsSelected.add(item);
            }
          }
        },
      );
    }

    return options.isNotEmpty
        ? SizedBox(
            height: min(options.length * 50, 400),
            width: 400,
            child: ListView.builder(
              itemCount: optionsFiltered.length,
              itemBuilder: (BuildContext context, int index) {
                SelectionWrapper item = optionsFiltered[index];
                return ListTile(
                  dense: true,
                  selected: optionsSelected.contains(item) ||
                      optionsUnselected.contains(item),
                  selectedColor: optionsSelected.contains(item)
                      ? Colors.green[400]
                      : Colors.red[800],
                  trailing: optionsSelected.contains(item)
                      ? const Icon(Icons.check)
                      : optionsUnselected.contains(item)
                          ? const Icon(Icons.close)
                          : null,
                  title: Text(
                    item.item.displayName,
                    style: AppStyle.textfield,
                  ),
                  onTap: () => onTap(item),
                );
              },
            ),
          )
        : const Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text("No items"),
            ),
          );
  }

  Widget buildData() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return wrapInBoxConstraints(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextSearch(setState),
            const SizedBox(height: 10),
            buildOptionsList(setState)
          ],
        ),
      );
    });
  }

  Widget buildError() {
    return const Center(child: TextHeadline('There was an error :('));
  }

  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: AlertDialog(
            backgroundColor: _background,
            title: Text(title),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            content: FutureBuilder<WrapperList>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  options = snapshot.data!;
                  optionsFiltered = options;
                  return buildData();
                }
                if (snapshot.hasError) {
                  return buildError();
                }
                return buildLoading();
              },
            ),
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
                  callback(optionsSelected, optionsUnselected);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
