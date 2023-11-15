import 'package:app/ui/src/anime_details.dart';
import 'package:app/ui/src/anime_query_page.dart';
import 'package:app/ui/src/collection_page.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/schedule_query_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final init = ref.watch(initPod);

    return init.when(
      data: (initSuccessful) => MaterialApp(
        theme: ThemeData(
          // colorSchemeSeed: const Color(0xff6750a4),
          // brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(10, 155, 12, 12),
            primary: const Color.fromARGB(255, 135, 109, 212),
            secondary: const Color.fromARGB(255, 24, 193, 190),
            error: const Color.fromARGB(255, 178, 99, 93),
            background: Colors.black,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,

          // IconButton theme mimicing material3 NavigationBar buttons
          // iconButtonTheme: IconButtonThemeData(
          //   style: IconButton.styleFrom(
          //     minimumSize: const Size(50, 20),
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(100)),
          //   ),
          // ),
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomePage(),
          'anime-details': (context) => const AnimeDetails(),
          'anime-query': (context) => const AnimeQueryPage(),
          'schedule-query': (context) => const ScheduleQueryPage(),
          'collection': (context) => const AnimeCollectionPage(),
        },
      ),
      error: (err, stack) => Text('Error: $err'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
