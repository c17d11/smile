import 'package:jikan_api/src/object/anime_order.dart';
import 'package:jikan_api/src/object/anime_sort.dart';
import 'package:jikan_api/src/object/genre.dart';

import 'anime_rating.dart';
import 'anime_status.dart';
import 'anime_type.dart';
import 'producer.dart';

class AnimeQuery {
  String? searchTerm;
  AnimeType? type;
  AnimeRating? rating;
  AnimeStatus? status;
  double? minScore;
  double? maxScore;
  int? minYear;
  int? maxYear;
  bool? sfw;
  List<Producer>? producers;
  List<Genre>? genresInclude;
  List<Genre>? genresExclude;
  int? page;
  AnimeOrder? orderBy;
  AnimeSort? sort;
}
