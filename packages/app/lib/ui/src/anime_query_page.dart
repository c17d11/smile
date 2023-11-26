import 'package:app/controller/src/object/anime_order.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/anime_rating.dart';
import 'package:app/controller/src/object/anime_sort.dart';
import 'package:app/controller/src/object/anime_status.dart';
import 'package:app/controller/src/object/anime_type.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/src/object/sfw_item.dart';
import 'package:app/ui/selection_widget/src/multiple_select.dart';
import 'package:app/ui/selection_widget/src/query_widget.dart';
import 'package:app/controller/state.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/selection_widget/src/single_select.dart';
import 'package:app/ui/selection_widget/src/year_select.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/range_select.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeQueryPage extends ConsumerStatefulWidget {
  const AnimeQueryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimeQueryPageState();
}

class _AnimeQueryPageState extends ConsumerState<AnimeQueryPage> {
  Widget buildOrderWidget(AnimeQueryIntern localQuery) {
    return SingleSelect(
      'Order by',
      AnimeOrder.values.map((e) => AnimeOrderItem(e)).toList(),
      onChanged: (item) {
        localQuery.orderBy =
            (item != null) ? (item as AnimeOrderItem).order : null;
      },
      initialValue: (localQuery.orderBy != null)
          ? AnimeOrderItem(localQuery.orderBy!)
          : null,
    );
  }

  Widget buildSortWidget(AnimeQueryIntern localQuery) {
    return SingleSelect(
      'Sort',
      AnimeSort.values.map((e) => AnimeSortItem(e)).toList(),
      onChanged: (item) {
        localQuery.sort = (item != null) ? (item as AnimeSortItem).sort : null;
      },
      initialValue:
          (localQuery.sort != null) ? AnimeSortItem(localQuery.sort!) : null,
    );
  }

  Widget buildSearchTermWidget(AnimeQueryIntern localQuery) {
    return QueryWidget(
      onChanged: (String s) {
        localQuery.searchTerm = s;
      },
      initialValue: localQuery.searchTerm ?? "",
    );
  }

  Future<List<ProducerIntern>> loadProducers() async {
    await ref.read(producerPod.notifier).get(0);
    return ref.read(producerPod).value ?? [];
  }

  Future<List<GenreIntern>> loadGenres() async {
    await ref.read(genrePod.notifier).get();
    return ref.read(genrePod).value ?? [];
  }

  Widget buildProducerWidget(AnimeQueryIntern localQuery) {
    return MultiSelect<ProducerIntern>(
      title: "Producers",
      loadOptions: loadProducers,
      initialSelected:
          localQuery.producers?.map((e) => ProducerIntern.from(e)).toList(),
      onChangedInclude: (items) {
        localQuery.producers = items.map((e) => e as ProducerIntern).toList();
      },
    );
  }

  Widget buildGenreWidget(AnimeQueryIntern localQuery) {
    return MultiSelect<GenreIntern>(
      title: "Genres",
      tristate: true,
      loadOptions: loadGenres,
      initialSelected:
          localQuery.genresInclude?.map((e) => GenreIntern.from(e)).toList(),
      initialUnselected:
          localQuery.genresExclude?.map((e) => GenreIntern.from(e)).toList(),
      onChangedInclude: (items) {
        localQuery.genresInclude = items.map((e) => e as GenreIntern).toList();
      },
      onChangedExclude: (items) {
        localQuery.genresExclude = items.map((e) => e as GenreIntern).toList();
      },
    );
  }

  Widget buildAnimeStatusWidget(AnimeQueryIntern localQuery) {
    return SingleSelect(
      'Status',
      AnimeStatus.values.map((e) => AnimeStatusItem(e)).toList(),
      onChanged: (item) {
        localQuery.status =
            (item != null) ? (item as AnimeStatusItem).status : null;
      },
      initialValue: (localQuery.status != null)
          ? AnimeStatusItem(localQuery.status!)
          : null,
    );
  }

  Widget buildAnimeRatingWidget(AnimeQueryIntern localQuery) {
    return SingleSelect(
      'Rating',
      AnimeRating.values.map((e) => AnimeRatingItem(e)).toList(),
      onChanged: (item) {
        localQuery.rating =
            (item != null) ? (item as AnimeRatingItem).rating : null;
      },
      initialValue: (localQuery.rating != null)
          ? AnimeRatingItem(localQuery.rating!)
          : null,
    );
  }

  Widget buildAnimeTypeWidget(AnimeQueryIntern localQuery) {
    return SingleSelect(
      'Type',
      AnimeType.values.map((e) => AnimeTypeItem(e)).toList(),
      onChanged: (item) {
        localQuery.type = (item != null) ? (item as AnimeTypeItem).type : null;
      },
      initialValue:
          (localQuery.type != null) ? AnimeTypeItem(localQuery.type!) : null,
    );
  }

  Widget buildScoreWidget(AnimeQueryIntern localQuery) {
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

  Widget buildYearWidget(AnimeQueryIntern localQuery) {
    return YearSelect(
      title: "Year",
      initMinValue: localQuery.minYear,
      initMaxValue: localQuery.maxYear,
      onMinChanged: (min) => localQuery.minYear = min,
      onMaxChanged: (max) => localQuery.maxYear = max,
    );
  }

  Widget buildSfwWidget(AnimeQueryIntern localQuery) {
    return SingleSelect(
      'Sfw',
      [SfwItem(true), SfwItem(false)],
      onChanged: (item) {
        localQuery.sfw = (item != null) ? (item as SfwItem).sfw : null;
      },
      initialValue: (localQuery.sfw != null) ? SfwItem(localQuery.sfw!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = ModalRoute.of(context)?.settings.arguments as IconItem;

    final query = ref.read(animeQueryPod(page));
    AnimeQueryIntern localQuery = AnimeQueryIntern.from(query);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Container(
        child: Column(
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ref.read(animeQueryPod(page).notifier).set(localQuery);
                  Navigator.pop(context);
                },
                child: Text("APPLY",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.background,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
