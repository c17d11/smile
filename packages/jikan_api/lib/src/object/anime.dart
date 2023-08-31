import 'producer.dart';

class Anime {
  int? malId;
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
  List<Producer>? producers;
  int? episodes;
  String? imageUrl;

  @override
  String toString() => "Anime(malId: $malId, title: $title)";
}
