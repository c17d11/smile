import 'package:app/controller/src/controller/producer_controller.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

final depencyInjectorPod = Provider((ref) => Injector()..setup());

final apiPod = Provider<JikanApi>((ref) {
  return ref.watch(depencyInjectorPod).container.resolve<JikanApi>();
});

final databasePod = Provider((ref) {
  return ref.watch(depencyInjectorPod).container.resolve<Database>();
});

final initPod = FutureProvider<bool>((ref) async {
  await ref.watch(databasePod).init();

  // successful init
  return true;
});

final animeSearchControllerPod =
    StateNotifierProvider<AnimeSearchController, AsyncValue<List<AnimeIntern>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  return AnimeSearchController(db, api);
});

final producerPod =
    StateNotifierProvider<ProducerController, AsyncValue<List<ProducerIntern>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  return ProducerController(db);
});

final animeControllerPod =
    StateNotifierProvider<AnimeController, AsyncValue<AnimeIntern?>>((ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  return AnimeController(db, api);
});

final animeQueryPod =
    Provider.family<AnimeQuery, IconItem>((ref, arg) => AnimeQuery());

extension AsyncValueUi on AsyncValue<List<AnimeIntern>> {
  bool get isLoading => this is AsyncLoading<List<AnimeIntern>>;
  bool get isError => this is AsyncError<List<AnimeIntern>>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}
