import 'package:app/object/settings.dart';
import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/settings/collection.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/settings/converter.dart';
import 'package:isar/isar.dart';

class IsarSettingsModel extends IsarModel implements SettingsModel {
  IsarSettingsModel(super.db);

  Future<Settings?> get() async {
    IsarSettings? settings = await db.isarSettings.where().findFirst();
    return settings == null ? null : IsarSettingsConverter().fromImpl(settings);
  }

  Future<int> insert(Settings settings) async {
    IsarSettings isarSettings = IsarSettingsConverter().toImpl(settings);
    return await db.isarSettings.put(isarSettings);
  }

  @override
  Future<Settings?> getSettings() async {
    return await get();
  }

  @override
  Future<void> updateSettings(Settings s) async {
    await insert(s);
  }
}
