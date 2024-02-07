import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/anime/collection.dart';
import 'package:app/database/src/isar/anime/converter.dart';
import 'package:app/database/src/isar/anime_note/model.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/genre/model.dart';
import 'package:app/database/src/isar/producer/model.dart';
import 'package:app/object/anime.dart';
import 'package:app/object/genre.dart';
import 'package:app/object/producer.dart';

class IsarAnimeModel extends IsarModel implements AnimeModel {
  final IsarAnimeConverter _animeConverter = IsarAnimeConverter();
  final IsarProducerModel _producerModel;
  final IsarGenreModel _genreModel;
  final IsarAnimeNoteModel _animeNoteModel;
  IsarAnimeModel(super.db)
      : _producerModel = IsarProducerModel(db),
        _genreModel = IsarGenreModel(db),
        _animeNoteModel = IsarAnimeNoteModel(db);

  Future<Anime?> get(int id) async {
    IsarAnime? ret = await db.isarAnimes.get(id);

    if (ret == null) return null;

    Anime a = _animeConverter.fromImpl(ret);
    for (int producerId in ret.producerIds ?? []) {
      Producer? p = await _producerModel.get(producerId);
      if (p != null) a.producers!.add(p);
    }

    for (int genreId in ret.genreIds ?? []) {
      Genre? g = await _genreModel.get(genreId);
      if (g != null) a.genres!.add(g);
    }
    a.notes = await _animeNoteModel.get(id);
    return a;
  }

  Future<int> insert(Anime animeIn) async {
    IsarAnime animeImpl = _animeConverter.toImpl(animeIn);
    for (var producer in animeIn.producers ?? []) {
      int id = await _producerModel.insert(Producer.from(producer));
      animeImpl.producerIds!.add(id);
    }
    for (var genre in animeIn.genres ?? []) {
      int id = await _genreModel.insert(Genre.from(genre));
      animeImpl.genreIds!.add(id);
    }
    await db.isarAnimes.put(animeImpl);
    return animeIn.malId!;
  }

  @override
  Future<Anime?> getAnime(int malId) async {
    return await get(malId);
  }
}
