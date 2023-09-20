import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingleSelect extends StatefulWidget {
  final List<String> stuff;
  final String title;
  final Function(int index)? onChanged;
  final String? initialValue;
  final bool doShowReset;

  const SingleSelect(this.stuff, this.title,
      {super.key, this.onChanged, this.initialValue, this.doShowReset = true});

  @override
  State<SingleSelect> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect> {
  int _selected = -1;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      _selected = widget.stuff.indexWhere((e) => e == widget.initialValue);
    }
  }

  Widget buildItem(MapEntry<int, String> e) {
    Color foreground = Colors.white;

    void onPressed() {
      setState(() {
        _selected = e.key;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(e.key);
      }
    }

    if (e.key == _selected) {
      return PaddedSelectItem(
          e.value, Colors.green[400]!, foreground, onPressed);
    } else {
      return SelectItem(e.value, Colors.grey[400]!, foreground, onPressed);
    }
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 5,
                    spacing: 5,
                    direction: Axis.horizontal,
                    children: widget.stuff
                        .asMap()
                        .entries
                        .map((e) => buildItem(e))
                        .toList(),
                  ),
                ),
              ),
              if (_selected != -1) ...[
                IconButton(
                  disabledColor: Colors.grey[400],
                  icon: const Icon(Icons.clear),
                  color: Colors.red[400],
                  onPressed: _selected == -1
                      ? null
                      : () {
                          setState(() {
                            _selected = -1;
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged!(-1);
                          }
                        },
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

class FutureDialog {
  final String title;
  BuildContext context;
  final Future<List<String>> future;
  final void Function(List<String> selected, List<String> unselected) callback;

  List<String> options = [];
  List<String> optionsFiltered = [];
  List<String> optionsSelected;
  List<String> optionsUnselected;
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
                .where((e) => e.toLowerCase().contains(s.toLowerCase()))
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
              String item = optionsFiltered[index];
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
                title: Text(item),
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
            content: FutureBuilder<List<String>>(
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

class MultiSelect extends ConsumerStatefulWidget {
  final Future<List<String>> Function() loadOptions;
  final bool tristate;
  final String title;
  final ValueChanged<List<String>>? onChanged;
  final ValueChanged<List<String>>? onChangedExclude;
  final List<String>? initialSelected;
  final List<String>? initialUnselected;

  const MultiSelect(
      {required this.loadOptions,
      this.tristate = false,
      this.title = "",
      this.onChanged,
      this.onChangedExclude,
      this.initialSelected,
      this.initialUnselected,
      super.key});

  @override
  ConsumerState<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends ConsumerState<MultiSelect> {
  late List<String> _selectedItems;
  late List<String> _unselectedItems;

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
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedItems);
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
                                  .map((e) => SelectItem(
                                        e,
                                        Colors.green[400]!,
                                        Colors.white,
                                        () {
                                          setState(() {
                                            _selectedItems.remove(e);
                                          });
                                          if (widget.onChanged != null) {
                                            widget.onChanged!(_selectedItems);
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
                                  .map((e) => SelectItem(
                                        e,
                                        Colors.red[400]!,
                                        Colors.white,
                                        () {
                                          setState(() {
                                            _unselectedItems.remove(e);
                                          });
                                          if (widget.onChanged != null) {
                                            widget.onChanged!(_unselectedItems);
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
                        if (widget.onChanged != null) {
                          widget.onChanged!([]);
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

class PaddedSelectItem extends SelectItem {
  const PaddedSelectItem(
      super.text, super.background, super.foreground, super.onPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        minimumSize: const Size(10, 10),
        foregroundColor: foreground,
        backgroundColor: background,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          text.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class SelectItem extends StatelessWidget {
  final Color background;
  final Color foreground;
  final String text;
  final Function() onPressed;

  const SelectItem(this.text, this.background, this.foreground, this.onPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        minimumSize: const Size(10, 10),
        foregroundColor: foreground,
        backgroundColor: background,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }
}

class TristateChip extends StatelessWidget {
  bool? enabled;
  String text;
  Color? colorEnabled;
  Color? colorDisabled;
  Color? colorDefault;
  Color? colorTextEnabled;
  Color? colorTextDisabled;
  Color? colorTextDefault;
  Function() onPressed;

  TristateChip(this.enabled, this.text, this.onPressed,
      {this.colorDefault, this.colorDisabled, this.colorEnabled});

  Color getColor() {
    if (enabled == null) {
      return (colorDefault ?? Colors.teal[100])!;
    }
    if (enabled!) {
      return (colorEnabled ?? Colors.green[100])!;
    } else {
      return (colorDisabled ?? Colors.red[100])!;
    }
  }

  Color getTextColor(bool? b) {
    if (b == null) {
      return (colorTextDefault ?? Colors.white);
    }
    if (b) {
      return (colorTextEnabled ?? Colors.white);
    } else {
      return (colorTextDisabled ?? Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 20, minWidth: 20, maxWidth: 200, maxHeight: 100),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          minimumSize: Size(10, 10),
          foregroundColor: Colors.white,
          backgroundColor: getColor(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all((enabled ?? false) ? 5 : 0),
          child: Text(
            text.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: getTextColor(enabled),
            ),
          ),
        ),
      ),
    );
  }
}
