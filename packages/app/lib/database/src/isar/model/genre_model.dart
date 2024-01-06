import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/database/src/isar/collection/isar_genre.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

class IsarGenreModel extends IsarModel implements GenreModel {
  IsarGenreModel(super.db, {required super.expirationHours});

  Future<List<IsarGenre>> insertGenresInTxn(List<GenreIntern> genres) async {
    List<IsarGenre> isarGenres = [];
    for (var genre in genres) {
      IsarGenre isarGenre = IsarGenre.from(genre);
      await db.isarGenres.put(isarGenre);

      isarGenres.add(isarGenre);
    }
    return isarGenres;
  }

  @override
  Future<void> insertGenre(GenreIntern genre) async {
    IsarGenre isarGenre = genre as IsarGenre;
    await write(() async {
      await db.isarGenres.put(isarGenre);
    });
  }

  @override
  Future<GenreIntern?> getGenre(int id) async {
    IsarGenre? genre;
    await read(() async {
      genre = await db.isarGenres.get(id);
    });
    if (isExpired(genre)) return null;
    return genre;
  }

  @override
  Future<List<GenreIntern>> getAllGenres() async {
    late List<IsarGenre> genres;

    await read(() async {
      genres = await db.isarGenres.where().findAll();
    });
    return genres;
  }

  @override
  Future<bool> deleteGenre(int malId) async {
    bool success = false;

    await write(() async {
      success = await db.isarGenres.delete(malId);
    });

    return success;
  }

  @override
  Future<void> insertGenres(List<Genre> genres) async {
    List<IsarGenre> isarGenres = genres.map((e) => IsarGenre.from(e)).toList();

    await write(() async {
      await db.isarGenres.putAll(isarGenres);
    });
  }
}
