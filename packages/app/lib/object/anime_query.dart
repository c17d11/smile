import 'package:app/object/anime_app_filter.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeQuery extends JikanAnimeQuery {
  AnimeAppFilter appFilter = AnimeAppFilter();

  void update(JikanAnimeQuery q) {
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

  static AnimeQuery from(AnimeQuery q) {
    AnimeQuery animeQueryIntern = AnimeQuery()
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
      ..appFilter = q.appFilter.copy();
    return animeQueryIntern;
  }

  @override
  bool operator ==(Object other) =>
      other is AnimeQuery &&
      other.searchTerm == searchTerm &&
      other.type == type &&
      other.rating == rating &&
      other.status == status &&
      other.minScore == minScore &&
      other.maxScore == maxScore &&
      other.minYear == minYear &&
      other.maxYear == maxYear &&
      other.sfw == sfw &&
      other.producers == producers &&
      other.genresInclude == genresInclude &&
      other.genresExclude == genresExclude &&
      other.page == page &&
      other.orderBy == orderBy &&
      other.sort == sort;

  @override
  int get hashCode =>
      searchTerm.hashCode ^
      type.hashCode ^
      rating.hashCode ^
      status.hashCode ^
      minScore.hashCode ^
      maxScore.hashCode ^
      minYear.hashCode ^
      maxYear.hashCode ^
      sfw.hashCode ^
      producers.hashCode ^
      genresInclude.hashCode ^
      genresExclude.hashCode ^
      page.hashCode ^
      orderBy.hashCode ^
      sort.hashCode;

  static AnimeQuery nextPage(AnimeQuery q) {
    AnimeQuery query = AnimeQuery.from(q);
    query.page = (query.page ?? 1) + 1;
    return query;
  }
}
