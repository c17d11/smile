import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/anime_note/collection.dart';
import 'package:app/object/anime_notes.dart';

class IsarAnimeNoteConverter extends Converter<AnimeNotes, IsarAnimeNote> {
  @override
  AnimeNotes fromImpl(IsarAnimeNote t) {
    return AnimeNotes()
      ..malId = t.id
      ..favorite = t.favorite
      ..tags = []
      ..score = t.score
      ..notes = t.notes;
  }

  @override
  IsarAnimeNote toImpl(AnimeNotes t) {
    return IsarAnimeNote(id: t.malId!)
      ..favorite = t.favorite
      ..tagIds = []
      ..score = t.score
      ..notes = t.notes;
  }
}
