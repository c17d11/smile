import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class TagController extends StateNotifier<AsyncValue<List<Tag>>> {
  final Database _database;

  TagController(this._database) : super(const AsyncLoading());

  Future<List<IsarTag>> _getDatabaseTags() async {
    List<IsarTag> tags = await _database.getAllTags();
    return tags;
  }

  Future<void> get() async {
    try {
      state = const AsyncLoading();
      List<IsarTag> tags = await _getDatabaseTags();

      state = AsyncValue.data(tags.map((e) => e.toTag()).toList());
    } on JikanApiException catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);

      // TODO: Database error
    }
  }

  Future<void> insertTags(List<Tag> tags) async {
    try {
      state = const AsyncLoading();
      await _database.insertTags(tags);
      List<IsarTag> isarTags = await _getDatabaseTags();
      state = AsyncValue.data(isarTags.map((e) => e.toTag()).toList());
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
