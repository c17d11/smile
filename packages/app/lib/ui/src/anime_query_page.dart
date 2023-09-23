import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/anime_rating.dart';
import 'package:app/controller/src/object/anime_status.dart';
import 'package:app/controller/src/object/anime_type.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/ui/selection_widget/multiple_select.dart';
import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/selection_widget/single_select.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/range_select.dart';
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

    final query = ref.read(animeQueryPod(page));
    AnimeQuery localQuery = AnimeQueryIntern.from(query);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      QueryWidget(
                        onChanged: (String s) {
                          localQuery.searchTerm = s;
                        },
                        initialValue: localQuery.searchTerm ?? "",
                      ),
                      const SizedBox(height: 10),
                      MultiSelect(
                        loadOptions: () async {
                          await ref.read(producerPod.notifier).get(0);
                          return ref
                                  .read(producerPod)
                                  .value
                                  ?.map((e) => SelectionWrapper(e))
                                  .toList() ??
                              [];
                        },
                        initialSelected: localQuery.producers
                            ?.map(
                                (e) => SelectionWrapper(ProducerIntern.from(e)))
                            .toList(),
                        onChangedInclude: (items) {
                          localQuery.producers = items
                              .map((e) => e.item as ProducerIntern)
                              .toList();
                        },
                        title: "Producers",
                      ),
                      const SizedBox(height: 10),
                      MultiSelect(
                        tristate: true,
                        loadOptions: () async {
                          await ref.read(genrePod.notifier).get();
                          return ref
                                  .read(genrePod)
                                  .value
                                  ?.map((e) => SelectionWrapper(e))
                                  .toList() ??
                              [];
                        },
                        initialSelected: localQuery.genresInclude
                            ?.map((e) => SelectionWrapper(GenreIntern.from(e)))
                            .toList(),
                        initialUnselected: localQuery.genresExclude
                            ?.map((e) => SelectionWrapper(GenreIntern.from(e)))
                            .toList(),
                        onChangedInclude: (items) {
                          localQuery.genresInclude =
                              items.map((e) => e.item as GenreIntern).toList();
                        },
                        onChangedExclude: (items) {
                          localQuery.genresExclude =
                              items.map((e) => e.item as GenreIntern).toList();
                        },
                        title: "Genres",
                      ),
                      const SizedBox(height: 10),
                      SingleSelect(
                        AnimeStatus.values
                            .map((e) => SelectionWrapper(AnimeStatusItem(e)))
                            .toList(),
                        'Status',
                        onChanged: (item) {
                          localQuery.status = (item != null)
                              ? (item.item as AnimeStatusItem).status
                              : null;
                        },
                        initialValue: (localQuery.status != null)
                            ? SelectionWrapper(
                                AnimeStatusItem(localQuery.status!))
                            : null,
                      ),
                      const SizedBox(height: 10),
                      SingleSelect(
                        AnimeRating.values
                            .map((e) => SelectionWrapper(AnimeRatingItem(e)))
                            .toList(),
                        'Rating',
                        onChanged: (item) {
                          localQuery.rating = (item != null)
                              ? (item.item as AnimeRatingItem).rating
                              : null;
                        },
                        initialValue: (localQuery.rating != null)
                            ? SelectionWrapper(
                                AnimeRatingItem(localQuery.rating!))
                            : null,
                      ),
                      const SizedBox(height: 10),
                      SingleSelect(
                        AnimeType.values
                            .map((e) => SelectionWrapper(AnimeTypeItem(e)))
                            .toList(),
                        'Type',
                        onChanged: (item) {
                          localQuery.type = (item != null)
                              ? (item.item as AnimeTypeItem).type
                              : null;
                        },
                        initialValue: (localQuery.type != null)
                            ? SelectionWrapper(AnimeTypeItem(localQuery.type!))
                            : null,
                      ),
                      const SizedBox(height: 10),
                      RangeSelect(
                        "Score",
                        0,
                        10,
                        stepSize: 0.5,
                        initialMin: localQuery.minScore,
                        initialMax: localQuery.maxScore,
                        onChanged: (value) {
                          if (value == null) {
                            localQuery.minScore = null;
                            localQuery.maxScore = null;
                          } else {
                            localQuery.minScore =
                                value.start != 0 ? value.start : null;
                            localQuery.maxScore =
                                value.end != 10 ? value.end : null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      RangeSelect(
                        "Year",
                        1970,
                        2023,
                        stepSize: 1,
                        showInts: true,
                        initialMin: localQuery.minYear?.toDouble(),
                        initialMax: localQuery.maxYear?.toDouble(),
                        onChanged: (value) {
                          if (value == null) {
                            localQuery.minYear = null;
                            localQuery.maxYear = null;
                          } else {
                            localQuery.minYear = value.start != 1970
                                ? value.start.toInt()
                                : null;
                            localQuery.maxYear =
                                value.end != 2023 ? value.end.toInt() : null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 40,
              color: Colors.green[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              query.override(localQuery);
              Navigator.pop(context);
            },
          ),
        ],
      ),
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
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Search'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
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
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                hintText: "Enter title",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
