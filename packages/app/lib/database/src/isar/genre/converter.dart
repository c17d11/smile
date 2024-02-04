import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/genre/collection.dart';
import 'package:app/object/genre.dart';

class IsarGenreConverter extends Converter<Genre, IsarGenre> {
  @override
  Genre fromImpl(IsarGenre t) {
    return Genre()
      ..malId = t.id
      ..name = t.name
      ..count = t.count;
  }

  @override
  IsarGenre toImpl(Genre t) {
    return IsarGenre(id: t.malId!)
      ..name = t.name
      ..count = t.count;
  }
}
