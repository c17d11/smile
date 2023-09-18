import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class GenreController extends StateNotifier<AsyncValue<List<GenreIntern>>> {
  final Database _database;

  GenreController(this._database) : super(const AsyncValue.data([]));

  Future<List<GenreIntern>> _getDatabaseGenres() async {
    List<GenreIntern> genres = await _database.getAllGenres();
    return genres;
  }

  Future<List<GenreIntern>> _getGenres() async {
    List<GenreIntern> genres = await _getDatabaseGenres();
    return genres;
  }

  Future<void> get() async {
    try {
      state = const AsyncLoading();
      List<GenreIntern> genres = await _getGenres();

      state = AsyncValue.data(genres);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}
