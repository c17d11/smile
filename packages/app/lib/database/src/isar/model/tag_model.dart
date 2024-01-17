import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarTagModel extends IsarModel implements TagModel {
  IsarTagModel(super.db, {required super.expirationHours});

  Future<List<IsarTag>> insertTagsInTxn(List<Tag> tags) async {
    List<IsarTag> isarTags = tags.map((e) => IsarTag.fromTag(e)).toList();
    await db.isarTags.putAllByIndex('name', isarTags);
    return isarTags;
  }

  @override
  Future<bool> deleteTag(Tag tag) async {
    bool success = false;

    await write(() async {
      success = await db.isarTags.deleteByIndex('name', [tag.name]);
    });
    return success;
  }

  @override
  Future<List<IsarTag>> getAllTags() async {
    late List<IsarTag> tags;
    await read(() async {
      tags = await db.isarTags.where().findAll();
    });
    return tags;
  }

  @override
  Future<IsarTag?> getTag(String tagName) async {
    late IsarTag? tag;
    await read(() async {
      tag = await db.isarTags.filter().nameEqualTo(tagName).findFirst();
    });
    return tag;
  }

  @override
  Future<void> insertTags(List<Tag> tags) async {
    await write(() async {
      await insertTagsInTxn(tags);
    });
  }
}
