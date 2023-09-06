import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/src/home.dart';
import 'package:ui/src/pod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: JikanUi()));
}

class JikanUi extends ConsumerStatefulWidget {
  const JikanUi({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JikanUiState();
}

class _JikanUiState extends ConsumerState<JikanUi> {
  Future<void> init() async {
    await ref.watch(databasePod).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          return MaterialApp(
            initialRoute: 'home',
            routes: {
              'home': (context) => const Home(),
            },
          );
        });
  }
}
