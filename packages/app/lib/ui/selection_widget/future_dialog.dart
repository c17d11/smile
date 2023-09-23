import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:flutter/material.dart';

class FutureDialog {
  final String title;
  BuildContext context;
  final Future<List<SelectionWrapper>> future;
  final void Function(
          List<SelectionWrapper> selected, List<SelectionWrapper> unselected)
      callback;

  List<SelectionWrapper> options = [];
  List<SelectionWrapper> optionsFiltered = [];
  List<SelectionWrapper> optionsSelected;
  List<SelectionWrapper> optionsUnselected;
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

  Widget wrapDialogBoxConstraints(Widget w) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Container(
          height: 1000,
          width: 400,
          // color: Colors.grey[200],
          child: w,
        ));
  }

  Widget buildTextSearch(StateSetter setState) {
    return TextField(
      style: const TextStyle(fontSize: 14.0),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        hintText: 'Enter a search term',
      ),
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
    return options.isNotEmpty
        ? ListView.builder(
            itemCount: optionsFiltered.length,
            itemBuilder: (BuildContext context, int index) {
              SelectionWrapper item = optionsFiltered[index];
              return ListTile(
                dense: true,
                selected: optionsSelected.contains(item) ||
                    optionsUnselected.contains(item),
                selectedColor:
                    optionsSelected.contains(item) ? Colors.green : Colors.red,
                trailing: optionsSelected.contains(item)
                    ? const Icon(Icons.check)
                    : optionsUnselected.contains(item)
                        ? const Icon(Icons.close)
                        : null,
                title: Text(item.item.displayName),
                onTap: () {
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
                },
              );
            },
          )
        : const Center(child: Text("No items"));
  }

  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            // backgroundColor: Colors.grey[200],
            title: Text(title),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            content: FutureBuilder<List<SelectionWrapper>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  options = snapshot.data!;
                  optionsFiltered = options;
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return wrapDialogBoxConstraints(Column(
                      children: [
                        buildTextSearch(setState),
                        const SizedBox(height: 10),
                        Expanded(
                          child: buildOptionsList(setState),
                        ),
                      ],
                    ));
                  });
                }
                if (snapshot.hasError) {
                  return Text(
                    'There was an error :(',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
                return const Center(child: CircularProgressIndicator());
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
