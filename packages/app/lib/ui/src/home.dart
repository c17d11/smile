import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_favorite_page.dart';
import 'package:app/ui/src/anime_list.dart';
import 'package:app/ui/src/anime_schedule_page.dart';
import 'package:app/ui/src/collection_page.dart';
import 'package:app/ui/src/settings_page.dart';
import 'package:flutter/material.dart';

class HomeNavItem extends IconItem {
  @override
  String get label => "Home";

  @override
  Icon get icon => const Icon(Icons.home_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.home);

  @override
  Widget buildContent() {
    return AnimeListPage(page: this);
  }
}

class FavoriteNavItem extends IconItem {
  @override
  String get label => "Favorite";

  @override
  Icon get icon => const Icon(Icons.favorite_outline);

  @override
  Icon get selectedIcon => const Icon(Icons.favorite);

  @override
  Widget buildContent() {
    return AnimeFavoritePage(page: this);
  }
}

class ScheduleNavItem extends IconItem {
  @override
  String get label => "Schedule";

  @override
  Icon get icon => const Icon(Icons.calendar_month_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.calendar_month);

  @override
  Widget buildContent() {
    return AnimeSchedulePage(page: this);
  }
}

class CollectionsNavItem extends IconItem {
  @override
  String get label => "Collections";

  @override
  Icon get icon => const Icon(Icons.collections_bookmark_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.collections_bookmark);

  @override
  Widget buildContent() {
    return CollectionPage(page: this);
  }
}

class SettingsNavItem extends IconItem {
  @override
  String get label => "Settings";

  @override
  Icon get icon => const Icon(Icons.settings_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.settings);

  @override
  Widget buildContent() {
    return const SettingsPage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconItem selectedContent = HomeNavItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationContainer(
        startItem: selectedContent,
        landscapeItems: [
          CollectionsNavItem(),
          FavoriteNavItem(),
          HomeNavItem(),
          ScheduleNavItem(),
          SettingsNavItem(),
        ],
        portraitItems: [
          HomeNavItem(),
          FavoriteNavItem(),
          ScheduleNavItem(),
          CollectionsNavItem(),
          SpaceItem(),
          SettingsNavItem(),
        ],
        content: SafeArea(child: selectedContent.buildContent()),
        onClick: (IconItem selected) => setState(
          () {
            selectedContent = selected;
          },
        ),
      ),
    );
  }
}
