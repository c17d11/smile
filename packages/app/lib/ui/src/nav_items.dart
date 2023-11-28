import 'package:app/controller/src/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/anime_favorite_page.dart';
import 'package:app/ui/src/genre_list.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/anime_list.dart';
import 'package:app/ui/src/anime_schedule_page.dart';
import 'package:app/ui/src/collection_page.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/producer_list.dart';
import 'package:app/ui/src/settings_page.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNavItem extends IconItem {
  @override
  String get label => "Browse";

  @override
  Icon get icon => const Icon(Icons.home_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.home);

  @override
  Widget buildContent() {
    return AnimeListPage(page: this);
  }

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, 'anime-query', arguments: this);
      },
      icon: const Icon(Icons.sort),
    );
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

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return Container();
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

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, 'schedule-query');
      },
      icon: const Icon(Icons.sort),
    );
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

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () => showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller = TextEditingController();
                return WillPopScope(
                  onWillPop: () async {
                    return true;
                  },
                  child: AlertDialog(
                    title: TextWindow("Enter tag name"),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: SizedBox(
                            height: 150,
                            width: 200,
                            child: TextField(controller: controller)),
                      );
                    }),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Apply'),
                        onPressed: () {
                          Navigator.pop(context, controller.text);
                        },
                      ),
                    ],
                  ),
                );
              },
            ).then((value) async {
              if (value != null) {
                await ref.read(tagPod.notifier).insertTags([Tag(value, 0)]);
                ref.invalidate(pagePod);
                // setState(() {});
              }
            }),
        child: Text("New collection"));
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

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class ProducersNavItem extends IconItem {
  @override
  String get label => "Producers";

  @override
  Icon get icon => const Icon(Icons.business_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.business);

  @override
  Widget buildContent() {
    return ProducerListPage(page: this);
  }

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class GenresNavItem extends IconItem {
  @override
  String get label => "Genres";

  @override
  Icon get icon => const Icon(Icons.label_outline);

  @override
  Icon get selectedIcon => const Icon(Icons.label);

  @override
  Widget buildContent() {
    return GenreListPage();
  }

  @override
  Widget buildAppBarWidget(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
