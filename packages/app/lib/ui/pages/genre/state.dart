import 'package:app/database/src/interface/database.dart';
import 'package:app/object/genre.dart';
import 'package:app/ui/pages/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class GenreController extends StateNotifier<AsyncValue<List<Genre>>> {
  final Database _database;
  final JikanApi _api;

  GenreController(this._database, this._api) : super(const AsyncLoading());

  Future<List<Genre>> _getDatabaseGenres() async {
    List<Genre> genres = await _database.getAllGenres();
    return genres;
  }

  Future<List<Genre>> _getApiGenres() async {
    List<JikanGenre> genres = await _api.searchGenres();
    return genres.map((e) => Genre.from(e)).toList();
  }

  bool isCountMissing(List<Genre> genres) {
    // If count is missing then the geners have not been fetch from the genre
    // API and have been created by fetching from the anime API
    return genres.where((element) => element.count == null).toList().isNotEmpty;
  }

  Future<List<Genre>> _getGenres() async {
    List<Genre> genres = await _getDatabaseGenres();
    if (genres.isEmpty || isCountMissing(genres)) {
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
      List<Genre> genres = await _getGenres();

      state = AsyncValue.data(genres);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }
}

final genrePod =
    StateNotifierProvider<GenreController, AsyncValue<List<Genre>>>((ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  GenreController genres = GenreController(db, api);
  genres.get();
  return genres;
});
