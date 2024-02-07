import 'package:app/database/src/interface/database.dart';
import 'package:app/object/anime.dart';
import 'package:app/object/anime_response.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class FavoriteStateNotifier extends StateNotifier<AsyncValue<AnimeResponse>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  FavoriteStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databasePod);
  }

  Future<AnimeResponse> _getFavorites() async {
    AnimeResponse res = await _database.getFavoriteAnimes();
    return res;
  }

  Future<void> get() async {
    try {
      state = const AsyncLoading();
      AnimeResponse res = await _getFavorites();
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> refresh(int animeId) async {
    Anime? anime = await _database.getAnime(animeId);
    AnimeResponse res = state.value!;
    res.animes =
        res.animes?.map((e) => e.malId == animeId ? anime! : e).toList();

    state = AsyncValue.data(res);
  }
}

final animeFavorite = StateNotifierProvider.autoDispose<FavoriteStateNotifier,
    AsyncValue<AnimeResponse>>((ref) {
  FavoriteStateNotifier controller = FavoriteStateNotifier(ref);
  controller.get();
  return controller;
});
