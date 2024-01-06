import 'package:app/controller/src/object/tag.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class AnimeIntern extends Anime {
  bool? isFavorite;
  bool? isBlacklisted;
  List<Tag>? tags;
  float? personalScore;
  String? personalNotes;

  @override
  bool operator ==(Object other) =>
      other is AnimeIntern && other.malId == malId;

  @override
  int get hashCode => malId.hashCode;
}
