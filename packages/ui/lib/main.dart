import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:database/database.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:ui/src/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Database db = Database();
  await db.init();
  JikanApi api = JikanApi();

  runApp(JikanUi(db, api));
}

class JikanUi extends ConsumerStatefulWidget {
  final Database _db;
  final JikanApi _api;

  const JikanUi(this._db, this._api, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JikanUiState();
}

class _JikanUiState extends ConsumerState<JikanUi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => Home(),
      },
    );
  }
}
