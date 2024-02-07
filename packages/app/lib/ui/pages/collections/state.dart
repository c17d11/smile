import 'package:app/controller/state.dart';
import 'package:app/object/collection_query.dart';
import 'package:app/object/tag.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/ui/pages/home.dart';
import 'package:app/ui/pages/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class CollectionStateNotifier extends StateNotifier<AsyncValue<AnimeResponse>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  CollectionStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databasePod);
  }

  Future<AnimeResponse> _getCollection(CollectionQuery query) async {
    AnimeResponse res =
        await _database.getTagAnimes(query.collectionName ?? '');
    return res;
  }

  Future<void> get(CollectionQuery query) async {
    try {
      state = const AsyncLoading();
      AnimeResponse res = await _getCollection(query);
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

final animeCollection = StateNotifierProvider.family.autoDispose<
    CollectionStateNotifier,
    AsyncValue<AnimeResponse>,
    CollectionQuery>((ref, arg) {
  CollectionStateNotifier controller = CollectionStateNotifier(ref);
  controller.get(arg);
  return controller;
});

class CollectionNameStateNotifier
    extends StateNotifier<AsyncValue<List<String>>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  CollectionNameStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databasePod);
  }

  Future<List<Tag>> _getCollectionNames() async {
    List<Tag> tags = await _database.getAllTags();
    return tags;
  }

  Future<void> get() async {
    try {
      state = const AsyncLoading();
      List<Tag> res = await _getCollectionNames();
      if (!mounted) return;

      state = AsyncValue.data(res.map((e) => e.name!).toList());
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }
}

final collectionNames = StateNotifierProvider<CollectionNameStateNotifier,
    AsyncValue<List<String>>>((ref) {
  ref.watch(pageIndexPod);

  CollectionNameStateNotifier controller = CollectionNameStateNotifier(ref);
  controller.get();
  return controller;
});

Future<void> deleteCollection(WidgetRef ref, String tagName) async {
  try {
    Database db = ref.read(databasePod);
    await db.deleteTag(Tag()
      ..name = tagName
      ..animeCount = 0);
  } on Exception catch (e, _) {}
}
