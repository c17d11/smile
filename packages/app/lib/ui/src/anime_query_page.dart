import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/anime_rating.dart';
import 'package:app/controller/src/object/anime_status.dart';
import 'package:app/controller/src/object/anime_type.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/ui/selection_widget/multiple_select.dart';
import 'package:app/ui/selection_widget/query_widget.dart';
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
  Widget buildSearchTermWidget(AnimeQuery localQuery) {
    return QueryWidget(
      onChanged: (String s) {
        localQuery.searchTerm = s;
      },
      initialValue: localQuery.searchTerm ?? "",
    );
  }

  Widget buildProducerWidget(AnimeQuery localQuery) {
    return MultiSelect(
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
          ?.map((e) => SelectionWrapper(ProducerIntern.from(e)))
          .toList(),
      onChangedInclude: (items) {
        localQuery.producers =
            items.map((e) => e.item as ProducerIntern).toList();
      },
      title: "Producers",
    );
  }

  Widget buildGenreWidget(AnimeQuery localQuery) {
    return MultiSelect(
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
    );
  }

  Widget buildAnimeStatusWidget(AnimeQuery localQuery) {
    return SingleSelect(
      AnimeStatus.values
          .map((e) => SelectionWrapper(AnimeStatusItem(e)))
          .toList(),
      'Status',
      onChanged: (item) {
        localQuery.status =
            (item != null) ? (item.item as AnimeStatusItem).status : null;
      },
      initialValue: (localQuery.status != null)
          ? SelectionWrapper(AnimeStatusItem(localQuery.status!))
          : null,
    );
  }

  Widget buildAnimeRatingWidget(AnimeQuery localQuery) {
    return SingleSelect(
      AnimeRating.values
          .map((e) => SelectionWrapper(AnimeRatingItem(e)))
          .toList(),
      'Rating',
      onChanged: (item) {
        localQuery.rating =
            (item != null) ? (item.item as AnimeRatingItem).rating : null;
      },
      initialValue: (localQuery.rating != null)
          ? SelectionWrapper(AnimeRatingItem(localQuery.rating!))
          : null,
    );
  }

  Widget buildAnimeTypeWidget(AnimeQuery localQuery) {
    return SingleSelect(
      AnimeType.values.map((e) => SelectionWrapper(AnimeTypeItem(e))).toList(),
      'Type',
      onChanged: (item) {
        localQuery.type =
            (item != null) ? (item.item as AnimeTypeItem).type : null;
      },
      initialValue: (localQuery.type != null)
          ? SelectionWrapper(AnimeTypeItem(localQuery.type!))
          : null,
    );
  }

  Widget buildScoreWidget(AnimeQuery localQuery) {
    return RangeSelect(
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
          localQuery.minScore = value.start != 0 ? value.start : null;
          localQuery.maxScore = value.end != 10 ? value.end : null;
        }
      },
    );
  }

  Widget buildYearWidget(AnimeQuery localQuery) {
    return RangeSelect(
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
          localQuery.minYear = value.start != 1970 ? value.start.toInt() : null;
          localQuery.maxYear = value.end != 2023 ? value.end.toInt() : null;
        }
      },
    );
  }

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
                      buildSearchTermWidget(localQuery),
                      const SizedBox(height: 10),
                      buildProducerWidget(localQuery),
                      const SizedBox(height: 10),
                      buildGenreWidget(localQuery),
                      const SizedBox(height: 10),
                      buildAnimeStatusWidget(localQuery),
                      const SizedBox(height: 10),
                      buildAnimeRatingWidget(localQuery),
                      const SizedBox(height: 10),
                      buildAnimeTypeWidget(localQuery),
                      const SizedBox(height: 10),
                      buildScoreWidget(localQuery),
                      const SizedBox(height: 10),
                      buildYearWidget(localQuery),
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
