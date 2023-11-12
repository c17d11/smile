import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarTagModel extends IsarModel implements TagModel {
  IsarTagModel(super.db, {required super.expirationHours});

  @override
  Future<bool> deleteTag(Tag tag) async {
    bool success = false;

    await write(() async {
      success = await db.isarTags.delete(tag.id);
    });
    return success;
  }

  @override
  Future<List<Tag>?> getAllTags() async {
    late List<IsarTag> tags;
    await read(() async {
      tags = await db.isarTags.where().findAll();
    });
    return tags.map((e) => e.toTag()).toList();
  }

  @override
  Future<void> insertTag(Tag tag) async {
    IsarTag isarTag = IsarTag.fromTag(tag);
    await write(() async {
      await db.isarTags.put(isarTag);
    });
  }
}
