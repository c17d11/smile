import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/database/src/isar/collection/isar_genre.dart';
import 'package:app/database/src/isar/collection/isar_producer.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

part 'isar_anime_query.g.dart';

@Collection(ignore: {
  'type',
  'rating',
  'status',
  'orderBy',
  'sort',
  'producers',
  'genresInclude',
  'genresExclude',
  'tag'
})
class IsarAnimeQuery extends AnimeQueryIntern {
  Id? id;

  @Index(unique: true, replace: true)
  String pageUi = "unique";

  @Enumerated(EnumType.name)
  AnimeType? isarType;

  @Enumerated(EnumType.name)
  AnimeRating? isarRating;

  @Enumerated(EnumType.name)
  AnimeStatus? isarStatus;

  @Enumerated(EnumType.name)
  AnimeOrder? isarOrder;

  @Enumerated(EnumType.name)
  AnimeSort? isarSort;

  final isarProducers = IsarLinks<IsarProducer>();
  final isarGenresInclude = IsarLinks<IsarGenre>();
  final isarGenresExclude = IsarLinks<IsarGenre>();

  final isarTag = IsarLink<IsarTag>();

  static IsarAnimeQuery from(AnimeQueryIntern q) {
    IsarAnimeQuery query = IsarAnimeQuery()
      ..searchTerm = q.searchTerm
      ..isarType = q.type
      ..isarRating = q.rating
      ..isarStatus = q.status
      ..minScore = q.minScore
      ..maxScore = q.maxScore
      ..minYear = q.minYear
      ..maxYear = q.maxYear
      ..sfw = q.sfw
      ..producers = q.producers
      ..genresInclude = q.genresInclude
      ..genresExclude = q.genresExclude
      ..page = q.page
      ..isarOrder = q.orderBy
      ..isarSort = q.sort
      ..isFavorite = q.isFavorite
      ..tag = q.tag;
    return query;
  }
}
