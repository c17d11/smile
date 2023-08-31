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
  // TODO: genres
  List<Producer>? producers;
  int? page;
}
