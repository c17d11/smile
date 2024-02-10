import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/anime_query/collection.dart';
import 'package:app/database/src/isar/anime_query/converter.dart';
import 'package:app/database/src/isar/genre/model.dart';
import 'package:app/database/src/isar/producer/model.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/tag/model.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/object/tag.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

class IsarAnimeQueryModel extends IsarModel implements AnimeQueryModel {
  final IsarAnimeQueryConverter _animeQueryConverter =
      IsarAnimeQueryConverter();
  final IsarProducerModel _producerModel;
  final IsarGenreModel _genreModel;
  final IsarTagModel _tagModel;

  IsarAnimeQueryModel(super.db)
      : _producerModel = IsarProducerModel(db),
        _genreModel = IsarGenreModel(db),
        _tagModel = IsarTagModel(db);

  Future<AnimeQuery?> get() async {
    IsarAnimeQuery? ret = await db.isarAnimeQuerys.where().findFirst();

    if (ret == null) return null;

    AnimeQuery a = _animeQueryConverter.fromImpl(ret);
    for (int producerId in ret.producerIds ?? []) {
      JikanProducer? p = await _producerModel.get(producerId);
      if (p != null) a.producers!.add(p);
    }
    for (int genreId in ret.genresIncludeIds ?? []) {
      JikanGenre? g = await _genreModel.get(genreId);
      if (g != null) a.genresInclude!.add(g);
    }
    for (int genreId in ret.genresExcludeIds ?? []) {
      JikanGenre? g = await _genreModel.get(genreId);
      if (g != null) a.genresExclude!.add(g);
    }
    for (String tagId in ret.showOnlyTagIds ?? []) {
      Tag? t = await _tagModel.get(tagId);
      if (t != null) {
        a.appFilter.showOnlyTags.add(t);
      }
    }
    return a;
  }

  Future<int> insert(AnimeQuery queryIn) async {
    IsarAnimeQuery queryImpl = _animeQueryConverter.toImpl(queryIn);

    for (var tag in queryIn.appFilter.showOnlyTags) {
      String id = await _tagModel.insert(tag);
      queryImpl.showOnlyTagIds ??= [];
      queryImpl.showOnlyTagIds!.add(id);
    }

    int id = await db.isarAnimeQuerys.put(queryImpl);
    return id;
  }

  @override
  Future<AnimeQuery?> getAnimeQuery() async {
    return await get();
  }

  @override
  Future<void> updateAnimeQuery(AnimeQuery query) async {
    await insert(query);
  }
}
