import 'package:app/database/src/interface/database.dart';
import 'package:app/object/anime_query.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimeQueryNotifier extends StateNotifier<AnimeQuery> {
  final Database db;
  AnimeQueryNotifier(this.db) : super(AnimeQuery());

  Future<void> load() async {
    AnimeQuery? query = await db.getAnimeQuery();
    state = query ?? AnimeQuery();
  }

  Future<void> set(AnimeQuery newQuery) async {
    await db.updateAnimeQuery(newQuery);
    state = newQuery;
  }
}

final animeQueryPod =
    StateNotifierProvider<AnimeQueryNotifier, AnimeQuery>((ref) {
  Database db = ref.watch(databasePod);
  final notifier = AnimeQueryNotifier(db);
  notifier.load();
  return notifier;
});
