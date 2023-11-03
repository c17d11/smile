import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

void _confirm(
  String title,
  String description,
  BuildContext context,
  Function()? onConfirm,
) {
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
              child: TextHeadline(description),
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
              child: const Text('OK'),
              onPressed: () {
                if (onConfirm != null) {
                  onConfirm();
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

class ConfirmButton extends StatelessWidget {
  final String title;
  final String description;
  final Function() onConfirm;

  const ConfirmButton({
    required this.title,
    required this.description,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SelectChip(
      text: title,
      background: Colors.grey[400]!,
      foreground: Colors.white,
      onPressed: () => _confirm(
        title,
        description,
        context,
        onConfirm,
      ),
    );
  }
}
