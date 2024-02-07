import 'package:app/object/tag.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class TagController extends StateNotifier<AsyncValue<List<Tag>>> {
  final Database _database;

  TagController(this._database) : super(const AsyncLoading());

  Future<List<Tag>> _getDatabaseTags() async {
    List<Tag> tags = await _database.getAllTags();
    return tags;
  }

  Future<void> get() async {
    try {
      state = const AsyncLoading();
      List<Tag> tags = await _getDatabaseTags();

      state = AsyncValue.data(tags);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }

  Future<void> insertTags(List<Tag> tags) async {
    try {
      state = const AsyncLoading();
      await _database.insertTags(tags);
      List<Tag> updatedTags = await _getDatabaseTags();
      state = AsyncValue.data(updatedTags);
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }

  Future<void> removeTag(Tag tag) async {
    try {
      bool success = await _database.deleteTag(tag);
      if (success) {
        state = AsyncValue.data(
            state.asData!.value.where((e) => e != tag).toList());
      }
    } on Exception catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}

final tagPod =
    StateNotifierProvider<TagController, AsyncValue<List<Tag>>>((ref) {
  Database db = ref.watch(databasePod);
  TagController controller = TagController(db);
  controller.get();
  return controller;
});
