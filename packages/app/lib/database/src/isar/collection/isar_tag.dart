import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/isar/collection/isar_anime.dart';
import 'package:isar/isar.dart';

part 'isar_tag.g.dart';

@Collection()
class IsarTag {
  Id? id;

  @Index(name: 'name', unique: true, replace: true)
  String name;

  @Backlink(to: 'isarTags')
  final animes = IsarLinks<IsarAnime>();

  IsarTag({required this.name});

  static IsarTag fromTag(Tag t) {
    IsarTag tag = IsarTag(name: t.name);
    return tag;
  }

  Tag toTag() {
    Tag tag = Tag(name, animes.length);
    return tag;
  }

  @override
  bool operator ==(Object other) => (other is IsarTag) && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
