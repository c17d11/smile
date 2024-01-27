import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/about/nav_item.dart';
import 'package:app/ui/src/browse/nav_item.dart';
import 'package:app/ui/src/collections/nav_item.dart';
import 'package:app/ui/src/favorite/nav_item.dart';
import 'package:app/ui/src/nav_items.dart';
import 'package:app/ui/src/schedule/nav_item.dart';
import 'package:app/ui/src/test_page/test_nav_item.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PageGroup {
  String get title;
  List<IconItem> get pages;
  void onNavigate(WidgetRef ref);
}

class AnimeGroup extends PageGroup {
  @override
  void onNavigate(WidgetRef ref) =>
      ref.read(pageGroupPod.notifier).state = this;

  @override
  List<IconItem> get pages => [
        BrowseNavItem(),
        ScheduleNavItem(),
        FavoriteNavItem(),
        CollectionsNavItem(),
        // TestNavItem(),
      ];

  @override
  String get title => "Anime";
}

class OtherGroup extends PageGroup {
  @override
  void onNavigate(WidgetRef ref) =>
      ref.read(pageGroupPod.notifier).state = this;

  @override
  List<IconItem> get pages => [ProducersNavItem(), GenresNavItem()];

  @override
  String get title => "Other";
}

class SettingsGroup extends PageGroup {
  @override
  void onNavigate(WidgetRef ref) =>
      ref.read(pageGroupPod.notifier).state = this;

  @override
  List<IconItem> get pages => [AboutNavItem(), SettingsNavItem()];

  @override
  String get title => "";
}

final pageGroupPod = StateProvider<PageGroup>((ref) => AnimeGroup());
final pageIndexPod = StateProvider<int>((ref) => 0);
final pagePod = StateProvider<IconItem?>((ref) {
  final group = ref.watch(pageGroupPod);
  final index = ref.watch(pageIndexPod);
  return group.pages[index];
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Widget buildListTile(IconItem item, WidgetRef ref, PageGroup g, int index) {
    return ListTile(
      leading: ref.read(pagePod) == item ? item.selectedIcon : item.icon,
      title: Text(item.label),
      selected: ref.read(pagePod) == item,
      onTap: () {
        ref.read(pageGroupPod.notifier).state = g;
        ref.read(pageIndexPod.notifier).state = index;
        Navigator.pop(context);
      },
    );
  }

  Widget buildNavigationDestination(IconItem item) {
    return NavigationDestination(
      selectedIcon: item.selectedIcon,
      icon: item.icon,
      label: item.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    PageGroup? group = ref.watch(pageGroupPod);
    int index = ref.watch(pageIndexPod);
    IconItem? page = ref.watch(pagePod);

    return Scaffold(
      appBar: AppBar(
        actions: page != null ? [page.buildAppBarWidget(context, ref)] : [],
        title: page?.buildAppBarTitle(),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: null),
                  ...[
                    TextDivider(AnimeGroup().title),
                    ...AnimeGroup().pages.asMap().entries.map(
                        (e) => buildListTile(e.value, ref, AnimeGroup(), e.key))
                  ],
                  ...[
                    TextDivider(OtherGroup().title),
                    ...OtherGroup().pages.asMap().entries.map(
                        (e) => buildListTile(e.value, ref, OtherGroup(), e.key))
                  ],
                  const Spacer(),
                  ...[
                    TextDivider(SettingsGroup().title),
                    ...SettingsGroup().pages.asMap().entries.map((e) =>
                        buildListTile(e.value, ref, SettingsGroup(), e.key))
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      body: page?.buildContent(ref),
      bottomNavigationBar: (group?.pages.length ?? 0) > 1
          ? NavigationBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              indicatorColor: Theme.of(context).colorScheme.primary,
              shadowColor: Theme.of(context).colorScheme.secondary,
              onDestinationSelected: (value) {
                ref.read(pageIndexPod.notifier).state = value;
              },
              selectedIndex: index,
              destinations: group!.pages
                  .map((e) => buildNavigationDestination(e))
                  .toList())
          : null,
    );
  }
}
