import 'package:app/controller/src/controller/anime_collection_controller.dart';
import 'package:app/controller/src/controller/anime_collection_state_controller.dart';
import 'package:app/ui/src/favorite/favorite_state.dart';
import 'package:app/ui/src/schedule/schedule_state.dart';
import 'package:app/controller/src/controller/anime_search_state_controller.dart';
import 'package:app/controller/src/controller/genre_controller.dart';
import 'package:app/controller/src/controller/producer_controller.dart';
import 'package:app/controller/src/controller/producer_search_controller.dart';
import 'package:app/controller/src/controller/tag_controller.dart';
import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/controller/src/object/genre_intern.dart';
import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/controller/src/object/schedule_query_intern.dart';
import 'package:app/controller/src/object/settings_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/controller/state.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/database/src/populate_database.dart';
import 'package:app/ui/navigation_container/navigation_container.dart';
import 'package:app/ui/src/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

final depencyInjectorPod = Provider((ref) => Injector()..setup());

final apiPod = Provider<JikanApi>((ref) {
  final apiSettings = ref.watch(apiSettingsPod);
  final api = ref.watch(depencyInjectorPod).container.resolve<JikanApi>();
  api.setRequestRate(
    requestsPerSecond: apiSettings.requestsPerSecond,
    requestsPerMinute: apiSettings.requestsPerMinute,
  );
  return api;
});

final databasePod = Provider((ref) {
  return ref.watch(depencyInjectorPod).container.resolve<Database>();
});

final databaseUpdatePod = Provider((ref) {
  final db = ref.watch(databasePod);
  final dbSettings = ref.watch(databaseSettingsPod);
  db.setExpirationHours(dbSettings.cacheTimeoutHours!);
  return db;
});

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
    StateNotifierProvider<ProducerController, AsyncValue<List<ProducerIntern>>>(
        (ref) {
  Database db = ref.watch(databaseUpdatePod);
  return ProducerController(db);
});

final producerSearchPod = StateNotifierProvider.family<ProducerSearchController,
    AsyncValue<ProducerResponseIntern>, ProducerQueryIntern>((ref, arg) {
  Database db = ref.watch(databaseUpdatePod);
  JikanApi api = ref.watch(apiPod);
  ProducerSearchController controller = ProducerSearchController(db, api);
  controller.get(arg);
  return controller;
});

final producerQueryPod = StateNotifierProvider.family<ProducerQueryNotifier,
    ProducerQueryIntern, IconItem>((ref, arg) {
  Database db = ref.watch(databasePod);
  final notifier = ProducerQueryNotifier(arg.label, db);
  notifier.load();
  return notifier;
});

final genrePod =
    StateNotifierProvider<GenreController, AsyncValue<List<GenreIntern>>>(
        (ref) {
  Database db = ref.watch(databaseUpdatePod);
  JikanApi api = ref.watch(apiPod);
  GenreController genres = GenreController(db, api);
  genres.get();
  return genres;
});

final tagPod =
    StateNotifierProvider<TagController, AsyncValue<List<Tag>>>((ref) {
  Database db = ref.watch(databaseUpdatePod);
  TagController controller = TagController(db);
  controller.get();
  return controller;
});

final animeControllerPod =
    StateNotifierProvider<AnimeController, AsyncValue<AnimeIntern?>>((ref) {
  Database db = ref.watch(databaseUpdatePod);
  JikanApi api = ref.watch(apiPod);
  return AnimeController(db, api);
});

final animeQueryPod = StateNotifierProvider.family<AnimeQueryNotifier,
    AnimeQueryIntern, IconItem>((ref, arg) {
  Database db = ref.watch(databasePod);
  final notifier = AnimeQueryNotifier(arg.label, db);
  notifier.load();
  return notifier;
});

final scheduleQueryPod =
    StateNotifierProvider<ScheduleQueryNotifier, ScheduleQueryIntern>((ref) {
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

final apiSettingsPod = Provider<JikanApiSettings>((ref) {
  final settings = ref.watch(settingsPod);
  return settings.apiSettings;
});

final databaseSettingsPod = Provider<DatabaseSettings>((ref) {
  final settings = ref.watch(settingsPod);
  return settings.dbSettings;
});

final packageInfoPod = FutureProvider<PackageInfo>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info;
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

extension AsyncValueUiProducer on AsyncValue<ProducerResponseIntern> {
  bool get isLoading => this is AsyncLoading<ProducerResponseIntern>;
  bool get isError => this is AsyncError<ProducerResponseIntern>;

  void showSnackBarOnError(BuildContext context) =>
      whenOrNull(error: (error, _) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
}

// final animeResponseGet =
//     FutureProvider.family<AnimeResponseIntern, AnimeQueryIntern>(
//         (ref, arg) async {
//   Database db = ref.watch(databaseUpdatePod);
//   JikanApi api = ref.watch(apiPod);
//   String queryString = api.buildAnimeSearchQuery(arg);
//   AnimeResponseIntern? res = await db.getAnimeResponse(queryString);
//   if (res == null) {
//     AnimeResponse resApi = await api.searchAnimes(arg);
//     res = db.createAnimeResponseIntern(resApi);
//     await db.insertAnimeResponse(res);
//   }
//   return res;
// });

// final animeFavoritesGet =
//     FutureProvider.family<AnimeResponseIntern, int>((ref, arg) async {
//   Database db = ref.watch(databaseUpdatePod);
//   List<AnimeIntern> favorites = await db.getFavoriteAnimes(arg);
//   int favoriteCount = await db.countFavoriteAnimes();
//   int pageCount = db.countFavoriteAnimePages(favoriteCount);

//   AnimeResponseIntern res = IsarAnimeResponse(q: "favorites");
//   res.data = favorites;
//   res.pagination = Pagination()
//     ..currentPage = arg
//     ..hasNextPage = false
//     ..itemCount = favorites.length
//     ..itemPerPage = favorites.length
//     ..itemTotal = favoriteCount
//     ..lastVisiblePage = pageCount;
//   return res;
// });

// final animeScheduleGet =
//     FutureProvider.family<AnimeResponseIntern, ScheduleQueryIntern>(
//         (ref, arg) async {
//   Database db = ref.watch(databaseUpdatePod);
//   JikanApi api = ref.watch(apiPod);
//   String queryString = api.buildScheduleSearchQuery(arg);
//   AnimeResponseIntern? res = await db.getAnimeResponse(queryString);
//   if (res == null) {
//     AnimeResponse resApi = await api.searchSchedule(arg);
//     res = db.createAnimeResponseIntern(resApi);
//     await db.insertAnimeResponse(res);
//   }
//   return res;
// });

// final animeCollectionGet =
//     FutureProvider.family<AnimeResponseIntern, AnimeQueryIntern>(
//         (ref, arg) async {
//   Database db = ref.watch(databaseUpdatePod);
//   if (arg.tag == null || arg.page == null) {
//     return IsarAnimeResponse(q: "");
//   }
//   Tag tag = arg.tag!;
//   int page = arg.page!;

//   List<AnimeIntern> animes = await db.getCollection(tag, page);
//   int collectionCount = await db.countCollectionAnimes(tag);
//   int pageCount = db.countFavoriteAnimePages(collectionCount);

//   AnimeResponseIntern res = IsarAnimeResponse(q: "tag${tag.name}");
//   res.data = animes;
//   res.pagination = Pagination()
//     ..currentPage = page
//     ..hasNextPage = false
//     ..itemCount = animes.length
//     ..itemPerPage = animes.length
//     ..itemTotal = collectionCount
//     ..lastVisiblePage = pageCount;
//   return res;
// });

