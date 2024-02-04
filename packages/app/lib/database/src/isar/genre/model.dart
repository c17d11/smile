import 'package:app/object/genre.dart';
import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/genre/collection.dart';
import 'package:app/database/src/isar/genre/converter.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:isar/isar.dart';

class IsarGenreModel extends IsarModel implements GenreModel {
  final IsarGenreConverter _genreConverter = IsarGenreConverter();
  IsarGenreModel(super.db);

  Future<Genre?> get(int id) async {
    IsarGenre? ret = await db.isarGenres.get(id);

    if (ret == null) return null;

    Genre g = _genreConverter.fromImpl(ret);
    return g;
  }

  Future<int> insert(Genre genreIn) async {
    IsarGenre genreImpl = _genreConverter.toImpl(genreIn);
    await db.isarGenres.put(genreImpl);
    return genreIn.malId!;
  }

  @override
  Future<List<Genre>> getAllGenres() async {
    List<IsarGenre> genres = await db.isarGenres.where().findAll();
    return genres.map((e) => _genreConverter.fromImpl(e)).toList();
  }

  @override
  Future<void> insertGenres(List<Genre> genres) async {
    for (var genre in genres) {
      await insert(genre);
    }
  }
}
