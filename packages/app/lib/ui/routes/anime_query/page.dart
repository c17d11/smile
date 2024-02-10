import 'package:app/object/anime_order.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/object/anime_rating.dart';
import 'package:app/object/anime_sort.dart';
import 'package:app/object/anime_status.dart';
import 'package:app/object/anime_type.dart';
import 'package:app/object/genre.dart';
import 'package:app/object/producer.dart';
import 'package:app/object/bool_item.dart';
import 'package:app/ui/common/multiple_select.dart';
import 'package:app/ui/common/query_widget.dart';
import 'package:app/ui/common/range_select.dart';
import 'package:app/ui/common/single_select.dart';
import 'package:app/ui/common/year_select.dart';
import 'package:app/ui/routes/home/pages/genre/state.dart';
import 'package:app/ui/state/anime_query.dart';
import 'package:app/ui/state/producer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeQueryPage extends ConsumerStatefulWidget {
  const AnimeQueryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimeQueryPageState();
}

class _AnimeQueryPageState extends ConsumerState<AnimeQueryPage> {
  Widget buildOrderWidget(AnimeQuery localQuery) {
    return SingleSelect(
      'Order by',
      JikanAnimeOrder.values.map((e) => AnimeOrderItem(e)).toList(),
      onChanged: (item) {
        localQuery.orderBy =
            (item != null) ? (item as AnimeOrderItem).order : null;
      },
      initialValue: (localQuery.orderBy != null)
          ? AnimeOrderItem(localQuery.orderBy!)
          : null,
    );
  }

  Widget buildSortWidget(AnimeQuery localQuery) {
    return SingleSelect(
      'Sort',
      JikanAnimeSort.values.map((e) => AnimeSortItem(e)).toList(),
      onChanged: (item) {
        localQuery.sort = (item != null) ? (item as AnimeSortItem).sort : null;
      },
      initialValue:
          (localQuery.sort != null) ? AnimeSortItem(localQuery.sort!) : null,
    );
  }

  Widget buildSearchTermWidget(AnimeQuery localQuery) {
    return QueryWidget(
      onChanged: (String s) {
        localQuery.searchTerm = s;
      },
      initialValue: localQuery.searchTerm ?? "",
    );
  }

  Future<List<Producer>> loadProducers() async {
    await ref.read(producerPod.notifier).get(0);
    return ref.read(producerPod).value ?? [];
  }

  Future<List<Genre>> loadGenres() async {
    await ref.read(genrePod.notifier).get();
    return ref.read(genrePod).value ?? [];
  }

  Widget buildProducerWidget(AnimeQuery localQuery) {
    return MultiSelect<Producer>(
      title: "Producers",
      loadOptions: loadProducers,
      initialSelected:
          localQuery.producers?.map((e) => Producer.from(e)).toList(),
      onChangedInclude: (items) {
        localQuery.producers = items.map((e) => e as Producer).toList();
      },
    );
  }

  Widget buildGenreWidget(AnimeQuery localQuery) {
    return MultiSelect<Genre>(
      title: "Genres",
      tristate: true,
      loadOptions: loadGenres,
      initialSelected:
          localQuery.genresInclude?.map((e) => Genre.from(e)).toList(),
      initialUnselected:
          localQuery.genresExclude?.map((e) => Genre.from(e)).toList(),
      onChangedInclude: (items) {
        localQuery.genresInclude = items.map((e) => e as Genre).toList();
      },
      onChangedExclude: (items) {
        localQuery.genresExclude = items.map((e) => e as Genre).toList();
      },
    );
  }

  Widget buildAnimeStatusWidget(AnimeQuery localQuery) {
    return SingleSelect(
      'Status',
      JikanAnimeStatus.values.map((e) => AnimeStatusItem(e)).toList(),
      onChanged: (item) {
        localQuery.status =
            (item != null) ? (item as AnimeStatusItem).status : null;
      },
      initialValue: (localQuery.status != null)
          ? AnimeStatusItem(localQuery.status!)
          : null,
    );
  }

  Widget buildAnimeRatingWidget(AnimeQuery localQuery) {
    return SingleSelect(
      'Rating',
      JikanAnimeRating.values.map((e) => AnimeRatingItem(e)).toList(),
      onChanged: (item) {
        localQuery.rating =
            (item != null) ? (item as AnimeRatingItem).rating : null;
      },
      initialValue: (localQuery.rating != null)
          ? AnimeRatingItem(localQuery.rating!)
          : null,
    );
  }

  Widget buildAnimeTypeWidget(AnimeQuery localQuery) {
    return SingleSelect(
      'Type',
      JikanAnimeType.values.map((e) => AnimeTypeItem(e)).toList(),
      onChanged: (item) {
        localQuery.type = (item != null) ? (item as AnimeTypeItem).type : null;
      },
      initialValue:
          (localQuery.type != null) ? AnimeTypeItem(localQuery.type!) : null,
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
    return YearSelect(
      title: "Year",
      initMinValue: localQuery.minYear,
      initMaxValue: localQuery.maxYear,
      onMinChanged: (min) => localQuery.minYear = min,
      onMaxChanged: (max) => localQuery.maxYear = max,
    );
  }

  Widget buildSfwWidget(AnimeQuery localQuery) {
    return SingleSelect(
      'Sfw',
      [BoolItem(true), BoolItem(false)],
      onChanged: (item) {
        localQuery.sfw = (item != null) ? (item as BoolItem).value : null;
      },
      initialValue: (localQuery.sfw != null) ? BoolItem(localQuery.sfw!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.read(animeQueryPod);
    AnimeQuery localQuery = AnimeQuery.from(query);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(animeQueryPod.notifier).set(localQuery);
          Navigator.pop(context);
        },
        label: const Text('Search'),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                    const SizedBox(height: 10),
                    buildSfwWidget(localQuery),
                    const SizedBox(height: 10),
                    buildOrderWidget(localQuery),
                    const SizedBox(height: 10),
                    buildSortWidget(localQuery),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
