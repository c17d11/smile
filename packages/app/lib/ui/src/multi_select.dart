import 'package:flutter/material.dart';

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
    return
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //   child:
        Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 24),
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
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
                // Visibility(
                //   visible: _selected != -1,
                // child:
                if (widget.doShowReset) ...[
                  IconButton(
                    disabledColor: Colors.grey[400],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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
                // ),
              ],
              // ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  List<String> stuff;
  bool tristate;
  String title;
  final ValueChanged<List<String>>? onChanged;
  final ValueChanged<List<String>>? onChangedExclude;
  final List<String>? initialSelected;
  final List<String>? initialUnselected;

  MultiSelect(this.stuff,
      {this.tristate = false,
      this.title = "",
      this.onChanged,
      this.onChangedExclude,
      this.initialSelected,
      this.initialUnselected,
      super.key});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late List<String> _selectedItems;
  late List<String> _unselectedItems;

  @override
  void initState() {
    super.initState();

    _selectedItems = widget.initialSelected ?? [];
    _unselectedItems = widget.initialUnselected ?? [];
  }

  _showDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        List<String> filtered = [...widget.stuff];
        List<String> selected = [..._selectedItems];
        List<String> unselected = [..._unselectedItems];
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text(widget.title),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    TextField(
                      style: TextStyle(fontSize: 14.0),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        fillColor: Colors.white60,
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide:
                                BorderSide(style: BorderStyle.none, width: 0)),
                        hintText: 'Enter a search term',
                      ),
                      onChanged: (s) {
                        setState(
                          () {
                            filtered = [...widget.stuff]
                                .where((e) =>
                                    e.toLowerCase().contains(s.toLowerCase()))
                                .toList();
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (BuildContext context, int index) {
                          String item = filtered[index];
                          return ListTile(
                            dense: true,
                            selected: selected.contains(item) ||
                                unselected.contains(item),
                            selectedColor: selected.contains(item)
                                ? Colors.green
                                : Colors.red,
                            trailing: selected.contains(item)
                                ? Icon(Icons.check)
                                : unselected.contains(item)
                                    ? Icon(Icons.close)
                                    : null,
                            title: Text(item),
                            onTap: () {
                              setState(
                                () {
                                  if (widget.tristate) {
                                    if (selected.contains(item)) {
                                      selected.remove(item);
                                      unselected.add(item);
                                    } else if (unselected.contains(item)) {
                                      unselected.remove(item);
                                    } else {
                                      selected.add(item);
                                    }
                                  } else {
                                    if (selected.contains(item)) {
                                      selected.remove(item);
                                    } else {
                                      selected.add(item);
                                    }
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.grey[800],
                      onPressed: _showDialog,
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
                                              widget
                                                  .onChanged!(_unselectedItems);
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
