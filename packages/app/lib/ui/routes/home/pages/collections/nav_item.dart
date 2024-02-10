import 'package:app/object/tag.dart';
import 'package:app/ui/common/icon_item.dart';
import 'package:app/ui/routes/home/pages/collections/page.dart';
import 'package:app/ui/routes/home/pages/collections/state.dart';
import 'package:app/ui/state/hide_titles.dart';
import 'package:app/ui/state/tag.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionsNavItem extends IconItem {
  @override
  String get label => "Collections";

  @override
  Icon get icon => const Icon(Icons.collections_bookmark_outlined);

  @override
  Icon get selectedIcon => const Icon(Icons.collections_bookmark);

  @override
  Widget buildContent(WidgetRef ref) {
    return const CollectionPage();
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
      TextButton(
          onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  TextEditingController controller = TextEditingController();
                  return WillPopScope(
                    onWillPop: () async {
                      return true;
                    },
                    child: AlertDialog(
                      title: const TextWindow("Enter tag name"),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      content: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: SizedBox(
                              height: 50,
                              width: 300,
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
                  await ref.read(tagPod.notifier).insertTags([
                    Tag()
                      ..name = value
                      ..animeCount = 0
                  ]);
                  ref.invalidate(collectionNames);
                }
              }),
          child: const Text("New collection")),
    ];
  }

  @override
  Widget buildAppBarTitle() {
    return const TextFields("Collections");
  }

  @override
  Widget? buildFab(_, __) => null;
}
