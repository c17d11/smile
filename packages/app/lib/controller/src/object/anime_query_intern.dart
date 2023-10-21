import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeQueryIntern extends AnimeQuery {
  bool? isFavorite;

  void override(AnimeQuery q) {
    searchTerm = q.searchTerm;
    type = q.type;
    rating = q.rating;
    status = q.status;
    minScore = q.minScore;
    maxScore = q.maxScore;
    minYear = q.minYear;
    maxYear = q.maxYear;
    sfw = q.sfw;
    producers = q.producers;
    genresInclude = q.genresInclude;
    genresExclude = q.genresExclude;
    page = q.page;
    orderBy = q.orderBy;
    sort = q.sort;
  }

  static AnimeQueryIntern from(AnimeQueryIntern q) {
    AnimeQueryIntern animeQueryIntern = AnimeQueryIntern()
      ..searchTerm = q.searchTerm
      ..type = q.type
      ..rating = q.rating
      ..status = q.status
      ..minScore = q.minScore
      ..maxScore = q.maxScore
      ..minYear = q.minYear
      ..maxYear = q.maxYear
      ..sfw = q.sfw
      ..producers = q.producers
      ..genresInclude = q.genresInclude
      ..genresExclude = q.genresExclude
      ..page = q.page
      ..orderBy = q.orderBy
      ..sort = q.sort
      ..isFavorite = q.isFavorite;
    return animeQueryIntern;
  }
}

class AnimeQueryNotifier extends StateNotifier<AnimeQueryIntern> {
  AnimeQueryNotifier() : super(AnimeQueryIntern());

  void set(AnimeQueryIntern newQuery) {
    state = newQuery;
  }
}
