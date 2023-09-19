import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/multi_select.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeQueryPage extends ConsumerStatefulWidget {
  const AnimeQueryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimeQueryPageState();
}

class _AnimeQueryPageState extends ConsumerState<AnimeQueryPage> {
  @override
  Widget build(BuildContext context) {
    final page = ModalRoute.of(context)?.settings.arguments as IconItem;

    final query = ref.watch(animeQueryPod(page));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body:
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          // Expanded(
          //     child:
          SingleChildScrollView(
        child: Container(
          color: Colors.grey[300],
          child: Column(
            children: [
              QueryWidget(
                onChanged: (String s) {
                  query.searchTerm = s;
                },
                initialValue: "",
              ),
            ],
          ),
        ),
      ),
      // )
      //   ],
      // ),
    );
  }
}

class QueryWidget extends ConsumerStatefulWidget {
  final String? initialValue;
  final Function? onChanged;

  const QueryWidget({this.initialValue, this.onChanged, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QueryWidgetState();
}

class _QueryWidgetState extends ConsumerState<QueryWidget> {
  final TextEditingController _controller = TextEditingController();
  bool showReset = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // they are not the same
      if (_controller.text.isNotEmpty ^ showReset) {
        setState(() {
          showReset = !showReset;
        });
      }
    });

    if (widget.onChanged != null) {
      _controller.addListener(() {
        widget.onChanged!(_controller.text);
      });
    }
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final producers = ref.watch(producerPod);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Search'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                suffixIcon: showReset
                    ? IconButton(
                        onPressed: () {
                          _controller.text = "";
                        },
                        icon: Icon(Icons.clear, color: Colors.red[400]))
                    : null,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                hintText: "Enter title",
              ),
            ),
            MultiSelect(
              loadOptions: () async {
                await ref.read(producerPod.notifier).get(0);
                return ref
                        .read(producerPod)
                        .value
                        ?.map((e) => e.title ?? '')
                        .toList() ??
                    [];
              },
              initialSelected: const [],
              onChanged: (List<String> titles) {},
              title: "Producers",
            ),
            MultiSelect(
              tristate: true,
              loadOptions: () async {
                await ref.read(genrePod.notifier).get();
                return ref
                        .read(genrePod)
                        .value
                        ?.map((e) => e.name ?? '')
                        .toList() ??
                    [];
              },
              initialSelected: const [],
              onChanged: (List<String> names) {},
              title: "Genres",
            ),
            SingleSelect(
              AnimeStatus.values.map((e) => e.capitalize).toList(),
              'Status',
            ),
            SingleSelect(
              AnimeRating.values.map((e) => e.capitalize).toList(),
              'Rating',
            ),
            SingleSelect(
              AnimeType.values.map((e) => e.capitalize).toList(),
              'Type',
            ),
          ],
        ),
      ),
    );
  }
}
