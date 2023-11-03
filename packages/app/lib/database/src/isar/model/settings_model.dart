import 'package:app/controller/src/object/settings_intern.dart';
import 'package:app/database/src/isar/collection/isar_settings.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarSettingsModel extends IsarModel implements SettingsModel {
  IsarSettingsModel(super.db);

  @override
  Future<Settings?> getSettings() async {
    IsarSettings? settings;
    await read(() async {
      settings = await db.isarSettings.where().findFirst();
      settings?.apiSettings = settings?.isarApiSettings as JikanApiSettings;
      settings?.dbSettings = settings?.isarDbSettings as DatabaseSettings;
    });
    return settings;
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    IsarSettings isarSettings = IsarSettings.from(settings);
    await write(() async {
      await db.isarSettings.put(isarSettings);
    });
  }
}
