import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_list.dart';
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
    return Container(
      color: Colors.green[300],
    );
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
    return Container(
      color: Colors.red[300],
    );
  }
}

class NewsNavItem extends IconItem {
  @override
  String get label => "News";

  @override
  Icon get icon => const Icon(Icons.new_releases_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.new_releases);

  @override
  Widget buildContent() {
    return Container(
      color: Colors.yellow[300],
    );
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
    return Container(
      color: Colors.purple[300],
    );
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
    return NavigationContainer(
      startItem: selectedContent,
      landscapeItems: [
        NewsNavItem(),
        FavoriteNavItem(),
        HomeNavItem(),
        ScheduleNavItem(),
        SettingsNavItem(),
      ],
      portraitItems: [
        HomeNavItem(),
        FavoriteNavItem(),
        ScheduleNavItem(),
        NewsNavItem(),
        SpaceItem(),
        SettingsNavItem(),
      ],
      content: selectedContent.buildContent(),
      onClick: (IconItem selected) => setState(
        () {
          selectedContent = selected;
        },
      ),
    );
  }
}
