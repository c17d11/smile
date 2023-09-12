import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';

final databasePod = Provider<Database>((ref) => Database());
final apiPod = Provider<JikanApi>((ref) => JikanApi());

final animeSearchControllerPod =
    StateNotifierProvider<AnimeSearchController, AsyncValue<List<AnimeIntern>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  return AnimeSearchController(db, api);
});

final animeControllerPod =
    StateNotifierProvider<AnimeController, AsyncValue<AnimeIntern?>>((ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  return AnimeController(db, api);
});

extension AsyncValueUi on AsyncValue<List<AnimeIntern>> {
  bool get isLoading => this is AsyncLoading<List<AnimeIntern>>;
  bool get isError => this is AsyncError<List<AnimeIntern>>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}
