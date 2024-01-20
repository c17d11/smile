import 'package:app/controller/src/object/tag.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/collections/page.dart';
import 'package:app/ui/src/collections/state.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/pod.dart';
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
                await ref.read(tagPod.notifier).insertTags([Tag(value, 0)]);
                ref.invalidate(collectionNames);
              }
            }),
        child: Text("New collection"));
  }
}
