import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/anime_query/collection.dart';
import 'package:app/object/anime_query.dart';

class IsarAnimeQueryConverter extends Converter<AnimeQuery, IsarAnimeQuery> {
  @override
  AnimeQuery fromImpl(IsarAnimeQuery t) {
    return AnimeQuery()
      ..searchTerm = t.searchTerm
      ..type = t.type
      ..rating = t.rating
      ..status = t.status
      ..minScore = t.minScore
      ..maxScore = t.maxScore
      ..minYear = t.minYear
      ..maxYear = t.maxYear
      ..sfw = t.sfw
      ..producers = []
      ..genresInclude = []
      ..genresExclude = []
      ..page = t.page
      ..orderBy = t.orderBy
      ..sort = t.sort;
  }

  @override
  IsarAnimeQuery toImpl(AnimeQuery t) {
    return IsarAnimeQuery()
      ..searchTerm = t.searchTerm
      ..type = t.type
      ..rating = t.rating
      ..status = t.status
      ..minScore = t.minScore
      ..maxScore = t.maxScore
      ..minYear = t.minYear
      ..maxYear = t.maxYear
      ..sfw = t.sfw
      ..producerIds = t.producers?.map((e) => e.malId!).toList()
      ..genresIncludeIds = t.genresInclude?.map((e) => e.malId!).toList()
      ..genresExcludeIds = t.genresExclude?.map((e) => e.malId!).toList()
      ..page = t.page
      ..orderBy = t.orderBy
      ..sort = t.sort;
  }
}
