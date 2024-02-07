import 'package:app/database/src/interface/model.dart';
import 'package:app/object/anime_notes.dart';
import 'package:app/object/tag.dart';
import 'package:app/database/src/isar/anime_note/collection.dart';
import 'package:app/database/src/isar/anime_note/converter.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/tag/model.dart';
import 'package:isar/isar.dart';

class IsarAnimeNoteModel extends IsarModel implements AnimeNotesModel {
  final IsarAnimeNoteConverter _animeNoteConverter = IsarAnimeNoteConverter();
  final IsarTagModel _tagModel;
  IsarAnimeNoteModel(super.db) : _tagModel = IsarTagModel(db);

  Future<AnimeNotes?> get(int id) async {
    IsarAnimeNote? ret = await db.isarAnimeNotes.get(id);

    if (ret == null) return null;

    AnimeNotes n = _animeNoteConverter.fromImpl(ret);
    for (String tagId in ret.tagIds ?? []) {
      Tag? t = await _tagModel.get(tagId);
      if (t != null) n.tags!.add(t);
    }

    return n;
  }

  Future<int> insert(AnimeNotes noteIn) async {
    IsarAnimeNote noteImpl = _animeNoteConverter.toImpl(noteIn);
    for (var tag in noteIn.tags ?? []) {
      String id = await _tagModel.insert(tag);
      noteImpl.tagIds!.add(id);
    }
    await db.isarAnimeNotes.put(noteImpl);
    return noteIn.malId!;
  }

  @override
  Future<void> updateAnimeNotes(AnimeNotes notes) async {
    await insert(notes);
  }

  @override
  Future<List<int>> getFavoriteAnimeIds() async {
    List<IsarAnimeNote> notes =
        await db.isarAnimeNotes.filter().favoriteEqualTo(true).findAll();

    return notes.map((e) => e.id).toList();
  }

  @override
  Future<List<int>> getTagAnimeIds(String tagName) async {
    List<IsarAnimeNote> notes = await db.isarAnimeNotes
        .filter()
        .tagIdsElementEqualTo(tagName)
        .findAll();

    return notes.map((e) => e.id).toList();
  }
}
