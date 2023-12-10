import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class GenreController extends StateNotifier<AsyncValue<List<GenreIntern>>> {
  final Database _database;
  final JikanApi _api;

  GenreController(this._database, this._api) : super(const AsyncLoading());

  Future<List<GenreIntern>> _getDatabaseGenres() async {
    List<GenreIntern> genres = await _database.getAllGenres();
    return genres;
  }

  Future<List<Genre>> _getApiGenres() async {
    List<Genre> genres = await _api.searchGenres();
    return genres;
  }

  Future<List<GenreIntern>> _getGenres() async {
    List<GenreIntern> genres = await _getDatabaseGenres();
    if (genres.isEmpty) {
      List<Genre> apiGenres = await _getApiGenres();
      await _database.insertGenres(apiGenres);
    }
    genres = await _getDatabaseGenres();
    genres.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
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
