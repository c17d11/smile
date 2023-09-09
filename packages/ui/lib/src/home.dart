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
      destinations: <Widget>[
        _NewsItem().navItem,
        _FavoriteItem().navItem,
        _HomeItem().navItem,
        _ScheduleItem().navItem,
        _SettingsItem().navItem,
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
      destinations: <NavigationRailDestination>[
        _NewsItem().railItem,
        _FavoriteItem().railItem,
        _HomeItem().railItem,
        _ScheduleItem().railItem,
        _SettingsItem().railItem,
      ],
      trailing: _SettingsItem().,
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

abstract class _PageItem {
  late Icon iconSelected;
  late Icon icon;
  late String name;

  NavigationDestination get navItem => NavigationDestination(
        selectedIcon: iconSelected,
        icon: icon,
        label: name,
      );

  NavigationRailDestination get railItem => NavigationRailDestination(
        selectedIcon: iconSelected,
        icon: icon,
        label: Text(name),
      );
}

class _HomeItem extends _PageItem {
  _HomeItem() {
    iconSelected = const Icon(Icons.home_outlined);
    icon = const Icon(Icons.home);
    name = "Home";
  }
}

class _NewsItem extends _PageItem {
  _NewsItem() {
    iconSelected = const Icon(Icons.new_releases_outlined);
    icon = const Icon(Icons.new_releases);
    name = "News";
  }
}

class _FavoriteItem extends _PageItem {
  _FavoriteItem() {
    iconSelected = const Icon(Icons.favorite_outline);
    icon = const Icon(Icons.favorite);
    name = "Favorite";
  }
}

class _ScheduleItem extends _PageItem {
  _ScheduleItem() {
    iconSelected = const Icon(Icons.calendar_month_outlined);
    icon = const Icon(Icons.calendar_month);
    name = "Schedule";
  }
}

class _SettingsItem extends _PageItem {
  _SettingsItem() {
    iconSelected = const Icon(Icons.settings_outlined);
    icon = const Icon(Icons.settings);
    name = "Settings";
  }
}
