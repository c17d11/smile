import 'package:app/ui/common/icon_item.dart';
import 'package:app/ui/routes/home/pages/settings/page.dart';
import 'package:app/ui/routes/home/pages/settings/state.dart';
import 'package:app/ui/state/hide_titles.dart';
import 'package:app/ui/state/settings.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNavItem extends IconItem {
  @override
  String get label => "Settings";

  @override
  Icon get icon => const Icon(Icons.settings_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.settings);

  @override
  Widget buildContent(WidgetRef ref) {
    return const SettingsPage();
  }

  @override
  List<Widget> buildAppBarWidgets(BuildContext context, WidgetRef ref) {
    return [
      IconButton(
          onPressed: () {
            ref.read(hideTitles.notifier).state =
                !ref.read(hideTitles.notifier).state;
          },
          icon: const Icon(Icons.text_fields)),
    ];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Settings");
  }

  @override
  Widget? buildFab(BuildContext context, WidgetRef ref) =>
      FloatingActionButton.extended(
        onPressed: () async {
          await ref
              .read(settingsPod.notifier)
              .set(ref.read(localSettings))
              .then((value) =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Saved"),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: const Duration(milliseconds: 250),
                    // behavior: SnackBarBehavior.floating,
                  )));
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      );
}
