import 'package:app/ui/selection_widget/src/select_item.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

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
      background: _backgroundSecondary,
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
