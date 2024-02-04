import 'package:jikan_api/src/object/anime_order.dart';
import 'package:jikan_api/src/object/anime_sort.dart';
import 'package:jikan_api/src/object/genre.dart';

import 'anime_rating.dart';
import 'anime_status.dart';
import 'anime_type.dart';
import 'producer.dart';

class JikanAnimeQuery {
  String? searchTerm;
  JikanAnimeType? type;
  JikanAnimeRating? rating;
  JikanAnimeStatus? status;
  double? minScore;
  double? maxScore;
  int? minYear;
  int? maxYear;
  bool? sfw;
  List<JikanProducer>? producers;
  List<JikanGenre>? genresInclude;
  List<JikanGenre>? genresExclude;
  int? page;
  JikanAnimeOrder? orderBy;
  JikanAnimeSort? sort;
}
