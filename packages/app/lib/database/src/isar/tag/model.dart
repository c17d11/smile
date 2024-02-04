import 'package:app/object/tag.dart';
import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/anime_note/collection.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/tag/collection.dart';
import 'package:app/database/src/isar/tag/converter.dart';
import 'package:isar/isar.dart';

class IsarTagModel extends IsarModel implements TagModel {
  final IsarTagConverter _tagConverter = IsarTagConverter();
  IsarTagModel(super.db);

  Future<Tag?> get(String id) async {
    IsarTag? ret = await db.isarTags.where().nameEqualTo(id).findFirst();

    if (ret == null) return null;

    Tag tag = _tagConverter.fromImpl(ret);

    // TODO: move call to anime notes
    tag.animeCount = await db.isarAnimeNotes
        .filter()
        .tagIdsElementContains(ret.name)
        .count();
    return tag;
  }

  Future<String> insert(Tag tagIn) async {
    IsarTag tagImpl = _tagConverter.toImpl(tagIn);
    await db.isarTags.put(tagImpl);
    return tagImpl.name;
  }

  @override
  Future<bool> deleteTag(Tag tag) async {
    return await db.isarTags.deleteByName(tag.name!);
  }

  @override
  Future<List<Tag>> getAllTags() async {
    List<IsarTag> tags = await db.isarTags.where().findAll();
    return tags.map((e) => _tagConverter.fromImpl(e)).toList();
  }

  @override
  Future<void> insertTags(List<Tag> tags) async {
    for (var tag in tags) {
      await insert(tag);
    }
  }
}
