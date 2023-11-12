import 'package:app/controller/src/object/tag.dart';
import 'package:app/database/src/database_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class TagController extends StateNotifier<AsyncValue<List<Tag>>> {
  final Database _database;

  TagController(this._database) : super(const AsyncValue.data([]));

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
}
