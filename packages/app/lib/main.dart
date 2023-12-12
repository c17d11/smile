import 'package:app/ui/src/anime_details.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/anime_query_page.dart';
import 'package:app/ui/src/collection_page.dart';
import 'package:app/ui/src/nav_items.dart';
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
            seedColor: Color.fromARGB(255, 161, 202, 200),
            primary: const Color.fromARGB(255, 161, 202, 200),
            onSurface: Colors.grey[300],
            onSurfaceVariant: Colors.grey[500],
            onBackground: Colors.grey[800],
            error: Colors.red[600],
            // secondary: Color.fromARGB(255, 176, 161, 202),
            // error: const Color.fromARGB(255, 178, 99, 93),
            // background: Colors.black,

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
      loading: () => Container(
        color: const Color.fromARGB(255, 161, 202, 200),
        child: Image.asset('assets/coffee.webp', fit: BoxFit.none),
      ),
    );
  }
}
