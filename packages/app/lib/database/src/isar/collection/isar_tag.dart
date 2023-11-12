import 'package:app/controller/src/object/tag.dart';
import 'package:isar/isar.dart';

part 'isar_tag.g.dart';

@Collection()
class IsarTag {
  Id id;

  String name;

  IsarTag({required this.id, required this.name});

  static IsarTag fromTag(Tag t) {
    IsarTag tag = IsarTag(id: t.id, name: t.name);
    return tag;
  }

  Tag toTag() {
    Tag tag = Tag(id, name);
    return tag;
  }
}
