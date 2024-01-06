import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeQueryIntern extends AnimeQuery {
  bool? isFavorite;
  Tag? tag;

  void update(AnimeQuery q) {
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
      ..isFavorite = q.isFavorite
      ..tag = q.tag;
    return animeQueryIntern;
  }

  @override
  bool operator ==(Object other) =>
      other is AnimeQueryIntern &&
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

  static AnimeQueryIntern nextPage(AnimeQueryIntern q) {
    AnimeQueryIntern query = AnimeQueryIntern.from(q);
    query.page = (query.page ?? 1) + 1;
    return query;
  }
}

class AnimeQueryNotifier extends StateNotifier<AnimeQueryIntern> {
  final Database db;
  final String page;
  AnimeQueryNotifier(this.page, this.db) : super(AnimeQueryIntern());

  Future<void> load() async {
    AnimeQueryIntern? query = await db.getAnimeQuery(page);
    state = query ?? AnimeQueryIntern();
  }

  Future<void> set(AnimeQueryIntern newQuery) async {
    await db.updateAnimeQuery(page, newQuery);
    state = newQuery;
  }
}

class ProducerQueryIntern extends ProducerQuery {
  void replace(ProducerQuery q) {
    searchTerm = q.searchTerm;
    page = q.page;
  }

  static ProducerQueryIntern from(ProducerQueryIntern q) {
    ProducerQueryIntern query = ProducerQueryIntern()
      ..searchTerm = q.searchTerm
      ..page = q.page;
    return query;
  }

  static ProducerQueryIntern nextPage(ProducerQueryIntern q) {
    ProducerQueryIntern query = ProducerQueryIntern.from(q);
    query.page = (query.page ?? 1) + 1;
    return query;
  }

  @override
  bool operator ==(Object other) =>
      other is ProducerQueryIntern &&
      other.page == page &&
      other.searchTerm == searchTerm;

  @override
  int get hashCode => page.hashCode ^ searchTerm.hashCode;
}

class ProducerQueryNotifier extends StateNotifier<ProducerQueryIntern> {
  final Database db;
  final String page;
  ProducerQueryNotifier(this.page, this.db) : super(ProducerQueryIntern());

  Future<void> load() async {
    ProducerQueryIntern? query = await db.getProducerQuery(page);
    state = query ?? ProducerQueryIntern();
  }

  Future<void> set(ProducerQueryIntern newQuery) async {
    await db.updateProducerQuery(page, newQuery);
    state = newQuery;
  }
}
