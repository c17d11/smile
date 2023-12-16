import 'package:app/controller/src/object/tag.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class AnimeIntern extends Anime {
  bool? isFavorite;
  bool? isBlacklisted;
  List<Tag>? tags;

  @override
  bool operator ==(Object other) =>
      other is AnimeIntern && other.malId == malId;

  @override
  int get hashCode => malId.hashCode;
}
