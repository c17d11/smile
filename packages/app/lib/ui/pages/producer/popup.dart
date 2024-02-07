import 'package:app/object/producer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color _background = Colors.black;
final Color _backgroundSecondary = Colors.grey[900]!;
final Color _foreground = Colors.grey[300]!;
final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

Future showProducerDetailsPopUp(BuildContext context, Producer producer) async {
  String s = "";
  if (producer.established != null) {
    String ss =
        producer.established!.substring(0, producer.established!.indexOf('+'));
    DateTime dt = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(ss);
    s = DateFormat('yyyy-MM-dd').format(dt);
  }

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                producer!.imageUrl ?? '',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              "${producer.title}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: _foreground,
              ),
            ),
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 600,
          maxWidth: 300,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                "ESTABLISHED",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundSecondary,
                ),
              ),
              Text(
                s.isNotEmpty ? s : '-',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundThird,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "ANIMES",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundSecondary,
                ),
              ),
              Text(
                producer.count != null ? "${producer.count} animes" : '-',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundThird,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "ABOUT",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundSecondary,
                ),
              ),
              Text(
                producer.about ?? '-',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  color: _foregroundThird,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
