import 'package:app/controller/src/object/genre_intern.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

part 'isar_genre.g.dart';

@Collection()
class IsarGenre extends GenreIntern {
  @Index(unique: true, replace: true)
  Id id;
  IsarGenre({required this.id});

  static IsarGenre from(Genre g) {
    IsarGenre genreIntern = IsarGenre(id: g.malId!)
      ..malId = g.malId
      ..name = g.name
      ..count = g.count;
    return genreIntern;
  }
}
