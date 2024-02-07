import 'package:app/controller/src/controller/genre_controller.dart';
import 'package:app/controller/src/controller/producer_controller.dart';
import 'package:app/controller/src/controller/producer_search_controller.dart';
import 'package:app/controller/src/controller/tag_controller.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/object/genre.dart';
import 'package:app/object/producer_query.dart';
import 'package:app/object/producer_response.dart';
import 'package:app/object/schedule_query.dart';
import 'package:app/object/settings.dart';
import 'package:app/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

final depencyInjectorPod = Provider((ref) => Injector()..setup());

final apiPod = Provider<JikanApi>((ref) {
  final settings = ref.watch(settingsPod);
  final api = ref.watch(depencyInjectorPod).container.resolve<JikanApi>();
  api.setRequestRate(
    requestsPerSecond: settings.apiSettings.requestsPerSecond,
    requestsPerMinute: settings.apiSettings.requestsPerMinute,
  );
  return api;
});

final databasePod = Provider((ref) {
  return ref.watch(depencyInjectorPod).container.resolve<Database>();
});

// final databaseUpdatePod = Provider((ref) {
//   final db = ref.watch(databasePod);
//   final dbSettings = ref.watch(databaseSettingsPod);
//   db.setExpirationHours(dbSettings.cacheTimeoutHours!);
//   return db;
// });

final initPod = FutureProvider<bool>((ref) async {
  await ref.watch(databasePod).init();

  // await ref
  //     .watch(depencyInjectorPod)
  //     .container
  //     .resolve<PopulateDatabase>()
  //     .populate();

  // successful init
  return true;
});

// final animeUpdate =
//     StateNotifierProvider<AnimeUpdateController, AsyncValue<AnimeIntern>>(
//         (ref) {
//   AnimeUpdateController controller = AnimeUpdateController(ref);
//   return controller;
// });

// final animeResponseUpdate = StateNotifierProvider<AnimeResponseUpdateController,
//     AsyncValue<AnimeResponseIntern>>((ref) {
//   AnimeResponseUpdateController controller = AnimeResponseUpdateController(ref);
//   return controller;
// });

final producerPod =
    StateNotifierProvider<ProducerController, AsyncValue<List<Producer>>>(
        (ref) {
  Database db = ref.watch(databasePod);
  return ProducerController(db);
});

final producerSearchPod = StateNotifierProvider.family<ProducerSearchController,
    AsyncValue<ProducerResponse>, ProducerQuery>((ref, arg) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  ProducerSearchController controller = ProducerSearchController(db, api);
  controller.get(arg);
  return controller;
});

final producerQueryPod = StateNotifierProvider.family<ProducerQueryNotifier,
    ProducerQuery, IconItem>((ref, arg) {
  Database db = ref.watch(databasePod);
  final notifier = ProducerQueryNotifier(arg.label, db);
  notifier.load();
  return notifier;
});

final genrePod =
    StateNotifierProvider<GenreController, AsyncValue<List<Genre>>>((ref) {
  Database db = ref.watch(databasePod);
  JikanApi api = ref.watch(apiPod);
  GenreController genres = GenreController(db, api);
  genres.get();
  return genres;
});

final tagPod =
    StateNotifierProvider<TagController, AsyncValue<List<Tag>>>((ref) {
  Database db = ref.watch(databasePod);
  TagController controller = TagController(db);
  controller.get();
  return controller;
});

final animeQueryPod =
    StateNotifierProvider<AnimeQueryNotifier, AnimeQuery>((ref) {
  Database db = ref.watch(databasePod);
  final notifier = AnimeQueryNotifier(db);
  notifier.load();
  return notifier;
});

final scheduleQueryPod =
    StateNotifierProvider<ScheduleQueryNotifier, ScheduleQuery>((ref) {
  Database db = ref.watch(databasePod);
  final notifier = ScheduleQueryNotifier(db);
  notifier.load();
  return notifier;
});

final settingsPod = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  Database db = ref.watch(databasePod);
  final notifier = SettingsNotifier(db);
  notifier.load();
  return notifier;
});

// final apiSettingsPod = Provider<JikanApiSettings>((ref) {
//   final settings = ref.watch(settingsPod);
//   return settings.apiSettings;
// });

// final databaseSettingsPod = Provider<DatabaseSettings>((ref) {
//   final settings = ref.watch(settingsPod);
//   return settings.dbSettings;
// });

extension AsyncValueUiAnime on AsyncValue<AnimeResponse> {
  bool get isLoading => this is AsyncLoading<AnimeResponse>;
  bool get isError => this is AsyncError<AnimeResponse>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}

extension AsyncValueUiProducer on AsyncValue<ProducerResponse> {
  bool get isLoading => this is AsyncLoading<ProducerResponse>;
  bool get isError => this is AsyncError<ProducerResponse>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}

final hideTitles = StateProvider((ref) => false);
