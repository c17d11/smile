import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarAnime {
  @Index(unique: true, replace: true)
  Id id;

  String? title;
  List<String>? titles;
  double? score;
  String? schedule;
  String? type;
  String? source;
  String? status;
  String? airedFrom;
  String? airedTo;
  String? duration;
  String? rating;
  int? rank;
  String? synopsis;
  String? background;
  String? season;
  int? year;
  DateTime? broadcast;
  List<int>? producerIds;
  List<int>? genreIds;
  int? episodes;
  String? imageUrl;

  IsarAnime({required this.id});
}
