import 'package:app/controller/src/controller/genre_controller.dart';
import 'package:app/controller/src/controller/producer_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/populate_database.dart';
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

  await ref
      .watch(depencyInjectorPod)
      .container
      .resolve<PopulateDatabase>()
      .populate();

  // successful init
  return true;
});

final animeSearchControllerPod = StateNotifierProvider.family<
    AnimeSearchController,
    AsyncValue<AnimeResponseIntern>,
    AnimeQueryIntern>((ref, arg) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  AnimeSearchController controller = AnimeSearchController(db, api);
  if (arg.isFavorite ?? false) {
    controller.getFavorites(arg.page ?? 1);
  } else {
    controller.get(arg);
  }
  return controller;
});

final producerPod =
    StateNotifierProvider<ProducerController, AsyncValue<List<ProducerIntern>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  return ProducerController(db);
});

final genrePod =
    StateNotifierProvider<GenreController, AsyncValue<List<GenreIntern>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  return GenreController(db);
});

final animeControllerPod =
    StateNotifierProvider<AnimeController, AsyncValue<AnimeIntern?>>((ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  return AnimeController(db, api);
});

final animeQueryPod = StateNotifierProvider.family
    .autoDispose<AnimeQueryNotifier, AnimeQueryIntern, IconItem>((ref, arg) {
  Database db = ref.watch(databasePod);
  final notifier = AnimeQueryNotifier(arg.label, db);
  notifier.load();
  return notifier;
});

extension AsyncValueUi on AsyncValue<AnimeResponseIntern> {
  bool get isLoading => this is AsyncLoading<AnimeResponseIntern>;
  bool get isError => this is AsyncError<AnimeResponseIntern>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}
