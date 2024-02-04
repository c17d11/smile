import 'package:app/object/tag.dart';
import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/tag/collection.dart';

class IsarTagConverter extends Converter<Tag, IsarTag> {
  @override
  Tag fromImpl(IsarTag t) {
    return Tag()
      ..name = t.name
      ..animeCount = null;
  }

  @override
  IsarTag toImpl(Tag t) {
    return IsarTag(name: t.name!);
  }
}
