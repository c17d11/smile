import 'package:app/object/tag.dart';
import 'package:app/ui/selection_widget/src/selection_wrapper.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _primary = Colors.teal.shade200;
final Color _primarySecondary = Colors.teal.shade400;

class FutureTagDialog {
  final String title;
  BuildContext context;
  final Future<WrapperList> future;
  final void Function(WrapperList selected) callback;

  WrapperList options = [];
  WrapperList optionsSelected;

  FutureTagDialog(
    this.title,
    this.context,
    optionsSelected,
    this.future,
    this.callback,
  ) : optionsSelected = [...optionsSelected];

  Widget wrapInBoxConstraints(Widget w) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: SizedBox(
          height: 1000,
          width: 400,
          child: w,
        ));
  }

  Widget buildTextSearch(StateSetter setState) {
    return ActionTextField(onPressed: (s) {
      setState(() {
        Tag tag = Tag()
          ..name = s
          ..animeCount = 0;
        options.add(SelectionWrapper<Tag>(tag));
      });
    });
  }

  Widget buildOptionsList(StateSetter setState) {
    void onTap(SelectionWrapper item) {
      setState(
        () {
          if (optionsSelected.contains(item)) {
            optionsSelected.remove(item);
          } else {
            optionsSelected.add(item);
          }
        },
      );
    }

    return options.isNotEmpty
        ? ListView.builder(
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              SelectionWrapper item = options[index];
              return ListTile(
                dense: true,
                selected: optionsSelected.contains(item),
                selectedColor: optionsSelected.contains(item)
                    ? Colors.green[400]
                    : Colors.red[800],
                trailing: optionsSelected.contains(item)
                    ? const Icon(Icons.check)
                    : null,
                title: Text(
                  item.item.displayName,
                  style: AppStyle.textfield,
                ),
                onTap: () => onTap(item),
              );
            },
          )
        : const Center(child: Text("No items"));
  }

  Widget buildData() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return wrapInBoxConstraints(
        Column(
          children: [
            buildTextSearch(setState),
            const SizedBox(height: 10),
            Expanded(child: buildOptionsList(setState)),
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
                  callback(optionsSelected);
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
