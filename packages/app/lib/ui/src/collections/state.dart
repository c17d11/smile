import 'package:app/controller/src/object/collection_query_intern.dart';
import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/ui/src/home.dart';
import 'package:app/ui/src/pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class CollectionStateNotifier
    extends StateNotifier<AsyncValue<IsarAnimeResponse>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  CollectionStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
  }

  Future<IsarAnimeResponse> _getCollection(CollectionQueryIntern query) async {
    IsarTag? tag = await _database.getTag(query.collectionName ?? '');

    IsarAnimeResponse res = IsarAnimeResponse(q: "tag-${query.collectionName}");

    // TODO: Move this mapping to a model class
    res.data = tag?.animes
        .map((e) => e
          ..tags = e.isarTags.map((e) => e.toTag()).toList()
          ..producers = e.isarProducers.map((e) => e.toProducer()).toList()
          ..genres = e.isarGenres.toList())
        .toList();
    res.pagination = Pagination()
      ..currentPage = query.page ?? 1
      ..hasNextPage = false
      ..itemCount = tag?.animes.toList().length
      ..itemPerPage = tag?.animes.toList().length
      ..itemTotal = tag?.animes.toList().length
      ..lastVisiblePage = 1;
    return res;
  }

  Future<void> get(CollectionQueryIntern query) async {
    try {
      state = const AsyncLoading();
      IsarAnimeResponse res = await _getCollection(query);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
      // TODO: Database error
    }
  }

  Future<void> refresh() async {
    state = AsyncValue.data(state.value!);
  }
}

final animeCollection = StateNotifierProvider.family.autoDispose<
    CollectionStateNotifier,
    AsyncValue<IsarAnimeResponse>,
    CollectionQueryIntern>((ref, arg) {
  CollectionStateNotifier controller = CollectionStateNotifier(ref);
  controller.get(arg);
  return controller;
});

class CollectionNameStateNotifier
    extends StateNotifier<AsyncValue<List<String>>> {
  late final Database _database;
  final StateNotifierProviderRef ref;

  CollectionNameStateNotifier(this.ref) : super(const AsyncLoading()) {
    _database = ref.watch(databaseUpdatePod);
  }

  Future<List<IsarTag>> _getCollectionNames() async {
    List<IsarTag> tags = await _database.getAllTags();
    return tags;
  }

  Future<void> get() async {
    try {
      state = const AsyncLoading();
      List<IsarTag> res = await _getCollectionNames();
      if (!mounted) return;

      state = AsyncValue.data(res.map((e) => e.name).toList());
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
    Database db = ref.read(databaseUpdatePod);
    await db.deleteTag(Tag(tagName, 0));
  } on Exception catch (e, _) {}
}
