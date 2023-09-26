import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueryWidget extends ConsumerStatefulWidget {
  final String? initialValue;
  final Function? onChanged;

  const QueryWidget({this.initialValue, this.onChanged, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QueryWidgetState();
}

class _QueryWidgetState extends ConsumerState<QueryWidget> {
  final TextEditingController _controller = TextEditingController();
  bool showReset = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // they are not the same
      if (_controller.text.isNotEmpty ^ showReset) {
        setState(() {
          showReset = !showReset;
        });
      }
    });

    if (widget.onChanged != null) {
      _controller.addListener(() {
        widget.onChanged!(_controller.text);
      });
    }
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
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
                    'Search'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: showReset
                    ? IconButton(
                        onPressed: () {
                          _controller.text = "";
                        },
                        icon: Icon(Icons.clear, color: Colors.red[400]))
                    : null,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                hintText: "Enter title",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
