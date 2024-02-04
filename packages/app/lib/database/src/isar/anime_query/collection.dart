import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

part 'collection.g.dart';

@Collection()
class IsarAnimeQuery {
  @Index(unique: true, replace: true)
  Id id = 1;

  String? searchTerm;

  @Enumerated(EnumType.name)
  JikanAnimeType? type;

  @Enumerated(EnumType.name)
  JikanAnimeRating? rating;

  @Enumerated(EnumType.name)
  JikanAnimeStatus? status;

  double? minScore;
  double? maxScore;
  int? minYear;
  int? maxYear;
  bool? sfw;
  List<int>? producerIds;
  List<int>? genresIncludeIds;
  List<int>? genresExcludeIds;
  int? page;

  @Enumerated(EnumType.name)
  JikanAnimeOrder? orderBy;

  @Enumerated(EnumType.name)
  JikanAnimeSort? sort;
}
