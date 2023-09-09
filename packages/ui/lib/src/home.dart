import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/src/anime_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentPageIndex = 0;

  Widget buildNavigationBar() {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.new_releases_outlined),
          icon: Icon(Icons.new_releases),
          label: 'News',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.favorite_outline),
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.home_outlined),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.calendar_month_outlined),
          icon: Icon(Icons.calendar_month),
          label: 'Schedule',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings_outlined),
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: currentPageIndex,
      groupAlignment: -0.95,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          selectedIcon: Icon(Icons.new_releases_outlined),
          icon: Icon(Icons.new_releases),
          label: Text('News'),
        ),
        NavigationRailDestination(
          selectedIcon: Icon(Icons.favorite_outline),
          icon: Icon(Icons.favorite),
          label: Text('Favorite'),
        ),
        NavigationRailDestination(
          selectedIcon: Icon(Icons.home_outlined),
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          selectedIcon: Icon(Icons.calendar_month_outlined),
          icon: Icon(Icons.calendar_month),
          label: Text('Schedule'),
        ),
        NavigationRailDestination(
          selectedIcon: Icon(Icons.settings_outlined),
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }

  Widget buildBody() {
    return <Widget>[
      Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text('Page 1'),
      ),
      Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: const Text('Page 2'),
      ),
      const AnimeList(),
      Container(
        color: Colors.purple,
        alignment: Alignment.center,
        child: const Text('Page 4'),
      ),
      Container(
        color: Colors.orange,
        alignment: Alignment.center,
        child: const Text('Page 5'),
      ),
    ][currentPageIndex];
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.aspectRatio > 1;

    return Scaffold(
      bottomNavigationBar: isWideScreen ? null : buildNavigationBar(),
      body: isWideScreen
          ? SafeArea(
              child: Row(
                children: <Widget>[
                  buildNavigationRail(),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: buildBody(),
                  ),
                ],
              ),
            )
          : buildBody(),
    );
  }
}
