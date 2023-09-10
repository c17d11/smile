import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/src/anime_details.dart';
import 'package:ui/src/home.dart';
import 'package:ui/src/pod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
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
            theme: ThemeData(
              colorSchemeSeed: const Color(0xff6750a4),
              useMaterial3: true,

              // IconButton theme mimicing material3 NavigationBar buttons
              iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(
                  minimumSize: const Size(50, 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ),
            routes: {
              'home': (context) => const HomePage(),
              'anime-details': (context) => const AnimeDetails(),
              'anime-query': (context) => const HomePage(),
            },
          );
        });
  }
}
